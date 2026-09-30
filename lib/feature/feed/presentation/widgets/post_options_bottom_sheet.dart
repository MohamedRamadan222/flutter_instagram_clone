import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostOptionsBottomSheet extends StatelessWidget {
  const PostOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handel
            Container(
              width: 30,
              height: 2,
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade500,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // top actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TopAction(icon: Icons.bookmark_border, label: 'Save'),
                  _TopAction(icon: Icons.qr_code, label: 'QR code'),
                  _TopAction(icon: Icons.link, label: 'Link'),
                  _TopAction(icon: Icons.share, label: 'Share'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Divider(color: Colors.white.withValues(alpha: 0.2)),
            // list items
            _SheetItem(icon: Icons.star_border, title: 'Add to favorite'),
            _SheetItem(icon: Icons.person_remove_outlined, title: 'Unfollow'),
            _SheetItem(
              icon: Icons.info_outline,
              title: 'Why you\'re seeing this post',
            ),
            _SheetItem(icon: Icons.visibility_off_outlined, title: 'Hide'),
            _SheetItem(icon: Icons.person_off_outlined, title: 'Restrict'),
            _SheetItem(icon: Icons.report_outlined, title: 'Report',isDestructive: true,),
            SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
}

class _SheetItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDestructive;

  const _SheetItem({
    required this.icon,
    required this.title,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.white),
      title: Text(title,
      style: GoogleFonts.outfit(
        color: isDestructive ? Colors.red : Colors.white,
        fontSize: 14,
      ),
    ),
      onTap: (){
        Navigator.pop(context);
      },
    );
  }
}

class _TopAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TopAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
