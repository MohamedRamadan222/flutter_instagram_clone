import 'package:flutter/rendering.dart';
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
  final ScrollController _scroll = ScrollController();
  late List<Map<String, dynamic>> _messages;

  @override
  void initState() {
    super.initState();
    final raw = widget.chat['messages'] as List? ?? [];
    _messages = [
      for (final e in raw) Map<String, dynamic>.from(e as Map),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      _messages.add({'fromMe': true, 'text': trimmed, 'time': 'now'});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final username = '${widget.chat['username'] ?? 'Chat'}';
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          username,
          style: GoogleFonts.outfit(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      'No messages yet. Say hello.',
                      style: GoogleFonts.outfit(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    controller: _scroll,
                    padding: EdgeInsets.all(12.w),
                    // P6-2: bubbles are cheap; drop offscreen ones.
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: true,
                    scrollCacheExtent: ScrollCacheExtent.pixels(300),
                    itemCount: _messages.length,
                    itemBuilder: (context, i) {
                      final m = _messages[i];
                      final me = m['fromMe'] == true;
                      return Align(
                        alignment: me
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
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
                            '${m['text'] ?? ''}',
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
