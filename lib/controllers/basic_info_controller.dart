import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../app/routes/app_routes.dart';
import '../core/utils/helpers.dart';
import '../core/utils/validators.dart';

class BasicInfoController extends GetxController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();

  final RxString selectedGender = ''.obs;
  final RxString profileImagePath = ''.obs;
  final RxBool isLoading = false.obs;

  final ImagePicker _imagePicker = ImagePicker();

  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dobController.dispose();
    super.onClose();
  }

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  // Pick Image from Camera or Gallery
  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        profileImagePath.value = pickedFile.path;
        Helpers.showSnackbar(
          message: 'Profile photo updated successfully!',
          isError: false,
        );
      }
    } catch (e, stack) {
      debugPrint('Error picking image: $e\n$stack');
      Helpers.showSnackbar(
        message: 'Could not open ${source == ImageSource.camera ? "camera" : "gallery"}: ${e.toString()}',
        isError: true,
      );
    }
  }

  void removeProfileImage() {
    profileImagePath.value = '';
    Helpers.showSnackbar(
      message: 'Profile photo removed',
      isError: false,
    );
  }

  // Date of Birth Picker
  Future<void> pickDate(BuildContext context) async {
    final DateTime initialDate = DateTime(2000, 1, 1);
    final DateTime firstDate = DateTime(1940);
    final DateTime lastDate = DateTime.now().subtract(const Duration(days: 365 * 14)); // Minimum 14 years old

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dobController.text.isNotEmpty ? initialDate : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFA5A00),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final formatted = '${picked.day} ${months[picked.month - 1]} ${picked.year}';
      dobController.text = formatted;
    }
  }

  // Form Validation & Navigation
  void onContinue() {
    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final dob = dobController.text.trim();
    final gender = selectedGender.value.trim();

    // 1. Full Name Validation (Capitalize, No numbers/special characters)
    if (fullName.isEmpty) {
      Helpers.showSnackbar(
        message: 'Please enter your Full Name',
        isError: true,
      );
      return;
    }

    if (fullName.length < 2) {
      Helpers.showSnackbar(
        message: 'Full Name must be at least 2 characters long',
        isError: true,
      );
      return;
    }

    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(fullName)) {
      Helpers.showSnackbar(
        message: 'Full Name should only contain letters and spaces',
        isError: true,
      );
      return;
    }

    // 2. Mobile Number Validation (Strictly 10 digits as in Login Screen)
    if (phone.isEmpty) {
      Helpers.showSnackbar(
        message: 'Please enter your 10-digit mobile number',
        isError: true,
      );
      return;
    }

    if (phone.length != 10) {
      Helpers.showSnackbar(
        message: 'Mobile number must be exactly 10 digits',
        isError: true,
      );
      return;
    }

    final phoneError = Validators.validatePhone(phone);
    if (phoneError != null) {
      Helpers.showSnackbar(
        message: phoneError,
        isError: true,
      );
      return;
    }

    // 3. Email Validation (If provided, must be valid)
    if (email.isNotEmpty) {
      final emailError = Validators.validateEmail(email);
      if (emailError != null) {
        Helpers.showSnackbar(
          message: emailError,
          isError: true,
        );
        return;
      }
    }

    // 4. Date of Birth Validation (Mandatory)
    if (dob.isEmpty) {
      Helpers.showSnackbar(
        message: 'Date of Birth is mandatory. Please select your DOB.',
        isError: true,
      );
      return;
    }

    // 5. Gender Validation (Mandatory)
    if (gender.isEmpty) {
      Helpers.showSnackbar(
        message: 'Gender is mandatory. Please select your gender.',
        isError: true,
      );
      return;
    }

    // All validations passed -> proceed
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      isLoading.value = false;
      Get.toNamed(AppRoutes.serviceCategory);
    });
  }
}
