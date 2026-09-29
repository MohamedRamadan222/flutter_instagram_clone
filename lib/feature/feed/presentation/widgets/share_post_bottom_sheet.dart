import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SharePostBottomSheet extends StatefulWidget {
  final Map<String, dynamic> post;

  const SharePostBottomSheet({super.key, required this.post});

  @override
  State<SharePostBottomSheet> createState() => _SharePostBottomSheetState();
}

class _SharePostBottomSheetState extends State<SharePostBottomSheet> {
  Future<void> _copyLink() async {
    // posts carry a stable id since Phase 2 (03_DATA_CONTRACTS.md)
    await Clipboard.setData(
      ClipboardData(text: 'ig://post/${widget.post['id']}'),
    );
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Link copied')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share',
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Divider(color: Colors.grey.shade800, height: 1),
            SizedBox(height: 8.h),
            ...DummyData.accounts
                .where((a) => a['isCurrent'] != true)
                .map(
                  (a) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CustomCircleAvatar(
                      imgUrl: a['profilePic'],
                      radius: 20.r,
                    ),
                    title: Text(
                      a['username'],
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Post sent to ${a['username']}')),
                      );
                    },
                  ),
                ),
            Divider(color: Colors.grey.shade800, height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: const Icon(Icons.link, color: Colors.white, size: 20),
              ),
              title: Text(
                'Copy link',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: _copyLink,
            ),
          ],
        ),
      ),
    );
  }
}