import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // private constructor

  // 🔥 Primary Colors
  static const Color primary = Colors.white;
  static const Color background = Colors.black;

  // 🧾 Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3); // softer grey
  static const Color textMuted = Color(0xFF8E8E8E);

  // 🧱 UI Colors
  static const Color border = Color(0xFF262626);
  static const Color divider = Color(0xFF1A1A1A);
  static const Color card = Color(0xFF121212);

  // ❤️ Instagram Brand Colors
  static const Color blue = Color(0xFF0095F6);
  static const Color red = Color(0xFFED4956);

  // ⚠️ States
  static const Color error = Colors.red;
  static const Color success = Colors.green;

  // 👤 Avatar / Placeholder
  static const Color shimmerBase = Color(0xFF2A2A2A);
  static const Color shimmerHighlight = Color(0xFF3A3A3A);
}