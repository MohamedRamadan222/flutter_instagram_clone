import 'package:flutter/material.dart';

class SuggestedUsersSection extends StatefulWidget {
  const SuggestedUsersSection({super.key});

  @override
  State<SuggestedUsersSection> createState() => _SuggestedUsersSectionState();
}

class _SuggestedUsersSectionState extends State<SuggestedUsersSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.red,
      child: Text(
        'Suggested users section',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
