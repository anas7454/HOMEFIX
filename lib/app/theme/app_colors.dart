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
  static const Color surface = Colors.white;
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color inputBg = Color(0xFFF8FAFC);
  static const Color cardBackground = Colors.white;
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFE8EEF5);
  static const Color divider = Color(0xFFE2E8F0);

  // Soft Warm Ambients & Glows
  static const Color bgWarm = Color(0xFFFFFBF7);
  static const Color bgGradientTop = Color(0xFFFFFDFB);
  static const Color bgGradientBottom = Color(0xFFFFF8F2);
  static const Color peachGlow1 = Color(0xFFFFE6D0);
  static const Color peachGlow2 = Color(0xFFFFE8D6);
  static const Color peachGlow3 = Color(0xFFFFDEC4);

  // Gradient definitions
  static const LinearGradient onboardingGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFCFCFD),
      Color(0xFFFFF6EE),
    ],
  );

  static const LinearGradient ambientWarmGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      bgGradientTop,
      bgGradientBottom,
    ],
  );

  // Text Colors
  static const Color textTitle = Color(0xFF0F172A); // Crisp Dark Navy/Black
  static const Color darkText = Color(0xFF0F172A);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSub = Color(0xFF64748B); // Refined Slate Grey
  static const Color descriptionColor = Color(0xFF64748B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF5A6981);
  static const Color textPlaceholder = Color(0xFF94A3B8);
  static const Color textSkip = Color(0xFF64748B);
  static const Color skipColor = Color(0xFF64748B);
  static const Color textWhite = Colors.white;

  // Icon Colors
  static const Color iconDark = Color(0xFF0F172A);
  static const Color iconMuted = Color(0xFF64748B);
  static const Color iconSlate = Color(0xFF475569);

  // Indicators & Navigation
  static const Color dotActive = Color(0xFFFA5A00);
  static const Color dotInactive = Color(0xFFE2E8F0);

  // Third Party Brands
  static const Color googleRed = Color(0xFFEA4335);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleGreen = Color(0xFF34A853);
  static const Color googleBlue = Color(0xFF4285F4);

  // Status Colors
  static const Color error = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFE11D48);
  static const Color success = Color(0xFF22C55E);
  static const Color successDark = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);

  // Tinted Accents & Card Themes
  static const Color blueTint = Color(0xFFEFF6FF);
  static const Color blueIcon = Color(0xFF0284C7);
  static const Color categorySelectedBgTop = Color(0xFFFFF7ED);
  static const Color categorySelectedBgBottom = Color(0xFFFFFDFB);
}
