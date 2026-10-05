import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/models/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ========================================================
        // TITLE & SUBTITLE SECTION
        // ========================================================
        Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 26.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Headline Title (e.g., "All Home Services\nin One App")
              Text(
                item.title,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8.0),
              // Subtitle Description
              Text(
                item.description,
                style: AppTextStyles.onboardingSubText,
              ),
            ],
          ),
        ),

        const SizedBox(height: 12.0),

        // ========================================================
        // MAIN 3D ILLUSTRATION / GRAPHIC SECTION
        // ========================================================
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Image.asset(
                item.image,
                width: double.infinity,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(60),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: AppColors.primaryOrange,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Place image at:\n${item.image}',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.placeholderFallback,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
