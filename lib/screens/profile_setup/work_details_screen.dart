import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/work_details_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
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
              // TOP APP BAR (Back Button + Step Progress Bar + "4/6")
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

                    // Progress Bar (4/6)
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
                              widthFactor: 4 / 6, // Step 4 of 6
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

                    // Step Indicator Text (4/6)
                    const Text(
                      '4/6',
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
              // SCROLLABLE FORM BODY
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
                        'Work Details',
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
                        'Tell us about your experience\nand service details.',
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
                      const SizedBox(height: 12.0),

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
                      const SizedBox(height: 12.0),

                      // 3. Starting Price * & Rate Unit
                      _StartingPriceCard(controller: controller),
                      const SizedBox(height: 12.0),

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
                      const SizedBox(height: 18.0),

                      // 5. About Yourself *
                      Row(
                        children: const [
                          Text(
                            'About Yourself',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            ' *',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),

                      // About Yourself Multiline Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: const Color(0xFFE8EEF5),
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
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF334155),
                                height: 1.45,
                              ),
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
                                    style: const TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                );
                              },
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Write about your background, skills and experience...',
                                hintStyle: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF94A3B8),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24.0),
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12.0),
                ...options.map((option) {
                  final isSelected = selectedValue == option;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      option,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 15.0,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.primaryOrange : const Color(0xFF0F172A),
                      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFE8EEF5),
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
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1.0,
              ),
            ),
            child: const Center(
              child: Text(
                '₹',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF475569),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14.0),

          // Price Field Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Starting Price *',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2.0),
                Row(
                  children: [
                    const Text(
                      '₹ ',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: controller.priceController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
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
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                ),
                builder: (context) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40.0,
                              height: 4.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2E8F0),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Select Pricing Model',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          ...controller.rateUnitOptions.map((unit) {
                            final isSelected = controller.selectedRateUnit.value == unit;
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                unit,
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 15.0,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.primaryOrange
                                      : const Color(0xFF0F172A),
                                ),
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Text(
                      controller.selectedRateUnit.value,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF64748B),
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
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: const Color(0xFFE8EEF5),
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
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 20.0,
                  color: const Color(0xFF475569),
                ),
              ),
            ),
            const SizedBox(width: 14.0),

            // Middle Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    valueText,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),

            // Trailing Dropdown Arrow
            if (showDropdownArrow)
              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 4.0),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF475569),
                  size: 22.0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
