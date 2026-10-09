import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/basic_info_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_sizes.dart';
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
        systemNavigationBarColor: AppColors.bgWarm,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: AppColors.bgGradientTop,
          body: SafeArea(
            child: Column(
              children: [
                // ========================================================
                // TOP APP BAR (Back Button + Step Progress Bar + "2/6")
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

                      // Progress Bar (Step 2 of 6)
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
                                widthFactor: 2 / 6,
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
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSizes.p12),

                        // Title
                        const Text(
                          'Basic Information',
                          style: AppTextStyles.basicInfoTitle,
                        ),
                        const SizedBox(height: AppSizes.p6),

                        // Subtitle
                        const Text(
                          'Add your personal details to create your profile.',
                          style: AppTextStyles.basicInfoSubtitle,
                        ),
                        const SizedBox(height: AppSizes.p24),

                        // ========================================================
                        // PROFILE PHOTO AVATAR + CAMERA BADGE (With BottomSheet)
                        // ========================================================
                        Center(
                          child: GestureDetector(
                            onTap: () => _showPhotoPicker(context, controller),
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
                                          color: AppColors.border,
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
                                        child: Obx(() {
                                          final String customPath = controller.profileImagePath.value;
                                          if (customPath.isNotEmpty && File(customPath).existsSync()) {
                                            return Image.file(
                                              File(customPath),
                                              fit: BoxFit.cover,
                                            );
                                          }
                                          return Image.asset(
                                            AppAssets.home8,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: AppColors.surfaceLight,
                                                child: const Icon(
                                                  Icons.person_rounded,
                                                  size: 56.0,
                                                  color: AppColors.textPlaceholder,
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                      ),
                                    ),

                                    // Camera Action Badge (Bottom Right)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
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
                                  ],
                                ),
                                const SizedBox(height: AppSizes.p10),

                                // "Add Profile Photo" Label
                                const Text(
                                  'Add Profile Photo',
                                  style: AppTextStyles.addPhotoLabel,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSizes.p24),

                        // ========================================================
                        // FORM FIELDS (With strict InputFormatters & Validations)
                        // ========================================================

                        // 1. Full Name (Words capitalized, Letters & Spaces only, Next Action)
                        _ProfileInputField(
                          icon: Icons.person_outline_rounded,
                          label: 'Full Name *',
                          controller: controller.fullNameController,
                          hintText: 'Enter your full name',
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                          ],
                        ),
                        const SizedBox(height: AppSizes.p12),

                        // 2. Mobile Number (Strict 10 digits as in Login screen, Next Action)
                        _ProfileInputField(
                          icon: Icons.phone_outlined,
                          label: 'Mobile Number *',
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          hintText: 'Enter 10-digit number',
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                        const SizedBox(height: AppSizes.p12),

                        // 3. Category (Mandatory, BottomSheet on tap)
                        Obx(
                          () => _ProfileInputField(
                            icon: Icons.work_outline_rounded,
                            label: 'Category *',
                            valueText: controller.selectedCategory.value.isNotEmpty
                                ? controller.selectedCategory.value
                                : null,
                            hintText: 'Select Category',
                            readOnly: true,
                            showDropdownArrow: true,
                            onTap: () => _showCategoryPicker(context, controller),
                          ),
                        ),
                        const SizedBox(height: AppSizes.p12),

                        // 4. Date of Birth (Mandatory, DatePicker on tap)
                        _ProfileInputField(
                          icon: Icons.calendar_today_outlined,
                          label: 'Date of Birth *',
                          controller: controller.dobController,
                          readOnly: true,
                          hintText: 'Select Date of Birth',
                          onTap: () => controller.pickDate(context),
                        ),
                        const SizedBox(height: AppSizes.p12),

                        // 5. Gender (Mandatory, BottomSheet on tap)
                        Obx(
                          () => _ProfileInputField(
                            icon: Icons.shield_outlined,
                            label: 'Gender *',
                            valueText: controller.selectedGender.value.isNotEmpty
                                ? controller.selectedGender.value
                                : null,
                            hintText: 'Select Gender',
                            readOnly: true,
                            showDropdownArrow: true,
                            onTap: () => _showGenderPicker(context, controller),
                          ),
                        ),

                        const SizedBox(height: AppSizes.p24),
                      ],
                    ),
                  ),
                ),

                // ========================================================
                // BOTTOM CONTINUE BUTTON (Reusable CustomButton)
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
      ),
    );
  }

  // ========================================================
  // PHOTO PICKER BOTTOM SHEET (Choose an Option - Camera & Gallery)
  // ========================================================
  void _showPhotoPicker(BuildContext context, BasicInfoController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.p24,
              AppSizes.p12,
              AppSizes.p24,
              AppSizes.p24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Drag Handle Indicator
                Container(
                  width: 44.0,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(AppSizes.r10),
                  ),
                ),
                const SizedBox(height: AppSizes.p16),

                // Centered "Choose an Option" Title
                const Text(
                  'Choose an Option',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 17.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textTitle,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: AppSizes.p20),

                // Two Horizontal Option Cards (Camera & Gallery)
                Row(
                  children: [
                    // Camera Card
                    Expanded(
                      child: _buildPickerOptionCard(
                        icon: Icons.camera_alt_rounded,
                        label: 'Camera',
                        onTap: () {
                          Navigator.pop(context);
                          controller.pickProfileImage(ImageSource.camera);
                        },
                      ),
                    ),
                    const SizedBox(width: AppSizes.p16),

                    // Gallery Card
                    Expanded(
                      child: _buildPickerOptionCard(
                        icon: Icons.photo_library_rounded,
                        label: 'Gallery',
                        onTap: () {
                          Navigator.pop(context);
                          controller.pickProfileImage(ImageSource.gallery);
                        },
                      ),
                    ),
                  ],
                ),

                // Remove Photo Option (if already uploaded)
                Obx(() {
                  if (controller.profileImagePath.value.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: AppSizes.p16),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          controller.removeProfileImage();
                        },
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 19.0,
                          color: AppColors.error,
                        ),
                        label: const Text(
                          'Remove Current Photo',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper Widget for Photo Picker Option Card
  Widget _buildPickerOptionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.p20),
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
                blurRadius: 8.0,
                offset: const Offset(0, 2.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular Icon Container
              Container(
                width: 52.0,
                height: 52.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEFF6FF), // Soft Tinted Blue Background as in image
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 26.0,
                    color: Color(0xFF0284C7), // Blue Icon color as in screenshot
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.p12),

              // Option Label Text
              Text(
                label,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTitle,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================================================
  // GENDER PICKER BOTTOM SHEET
  // ========================================================
  void _showGenderPicker(BuildContext context, BasicInfoController controller) {
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
                  'Select Gender',
                  style: AppTextStyles.bottomSheetTitle,
                ),
                const SizedBox(height: AppSizes.p12),
                ...controller.genderOptions.map((gender) {
                  final isSelected = controller.selectedGender.value == gender;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      gender,
                      style: isSelected
                          ? AppTextStyles.bottomSheetItemSelected
                          : AppTextStyles.bottomSheetItem,
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

  // ========================================================
  // CATEGORY PICKER BOTTOM SHEET
  // ========================================================
  void _showCategoryPicker(BuildContext context, BasicInfoController controller) {
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
                  'Select Category',
                  style: AppTextStyles.bottomSheetTitle,
                ),
                const SizedBox(height: AppSizes.p12),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.categoryOptions.length,
                    itemBuilder: (context, index) {
                      final category = controller.categoryOptions[index];
                      final isSelected = controller.selectedCategory.value == category;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          category,
                          style: isSelected
                              ? AppTextStyles.bottomSheetItemSelected
                              : AppTextStyles.bottomSheetItem,
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryOrange)
                            : null,
                        onTap: () {
                          controller.setCategory(category);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
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
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
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
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.inputFormatters,
    this.maxLength,
    this.readOnly = false,
    this.showDropdownArrow = false,
    this.onTap,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label placed separately above the text field
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textTitle,
            ),
          ),
        ),
        
        // Input Box
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            height: 52.0, // Fixed height for consistency
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p14,
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

                // Middle Text / Input Field
                Expanded(
                  child: valueText != null
                      ? Text(
                          valueText!,
                          style: AppTextStyles.inputCardValue,
                        )
                      : TextFormField(
                          controller: controller,
                          readOnly: readOnly,
                          keyboardType: keyboardType,
                          textCapitalization: textCapitalization,
                          textInputAction: textInputAction,
                          inputFormatters: inputFormatters,
                          maxLength: maxLength,
                          onTap: onTap,
                          style: AppTextStyles.inputCardValue,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            counterText: "",
                            hintText: hintText,
                            hintStyle: AppTextStyles.inputCardHint,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                ),

                // Optional Dropdown Arrow
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
        ),
      ],
    );
  }
}
