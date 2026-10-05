import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../core/utils/helpers.dart';
import '../app/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  // Phone Auth State
  final phoneController = TextEditingController();
  final RxString selectedCountryCode = '+91'.obs;
  final RxString countryFlag = '🇮🇳'.obs;

  // OTP State (4 digits)
  final RxList<String> otpDigits = List.generate(4, (index) => '').obs;
  final RxInt resendSeconds = 25.obs;
  final RxBool canResend = false.obs;
  Timer? _resendTimer;

  void resetOtp() {
    for (int i = 0; i < 4; i++) {
      otpDigits[i] = '';
    }
  }

  void startResendTimer() {
    _resendTimer?.cancel();
    resendSeconds.value = 25;
    canResend.value = false;

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value > 1) {
        resendSeconds.value--;
      } else {
        resendSeconds.value = 0;
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void resendOtp() {
    startResendTimer();
    Helpers.showSnackbar(
      title: 'OTP Sent',
      message:
          'A new 4-digit OTP has been sent to ${selectedCountryCode.value} ${phoneController.text.trim()}',
    );
  }

  void sendOtp() {
    // Remove any spaces if entered
    final phone = phoneController.text.trim().replaceAll(' ', '');

    if (phone.isEmpty) {
      Helpers.showSnackbar(
        title: 'Error',
        message: 'Enter the number',
        isError: true,
      );
      return;
    }

    // Indian phone numbers: exactly 10 digits, starts with 6, 7, 8, or 9
    final indianPhoneRegex = RegExp(r'^[6-9]\d{9}$');
    if (!indianPhoneRegex.hasMatch(phone)) {
      Helpers.showSnackbar(
        title: 'Error',
        message: 'Enter a valid number',
        isError: true,
      );
      return;
    }

    resetOtp();
    startResendTimer();
    Get.toNamed(AppRoutes.otp);
  }

  Future<void> verifyOtp(String enteredOtp) async {
    if (enteredOtp.length < 4) {
      Helpers.showSnackbar(
        title: 'Invalid OTP',
        message: 'Please enter all 4 digits of the verification code.',
        isError: true,
      );
      return;
    }

    try {
      isLoading.value = true;
      // Simulate verification / call login
      await Future.delayed(const Duration(milliseconds: 600));
      user.value = UserModel(
        id: '1',
        name: 'Rohit Sharma',
        email: 'user@homefix.com',
      );
      Helpers.showSnackbar(
        title: 'Success',
        message: 'Phone verified successfully!',
      );
      Get.toNamed(AppRoutes.roleSelection);
    } catch (e) {
      Helpers.showSnackbar(title: 'Error', message: e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 500));
      user.value = UserModel(
        id: '2',
        name: 'Google User',
        email: 'google.user@gmail.com',
      );
      Helpers.showSnackbar(
        title: 'Success',
        message: 'Signed in with Google successfully!',
      );
      Get.toNamed(AppRoutes.roleSelection);
    } catch (e) {
      Helpers.showSnackbar(title: 'Error', message: e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    user.value = null;
    Get.offAllNamed(AppRoutes.auth);
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    phoneController.dispose();
    super.onClose();
  }
}
