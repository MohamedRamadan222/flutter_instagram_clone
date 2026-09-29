import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Input row shared by the comments sheet and the chat detail screen.
/// Trims the text, ignores empty input, and clears the field on send.
class MessageComposer extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSend;
  final String hintText;
  final Widget? leading;
  final bool filled;
  final Color? fillColor;

  const MessageComposer({
    super.key,
    required this.controller,
    required this.onSend,
    this.hintText = 'Message...',
    this.leading,
    this.filled = false,
    this.fillColor,
  });

  void _submit() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    onSend(text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: 8.w),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.outfit(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.outfit(color: Colors.grey),
                border: filled
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide: BorderSide.none,
                      )
                    : InputBorder.none,
                filled: filled,
                fillColor: fillColor,
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
          IconButton(
            onPressed: _submit,
            icon: const Icon(Icons.send, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}