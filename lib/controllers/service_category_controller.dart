import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/routes/app_routes.dart';
import '../core/utils/helpers.dart';

class ServiceCategoryItem {
  final String id;
  final String title;
  final List<Color> ambientColors;

  const ServiceCategoryItem({
    required this.id,
    required this.title,
    required this.ambientColors,
  });
}

class ServiceCategoryController extends GetxController {
  // Selected category IDs (supports single or multi-selection)
  final RxList<String> selectedCategoryIds = <String>['electrician'].obs;
  final RxBool isLoading = false.obs;

  final List<ServiceCategoryItem> categories = const [
    ServiceCategoryItem(
      id: 'electrician',
      title: 'Electrician',
      ambientColors: [Color(0xFFFFFBEB), Color(0xFFFFFDF9), Colors.white],
    ),
    ServiceCategoryItem(
      id: 'plumber',
      title: 'Plumber',
      ambientColors: [Color(0xFFF0F9FF), Color(0xFFF8FAFC), Colors.white],
    ),
    ServiceCategoryItem(
      id: 'carpenter',
      title: 'Carpenter',
      ambientColors: [Color(0xFFFFFBEB), Color(0xFFFFFDF9), Colors.white],
    ),
    ServiceCategoryItem(
      id: 'mason',
      title: 'Mason /\nRaj Mistri',
      ambientColors: [Color(0xFFFFF7ED), Color(0xFFFFFDF9), Colors.white],
    ),
    ServiceCategoryItem(
      id: 'painter',
      title: 'Painter',
      ambientColors: [Color(0xFFFAF5FF), Color(0xFFFDFBFD), Colors.white],
    ),
    ServiceCategoryItem(
      id: 'ac_repair',
      title: 'AC Repair',
      ambientColors: [Color(0xFFF0FDF4), Color(0xFFF8FAFC), Colors.white],
    ),
    ServiceCategoryItem(
      id: 'washing_machine',
      title: 'Washing\nMachine Repair',
      ambientColors: [Color(0xFFEFF6FF), Color(0xFFF8FAFC), Colors.white],
    ),
    ServiceCategoryItem(
      id: 'refrigerator',
      title: 'Refrigerator\nRepair',
      ambientColors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9), Colors.white],
    ),
    ServiceCategoryItem(
      id: 'tv_repair',
      title: 'TV Repair',
      ambientColors: [Color(0xFFEEF2FF), Color(0xFFF8FAFC), Colors.white],
    ),
    ServiceCategoryItem(
      id: 'ro_repair',
      title: 'RO Repair',
      ambientColors: [Color(0xFFECFEFF), Color(0xFFF0F9FF), Colors.white],
    ),
    ServiceCategoryItem(
      id: 'appliance_repair',
      title: 'Appliance\nRepair',
      ambientColors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9), Colors.white],
    ),
    ServiceCategoryItem(
      id: 'other',
      title: 'Other',
      ambientColors: [Color(0xFFF8FAFC), Color(0xFFF8FAFC), Colors.white],
    ),
  ];

  bool isSelected(String id) {
    return selectedCategoryIds.contains(id);
  }

  void toggleCategory(String id) {
    if (selectedCategoryIds.contains(id)) {
      if (selectedCategoryIds.length > 1) {
        selectedCategoryIds.remove(id);
      }
    } else {
      selectedCategoryIds.add(id);
    }
  }

  void onContinue() {
    if (selectedCategoryIds.isEmpty) {
      Helpers.showSnackbar(
        message: 'Please select at least one service category',
        isError: true,
      );
      return;
    }

    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      isLoading.value = false;
      Get.toNamed(AppRoutes.workDetails);
    });
  }
}
