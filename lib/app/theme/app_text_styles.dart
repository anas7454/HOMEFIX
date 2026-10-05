import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Central Font Family
  static const String fontFamily = 'Sora';

  // Onboarding & Headings
  static const TextStyle onboardingTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 29,
    fontWeight: FontWeight.w700, // Sora Bold
    color: AppColors.textTitle,
    height: 1.22,
    letterSpacing: -0.5,
  );

  static const TextStyle onboardingSubText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.5,
    fontWeight: FontWeight.w400, // Sora Regular
    color: AppColors.textSub,
    height: 1.45,
    letterSpacing: -0.15,
  );

  static const TextStyle skipText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600, // Sora SemiBold
    color: AppColors.skipColor,
    letterSpacing: 0.1,
  );

  static const TextStyle stepIndicator = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.5,
    fontWeight: FontWeight.w700, // Sora Bold
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600, // Sora SemiBold
    color: Colors.white,
  );

  static const TextStyle getStartedButton = TextStyle(
    fontFamily: fontFamily,
    color: Colors.white,
    fontSize: 16.5,
    fontWeight: FontWeight.w700, // Sora Bold
    letterSpacing: 0.2,
  );

  static const TextStyle placeholderFallback = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    color: AppColors.textSub,
    fontWeight: FontWeight.w500,
  );

  // Auth & OTP Styles
  static const TextStyle authCardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700, // Sora Bold
    color: AppColors.textTitle,
    letterSpacing: -0.4,
  );

  static const TextStyle authCardSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.5,
    fontWeight: FontWeight.w400, // Sora Regular
    color: AppColors.textSub,
    height: 1.45,
  );

  static const TextStyle otpTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700, // Sora Bold
    color: AppColors.textTitle,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle otpSubText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Sora Regular
    color: AppColors.textSub,
    height: 1.4,
  );

  static const TextStyle phoneInputText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600, // Sora SemiBold
    color: AppColors.textTitle,
  );

  static const TextStyle otpDigit = TextStyle(
    fontFamily: fontFamily,
    fontSize: 21,
    fontWeight: FontWeight.w700, // Sora Bold
    color: AppColors.textTitle,
  );

  // General App Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textTitle,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textTitle,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textTitle,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textTitle,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSub,
  );
}
