import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/service_category_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/category_3d_icons.dart';

class ServiceCategoryScreen extends StatelessWidget {
  const ServiceCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServiceCategoryController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.bgWarm,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bgGradientTop,
        body: SafeArea(
          child: Column(
            children: [
              // ========================================================
              // TOP APP BAR (Back Button + Step Progress Bar + "3/6")
              // ========================================================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p16,
                  vertical: AppSizes.p8,
                ),
                child: Row(
                  children: [
                    // Back Button
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(AppSizes.r20),
                      child: const Padding(
                        padding: EdgeInsets.all(AppSizes.p6),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: AppSizes.iconLg,
                          color: AppColors.iconDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.p16),

                    // Progress Bar (3/6)
                    Expanded(
                      child: Center(
                        child: Container(
                          height: 7.0,
                          constraints: const BoxConstraints(maxWidth: 160.0),
                          decoration: BoxDecoration(
                            color: AppColors.peachGlow2,
                            borderRadius: BorderRadius.circular(AppSizes.r10),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: 3 / 6, // Step 3 of 6
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryOrange,
                                  borderRadius: BorderRadius.circular(AppSizes.r10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: AppSizes.p16),

                    // Step Indicator Text (3/6)
                    const Text(
                      '3/6',
                      style: AppTextStyles.stepIndicatorOrange,
                    ),
                  ],
                ),
              ),

              // ========================================================
              // SCROLLABLE BODY CONTENT
              // ========================================================
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSizes.p12),

                      // Title
                      const Text(
                        'Select Service\nCategory',
                        style: AppTextStyles.basicInfoTitle,
                      ),
                      const SizedBox(height: AppSizes.p6),

                      // Subtitle
                      const Text(
                        'Choose the services you provide.',
                        style: AppTextStyles.basicInfoSubtitle,
                      ),
                      const SizedBox(height: AppSizes.p20),

                      // 3-Column Ultra Premium 3D Service Category Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: AppSizes.p14,
                          crossAxisSpacing: AppSizes.p14,
                          childAspectRatio: 0.79,
                        ),
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          final item = controller.categories[index];
                          return Obx(() {
                            final isSelected = controller.isSelected(item.id);
                            return _CategoryCard(
                              item: item,
                              isSelected: isSelected,
                              onTap: () => controller.toggleCategory(item.id),
                            );
                          });
                        },
                      ),

                      const SizedBox(height: AppSizes.p20),
                    ],
                  ),
                ),
              ),

              // ========================================================
              // REUSABLE BOTTOM CONTINUE BUTTON
              // ========================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.p20,
                  AppSizes.p10,
                  AppSizes.p20,
                  AppSizes.p16,
                ),
                child: Obx(
                  () => CustomButton(
                    text: 'Continue',
                    height: AppSizes.buttonHeightSm,
                    icon: Icons.arrow_forward_rounded,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.onContinue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========================================================
// ULTRA PREMIUM 3D SERVICE CATEGORY CARD
// ========================================================
class _CategoryCard extends StatelessWidget {
  final ServiceCategoryItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.r20),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.categorySelectedBgTop,
                    AppColors.categorySelectedBgBottom,
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: item.ambientColors,
                ),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryOrange
                : AppColors.borderLight,
            width: isSelected ? 2.0 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryOrange.withValues(alpha: 0.22)
                  : Colors.black.withValues(alpha: 0.035),
              blurRadius: isSelected ? 14.0 : 6.0,
              spreadRadius: 0.0,
              offset: isSelected ? const Offset(0, 4.0) : const Offset(0, 2.0),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Selected Orange Checkmark Badge (Top Right)
            if (isSelected)
              Positioned(
                top: -3.0,
                right: -3.0,
                child: Container(
                  width: 22.0,
                  height: 22.0,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryOrange.withValues(alpha: 0.45),
                        blurRadius: 6.0,
                        offset: const Offset(0, 2.0),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 14.0,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ),

            // Card Inner Content (3D Icon + Title)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p6, vertical: AppSizes.p10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 3D Custom Rendered Graphic Icon
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Category3DIcon(
                        categoryId: item.id,
                        size: 50.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.p6),

                  // Category Title Label
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        item.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: isSelected
                            ? AppTextStyles.categoryGridItemSelected
                            : AppTextStyles.categoryGridItem,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
