import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/routes/app_routes.dart';
import '../core/utils/helpers.dart';
import '../core/services/location_service.dart';
import 'auth_controller.dart';
import 'basic_info_controller.dart';
import 'service_category_controller.dart';

class WorkDetailsController extends GetxController {
  final RxString selectedExperience = ''.obs;
  final RxString selectedArea = ''.obs;
  final TextEditingController priceController = TextEditingController();
  final RxString selectedRateUnit = 'Per visit / Per hour'.obs;
  final RxString selectedWorkingHours = ''.obs;
  final TextEditingController aboutController = TextEditingController();

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
    super.onClose();
  }

  void setExperience(String exp) => selectedExperience.value = exp;
  void setArea(String area) => selectedArea.value = area;
  void setRateUnit(String unit) => selectedRateUnit.value = unit;
  void setWorkingHours(String hours) => selectedWorkingHours.value = hours;

  Future<void> onContinue() async {
    if (selectedExperience.value.trim().isEmpty) {
      Helpers.showSnackbar(
        message: 'Please select your experience',
        isError: true,
      );
      return;
    }

    if (selectedArea.value.trim().isEmpty) {
      Helpers.showSnackbar(
        message: 'Please select your service area',
        isError: true,
      );
      return;
    }

    if (priceController.text.trim().isEmpty) {
      Helpers.showSnackbar(
        message: 'Please enter your starting price',
        isError: true,
      );
      return;
    }

    if (aboutController.text.trim().isEmpty) {
      Helpers.showSnackbar(
        message: 'Please write a brief description about yourself',
        isError: true,
      );
      return;
    }

    isLoading.value = true;
    try {
      final authCtrl = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
      var workerId = authCtrl?.user.value?.id;

      if (workerId == null || !workerId.contains('-')) {
        workerId = Helpers.generateUuid();
        if (authCtrl?.user.value != null) {
          authCtrl!.user.value = authCtrl.user.value!.copyWith(id: workerId);
        }
      }

      if (authCtrl != null) {
        // Collect skills from ServiceCategoryController or BasicInfoController
        List<String> skills = [];
        if (Get.isRegistered<ServiceCategoryController>()) {
          final catCtrl = Get.find<ServiceCategoryController>();
          skills = catCtrl.selectedCategoryIds.toList();
        }
        if (skills.isEmpty && Get.isRegistered<BasicInfoController>()) {
          final basic = Get.find<BasicInfoController>();
          if (basic.selectedCategory.value.isNotEmpty) {
            skills = [basic.selectedCategory.value];
          }
        }
        if (skills.isEmpty) {
          skills = ['Service Provider'];
        }

        final expYears = int.tryParse(selectedExperience.value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
        final hourlyRate = double.tryParse(priceController.text.trim()) ?? 0.0;

        String? fullName;
        String? avatarUrl;
        if (Get.isRegistered<BasicInfoController>()) {
          final basic = Get.find<BasicInfoController>();
          if (basic.fullNameController.text.trim().isNotEmpty) {
            fullName = basic.fullNameController.text.trim();
          }
          if (basic.profileImagePath.value.trim().isNotEmpty) {
            avatarUrl = await authCtrl.authRepository.processAvatar(
              userId: workerId,
              filePath: basic.profileImagePath.value.trim(),
            );
          }
        }

        avatarUrl ??= authCtrl.user.value?.avatar;
        fullName ??= authCtrl.user.value?.name;

        final phone = authCtrl.fullPhoneNumber.isNotEmpty
            ? authCtrl.fullPhoneNumber
            : (authCtrl.user.value?.phone ?? '');

        // Fetch current GPS position for worker location
        double? latitude;
        double? longitude;
        try {
          final pos = await LocationService.getCurrentPosition();
          if (pos != null) {
            latitude = pos.latitude;
            longitude = pos.longitude;
          }
        } catch (_) {}

        await authCtrl.authRepository.saveWorkerDetails(
          workerId: workerId,
          skills: skills,
          experienceYears: expYears,
          fullName: fullName,
          avatarUrl: avatarUrl,
          phone: phone,
          bio: aboutController.text.trim(),
          city: selectedArea.value,
          hourlyRate: hourlyRate,
          latitude: latitude,
          longitude: longitude,
        );

        final updated = authCtrl.user.value?.copyWith(
          role: 'worker',
          isProfileCompleted: true,
          name: (fullName != null && fullName.isNotEmpty) ? fullName : authCtrl.user.value?.name,
          avatar: avatarUrl ?? authCtrl.user.value?.avatar,
          phone: phone.isNotEmpty ? phone : authCtrl.user.value?.phone,
        );
        authCtrl.user.value = updated;
        if (updated != null) {
          await authCtrl.saveUserLocally(updated);
        }
      }

      Helpers.showSnackbar(
        title: 'Profile Submitted',
        message: 'Your worker profile has been submitted successfully!',
      );

      // Navigate directly to Worker Dashboard (Homepage)
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      debugPrint('Error completing worker profile: $e');
      Get.offAllNamed(AppRoutes.dashboard);
    } finally {
      isLoading.value = false;
    }
  }
}