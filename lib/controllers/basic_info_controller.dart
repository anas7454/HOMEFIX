import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/routes/app_routes.dart';

class BasicInfoController extends GetxController {
  final fullNameController = TextEditingController(text: 'Rohit Sharma');
  final phoneController = TextEditingController(text: '98765 43210');
  final emailController = TextEditingController(text: 'rohit@gmail.com');
  final dobController = TextEditingController(text: '12 Jun 1995');

  final RxString selectedGender = 'Male'.obs;
  final RxString profileImagePath = ''.obs;
  final RxBool isLoading = false.obs;

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

  Future<void> pickDate(BuildContext context) async {
    final DateTime initialDate = DateTime(1995, 6, 12);
    final DateTime firstDate = DateTime(1950);
    final DateTime lastDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
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

  void onContinue() {
    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter your full name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter your mobile number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      isLoading.value = false;
      Get.toNamed(AppRoutes.serviceCategory);
    });
  }
}
