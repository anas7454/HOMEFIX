import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand / Primary Colors
  static const Color primary = Color(0xFFFA5A00); // #FA5A00 Vibrant Rich Warm Orange
  static const Color primaryOrange = Color(0xFFFA5A00);
  static const Color primaryDark = Color(0xFFE04F00);
  static const Color secondary = Color(0xFF22C55E); // #22C55E Verified Green
  static const Color ratingStar = Color(0xFFFACC15); // #FACC15 Star Yellow

  // Background & Surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color bgGradientTop = Color(0xFFFCFCFD); // #FCFCFD Crisp clean top
  static const Color bgGradientBottom = Color(0xFFFFF6EE); // #FFF6EE Soft warm glow bottom
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;
  static const Color border = Color(0xFFE2E8F0);

  // Gradient definitions
  static const LinearGradient onboardingGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      bgGradientTop,
      bgGradientBottom,
    ],
  );

  // Text Colors
  static const Color textTitle = Color(0xFF0F172A); // #0F172A Crisp Dark Navy/Black
  static const Color darkText = Color(0xFF0F172A);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSub = Color(0xFF64748B); // #64748B Refined Slate Grey
  static const Color descriptionColor = Color(0xFF64748B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textSkip = Color(0xFF64748B); // #64748B
  static const Color skipColor = Color(0xFF64748B);
  static const Color textWhite = Colors.white;

  // Indicators & Navigation
  static const Color dotActive = Color(0xFFFA5A00);
  static const Color dotInactive = Color(0xFFE2E8F0);

  // Status Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
}
