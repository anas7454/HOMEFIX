import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/onboarding_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/custom_button.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.onboardingGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                // ========================================================
                // TOP BAR (Step Pill & Skip Button)
                // ========================================================
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSizes.p24,
                    right: AppSizes.p24,
                    top: AppSizes.p12,
                    bottom: AppSizes.p4,
                  ),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Step Pill Badge ("01 / 03")
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.p12,
                            vertical: 5.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange,
                            borderRadius: BorderRadius.circular(AppSizes.r20),
                          ),
                          child: Text(
                            controller.items[controller.currentPage.value].step,
                            style: AppTextStyles.stepIndicator,
                          ),
                        ),

                        // Skip Button
                        GestureDetector(
                          onTap: controller.skip,
                          behavior: HitTestBehavior.opaque,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.p6,
                              vertical: AppSizes.p4,
                            ),
                            child: Text(
                              "Skip",
                              style: AppTextStyles.skipText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ========================================================
                // MAIN PAGEVIEW (Title, Subtitle & 3D Illustration)
                // ========================================================
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.items.length,
                    onPageChanged: controller.onPageChanged,
                    itemBuilder: (context, index) {
                      final item = controller.items[index];
                      return OnboardingPage(item: item);
                    },
                  ),
                ),

                // ========================================================
                // BOTTOM NAVIGATION BAR
                // ========================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.p24,
                    AppSizes.p8,
                    AppSizes.p24,
                    AppSizes.p22,
                  ),
                  child: Obx(() {
                    final bool isLastPage = controller.isLastPage;

                    return AnimatedCrossFade(
                      duration: const Duration(milliseconds: 280),
                      firstCurve: Curves.easeOutCubic,
                      secondCurve: Curves.easeOutCubic,
                      crossFadeState: isLastPage
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      // SCREEN 1 & 2: Dots Indicator + Circular Next Arrow Button
                      firstChild: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildPageIndicator(controller),
                          _buildCircleArrowButton(controller),
                        ],
                      ),
                      // SCREEN 3: Full-width "Get Started" Button
                      secondChild: _buildGetStartedButton(controller),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ====================================================
  // PAGE INDICATOR DOTS
  // ====================================================
  Widget _buildPageIndicator(OnboardingController controller) {
    return Obx(
      () => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          controller.items.length,
          (index) {
            final bool isActive = controller.currentPage.value == index;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.only(right: AppSizes.p6),
              width: isActive ? 24.0 : 7.0,
              height: 7.0,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryOrange
                    : AppColors.dotInactive,
                borderRadius: BorderRadius.circular(AppSizes.p4),
              ),
            );
          },
        ),
      ),
    );
  }

  // ====================================================
  // CIRCULAR ARROW BUTTON (FOR SCREENS 1 & 2)
  // ====================================================
  Widget _buildCircleArrowButton(OnboardingController controller) {
    return GestureDetector(
      onTap: controller.nextPage,
      child: Container(
        width: 58.0,
        height: 58.0,
        decoration: BoxDecoration(
          color: AppColors.primaryOrange,
          shape: BoxShape.circle,
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
        child: const Icon(
          Icons.arrow_forward_rounded,
          color: AppColors.textWhite,
          size: 26.0,
        ),
      ),
    );
  }

  // ====================================================
  // FULL-WIDTH "GET STARTED" BUTTON (FOR SCREEN 3 - Reusable CustomButton)
  // ====================================================
  Widget _buildGetStartedButton(OnboardingController controller) {
    return CustomButton(
      text: "Get Started",
      height: AppSizes.buttonHeightSm,
      icon: Icons.arrow_forward_rounded,
      onPressed: controller.getStarted,
    );
  }
}
