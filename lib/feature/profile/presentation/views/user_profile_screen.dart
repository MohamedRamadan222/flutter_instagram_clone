import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/feature/profile/presentation/views/profile_screen.dart';

class UserProfileScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ProfileContent(user: user, isMe: false);
  }
}
