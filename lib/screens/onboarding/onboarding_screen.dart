import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/onboarding_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/models/onboarding_model.dart';

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
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.onboardingGradient,
          ),
          child: SafeArea(
            minimum: const EdgeInsets.only(bottom: 12),
            child: Builder(builder: (context) {
              if (controller.items.isEmpty) return const SizedBox();
              
              return Column(
                children: [
                  // =======================
                  // MIDDLE: SWIPING CONTENT
                  // =======================
                  Expanded(
                    child: PageView.builder(
                      controller: controller.pageController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.items.length,
                      onPageChanged: controller.onPageChanged,
                      itemBuilder: (context, index) {
                        final item = controller.items[index];
                        return _OnboardingPage(data: item);
                      },
                    ),
                  ),

                  // =======================
                  // BOTTOM: INDICATORS & BUTTONS
                  // =======================
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 48.0),
                    child: Obx(() {
                      final int pageIndex = controller.currentPage.value;
                      final int pageCount = controller.items.length;
                      
                      return Column(
                        children: [
                          _PageIndicator(selectedIndex: pageIndex, count: pageCount),
                          const SizedBox(height: 14.0),
                          if (pageIndex > 0)
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: _OutlineButton(
                                    label: 'Back',
                                    onPressed: () {
                                      controller.pageController.previousPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: _PrimaryButton(
                                    label: pageIndex == pageCount - 1 ? 'Get Started' : 'Next',
                                    onPressed: controller.nextPage,
                                  ),
                                ),
                              ],
                            )
                          else
                            _PrimaryButton(label: 'Continue', onPressed: controller.nextPage),
                        ],
                      );
                    }),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final OnboardingItem data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double imageHeight = (constraints.maxWidth - 32.0) * 1052 / 698;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Image
              SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: Image.asset(
                  data.image,
                  key: const ValueKey<String>('onboarding-image'),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24.0),
              
              // Title and Subtitle
              Text(
                data.title,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8.0),
              Text(
                data.description,
                style: AppTextStyles.onboardingSubText,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.selectedIndex, required this.count});

  final int selectedIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(count, (int index) {
        final bool selected = index == selectedIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: selected ? 22.4 : 8.0,
          height: 8.0,
          margin: EdgeInsets.only(right: index == count - 1 ? 0 : 4.0),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.8),
          ),
        );
      }),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44.0,
      child: FilledButton(
        onPressed: onPressed ?? () {},
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(label, style: AppTextStyles.button),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.0,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.zero,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
