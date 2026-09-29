import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/state/post_reactions_store.dart';
import 'package:flutter_instagram_clone/core/theme/app_colors.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class SaveToCollectionBottomSheet extends ConsumerStatefulWidget {
  final Map post;
  final BuildContext parentContext;

  const SaveToCollectionBottomSheet({
    super.key,
    required this.post,
    required this.parentContext,
  });

  @override
  ConsumerState<SaveToCollectionBottomSheet> createState() =>
      _SaveToCollectionBottomSheetState();
}

class _SaveToCollectionBottomSheetState
    extends ConsumerState<SaveToCollectionBottomSheet> {
  late final Set<String> _savedTo;

  String get _postId => widget.post['id'] as String;

  @override
  void initState() {
    super.initState();
    // Seed from the reactions store so the sheet agrees with the bookmark
    // icon: a post that is already saved opens with a collection selected
    // (P2-2; collections themselves are a later phase).
    _savedTo = {};
    final saved = ref.read(postReactionsProvider)[_postId]?.saved ?? false;
    if (saved && DummyData.collections.isNotEmpty) {
      _savedTo.add(DummyData.collections.first['name'] as String);
    }
  }

  void _toggleCollection(String name) {
    setState(() {
      if (!_savedTo.remove(name)) {
        _savedTo.add(name);
      }
    });
    // Write back into the same store the feed bookmark reads, so both
    // save states can never diverge.
    ref
        .read(postReactionsProvider.notifier)
        .setSaved(_postId, _savedTo.isNotEmpty);
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
              'Save to collection',
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Divider(color: Colors.grey.shade800, height: 1),
            SizedBox(height: 8.h),
            ...DummyData.collections.map(
              (c) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: SizedBox(
                    width: 44.w,
                    height: 44.h,
                    child: _CollectionPreview(name: c['name'] as String),
                  ),
                ),
                title: Text(
                  c['name'],
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${(c['posts'] as List).length} posts • ${c['privacy']}',
                  style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12.sp),
                ),
                trailing: Icon(
                  _savedTo.contains(c['name'])
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: _savedTo.contains(c['name'])
                      ? Colors.blue
                      : Colors.grey,
                ),
                onTap: () => _toggleCollection(c['name'] as String),
              ),
            ),
            const Divider(color: Colors.transparent, height: 4),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              title: Text(
                'New collection',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(widget.parentContext).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Creating collections is coming in a later phase',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionPreview extends StatelessWidget {
  final String name;

  const _CollectionPreview({required this.name});

  @override
  Widget build(BuildContext context) {
    final preview = DummyData.getCollectionPreview(name);
    if (preview.isEmpty) {
      return Container(color: Colors.grey.shade900);
    }
    return CachedNetworkImage(
      imageUrl: preview,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(color: Colors.black),
      ),
    );
  }
}