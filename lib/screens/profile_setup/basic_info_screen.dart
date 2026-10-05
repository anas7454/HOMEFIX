import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/basic_info_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_assets.dart';
import '../../widgets/custom_button.dart';

class BasicInfoScreen extends StatelessWidget {
  const BasicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BasicInfoController());

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
              // TOP APP BAR (Back Button + Step Progress Bar + "2/6")
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

                    // Progress Bar
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
                              widthFactor: 2 / 6, // Step 2 of 6
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

                    // Step Indicator Text (2/6)
                    const Text(
                      '2/6',
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
                        'Basic Information',
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
                        'Add your personal details to create your profile.',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF64748B),
                          height: 1.35,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // ========================================================
                      // PROFILE PHOTO AVATAR + CAMERA BADGE
                      // ========================================================
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Avatar Circle
                                Container(
                                  width: 110.0,
                                  height: 110.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                      width: 2.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.06),
                                        blurRadius: 12.0,
                                        offset: const Offset(0, 4.0),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      AppAssets.home8,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: const Color(0xFFF1F5F9),
                                          child: const Icon(
                                            Icons.person_rounded,
                                            size: 56.0,
                                            color: Color(0xFF94A3B8),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                // Camera Action Badge (Bottom Right)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Can trigger photo picker
                                    },
                                    child: Container(
                                      width: 34.0,
                                      height: 34.0,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryOrange,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primaryOrange.withValues(alpha: 0.4),
                                            blurRadius: 6.0,
                                            offset: const Offset(0, 2.0),
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.camera_alt_rounded,
                                          size: 17.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),

                            // "Add Profile Photo" Label
                            const Text(
                              'Add Profile Photo',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24.0),

                      // ========================================================
                      // FORM FIELDS
                      // ========================================================

                      // 1. Full Name
                      _ProfileInputField(
                        icon: Icons.person_outline_rounded,
                        label: 'Full Name *',
                        controller: controller.fullNameController,
                        hintText: 'Enter your full name',
                      ),
                      const SizedBox(height: 12.0),

                      // 2. Mobile Number
                      _ProfileInputField(
                        icon: Icons.phone_outlined,
                        label: 'Mobile Number *',
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        hintText: 'Enter mobile number',
                      ),
                      const SizedBox(height: 12.0),

                      // 3. Email (Optional)
                      _ProfileInputField(
                        icon: Icons.mail_outline_rounded,
                        label: 'Email (Optional)',
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'Enter email address',
                      ),
                      const SizedBox(height: 12.0),

                      // 4. Date of Birth (Optional)
                      _ProfileInputField(
                        icon: Icons.calendar_today_outlined,
                        label: 'Date of Birth (Optional)',
                        controller: controller.dobController,
                        readOnly: true,
                        hintText: 'DD MMM YYYY',
                        onTap: () => controller.pickDate(context),
                      ),
                      const SizedBox(height: 12.0),

                      // 5. Gender
                      Obx(
                        () => _ProfileInputField(
                          icon: Icons.shield_outlined,
                          label: 'Gender',
                          valueText: controller.selectedGender.value,
                          readOnly: true,
                          showDropdownArrow: true,
                          onTap: () => _showGenderPicker(context, controller),
                        ),
                      ),

                      const SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ),

              // ========================================================
              // BOTTOM CONTINUE BUTTON (Reusable CustomButton)
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

  // Bottom Sheet Gender Picker
  void _showGenderPicker(BuildContext context, BasicInfoController controller) {
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
                  'Select Gender',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12.0),
                ...controller.genderOptions.map((gender) {
                  final isSelected = controller.selectedGender.value == gender;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      gender,
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
                      controller.setGender(gender);
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
// REUSABLE PROFILE INPUT FIELD CARD
// ========================================================
class _ProfileInputField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? valueText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool showDropdownArrow;
  final VoidCallback? onTap;
  final String? hintText;

  const _ProfileInputField({
    required this.icon,
    required this.label,
    this.valueText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.showDropdownArrow = false,
    this.onTap,
    this.hintText,
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

            // Middle Text / Input Field
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Label
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

                  // Value or Input
                  if (valueText != null)
                    Text(
                      valueText!,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    )
                  else
                    TextFormField(
                      controller: controller,
                      readOnly: readOnly,
                      keyboardType: keyboardType,
                      onTap: onTap,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: hintText,
                        hintStyle: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 15.0,
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

            // Optional Dropdown Arrow
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
