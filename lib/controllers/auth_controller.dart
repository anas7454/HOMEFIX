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
  final phoneController = TextEditingController(text: '98765 43210');
  final RxString selectedCountryCode = '+91'.obs;
  final RxString countryFlag = '🇮🇳'.obs;

  // OTP State
  final RxList<String> otpDigits = List.generate(6, (index) => '').obs;
  final RxInt resendSeconds = 25.obs;
  final RxBool canResend = false.obs;
  Timer? _resendTimer;

  // Pre-fill initial OTP for instant testing matching mockup: 2, 4, 6, 8, 1, 0
  final List<String> initialMockOtp = ['2', '4', '6', '8', '1', '0'];

  @override
  void onInit() {
    super.onInit();
    for (int i = 0; i < 6; i++) {
      otpDigits[i] = initialMockOtp[i];
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
      message: 'A new 6-digit OTP has been sent to ${selectedCountryCode.value} ${phoneController.text.trim()}',
    );
  }

  void sendOtp() {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      Helpers.showSnackbar(
        title: 'Phone Required',
        message: 'Please enter your phone number to continue.',
        isError: true,
      );
      return;
    }

    startResendTimer();
    Get.toNamed(AppRoutes.otp);
  }

  Future<void> verifyOtp(String enteredOtp) async {
    if (enteredOtp.length < 6) {
      Helpers.showSnackbar(
        title: 'Invalid OTP',
        message: 'Please enter all 6 digits of the verification code.',
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
      Get.offAllNamed(AppRoutes.dashboard);
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
      Get.offAllNamed(AppRoutes.dashboard);
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
