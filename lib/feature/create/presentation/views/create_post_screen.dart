import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/state/feed_posts_store.dart';
import 'package:flutter_instagram_clone/core/theme/app_colors.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

/// Create-flow screen: pick one or more photos, add a caption, then share.
/// The post is inserted at the top of the feed via [feedPostsProvider]
/// (P3-2).
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _caption = TextEditingController();
  List<XFile> _images = [];

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(imageQuality: 85);
    if (picked.isEmpty || !mounted) return;
    setState(() => _images = picked);
  }

  void _share() {
    if (_images.isEmpty) return;
    final user = DummyData.currentUser;
    final post = <String, dynamic>{
      'username': user['username'],
      'name': user['name'],
      'profilePic': user['profilePic'],
      'isFollowing': true,
      'media': [
        for (final image in _images)
          {'type': 'image', 'url': image.path},
      ],
      'likes': 0,
      'id': 'me_post_${DateTime.now().millisecondsSinceEpoch}',
      'caption': _caption.text.trim(),
      'comments': 0,
      'reposts': 0,
      'shares': 0,
      'timeAgo': 'now',
      'isSponsored': false,
      'commentsData': <Map<String, dynamic>>[],
    };
    ref.read(feedPostsProvider.notifier).addPost(post);
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Your post has been shared')),
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
          'New post',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _images.isEmpty ? null : _share,
            child: Text(
              'Share',
              style: GoogleFonts.outfit(
                color: _images.isEmpty ? Colors.grey : AppColors.blue,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SizedBox(
            height: 220.h,
            child: _images.isEmpty
                ? _buildEmptyPicker()
                : ListView.separated(
                    padding: EdgeInsets.all(12.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length + 1,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      if (index < _images.length) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.file(
                            File(_images[index].path),
                            width: 180.w,
                            height: 196.h,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      return InkWell(
                        onTap: _pickImages,
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          width: 180.w,
                          height: 196.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Colors.grey.shade800),
                          ),
                          child: const Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                CustomCircleAvatar(
                  imgUrl: DummyData.currentUser['profilePic'],
                  radius: 18.r,
                ),
                SizedBox(width: 10.w),
                Text(
                  DummyData.currentUser['username'],
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
            child: TextField(
              controller: _caption,
              maxLines: 4,
              maxLength: 2200,
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: 'Write a caption...',
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
      ),
    );
  }

  Widget _buildEmptyPicker() {
    return InkWell(
      onTap: _pickImages,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.photo_library_outlined, color: Colors.grey, size: 48.sp),
            SizedBox(height: 12.h),
            Text(
              'Choose photos',
              style: GoogleFonts.outfit(color: Colors.grey, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}