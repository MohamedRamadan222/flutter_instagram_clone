import 'dart:io';

import 'package:flutter_instagram_clone/core/config/app_config.dart';
import 'package:flutter_instagram_clone/core/data/local_cache.dart';
import 'package:flutter_instagram_clone/core/utils/time_format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase-backed data source (P5-3).
///
/// Every read maps database rows into the exact map shape the UI already
/// consumes (same keys as `03_DATA_CONTRACTS.md`), and every write keeps a
/// local JSON cache so offline starts degrade to "show the cache" instead of
/// failing. When no project is configured ([AppConfig.hasBackend] == false)
/// all calls return null / false and the app stays on dummy data.
class BackendDataSource {
  final LocalCache cache;
  static const int pageSize = 15;

  BackendDataSource({required this.cache});

  SupabaseClient? _client;

  bool get _available => AppConfig.hasBackend;

  /// Lazy, guarded client. Never throws when the backend is not configured.
  SupabaseClient? _init() {
    if (!_available) return null;
    try {
      if (_client != null) return _client;
      Supabase.initialize(
        url: AppConfig.supabaseUrl,
        // `publishableKey` is the current name for the anon public key.
        publishableKey: AppConfig.supabaseAnonKey,
      );
      return _client = Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------- helpers

  Future<String?> _ensureUser(String username) async {
    final client = _init();
    if (client == null) return null;
    try {
      final row = await client
          .from('users')
          .upsert(
            {'username': username, 'display_name': username},
            onConflict: 'username',
          )
          .select('id')
          .single();
      return row['id'] as String;
    } catch (_) {
      return null;
    }
  }

  String _formatTimeAgo(DateTime created) => formatTimeAgo(created);

  static DateTime _parseDate(dynamic value) =>
      value is String ? DateTime.tryParse(value) ?? DateTime.now() : DateTime.now();

  static int _commentsCount(dynamic value) {
    if (value is int) return value;
    if (value is List && value.isNotEmpty) {
      final first = value.first;
      if (first is Map) return (first['count'] as int?) ?? 0;
    }
    if (value is Map) return (value['count'] as int?) ?? 0;
    return 0;
  }

  Map<String, dynamic> _mapPost(Map<String, dynamic> row, String? me) {
    final user = (row['users'] as Map?) ?? const {};
    final media = <Map<String, dynamic>>[
      for (final raw in (row['post_media'] as List?) ?? <dynamic>[])
        () {
          final m = Map<String, dynamic>.from(raw as Map);
          return {
            ...m,
            'type': m['media_type'] == 'video' ? 'video' : 'image',
          };
        }(),
    ];
    media.sort((a, b) => (a['position'] as int? ?? 0)
        .compareTo(b['position'] as int? ?? 0));
    final likeIds = [
      for (final l in (row['post_likes'] as List?) ?? <dynamic>[])
        (l as Map)['user_id'],
    ];
    final saveIds = [
      for (final s in (row['saves'] as List?) ?? <dynamic>[])
        (s as Map)['user_id'],
    ];
    return {
      'id': row['id'],
      'username': user['username'] ?? '',
      'name': user['display_name'] ?? user['username'] ?? '',
      'profilePic': user['avatar_url'] ?? '',
      'location': row['location'],
      'isFollowing': false, // hydrated through the follow store
      'media': media,
      'likes': likeIds.length,
      'liked': me != null && likeIds.contains(me),
      'saved': me != null && saveIds.contains(me),
      'caption': row['caption'] ?? '',
      'comments': _commentsCount(row['comments']),
      'reposts': 0,
      'shares': 0,
      'timeAgo': _formatTimeAgo(_parseDate(row['created_at'])),
      'isSponsored': row['is_sponsored'] ?? false,
      'commentsData': <Map<String, dynamic>>[],
    };
  }

  // ------------------------------------------------------------------ posts

  /// Page 1-based feed fetch. Returns null when there is no backend or the
  /// fetch failed (falls back to cache); returns an empty list at end-of-feed
  /// so callers can stop pagination without poisoning retries.
  Future<List<Map<String, dynamic>>?> fetchPosts({
    required int page,
    String? me,
  }) async {
    final client = _init();
    if (client == null) return null;
    try {
      final from = (page - 1) * pageSize;
      final rows = await client
          .from('posts')
          .select(
            '*, users(username, display_name, avatar_url), '
            'post_media(id, media_type, url, position, reel_id), '
            'post_likes(user_id), saves(user_id), comments(count)',
          )
          .order('created_at', ascending: false)
          .range(from, from + pageSize - 1);
      if (rows.isEmpty) return <Map<String, dynamic>>[]; // end of feed
      final posts = [for (final r in rows) _mapPost(r, me)];
      await cache.write('feed_page_$page', posts);
      return posts;
    } catch (_) {
      return cache.read('feed_page_$page');
    }
  }

  /// Uploads the picked media, creates the post row and returns it in the
  /// UI's post shape. Null when there is no backend (caller then keeps the
  /// local-path post).
  Future<Map<String, dynamic>?> createPost({
    required String username,
    required String caption,
    required List<String> mediaPaths,
  }) async {
    if (mediaPaths.isEmpty) return null;
    final client = _init();
    if (client == null) return null;
    try {
      final userId = await _ensureUser(username);
      if (userId == null) return null;
      final media = <Map<String, dynamic>>[];
      for (var i = 0; i < mediaPaths.length; i++) {
        final path = mediaPaths[i];
        if (path.startsWith('http') || !await File(path).exists()) continue;
        final ext = path.split('.').last.toLowerCase().split('?').first;
        final isVideo = ['mp4', 'mov', 'webm'].contains(ext);
        final objectName =
            'posts/$userId/${DateTime.now().millisecondsSinceEpoch}_$i.$ext';
        await client.storage.from('posts').upload(objectName, File(path));
        final url = client.storage.from('posts').getPublicUrl(objectName);
        media.add({
          'type': isVideo ? 'video' : 'image',
          'url': url,
          'position': i,
        });
      }
      if (media.isEmpty) return null;
      final row = await client
          .from('posts')
          .insert({'user_id': userId, 'caption': caption})
          .select('id, created_at')
          .single();
      try {
        await client.from('post_media').insert([
          for (final m in media)
            {
              'post_id': row['id'],
              'media_type': m['type'],
              'url': m['url'],
              'position': m['position'],
            },
        ]);
      } catch (_) {
        // Avoid orphan posts when media rows fail.
        try {
          await client.from('posts').delete().eq('id', row['id']);
        } catch (_) {}
        return null;
      }
      return {
        'id': row['id'],
        'username': username,
        'name': username,
        'profilePic': '', // resolved on next feed hydration
        'media': [
          for (final m in media) {'type': m['type'], 'url': m['url']},
        ],
        'likes': 0,
        'liked': false,
        'saved': false,
        'caption': caption,
        'comments': 0,
        'reposts': 0,
        'shares': 0,
        'timeAgo': _formatTimeAgo(_parseDate(row['created_at'])),
        'isSponsored': false,
        'commentsData': <Map<String, dynamic>>[],
      };
    } catch (_) {
      return null;
    }
  }

  Future<void> togglePostLike({
    required String postId,
    required String username,
    required bool liked,
  }) async {
    final client = _init();
    if (client == null) return;
    final userId = await _ensureUser(username);
    if (userId == null) return;
    try {
      if (liked) {
        await client.from('post_likes').delete().match({
          'post_id': postId,
          'user_id': userId,
        });
      } else {
        await client.from('post_likes').insert({
          'post_id': postId,
          'user_id': userId,
        });
      }
    } catch (_) {}
  }

  Future<void> togglePostSave({
    required String postId,
    required String username,
    required bool saved,
  }) async {
    final client = _init();
    if (client == null) return;
    final userId = await _ensureUser(username);
    if (userId == null) return;
    try {
      if (saved) {
        await client.from('saves').delete().match({
          'post_id': postId,
          'user_id': userId,
        });
      } else {
        await client.from('saves').insert({
          'post_id': postId,
          'user_id': userId,
        });
      }
    } catch (_) {}
  }

  // --------------------------------------------------------------- comments

  Future<List<Map<String, dynamic>>?> fetchComments(String postId) async {
    final client = _init();
    if (client == null) return null;
    try {
      final rows = await client
          .from('comments')
          .select('*, users(username, avatar_url)')
          .eq('post_id', postId)
          .order('created_at', ascending: true);
      final comments = [
        for (final r in rows)
          {
            'username': (r['users'] as Map?)?['username'] ?? 'user',
            'profilePic': (r['users'] as Map?)?['avatar_url'] ?? '',
            'comment': r['text'] ?? '',
            'likes': 0,
            'time': _formatTimeAgo(_parseDate(r['created_at'])),
          },
      ];
      await cache.write('comments_$postId', comments);
      return comments;
    } catch (_) {
      return cache.read('comments_$postId');
    }
  }

  Future<void> addComment({
    required String postId,
    required String username,
    required String text,
  }) async {
    final client = _init();
    if (client == null) return;
    final userId = await _ensureUser(username);
    if (userId == null) return;
    try {
      await client.from('comments').insert({
        'post_id': postId,
        'user_id': userId,
        'text': text,
      });
    } catch (_) {}
  }

  // ---------------------------------------------------------------- follows

  Future<void> setFollow({
    required String targetUsername,
    required String me,
    // Whether the user is now following the target (after the local toggle).
    required bool isNowFollowing,
  }) async {
    final client = _init();
    if (client == null) return;
    final meId = await _ensureUser(me);
    final targetId = await _ensureUser(targetUsername);
    if (meId == null || targetId == null) return;
    try {
      if (isNowFollowing) {
        await client.from('follows').insert({
          'follower_id': meId,
          'following_id': targetId,
        });
      } else {
        await client.from('follows').delete().match({
          'follower_id': meId,
          'following_id': targetId,
        });
      }
    } catch (_) {}
  }

  // Kept for callers still using the old `following` name.
  Future<void> setFollowLegacy({
    required String targetUsername,
    required String me,
    required bool following,
  }) =>
      setFollow(
        targetUsername: targetUsername,
        me: me,
        isNowFollowing: following,
      );

  // ---------------------------------------------------------------- stories

  /// Grouped into the strip shape used by the home screen.
  Future<List<Map<String, dynamic>>?> fetchStories() async {
    final client = _init();
    if (client == null) return null;
    try {
      final rows = await client
          .from('stories')
          .select('*, users(username, avatar_url)')
          .gt('expires_at', DateTime.now().toUtc().toIso8601String())
          .order('created_at', ascending: false);
      final grouped = <String, Map<String, dynamic>>{};
      for (final r in rows) {
        final user = (r['users'] as Map?) ?? const {};
        final username = user['username'] as String? ?? '';
        if (username.isEmpty) continue;
        final entry = grouped.putIfAbsent(
          username,
          () => {
            'username': username,
            'profileImage': user['avatar_url'] ?? '',
            'isSeen': false,
            'stories': <Map<String, dynamic>>[],
          },
        );
        (entry['stories'] as List).add({
          'imageUrl': r['image_url'] ?? '',
          'id': r['id'],
        });
      }
      final stories = grouped.values.toList();
      await cache.write('stories', stories);
      return stories;
    } catch (_) {
      return cache.read('stories');
    }
  }

  Future<Map<String, dynamic>?> publishStory({
    required String username,
    required String imagePath,
  }) async {
    if (imagePath.isEmpty || imagePath.startsWith('http')) return null;
    if (!await File(imagePath).exists()) return null;
    final client = _init();
    if (client == null) return null;
    try {
      final userId = await _ensureUser(username);
      if (userId == null) return null;
      final objectName =
          'stories/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await client.storage.from('stories').upload(objectName, File(imagePath));
      final url = client.storage.from('stories').getPublicUrl(objectName);
      await client.from('stories').insert({
        'user_id': userId,
        'image_url': url,
        'expires_at': DateTime.now()
            .toUtc()
            .add(const Duration(hours: 24))
            .toIso8601String(),
      });
      return {'imageUrl': url};
    } catch (_) {
      return null;
    }
  }

  // ------------------------------------------------------------------ reels

  Future<List<Map<String, dynamic>>?> fetchReels() async {
    final client = _init();
    if (client == null) return null;
    try {
      final rows = await client
          .from('reels')
          .select('*, users(username, avatar_url)')
          .order('created_at', ascending: false)
          .limit(30);
      final reels = [
        for (final r in rows)
          {
            'id': r['id'],
            'username': (r['users'] as Map?)?['username'] ?? '',
            'profilePic': (r['users'] as Map?)?['avatar_url'] ?? '',
            'videoUrl': r['video_url'] ?? '',
            'caption': r['caption'] ?? '',
            'likes': '${r['likes_count'] ?? 0}',
            'comments': '${r['comments_count'] ?? 0}',
            'audioTitle': r['audio_title'] ?? 'Original Audio',
            'isFollowing': false,
          },
      ];
      await cache.write('reels', reels);
      return reels;
    } catch (_) {
      return cache.read('reels');
    }
  }

  Future<Map<String, dynamic>?> createReel({
    required String username,
    required String videoPath,
    required String caption,
  }) async {
    if (videoPath.isEmpty ||
        videoPath.startsWith('http') ||
        !await File(videoPath).exists()) {
      return null;
    }
    final client = _init();
    if (client == null) return null;
    try {
      final userId = await _ensureUser(username);
      if (userId == null) return null;
      final objectName =
          'reels/$userId/${DateTime.now().millisecondsSinceEpoch}.mp4';
      await client.storage.from('reels').upload(objectName, File(videoPath));
      final url = client.storage.from('reels').getPublicUrl(objectName);
      final row = await client.from('reels').insert({
        'user_id': userId,
        'video_url': url,
        'caption': caption,
        'audio_title': 'Original Audio - $username',
      }).select('id, created_at').single();
      return {
        'id': row['id'],
        'username': username,
        'profilePic': '',
        'videoUrl': url,
        'caption': caption,
        'likes': '0',
        'comments': '0',
        'audioTitle': 'Original Audio - $username',
        'isFollowing': false,
      };
    } catch (_) {
      return null;
    }
  }
}

/// Single data layer entry point used by the stores (P5-3).
final backendDataSourceProvider = Provider<BackendDataSource>(
  (ref) => BackendDataSource(cache: LocalCache()),
);