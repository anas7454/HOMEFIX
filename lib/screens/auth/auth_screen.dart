import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_assets.dart';
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
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: Colors.white,
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
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0),
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
                      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
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
                          const SizedBox(height: 6.0),

                          // Card Subtitle
                          const Text(
                            "Book trusted professionals for all your\nhome needs in just a few taps.",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.authCardSubtitle,
                          ),
                          const SizedBox(height: 20.0),

                          // Phone Input Field (Max 10 Indian Digits)
                          _buildPhoneInputField(authController),
                          const SizedBox(height: 16.0),

                          // Reusable Continue Button (Height 40px)
                          _buildContinueButton(authController),
                          const SizedBox(height: 16.0),

                          // OR Divider
                          _buildOrDivider(),
                          const SizedBox(height: 16.0),

                          // Continue with Google Button
                          _buildGoogleButton(authController),
                          const SizedBox(height: 16.0),

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
      height: 44.0,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                const SizedBox(width: 6.0),
                Text(
                  controller.selectedCountryCode.value,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTitle,
                  ),
                ),
                const SizedBox(width: 3.0),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16.0,
                  color: Color(0xFF64748B),
                ),
              ],
            ),
          ),

          // Vertical Divider
          Container(
            width: 1.0,
            height: 20.0,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            color: const Color(0xFFE2E8F0),
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
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textTitle,
                letterSpacing: 0.4,
              ),
              decoration: const InputDecoration(
                hintText: "Enter 10-digit number",
                hintStyle: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 0.0,
                ),
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
        height: 40.0,
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
            color: Color(0xFFE2E8F0),
            thickness: 1.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0),
          child: Text(
            "OR",
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Color(0xFFE2E8F0),
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
        height: 52.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26.0),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1.2,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGoogleGLogo(),
            const SizedBox(width: 10.0),
            const Text(
              "Continue with Google",
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textTitle,
              ),
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
      width: 20.0,
      height: 20.0,
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
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 11.5,
            fontWeight: FontWeight.w400,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 2.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {},
              child: const Text(
                "Terms of Service",
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTitle,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Text(
              " and ",
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
                color: Color(0xFF64748B),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                "Privacy Policy",
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTitle,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ====================================================
// VECTOR GOOGLE 'G' PAINTER
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
      ..color = const Color(0xFFEA4335)
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
      ..color = const Color(0xFFFBBC05)
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
      ..color = const Color(0xFF34A853)
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
      ..color = const Color(0xFF4285F4)
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
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(w / 2 - 1, h / 2 - 1.75, w / 2 + 1, 3.5),
      blueBarPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
