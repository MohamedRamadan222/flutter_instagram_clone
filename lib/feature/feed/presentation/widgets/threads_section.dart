import 'package:flutter/material.dart';

class ThreadsSection extends StatelessWidget {
  const ThreadsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.orange,
      child: Text(
        'Threads section',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
