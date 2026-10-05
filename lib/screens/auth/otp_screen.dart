import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_assets.dart';
import '../../widgets/custom_button.dart';

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
      4,
      (index) => TextEditingController(
        text: authController.otpDigits[index],
      ),
    );
    _focusNodes = List.generate(4, (index) => FocusNode());

    // Listen to focus changes for styling
    for (var f in _focusNodes) {
      f.addListener(() {
        if (mounted) setState(() {});
      });
    }
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
        systemNavigationBarColor: Color(0xFFFFF8F2),
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: const Color(0xFFFFFBF7),
          body: Stack(
            children: [
            // ========================================================
            // BACKGROUND AMBIENT GRADIENT & PEACH ACCENT BLOBS
            // ========================================================
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFFDFB),
                      Color(0xFFFFF8F2),
                    ],
                  ),
                ),
              ),
            ),

            // Top-right soft peach glow behind phone illustration
            Positioned(
              top: 50,
              right: -10,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFE6D0).withValues(alpha: 0.65),
                ),
              ),
            ),

            // Bottom-left large soft peach overlapping blobs (ditto to design)
            Positioned(
              bottom: -60,
              left: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFE8D6).withValues(alpha: 0.6),
                ),
              ),
            ),
            Positioned(
              bottom: -15,
              left: -40,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFDEC4).withValues(alpha: 0.55),
                ),
              ),
            ),

            // ========================================================
            // FOREGROUND CONTENT
            // ========================================================
            SafeArea(
              child: Column(
                children: [
                  // TOP APP BAR (Back Button)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          size: 24.0,
                          color: Color(0xFF0F172A),
                        ),
                        splashRadius: 22.0,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),

                  // MAIN SCROLLABLE CONTENT
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12.0),

                          // ========================================================
                          // HEADER SECTION: Title (2 lines) + home5.png + Subtitle + Phone
                          // ========================================================
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Right: home5.png 3D Illustration positioned at top-right
                              Positioned(
                                top: -16.0,
                                right: -110.0,
                                child: Image.asset(
                                  AppAssets.home5,
                                  width: 170.0,
                                  height: 170.0,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryOrange.withValues(alpha: 0.1),
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

                              // Left & Across: Title & Subtitle + Phone Number
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10.0),

                                  // Line 1 & Line 2: Title (Verify Your \n Phone Number)
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.54,
                                    child: const Text(
                                      "Verify Your\nPhone Number",
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        fontSize: 27.5,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0F172A),
                                        height: 1.15,
                                        letterSpacing: -0.6,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 14.0),

                                  // Line 3: Subtitle (We have sent a 4-digit OTP to)
                                  const Text(
                                    "We have sent a 4-digit OTP to",
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF5A6981),
                                      letterSpacing: -0.1,
                                    ),
                                  ),

                                  const SizedBox(height: 6.0),

                                  // Line 4: Phone Number + Edit Button (Guaranteed Single Line)
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Obx(
                                          () => Text(
                                            "${authController.selectedCountryCode.value} ${authController.phoneController.text.trim()}",
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontFamily: AppTextStyles.fontFamily,
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF0F172A),
                                              letterSpacing: -0.1,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        GestureDetector(
                                          onTap: () => Get.back(),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Edit",
                                                style: TextStyle(
                                                  fontFamily: AppTextStyles.fontFamily,
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.primaryOrange,
                                                  decoration: TextDecoration.underline,
                                                  decorationColor: AppColors.primaryOrange,
                                                ),
                                              ),
                                              SizedBox(width: 3.0),
                                              Icon(
                                                Icons.edit_rounded,
                                                size: 13.5,
                                                color: AppColors.primaryOrange,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 34.0),

                          // ====================================================
                          // 4-DIGIT OTP INPUT BOXES (Centered with Reduced Gap)
                          // ====================================================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: SizedBox(
                                  width: 58.0,
                                  height: 68.0,
                                  child: _buildOtpBox(index),
                                ),
                              );
                            }),
                          ),

                          const SizedBox(height: 26.0),

                          // ====================================================
                          // RESEND OTP TIMER
                          // ====================================================
                          Center(
                            child: Obx(() {
                              final int seconds = authController.resendSeconds.value;
                              final bool canResend = authController.canResend.value;

                              return Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
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

                          const SizedBox(height: 30.0),

                          // ====================================================
                          // VERIFY OTP BUTTON
                          // ====================================================
                          _buildVerifyButton(),

                          const SizedBox(height: 30.0),
                        ],
                      ),
                    ),
                  ),

                  // ========================================================
                  // BOTTOM TRUST & SECURITY BADGE
                  // ========================================================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 4.0, 24.0, 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shield_outlined,
                          size: 24.0,
                          color: Color(0xFF475569),
                        ),
                        const SizedBox(width: 10.0),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Your number is safe with us.",
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF64748B),
                                height: 1.25,
                              ),
                            ),
                            Text(
                              "We never share your information.",
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF64748B),
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  // ====================================================
  // INDIVIDUAL OTP DIGIT BOX (DITTO CARD)
  // ====================================================
  Widget _buildOtpBox(int index) {
    final isFocused = _focusNodes[index].hasFocus;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13.0),
        border: Border.all(
          color: isFocused ? AppColors.primaryOrange : const Color(0xFFE2E8F0),
          width: isFocused ? 1.6 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isFocused
                ? AppColors.primaryOrange.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.035),
            blurRadius: isFocused ? 8.0 : 5.0,
            offset: const Offset(0, 2.0),
          ),
        ],
      ),
      child: Center(
        child: KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: (event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.backspace) {
              if (_controllers[index].text.isNotEmpty) {
                _controllers[index].clear();
                authController.otpDigits[index] = '';
              } else if (index > 0) {
                _focusNodes[index - 1].requestFocus();
                _controllers[index - 1].clear();
                authController.otpDigits[index - 1] = '';
              }
              setState(() {});
            }
          },
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 23.0,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
            decoration: const InputDecoration(
              counterText: "",
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            onChanged: (value) {
              authController.otpDigits[index] = value;
              if (value.isNotEmpty) {
                if (index < 3) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                  // Auto verify when 4th digit entered
                  _onVerify();
                }
              } else {
                // If cleared, jump to previous box
                if (index > 0) {
                  _focusNodes[index - 1].requestFocus();
                }
              }
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  // ====================================================
  // VERIFY OTP BUTTON (Reusable CustomButton - Height 40px)
  // ====================================================
  Widget _buildVerifyButton() {
    return Obx(
      () => CustomButton(
        text: "Verify OTP",
        height: 40.0,
        icon: Icons.arrow_forward_rounded,
        isLoading: authController.isLoading.value,
        onPressed: _onVerify,
      ),
    );
  }
}
