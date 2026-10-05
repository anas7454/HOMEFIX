import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_assets.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final authController = Get.find<AuthController>();
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      6,
      (index) => TextEditingController(
        text: authController.otpDigits[index],
      ),
    );
    _focusNodes = List.generate(6, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String _getCompleteOtp() {
    return _controllers.map((c) => c.text.trim()).join();
  }

  void _onVerify() {
    final otp = _getCompleteOtp();
    authController.verifyOtp(otp);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFCFCFD),
                Color(0xFFFFF9F5),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // ========================================================
                // TOP APP BAR (Back Button)
                // ========================================================
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          size: 24.0,
                          color: AppColors.textTitle,
                        ),
                      ),
                    ),
                  ),
                ),

                // ========================================================
                // MAIN SCROLLABLE BODY
                // ========================================================
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8.0),

                        // Header with Title on Left & 3D Illustration on Right
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left: Title & Subtitle
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Verify Your\nPhone Number",
                                    style: AppTextStyles.otpTitle,
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    "We have sent a 6-digit OTP to",
                                    style: AppTextStyles.otpSubText,
                                  ),
                                  const SizedBox(height: 3.0),
                                  // Phone Number + Edit Button
                                  Row(
                                    children: [
                                      Obx(
                                        () => Text(
                                          "${authController.selectedCountryCode.value} ${authController.phoneController.text.trim()}",
                                          style: const TextStyle(
                                            fontFamily:
                                                AppTextStyles.fontFamily,
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textTitle,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      GestureDetector(
                                        onTap: () => Get.back(),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Edit",
                                              style: TextStyle(
                                                fontFamily:
                                                    AppTextStyles.fontFamily,
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.primaryOrange,
                                              ),
                                            ),
                                            SizedBox(width: 3.0),
                                            Icon(
                                              Icons.edit_outlined,
                                              size: 14.0,
                                              color: AppColors.primaryOrange,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Right: 3D OTP Illustration
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 120.0,
                                alignment: Alignment.centerRight,
                                child: Image.asset(
                                  AppAssets.otpIllustration,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryOrange
                                            .withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.mark_email_read_rounded,
                                        size: 44,
                                        color: AppColors.primaryOrange,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32.0),

                        // ====================================================
                        // 6-DIGIT OTP INPUT BOXES
                        // ====================================================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return _buildOtpBox(index);
                          }),
                        ),

                        const SizedBox(height: 24.0),

                        // ====================================================
                        // RESEND OTP TIMER
                        // ====================================================
                        Center(
                          child: Obx(() {
                            final int seconds = authController.resendSeconds.value;
                            final bool canResend = authController.canResend.value;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Didn't receive OTP? ",
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                if (!canResend) ...[
                                  Text(
                                    "Resend in 00:${seconds.toString().padLeft(2, '0')}",
                                    style: const TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryOrange,
                                    ),
                                  ),
                                ] else ...[
                                  GestureDetector(
                                    onTap: authController.resendOtp,
                                    child: const Text(
                                      "Resend OTP",
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryOrange,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            );
                          }),
                        ),

                        const SizedBox(height: 32.0),

                        // ====================================================
                        // VERIFY OTP BUTTON
                        // ====================================================
                        _buildVerifyButton(),

                        const SizedBox(height: 48.0),
                      ],
                    ),
                  ),
                ),

                // ========================================================
                // BOTTOM TRUST & SECURITY BADGE
                // ========================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF1F5F9),
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          size: 20.0,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      const Text(
                        "Your number is safe with us.\nWe never share your information.",
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF64748B),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ====================================================
  // INDIVIDUAL OTP DIGIT BOX
  // ====================================================
  Widget _buildOtpBox(int index) {
    return Container(
      width: 48.0,
      height: 56.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: _focusNodes[index].hasFocus
              ? AppColors.primaryOrange
              : const Color(0xFFE2E8F0),
          width: _focusNodes[index].hasFocus ? 1.8 : 1.2,
        ),
        boxShadow: [
          if (_focusNodes[index].hasFocus)
            BoxShadow(
              color: AppColors.primaryOrange.withValues(alpha: 0.15),
              blurRadius: 8.0,
              offset: const Offset(0, 2.0),
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4.0,
              offset: const Offset(0, 2.0),
            ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 21.0,
            fontWeight: FontWeight.w700,
            color: AppColors.textTitle,
          ),
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            authController.otpDigits[index] = value;
            if (value.isNotEmpty) {
              if (index < 5) {
                _focusNodes[index + 1].requestFocus();
              } else {
                _focusNodes[index].unfocus();
              }
            } else {
              if (index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            }
            setState(() {});
          },
        ),
      ),
    );
  }

  // ====================================================
  // VERIFY OTP BUTTON
  // ====================================================
  Widget _buildVerifyButton() {
    return GestureDetector(
      onTap: _onVerify,
      child: Container(
        width: double.infinity,
        height: 54.0,
        decoration: BoxDecoration(
          color: AppColors.primaryOrange,
          borderRadius: BorderRadius.circular(27.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withValues(alpha: 0.35),
              blurRadius: 16.0,
              spreadRadius: 0.0,
              offset: const Offset(0, 6.0),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Obx(() {
          if (authController.isLoading.value) {
            return const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            );
          }

          return const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verify OTP",
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(width: 8.0),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20.0,
              ),
            ],
          );
        }),
      ),
    );
  }
}
