import 'package:flutter/material.dart';

class AppColors {
  static const primaryGreen = Color(0xFF00C853);
  static const darkGreen = Color(0xFF009624);
  static const bgLight = Color(0xFFF8F9FA);
  static const textDark = Color(0xFF1A1A1A); // ✅ Added missing color
  
  static const glassBg = Color(0x1AFFFFFF);
  static const glassBorder = Color(0x4DFFFFFF);
  static const glassShadow = Color(0x1A000000);
  static const glassBgDark = Color(0x0D000000);
  
  static const mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00C853), Color(0xFF00796B)],
  );
}
