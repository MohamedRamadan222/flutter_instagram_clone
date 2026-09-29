import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/utils/messages_dummy_data.dart';
import 'package:flutter_instagram_clone/feature/message/presentation/views/chat_detail_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = MessagesDummyData.chats;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Messages',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (_, __) => Divider(
          color: Colors.grey.shade900,
          height: 1,
        ),
        itemBuilder: (context, i) {
          final chat = chats[i];
          final unread = chat['unread'] as int;
          return ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailScreen(chat: chat),
              ),
            ),
            leading: CustomCircleAvatar(
              imgUrl: chat['profilePic'],
              radius: 24.r,
            ),
            title: Text(
              chat['username'],
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              chat['lastMessage'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(color: Colors.grey),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chat['timeAgo'],
                  style: GoogleFonts.outfit(
                    color: Colors.grey,
                    fontSize: 12.sp,
                  ),
                ),
                if (unread > 0)
                  Container(
                    margin: EdgeInsets.only(top: 4.h),
                    padding: EdgeInsets.all(6.w),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unread',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
