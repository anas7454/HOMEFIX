import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
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

  /// Make a phone call using phone dialer
  static Future<void> makePhoneCall(String? rawPhone) async {
    if (rawPhone == null || rawPhone.trim().isEmpty) {
      showSnackbar(
        message: 'Phone number is not available',
        isError: true,
      );
      return;
    }

    final cleaned = rawPhone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleaned.isEmpty) {
      showSnackbar(
        message: 'Invalid phone number',
        isError: true,
      );
      return;
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: cleaned);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching call dialer: $e');
      showSnackbar(
        message: 'Could not open phone dialer: $cleaned',
        isError: true,
      );
    }
  }

  /// Open WhatsApp chat with phone number
  static Future<void> openWhatsApp(String? rawPhone) async {
    if (rawPhone == null || rawPhone.trim().isEmpty) {
      showSnackbar(
        message: 'Phone number is not available for WhatsApp',
        isError: true,
      );
      return;
    }

    var cleaned = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length == 10) {
      cleaned = '91$cleaned';
    }

    final Uri whatsappUri = Uri.parse('https://wa.me/$cleaned');
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        showSnackbar(
          message: 'Could not launch WhatsApp for $cleaned',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
      showSnackbar(
        message: 'Could not open WhatsApp',
        isError: true,
      );
    }
  }

  /// Generate a valid RFC 4122 v4 UUID without external dependencies
  static String generateUuid() {
    final rand = DateTime.now().microsecondsSinceEpoch;
    final r1 = (rand & 0xFFFFFFFF).toRadixString(16).padLeft(8, '0');
    final r2 = ((rand >> 32) & 0xFFFF).toRadixString(16).padLeft(4, '0');
    final r3 = '4' + (((rand >> 16) & 0x0FFF).toRadixString(16).padLeft(3, '0'));
    final r4 = 'a' + (((rand >> 8) & 0x0FFF).toRadixString(16).padLeft(3, '0'));
    final r5 = ((rand ^ 0xABCDEF123456) & 0xFFFFFFFFFFFF).toRadixString(16).padLeft(12, '0');
    return '$r1-$r2-$r3-$r4-$r5'.toLowerCase();
  }
}
