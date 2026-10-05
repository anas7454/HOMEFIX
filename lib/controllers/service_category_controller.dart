import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/routes/app_routes.dart';

class ServiceCategoryItem {
  final String id;
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const ServiceCategoryItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
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
      icon: Icons.lightbulb_rounded,
      iconColor: Color(0xFFF59E0B),
      bgColor: Color(0xFFFEF3C7),
    ),
    ServiceCategoryItem(
      id: 'plumber',
      title: 'Plumber',
      icon: Icons.water_drop_rounded,
      iconColor: Color(0xFF0284C7),
      bgColor: Color(0xFFE0F2FE),
    ),
    ServiceCategoryItem(
      id: 'carpenter',
      title: 'Carpenter',
      icon: Icons.hardware_rounded,
      iconColor: Color(0xFFB45309),
      bgColor: Color(0xFFFEF3C7),
    ),
    ServiceCategoryItem(
      id: 'mason',
      title: 'Mason /\nRaj Mistri',
      icon: Icons.foundation_rounded,
      iconColor: Color(0xFFEA580C),
      bgColor: Color(0xFFFFEDD5),
    ),
    ServiceCategoryItem(
      id: 'painter',
      title: 'Painter',
      icon: Icons.format_paint_rounded,
      iconColor: Color(0xFF8B5CF6),
      bgColor: Color(0xFFEDE9FE),
    ),
    ServiceCategoryItem(
      id: 'ac_repair',
      title: 'AC Repair',
      icon: Icons.ac_unit_rounded,
      iconColor: Color(0xFF0EA5E9),
      bgColor: Color(0xFFE0F2FE),
    ),
    ServiceCategoryItem(
      id: 'washing_machine',
      title: 'Washing\nMachine Repair',
      icon: Icons.local_laundry_service_rounded,
      iconColor: Color(0xFF06B6D4),
      bgColor: Color(0xFFCFFAFE),
    ),
    ServiceCategoryItem(
      id: 'refrigerator',
      title: 'Refrigerator\nRepair',
      icon: Icons.kitchen_rounded,
      iconColor: Color(0xFF64748B),
      bgColor: Color(0xFFF1F5F9),
    ),
    ServiceCategoryItem(
      id: 'tv_repair',
      title: 'TV Repair',
      icon: Icons.tv_rounded,
      iconColor: Color(0xFF3B82F6),
      bgColor: Color(0xFFDBEAFE),
    ),
    ServiceCategoryItem(
      id: 'ro_repair',
      title: 'RO Repair',
      icon: Icons.opacity_rounded,
      iconColor: Color(0xFF0284C7),
      bgColor: Color(0xFFE0F2FE),
    ),
    ServiceCategoryItem(
      id: 'appliance_repair',
      title: 'Appliance\nRepair',
      icon: Icons.handyman_rounded,
      iconColor: Color(0xFF475569),
      bgColor: Color(0xFFF1F5F9),
    ),
    ServiceCategoryItem(
      id: 'other',
      title: 'Other',
      icon: Icons.grid_view_rounded,
      iconColor: Color(0xFF64748B),
      bgColor: Color(0xFFF8FAFC),
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
      Get.snackbar(
        'Selection Required',
        'Please select at least one service category',
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
      Get.toNamed(AppRoutes.workDetails);
    });
  }
}
