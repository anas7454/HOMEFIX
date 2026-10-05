import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/routes/app_routes.dart';
import '../core/utils/helpers.dart';

class WorkDetailsController extends GetxController {
  final RxString selectedExperience = '5+ Years'.obs;
  final RxString selectedArea = 'Select Area'.obs;
  final TextEditingController priceController = TextEditingController(text: '299');
  final RxString selectedRateUnit = 'Per visit / Per hour'.obs;
  final RxString selectedWorkingHours = '9:00 AM - 8:00 PM'.obs;
  final TextEditingController aboutController = TextEditingController(
    text:
        'I am a professional electrician with 5+ years of experience in home, office and industrial electrical work. Quality service and customer satisfaction is my priority.',
  );

  final RxInt charCount = 148.obs;
  final RxBool isLoading = false.obs;

  final List<String> experienceOptions = [
    'Less than 1 Year',
    '1 - 3 Years',
    '3 - 5 Years',
    '5+ Years',
    '10+ Years',
  ];

  final List<String> areaOptions = [
    'Central Area & City Center',
    'North Sector & Suburbs',
    'South Residential District',
    'East Commercial Hub',
    'West Extension & Outer Ring',
    'All City / Entire Region',
  ];

  final List<String> rateUnitOptions = [
    'Per visit / Per hour',
    'Per visit',
    'Per hour',
    'Fixed inspection fee',
  ];

  final List<String> workingHoursOptions = [
    '9:00 AM - 8:00 PM',
    '8:00 AM - 6:00 PM',
    '10:00 AM - 9:00 PM',
    '24/7 Available (Emergency)',
    'Custom Timings',
  ];

  @override
  void onInit() {
    super.onInit();
    charCount.value = aboutController.text.length;
    aboutController.addListener(() {
      charCount.value = aboutController.text.length;
    });
  }

  @override
  void onClose() {
    priceController.dispose();
    aboutController.dispose();
    super.onClose();
  }

  void setExperience(String exp) => selectedExperience.value = exp;
  void setArea(String area) => selectedArea.value = area;
  void setRateUnit(String unit) => selectedRateUnit.value = unit;
  void setWorkingHours(String hours) => selectedWorkingHours.value = hours;

  void onContinue() {
    if (aboutController.text.trim().isEmpty) {
      Helpers.showSnackbar(
        message: 'Please write a brief description about yourself',
        isError: true,
      );
      return;
    }

    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading.value = false;
      // Navigate to Dashboard or next step
      Get.offAllNamed(AppRoutes.dashboard);
    });
  }
}
