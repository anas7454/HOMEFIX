import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../constants/app_sizes.dart';

class Helpers {
  Helpers._();

  static void showSnackbar({
    String? title,
    required String message,
    bool isError = false,
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    final Color bgColor = isError ? AppColors.errorDark : AppColors.successDark;

    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      backgroundColor: bgColor,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.p20,
        vertical: AppSizes.p16,
      ),
      borderRadius: AppSizes.r14,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p16,
        vertical: AppSizes.p12,
      ),
      messageText: Row(
        children: [
          Icon(
            isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
            color: Colors.white,
            size: AppSizes.iconLg,
          ),
          const SizedBox(width: AppSizes.p10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      boxShadows: [
        BoxShadow(
          color: bgColor.withValues(alpha: 0.35),
          blurRadius: 16.0,
          offset: const Offset(0, 6.0),
        ),
      ],
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 300),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCubic,
    );
  }

  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  static String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }
}
