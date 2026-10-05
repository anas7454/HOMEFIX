import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/work_details_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/custom_button.dart';

class WorkDetailsScreen extends StatelessWidget {
  const WorkDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkDetailsController());

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
              // TOP APP BAR (Back Button + Step Progress Bar + "4/6")
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

                    // Progress Bar (4/6)
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
                              widthFactor: 4 / 6, // Step 4 of 6
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

                    // Step Indicator Text (4/6)
                    const Text(
                      '4/6',
                      style: AppTextStyles.stepIndicatorOrange,
                    ),
                  ],
                ),
              ),

              // ========================================================
              // SCROLLABLE FORM BODY
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
                        'Work Details',
                        style: AppTextStyles.basicInfoTitle,
                      ),
                      const SizedBox(height: AppSizes.p6),

                      // Subtitle
                      const Text(
                        'Tell us about your experience\nand service details.',
                        style: AppTextStyles.basicInfoSubtitle,
                      ),
                      const SizedBox(height: AppSizes.p20),

                      // 1. Experience *
                      Obx(
                        () => _WorkInputFieldCard(
                          icon: Icons.business_center_outlined,
                          label: 'Experience *',
                          valueText: controller.selectedExperience.value,
                          showDropdownArrow: true,
                          onTap: () => _showSelectionBottomSheet(
                            context: context,
                            title: 'Select Experience',
                            options: controller.experienceOptions,
                            selectedValue: controller.selectedExperience.value,
                            onSelect: controller.setExperience,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.p12),

                      // 2. Service Area *
                      Obx(
                        () => _WorkInputFieldCard(
                          icon: Icons.location_on_outlined,
                          label: 'Service Area *',
                          valueText: controller.selectedArea.value,
                          showDropdownArrow: true,
                          onTap: () => _showSelectionBottomSheet(
                            context: context,
                            title: 'Select Service Area',
                            options: controller.areaOptions,
                            selectedValue: controller.selectedArea.value,
                            onSelect: controller.setArea,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.p12),

                      // 3. Starting Price * & Rate Unit
                      _StartingPriceCard(controller: controller),
                      const SizedBox(height: AppSizes.p12),

                      // 4. Working Hours
                      Obx(
                        () => _WorkInputFieldCard(
                          icon: Icons.access_time_rounded,
                          label: 'Working Hours',
                          valueText: controller.selectedWorkingHours.value,
                          showDropdownArrow: true,
                          onTap: () => _showSelectionBottomSheet(
                            context: context,
                            title: 'Select Working Hours',
                            options: controller.workingHoursOptions,
                            selectedValue: controller.selectedWorkingHours.value,
                            onSelect: controller.setWorkingHours,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.p18),

                      // 5. About Yourself *
                      Row(
                        children: const [
                          Text(
                            'About Yourself',
                            style: AppTextStyles.workDetailsFieldLabel,
                          ),
                          Text(
                            ' *',
                            style: AppTextStyles.workDetailsFieldRequired,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.p8),

                      // About Yourself Multiline Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSizes.p14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSizes.r16),
                          border: Border.all(
                            color: AppColors.borderLight,
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6.0,
                              offset: const Offset(0, 2.0),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: controller.aboutController,
                              maxLines: 4,
                              maxLength: 300,
                              style: AppTextStyles.workDetailsAboutInput,
                              buildCounter: (
                                context, {
                                required currentLength,
                                required isFocused,
                                maxLength,
                              }) {
                                return Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '$currentLength/$maxLength',
                                    style: AppTextStyles.termsPrompt,
                                  ),
                                );
                              },
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Write about your background, skills and experience...',
                                hintStyle: AppTextStyles.phoneHint,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSizes.p24),
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

  // Helper Modal Bottom Sheet for options
  void _showSelectionBottomSheet({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p20,
              vertical: AppSizes.p20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(AppSizes.p2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.p16),
                Text(
                  title,
                  style: AppTextStyles.bottomSheetTitle,
                ),
                const SizedBox(height: AppSizes.p12),
                ...options.map((option) {
                  final isSelected = selectedValue == option;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      option,
                      style: isSelected
                          ? AppTextStyles.bottomSheetItemSelected
                          : AppTextStyles.bottomSheetItem,
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryOrange)
                        : null,
                    onTap: () {
                      onSelect(option);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ========================================================
// STARTING PRICE CARD WITH SPLIT UNIT SELECTOR
// ========================================================
class _StartingPriceCard extends StatelessWidget {
  final WorkDetailsController controller;

  const _StartingPriceCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p14,
        vertical: AppSizes.p10,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6.0,
            offset: const Offset(0, 2.0),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left ₹ Icon Container
          Container(
            width: 42.0,
            height: 42.0,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSizes.r12),
              border: Border.all(
                color: AppColors.border,
                width: 1.0,
              ),
            ),
            child: const Center(
              child: Text(
                '₹',
                style: AppTextStyles.workDetailsCurrencySymbol,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.p14),

          // Price Field Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Starting Price *',
                  style: AppTextStyles.inputCardLabel,
                ),
                const SizedBox(height: AppSizes.p2),
                Row(
                  children: [
                    const Text(
                      '₹ ',
                      style: AppTextStyles.workDetailsPricePrefix,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: controller.priceController,
                        keyboardType: TextInputType.number,
                        style: AppTextStyles.workDetailsPriceInput,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: '299',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right Rate Unit Dropdown Selector
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r24)),
                ),
                builder: (context) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.p20,
                        vertical: AppSizes.p20,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40.0,
                              height: 4.0,
                              decoration: BoxDecoration(
                                color: AppColors.border,
                                borderRadius: BorderRadius.circular(AppSizes.p2),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.p16),
                          const Text(
                            'Select Pricing Model',
                            style: AppTextStyles.bottomSheetTitle,
                          ),
                          const SizedBox(height: AppSizes.p12),
                          ...controller.rateUnitOptions.map((unit) {
                            final isSelected = controller.selectedRateUnit.value == unit;
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                unit,
                                style: isSelected
                                    ? AppTextStyles.bottomSheetItemSelected
                                    : AppTextStyles.bottomSheetItem,
                              ),
                              trailing: isSelected
                                  ? const Icon(Icons.check_circle_rounded,
                                      color: AppColors.primaryOrange)
                                  : null,
                              onTap: () {
                                controller.setRateUnit(unit);
                                Navigator.pop(context);
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p10,
                vertical: AppSizes.p6,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppSizes.r10),
                border: Border.all(
                  color: AppColors.border,
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Text(
                      controller.selectedRateUnit.value,
                      style: AppTextStyles.workDetailsRateUnit,
                    ),
                  ),
                  const SizedBox(width: AppSizes.p4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.iconMuted,
                    size: 18.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ========================================================
// STANDARD WORK DETAILS INPUT CARD
// ========================================================
class _WorkInputFieldCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valueText;
  final bool showDropdownArrow;
  final VoidCallback onTap;

  const _WorkInputFieldCard({
    required this.icon,
    required this.label,
    required this.valueText,
    this.showDropdownArrow = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p14,
          vertical: AppSizes.p10,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          border: Border.all(
            color: AppColors.borderLight,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6.0,
              offset: const Offset(0, 2.0),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Icon Box
            Container(
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppSizes.r12),
                border: Border.all(
                  color: AppColors.border,
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: AppSizes.iconMd,
                  color: AppColors.iconSlate,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.p14),

            // Middle Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.inputCardLabel,
                  ),
                  const SizedBox(height: AppSizes.p2),
                  Text(
                    valueText,
                    style: AppTextStyles.inputCardValue,
                  ),
                ],
              ),
            ),

            // Trailing Dropdown Arrow
            if (showDropdownArrow)
              const Padding(
                padding: EdgeInsets.only(left: AppSizes.p8, right: AppSizes.p4),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.iconSlate,
                  size: 22.0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
