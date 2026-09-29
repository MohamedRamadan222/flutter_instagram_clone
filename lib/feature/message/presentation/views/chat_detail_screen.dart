import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/message_composer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> chat;
  const ChatDetailScreen({super.key, required this.chat});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  late List<Map<String, dynamic>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = (widget.chat['messages'] as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    setState(() {
      _messages.add({'fromMe': true, 'text': text, 'time': 'now'});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.chat['username'],
          style: GoogleFonts.outfit(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                final me = m['fromMe'] == true;
                return Align(
                  alignment:
                      me ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: me ? Colors.blue : Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      m['text'],
                      style: GoogleFonts.outfit(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          MessageComposer(
            controller: _controller,
            onSend: _sendMessage,
            hintText: 'Message...',
            filled: true,
            fillColor: Colors.grey.shade900,
          ),
        ],
      ),
    );
  }
}
