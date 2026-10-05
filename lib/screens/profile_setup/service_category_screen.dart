import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/service_category_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';

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
        systemNavigationBarColor: Color(0xFFFFFDFB),
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDFB),
        body: SafeArea(
          child: Column(
            children: [
              // ========================================================
              // TOP APP BAR (Back Button + Step Progress Bar + "3/6")
              // ========================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    // Back Button
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(20),
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 24.0,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),

                    // Progress Bar (3/6)
                    Expanded(
                      child: Center(
                        child: Container(
                          height: 7.0,
                          constraints: const BoxConstraints(maxWidth: 160.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE8D6),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: 3 / 6, // Step 3 of 6
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryOrange,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16.0),

                    // Step Indicator Text (3/6)
                    const Text(
                      '3/6',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ),

              // ========================================================
              // SCROLLABLE BODY CONTENT
              // ========================================================
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12.0),

                      // Title
                      const Text(
                        'Select Service\nCategory',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6.0),

                      // Subtitle
                      const Text(
                        'Choose the services you provide.',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF64748B),
                          height: 1.35,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // 3-Column Service Category Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12.0,
                          crossAxisSpacing: 12.0,
                          childAspectRatio: 0.88,
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

                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),

              // ========================================================
              // REUSABLE BOTTOM CONTINUE BUTTON
              // ========================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                child: Obx(
                  () => CustomButton(
                    text: 'Continue',
                    height: 50.0,
                    borderRadius: 25.0,
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
// INDIVIDUAL SERVICE CATEGORY CARD WIDGET
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
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF9F5) : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected ? AppColors.primaryOrange : const Color(0xFFE8EEF5),
            width: isSelected ? 1.8 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryOrange.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: isSelected ? 10.0 : 4.0,
              offset: isSelected ? const Offset(0, 3.0) : const Offset(0, 1.0),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Selected Checkmark Badge (Top Right)
            if (isSelected)
              Positioned(
                top: -2.0,
                right: -2.0,
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryOrange,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 13.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // Card Content (Icon + Title)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon Container
                  Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: item.bgColor,
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Center(
                      child: Icon(
                        item.icon,
                        color: item.iconColor,
                        size: 24.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Category Label
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 12.0,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? AppColors.primaryOrange : const Color(0xFF0F172A),
                      height: 1.15,
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
