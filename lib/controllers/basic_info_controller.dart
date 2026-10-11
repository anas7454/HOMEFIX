import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../app/routes/app_routes.dart';
import '../core/utils/helpers.dart';
import '../core/utils/validators.dart';
import 'auth_controller.dart';

class BasicInfoController extends GetxController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();

  final RxString selectedGender = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxString profileImagePath = ''.obs;
  final RxBool isLoading = false.obs;

  final ImagePicker _imagePicker = ImagePicker();

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> categoryOptions = [
    'Plumber',
    'Electrician',
    'Carpenter',
    'AC Repair',
    'Cleaning',
    'Painting',
    'Pest Control'
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<AuthController>()) {
      final authCtrl = Get.find<AuthController>();
      final phone = authCtrl.userPhoneClean;
      if (phone.isNotEmpty) {
        phoneController.text = phone;
      }
      final user = authCtrl.user.value;
      if (user != null) {
        if (fullNameController.text.isEmpty &&
            user.name.isNotEmpty &&
            user.name != 'User' &&
            user.name != 'Service Worker') {
          fullNameController.text = user.name;
        }
      }
    }
  }

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  // Pick Image from Camera or Gallery
  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        profileImagePath.value = pickedFile.path;
        Helpers.showSnackbar(
          message: 'Profile photo selected successfully!',
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
  Future<void> onContinue() async {
    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final dob = dobController.text.trim();
    final gender = selectedGender.value.trim();
    final category = selectedCategory.value.trim();

    // 0. Profile Photo Validation (Mandatory for Workers)
    if (profileImagePath.value.trim().isEmpty) {
      Helpers.showSnackbar(
        message: 'Profile photo is mandatory. Please upload your profile photo.',
        isError: true,
      );
      return;
    }

    // 1. Full Name Validation
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

    // 2. Mobile Number Validation
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

    // 3. Date of Birth Validation
    if (dob.isEmpty) {
      Helpers.showSnackbar(
        message: 'Date of Birth is mandatory. Please select your DOB.',
        isError: true,
      );
      return;
    }

    // 4. Gender Validation
    if (gender.isEmpty) {
      Helpers.showSnackbar(
        message: 'Gender is mandatory. Please select your gender.',
        isError: true,
      );
      return;
    }

    // 5. Category Validation
    if (category.isEmpty) {
      Helpers.showSnackbar(
        message: 'Category is mandatory. Please select your category.',
        isError: true,
      );
      return;
    }

    // All validations passed -> Save basic info and proceed
    isLoading.value = true;
    try {
      if (Get.isRegistered<AuthController>()) {
        final authCtrl = Get.find<AuthController>();
        var userId = authCtrl.user.value?.id;
        if (userId == null || !userId.contains('-')) {
          userId = Helpers.generateUuid();
          if (authCtrl.user.value != null) {
            authCtrl.user.value = authCtrl.user.value!.copyWith(id: userId);
          }
        }
        if (userId.isNotEmpty) {
          String? avatarUrl;
          if (profileImagePath.value.trim().isNotEmpty) {
            avatarUrl = await authCtrl.authRepository.processAvatar(
              userId: userId,
              filePath: profileImagePath.value.trim(),
            );
          }

          await authCtrl.authRepository.updateProfile(
            id: userId,
            fullName: fullName,
            avatarUrl: avatarUrl,
            phone: phone,
          );

          authCtrl.user.value = authCtrl.user.value?.copyWith(
            name: fullName,
            avatar: avatarUrl ?? authCtrl.user.value?.avatar,
            phone: phone,
          );
        }
      }

      Get.toNamed(AppRoutes.workDetails);
    } catch (e) {
      debugPrint('Error saving basic info: $e');
      Get.toNamed(AppRoutes.workDetails);
    } finally {
      isLoading.value = false;
    }
  }
}