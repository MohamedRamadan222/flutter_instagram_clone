import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/state/reels_store.dart';
import 'package:flutter_instagram_clone/core/theme/app_colors.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

/// Create-flow screen for reels: pick a video, generate its thumbnail with
/// `video_thumbnail`, add a caption, then share. The reel is inserted at the
/// top of the reels list via [reelsProvider] (P3-4).
class CreateReelScreen extends ConsumerStatefulWidget {
  const CreateReelScreen({super.key});

  @override
  ConsumerState<CreateReelScreen> createState() => _CreateReelScreenState();
}

class _CreateReelScreenState extends ConsumerState<CreateReelScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _caption = TextEditingController();
  XFile? _video;
  Uint8List? _thumbData;

  Future<void> _pickVideo() async {
    final picked = await _picker.pickVideo(source: ImageSource.gallery);
    if (picked == null || !mounted) return;
    setState(() {
      _video = picked;
      _thumbData = null;
    });
    // Thumbnail generation is best-effort: some platforms (e.g. desktop)
    // have no implementation, so the preview falls back to a play icon.
    try {
      final thumb = await VideoThumbnail.thumbnailData(
        video: picked.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 720,
        quality: 80,
      );
      if (!mounted || _video?.path != picked.path) return;
      setState(() => _thumbData = thumb);
    } catch (_) {
      // keep _thumbData null; preview shows a placeholder
    }
  }

  void _share() {
    if (_video == null) return;
    final user = DummyData.currentUser;
    final reel = <String, dynamic>{
      'id': 'me_reel_${DateTime.now().millisecondsSinceEpoch}',
      'username': user['username'],
      'profilePic': user['profilePic'],
      'videoUrl': _video!.path,
      'caption': _caption.text.trim(),
      'likes': '0',
      'comments': '0',
      'audioTitle': 'Original Audio - ${user['username']}',
      'isFollowing': true,
    };
    ref.read(reelsProvider.notifier).addReel(reel);
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Your reel has been shared')),
    );
  }

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New reel',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _video == null ? null : _share,
            child: Text(
              'Share',
              style: GoogleFonts.outfit(
                color: _video == null ? Colors.grey : AppColors.blue,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: _video == null
                  ? _buildEmptyPicker()
                  : _buildPreview(),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
            child: TextField(
              controller: _caption,
              maxLines: 3,
              maxLength: 2200,
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: 'Add a caption...',
                hintStyle:
                    GoogleFonts.outfit(color: Colors.grey, fontSize: 14.sp),
                border: InputBorder.none,
                counterStyle:
                    GoogleFonts.outfit(color: Colors.grey, fontSize: 11.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPicker() {
    return InkWell(
      onTap: _pickVideo,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.video_library_outlined, color: Colors.grey, size: 48.sp),
          SizedBox(height: 12.h),
          Text(
            'Choose a video',
            style: GoogleFonts.outfit(color: Colors.grey, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      margin: EdgeInsets.all(16.w),
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: 420.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: _thumbData != null
          ? Image.memory(_thumbData!, fit: BoxFit.cover)
          : const Icon(Icons.play_circle_outline, color: Colors.white, size: 56),
    );
  }
}