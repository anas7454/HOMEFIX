import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_text_styles.dart';

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

    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? const Color(0xFFE11D48) : const Color(0xFF16A34A),
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      borderRadius: 14.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      messageText: Row(
        children: [
          Icon(
            isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
            color: Colors.white,
            size: 22.0,
          ),
          const SizedBox(width: 10.0),
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
          color: (isError ? const Color(0xFFE11D48) : const Color(0xFF16A34A))
              .withValues(alpha: 0.35),
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

