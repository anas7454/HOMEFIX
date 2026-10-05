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
              Align(
                alignment: Alignment.bottomCenter,
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
                        AppSizes.p24,
                        AppSizes.p24,
                        AppSizes.p16,
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

                          // OR Divider
                          _buildOrDivider(),
                          const SizedBox(height: AppSizes.p16),

                          // Continue with Google Button
                          _buildGoogleButton(authController),
                          const SizedBox(height: AppSizes.p16),

                          // Terms & Privacy Footer
                          _buildTermsAndPrivacy(),
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
  // OR DIVIDER
  // ====================================================
  Widget _buildOrDivider() {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.divider,
            thickness: 1.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.p14),
          child: Text(
            "OR",
            style: AppTextStyles.orDivider,
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.divider,
            thickness: 1.0,
          ),
        ),
      ],
    );
  }

  // ====================================================
  // GOOGLE LOGIN BUTTON
  // ====================================================
  Widget _buildGoogleButton(AuthController controller) {
    return GestureDetector(
      onTap: controller.loginWithGoogle,
      child: Container(
        width: double.infinity,
        height: AppSizes.buttonHeightLg,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r26),
          border: Border.all(
            color: AppColors.border,
            width: 1.2,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGoogleGLogo(),
            const SizedBox(width: AppSizes.p10),
            const Text(
              "Continue with Google",
              style: AppTextStyles.googleButtonText,
            ),
          ],
        ),
      ),
    );
  }

  // ====================================================
  // GOOGLE 'G' ICON WIDGET
  // ====================================================
  Widget _buildGoogleGLogo() {
    return SizedBox(
      width: AppSizes.p20,
      height: AppSizes.p20,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
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

// ====================================================
// VECTOR GOOGLE 'G' PAINTER (Using AppColors)
// ====================================================
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    // Red Arc
    final redPaint = Paint()
      ..color = AppColors.googleRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 1.75),
      3.14159 * 0.75,
      3.14159 * 0.5,
      false,
      redPaint,
    );

    // Yellow Arc
    final yellowPaint = Paint()
      ..color = AppColors.googleYellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 1.75),
      3.14159 * 0.25,
      3.14159 * 0.5,
      false,
      yellowPaint,
    );

    // Green Arc
    final greenPaint = Paint()
      ..color = AppColors.googleGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 1.75),
      3.14159 * 1.25,
      3.14159 * 0.5,
      false,
      greenPaint,
    );

    // Blue Arc & Bar
    final bluePaint = Paint()
      ..color = AppColors.googleBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 1.75),
      3.14159 * 1.75,
      3.14159 * 0.5,
      false,
      bluePaint,
    );

    final blueBarPaint = Paint()
      ..color = AppColors.googleBlue
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(w / 2 - 1, h / 2 - 1.75, w / 2 + 1, 3.5),
      blueBarPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
