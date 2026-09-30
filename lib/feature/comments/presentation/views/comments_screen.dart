import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/common/widgets/feed_states.dart';
import 'package:flutter_instagram_clone/core/common/widgets/message_composer.dart';
import 'package:flutter_instagram_clone/core/state/comments_store.dart';
import 'package:flutter_instagram_clone/core/state/post_reactions_store.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> post;

  /// When true the sheet chrome (drag handle, fixed 75% height) is omitted
  /// and the sheet fills the page — used by the `/comments/:postId` route
  /// (P4-2). The bottom-sheet usage keeps the default.
  final bool asPage;

  const CommentsScreen({super.key, required this.post, this.asPage = false});

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _loadingComments = false;

  String get _postId => '${widget.post['id'] ?? 'unknown'}';

  @override
  void initState() {
    super.initState();
    // P5-3: replace dummy comments with backend rows when configured.
    _loadingComments = true;
    ref.read(commentsProvider.notifier).hydrate(_postId).whenComplete(() {
      if (mounted) setState(() => _loadingComments = false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendComment(String text) {
    ref.read(commentsProvider.notifier).add(_postId, text);
  }

  @override
  Widget build(BuildContext context) {
    final comments =
        ref.watch(commentsProvider.select((m) => m[_postId] ?? const []));
    final reactions =
        ref.watch(postReactionsProvider.select((m) => m[_postId]));
    return Container(
      color: Colors.black,
      height: widget.asPage
          ? null
          : MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          if (!widget.asPage) ...[
            SizedBox(height: 8.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 10.h),
          ],
          Text(
            'Comments (${comments.length})',
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Divider(color: Colors.grey.shade800),
          // post like row — same count as the feed card (P2 acceptance)
          if (reactions != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => ref
                      .read(postReactionsProvider.notifier)
                      .toggleLike(_postId),
                  icon: Icon(
                    reactions.liked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: reactions.liked ? Colors.red : Colors.white,
                    size: 22,
                  ),
                ),
                Text(
                  '${reactions.likes} likes',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          Expanded(
            child: _loadingComments && comments.isEmpty
                ? ListView.separated(
                    itemCount: 4,
                    separatorBuilder: (_, __) => SizedBox(height: 4.h),
                    itemBuilder: (context, i) => ListTile(
                      leading: ShimmerBox(
                        width: 32.w,
                        height: 32.w,
                        radius: 16,
                      ),
                      title: ShimmerBox(
                        width: double.infinity,
                        height: 12.h,
                        radius: 6,
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 6.h),
                        child: ShimmerBox(width: 120.w, height: 10.h, radius: 5),
                      ),
                    ),
                  )
                : comments.isEmpty
                ? EmptyState(
                    icon: Icons.chat_bubble_outline,
                    title: 'No comments yet',
                    subtitle: 'Be the first to comment.',
                  )
                : ListView.separated(
                    itemCount: comments.length,
                    separatorBuilder: (_, __) => SizedBox(height: 4.h),
                    itemBuilder: (context, i) {
                      final c = comments[i];
                      return ListTile(
                        leading: CustomCircleAvatar(
                          imgUrl: '${c['profilePic'] ?? ''}',
                          radius: 16.r,
                        ),
                        title: RichText(
                          text: TextSpan(
                            text: '${c['username'] ?? 'user'} ',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 13.sp,
                            ),
                            children: [
                              TextSpan(
                                text: '${c['comment'] ?? ''}',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text(
                          '${c['time'] ?? 'just now'}  •  ${c['likes'] ?? 0} likes',
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.favorite_border,
                          color: Colors.grey,
                          size: 18,
                        ),
                      );
                    },
                  ),
          ),
          Divider(color: Colors.grey.shade800, height: 1),
          MessageComposer(
            controller: _controller,
            onSend: _sendComment,
            hintText: 'Add a comment...',
            leading: CustomCircleAvatar(
              imgUrl: '${DummyData.currentUser['profilePic'] ?? ''}',
              radius: 16.r,
            ),
          ),
        ],
      ),
    );
  }
}