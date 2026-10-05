import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_sizes.dart';
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
        systemNavigationBarColor: AppColors.bgGradientBottom,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: AppColors.bgWarm,
          body: Stack(
            children: [
              // ========================================================
              // BACKGROUND AMBIENT GRADIENT & PEACH ACCENT BLOBS
              // ========================================================
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.ambientWarmGradient,
                  ),
                ),
              ),

              // Top-right soft peach glow behind phone illustration
              Positioned(
                top: 50.0,
                right: -10.0,
                child: Container(
                  width: 170.0,
                  height: 170.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.peachGlow1.withValues(alpha: 0.65),
                  ),
                ),
              ),

              // Bottom-left soft peach overlapping ambient blobs
              Positioned(
                bottom: -60.0,
                left: -60.0,
                child: Container(
                  width: 240.0,
                  height: 240.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.peachGlow2.withValues(alpha: 0.6),
                  ),
                ),
              ),
              Positioned(
                bottom: -15.0,
                left: -40.0,
                child: Container(
                  width: 170.0,
                  height: 170.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.peachGlow3.withValues(alpha: 0.55),
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
                      padding: const EdgeInsets.only(
                        left: AppSizes.p16,
                        top: AppSizes.p8,
                        bottom: AppSizes.p4,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            size: AppSizes.iconLg,
                            color: AppColors.iconDark,
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
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.p22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppSizes.p12),

                            // ========================================================
                            // HEADER SECTION: Title + home5.png + Subtitle + Phone
                            // ========================================================
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Right: home5.png 3D Illustration positioned at top-right
                                Positioned(
                                  top: -16.0,
                                  right: -150.0,
                                  child: Image.asset(
                                    AppAssets.home5,
                                    width: 170.0,
                                    height: 170.0,
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.high,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 90.0,
                                        height: 90.0,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryOrange.withValues(alpha: 0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.mark_email_read_rounded,
                                          size: 44.0,
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
                                    const SizedBox(height: AppSizes.p40),

                                    // Line 1 & Line 2: Title (Verify Your \n Phone Number)
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.54,
                                      child: const Text(
                                        "Verify Your\nPhone Number",
                                        style: AppTextStyles.otpHeaderTitle,
                                      ),
                                    ),

                                    const SizedBox(height: AppSizes.p14),

                                    // Line 3: Subtitle (We have sent a 4-digit OTP to)
                                    const Text(
                                      "We have sent a 4-digit OTP to",
                                      style: AppTextStyles.otpHeaderSubtitle,
                                    ),

                                    const SizedBox(height: AppSizes.p6),

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
                                              style: AppTextStyles.otpPhoneNumber,
                                            ),
                                          ),
                                          const SizedBox(width: AppSizes.p8),
                                          GestureDetector(
                                            onTap: () => Get.back(),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Edit",
                                                  style: AppTextStyles.otpEditLink,
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
                            // 4-DIGIT OTP INPUT BOXES (Shifted to Left)
                            // ====================================================
                            Padding(
                              padding: const EdgeInsets.only(right: AppSizes.p28),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(4, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                                    child: SizedBox(
                                      width: 58.0,
                                      height: 68.0,
                                      child: _buildOtpBox(index),
                                    ),
                                  );
                                }),
                              ),
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
                                      style: AppTextStyles.otpResendPrompt,
                                    ),
                                    if (!canResend) ...[
                                      Text(
                                        "Resend in 00:${seconds.toString().padLeft(2, '0')}",
                                        style: AppTextStyles.otpResendTimer,
                                      ),
                                    ] else ...[
                                      GestureDetector(
                                        onTap: authController.resendOtp,
                                        child: const Text(
                                          "Resend OTP",
                                          style: AppTextStyles.otpResendAction,
                                        ),
                                      ),
                                    ],
                                  ],
                                );
                              }),
                            ),

                            const SizedBox(height: 30.0),

                            // ====================================================
                            // VERIFY OTP BUTTON (Reusable CustomButton)
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
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.p24,
                        AppSizes.p4,
                        AppSizes.p24,
                        AppSizes.p16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            size: AppSizes.iconLg,
                            color: AppColors.iconSlate,
                          ),
                          const SizedBox(width: AppSizes.p10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Your number is safe with us.",
                                style: AppTextStyles.trustBadge,
                              ),
                              Text(
                                "We never share your information.",
                                style: AppTextStyles.trustBadge,
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
  // INDIVIDUAL OTP DIGIT BOX (Using AppColors and AppTextStyles)
  // ====================================================
  Widget _buildOtpBox(int index) {
    final isFocused = _focusNodes[index].hasFocus;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13.0),
        border: Border.all(
          color: isFocused ? AppColors.primaryOrange : AppColors.border,
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
            style: AppTextStyles.otpDigitBox,
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
                  _onVerify();
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
        height: AppSizes.buttonHeightSm,
        icon: Icons.arrow_forward_rounded,
        isLoading: authController.isLoading.value,
        onPressed: _onVerify,
      ),
    );
  }
}
