import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/common/widgets/message_composer.dart';
import 'package:flutter_instagram_clone/core/state/comments_store.dart';
import 'package:flutter_instagram_clone/core/state/post_reactions_store.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> post;
  const CommentsScreen({super.key, required this.post});

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final TextEditingController _controller = TextEditingController();

  String get _postId => (widget.post['id'] ?? 'unknown') as String;

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
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
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
            child: comments.isEmpty
                ? Center(
                    child: Text(
                      'No comments yet. Be the first.',
                      style: GoogleFonts.outfit(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: comments.length,
                    separatorBuilder: (_, __) => SizedBox(height: 4.h),
                    itemBuilder: (context, i) {
                      final c = comments[i];
                      return ListTile(
                        leading: CustomCircleAvatar(
                          imgUrl: c['profilePic'],
                          radius: 16.r,
                        ),
                        title: RichText(
                          text: TextSpan(
                            text: '${c['username']} ',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 13.sp,
                            ),
                            children: [
                              TextSpan(
                                text: '${c['comment']}',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text(
                          '${c['time']}  •  ${c['likes']} likes',
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
              imgUrl: DummyData.currentUser['profilePic'],
              radius: 16.r,
            ),
          ),
        ],
      ),
    );
  }
}