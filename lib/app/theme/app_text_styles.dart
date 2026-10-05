import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Central Font Family
  static const String fontFamily = 'Sora';

  // ========================================================
  // ONBOARDING STYLES
  // ========================================================
  static const TextStyle onboardingTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 29.0,
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
    fontSize: 14.0,
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

  static const TextStyle getStartedButton = TextStyle(
    fontFamily: fontFamily,
    color: Colors.white,
    fontSize: 16.5,
    fontWeight: FontWeight.w700, // Sora Bold
    letterSpacing: 0.2,
  );

  static const TextStyle placeholderFallback = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    color: AppColors.textSub,
    fontWeight: FontWeight.w500,
  );

  // ========================================================
  // AUTH / LOGIN SCREEN STYLES
  // ========================================================
  static const TextStyle authCardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22.0,
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

  static const TextStyle countryCode = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textTitle,
  );

  static const TextStyle phoneInput = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textTitle,
    letterSpacing: 0.4,
  );

  static const TextStyle phoneHint = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textPlaceholder,
    letterSpacing: 0.0,
  );

  static const TextStyle orDivider = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPlaceholder,
    letterSpacing: 0.5,
  );

  static const TextStyle googleButtonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textTitle,
  );

  static const TextStyle termsPrompt = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textSub,
  );

  static const TextStyle termsLink = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textTitle,
    decoration: TextDecoration.underline,
  );

  // ========================================================
  // OTP SCREEN STYLES
  // ========================================================
  static const TextStyle otpHeaderTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 27.5,
    fontWeight: FontWeight.w800,
    color: AppColors.textTitle,
    height: 1.15,
    letterSpacing: -0.6,
  );

  static const TextStyle otpHeaderSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    letterSpacing: -0.1,
  );

  static const TextStyle otpPhoneNumber = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.5,
    fontWeight: FontWeight.w800,
    color: AppColors.textTitle,
    letterSpacing: -0.1,
  );

  static const TextStyle otpEditLink = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.5,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryOrange,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primaryOrange,
  );

  static const TextStyle otpDigitBox = TextStyle(
    fontFamily: fontFamily,
    fontSize: 23.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textTitle,
  );

  static const TextStyle otpResendPrompt = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textSub,
  );

  static const TextStyle otpResendTimer = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.5,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryOrange,
  );

  static const TextStyle otpResendAction = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.5,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryOrange,
    decoration: TextDecoration.underline,
  );

  static const TextStyle trustBadge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSub,
    height: 1.25,
  );

  // Legacy / Backwards-compatible OTP references
  static const TextStyle otpTitle = otpHeaderTitle;
  static const TextStyle otpSubText = otpHeaderSubtitle;
  static const TextStyle phoneInputText = phoneInput;
  static const TextStyle otpDigit = otpDigitBox;

  // ========================================================
  // ROLE SELECTION SCREEN STYLES (Select Profile)
  // ========================================================
  static const TextStyle roleSelectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 27.0,
    fontWeight: FontWeight.w800,
    color: AppColors.textTitle,
    height: 1.18,
    letterSpacing: -0.5,
  );

  static const TextStyle roleSelectionSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textSub,
    letterSpacing: -0.1,
  );

  static const TextStyle roleCardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.5,
    fontWeight: FontWeight.w800,
    color: AppColors.textTitle,
    letterSpacing: -0.3,
  );

  static const TextStyle roleCardDescription = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSub,
    height: 1.34,
  );

  // ========================================================
  // BASIC INFORMATION SCREEN STYLES (Add Profile)
  // ========================================================
  static const TextStyle basicInfoTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26.0,
    fontWeight: FontWeight.w800,
    color: AppColors.textTitle,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle basicInfoSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSub,
    height: 1.35,
    letterSpacing: -0.1,
  );

  static const TextStyle addPhotoLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.5,
    fontWeight: FontWeight.w700,
    color: AppColors.textTitle,
    letterSpacing: -0.2,
  );

  static const TextStyle inputCardLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textSub,
  );

  static const TextStyle inputCardValue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textTitle,
  );

  static const TextStyle inputCardHint = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPlaceholder,
  );

  static const TextStyle bottomSheetTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textTitle,
  );

  static const TextStyle bottomSheetItem = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textTitle,
  );

  static const TextStyle bottomSheetItemSelected = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.0,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryOrange,
  );

  static const TextStyle stepIndicatorOrange = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.5,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryOrange,
  );

  // ========================================================
  // SERVICE CATEGORY SCREEN STYLES
  // ========================================================
  static const TextStyle categoryGridItem = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textTitle,
    height: 1.15,
  );

  static const TextStyle categoryGridItemSelected = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryOrange,
    height: 1.15,
  );

  // ========================================================
  // WORK DETAILS SCREEN STYLES
  // ========================================================
  static const TextStyle workDetailsFieldLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textTitle,
  );

  static const TextStyle workDetailsFieldRequired = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryOrange,
  );

  static const TextStyle workDetailsAboutInput = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    color: AppColors.textTitle,
    height: 1.45,
  );

  static const TextStyle workDetailsCurrencySymbol = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    color: AppColors.iconSlate,
  );

  static const TextStyle workDetailsPricePrefix = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textTitle,
  );

  static const TextStyle workDetailsPriceInput = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textTitle,
  );

  static const TextStyle workDetailsRateUnit = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.iconSlate,
  );

  // ========================================================
  // BUTTONS & GENERAL HEADINGS
  // ========================================================
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.0,
    fontWeight: FontWeight.w600, // Sora SemiBold
    color: Colors.white,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  static const TextStyle headingLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26.0,
    fontWeight: FontWeight.w800,
    color: AppColors.textTitle,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textTitle,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textTitle,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textTitle,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSub,
  );

  static const TextStyle inputLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textSub,
  );

  static const TextStyle inputValue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textTitle,
  );
}
