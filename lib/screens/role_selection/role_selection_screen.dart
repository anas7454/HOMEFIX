import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/role_selection_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/custom_button.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RoleSelectionController());

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

            // Top-right soft peach ambient glow circle
            Positioned(
              top: 40.0,
              right: -50.0,
              child: Container(
                width: 190.0,
                height: 190.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.peachGlow2.withValues(alpha: 0.65),
                ),
              ),
            ),

            // Bottom-left soft peach ambient glow circle
            Positioned(
              bottom: 40.0,
              left: -60.0,
              child: Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.peachGlow3.withValues(alpha: 0.55),
                ),
              ),
            ),

            // ========================================================
            // MAIN FOREGROUND CONTENT
            // ========================================================
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOP APP BAR (Back Button)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppSizes.p14,
                      top: AppSizes.p6,
                      bottom: AppSizes.p4,
                    ),
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: AppSizes.iconLg,
                        color: AppColors.iconDark,
                      ),
                      splashRadius: 22.0,
                      padding: const EdgeInsets.all(AppSizes.p8),
                      constraints: const BoxConstraints(),
                    ),
                  ),

                  // SCROLLABLE CONTENT (Title, Subtitle, and Role Cards)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSizes.p6),

                          // ========================================================
                          // TITLE & SUBTITLE
                          // ========================================================
                          const Text(
                            "How do you want\nto use HomeFix?",
                            style: AppTextStyles.roleSelectionTitle,
                          ),
                          const SizedBox(height: AppSizes.p6),

                          const Text(
                            "Choose your role to get started",
                            style: AppTextStyles.roleSelectionSubtitle,
                          ),
                          const SizedBox(height: AppSizes.p18),

                          // ========================================================
                          // ROLE CARD 1: "I need a service"
                          // ========================================================
                          Obx(
                            () => _RoleCard(
                              imagePath: AppAssets.home7,
                              title: "I need a service",
                              description:
                                  "Book trusted professionals for\nyour home, office or personal needs.",
                              isSelected:
                                  controller.selectedRole.value == UserRoleType.customer,
                              onTap: () =>
                                  controller.selectRole(UserRoleType.customer),
                            ),
                          ),

                          const SizedBox(height: AppSizes.p14),

                          // ========================================================
                          // ROLE CARD 2: "I provide services"
                          // ========================================================
                          Obx(
                            () => _RoleCard(
                              imagePath: AppAssets.home8,
                              title: "I provide services",
                              description:
                                  "Join as a professional and get\nnew job requests near you.",
                              isSelected:
                                  controller.selectedRole.value == UserRoleType.provider,
                              onTap: () =>
                                  controller.selectRole(UserRoleType.provider),
                            ),
                          ),

                          const SizedBox(height: AppSizes.p12),
                        ],
                      ),
                    ),
                  ),

                  // ========================================================
                  // BOTTOM REUSABLE CONTINUE BUTTON (CustomButton)
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
                        text: "Continue",
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
          ],
        ),
      ),
    );
  }
}

// ========================================================
// INDIVIDUAL ROLE CARD COMPONENT
// ========================================================
class _RoleCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.imagePath,
    required this.title,
    required this.description,
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
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r18),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryOrange
                : AppColors.border,
            width: isSelected ? 1.8 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryOrange.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: isSelected ? 14.0 : 8.0,
              spreadRadius: 0.0,
              offset: isSelected ? const Offset(0, 3.0) : const Offset(0, 2.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP BANNER IMAGE (With Dynamic Selection Badge)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16.5),
                  ),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: 115.0,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),

                // Interactive Selection Radio Indicator (Top Right)
                Positioned(
                  top: AppSizes.p10,
                  right: AppSizes.p10,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 25.0,
                    height: 25.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.primaryOrange
                          : AppColors.surface.withValues(alpha: 0.85),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryOrange
                            : AppColors.border,
                        width: isSelected ? 0.0 : 1.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? AppColors.primaryOrange.withValues(alpha: 0.3)
                              : Colors.black.withValues(alpha: 0.06),
                          blurRadius: 5.0,
                          offset: const Offset(0, 2.0),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Center(
                            child: Icon(
                              Icons.check_rounded,
                              size: 15.0,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),

            // BOTTOM TEXT SECTION
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.p16,
                AppSizes.p10,
                AppSizes.p16,
                AppSizes.p12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role Title
                  Text(
                    title,
                    style: AppTextStyles.roleCardTitle,
                  ),
                  const SizedBox(height: 3.0),

                  // Role Description
                  Text(
                    description,
                    style: AppTextStyles.roleCardDescription,
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
