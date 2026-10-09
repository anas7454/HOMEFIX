import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/custom_button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.surface,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // ========================================================
              // HERO BACKGROUND (HomeFix Brand, Technician & Villa)
              // ========================================================
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.60,
                child: Image.asset(
                  AppAssets.authBackground,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),

              // Subtle top gradient overlay for status bar readability
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ========================================================
              // BOTTOM SHEET LOGIN CARD
              // ========================================================
              Positioned(
                top: MediaQuery.of(context).size.height * 0.33, // Moved card significantly up
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.r32),
                      topRight: Radius.circular(AppSizes.r32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 24.0,
                        offset: const Offset(0, -6.0),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.p24,
                        AppSizes.p32,
                        AppSizes.p24,
                        AppSizes.p24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Card Title
                          const Text(
                            "Welcome to HomeFix",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.authCardTitle,
                          ),
                          const SizedBox(height: AppSizes.p6),

                          // Card Subtitle
                          const Text(
                            "Book trusted professionals for all your\nhome needs in just a few taps.",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.authCardSubtitle,
                          ),
                          const SizedBox(height: AppSizes.p20),

                          // Phone Input Field (Max 10 Indian Digits)
                          _buildPhoneInputField(authController),
                          const SizedBox(height: AppSizes.p16),

                          // Reusable Continue Button (Height 40px)
                          _buildContinueButton(authController),
                          const SizedBox(height: AppSizes.p16),


                          // Terms & Privacy Footer
                          _buildTermsAndPrivacy(),
                          const SizedBox(height: AppSizes.p32), // Added extra padding at the bottom to shift content slightly upward
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ====================================================
  // PHONE INPUT FIELD (Flag + +91 + Phone number, max 10 digits)
  // ====================================================
  Widget _buildPhoneInputField(AuthController controller) {
    return Container(
      height: AppSizes.inputHeight,
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(
          color: AppColors.border,
          width: 1.1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Flag & Country Code
          Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.countryFlag.value,
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(width: AppSizes.p6),
                Text(
                  controller.selectedCountryCode.value,
                  style: AppTextStyles.countryCode,
                ),
                const SizedBox(width: 3.0),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: AppSizes.iconSm,
                  color: AppColors.iconMuted,
                ),
              ],
            ),
          ),

          // Vertical Divider
          Container(
            width: 1.0,
            height: 20.0,
            margin: const EdgeInsets.symmetric(horizontal: AppSizes.p10),
            color: AppColors.divider,
          ),

          // Phone Number Input (Strict 10 Digits)
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: AppTextStyles.phoneInput,
              decoration: const InputDecoration(
                hintText: "Enter 10-digit number",
                hintStyle: AppTextStyles.phoneHint,
                counterText: "",
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================
  // CONTINUE BUTTON (Reusable CustomButton - Height 40px)
  // ====================================================
  Widget _buildContinueButton(AuthController controller) {
    return Obx(
      () => CustomButton(
        text: "Continue",
        height: AppSizes.buttonHeightSm,
        icon: Icons.arrow_forward_rounded,
        isLoading: controller.isLoading.value,
        onPressed: controller.sendOtp,
      ),
    );
  }

  // ====================================================
  // TERMS & PRIVACY POLICY FOOTER
  // ====================================================
  Widget _buildTermsAndPrivacy() {
    return Column(
      children: [
        const Text(
          "By continuing, you agree to our",
          textAlign: TextAlign.center,
          style: AppTextStyles.termsPrompt,
        ),
        const SizedBox(height: AppSizes.p2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {},
              child: const Text(
                "Terms of Service",
                style: AppTextStyles.termsLink,
              ),
            ),
            const Text(
              " and ",
              style: AppTextStyles.termsPrompt,
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                "Privacy Policy",
                style: AppTextStyles.termsLink,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

