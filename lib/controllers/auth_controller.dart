import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../core/services/supabase_service.dart';
import '../core/services/storage_service.dart';
import '../core/utils/helpers.dart';
import '../app/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStoredUser();
  }

  void _loadStoredUser() {
    try {
      if (Get.isRegistered<StorageService>()) {
        final storage = Get.find<StorageService>();
        final raw = storage.read('current_user');
        if (raw != null) {
          final map = raw is String ? jsonDecode(raw) : raw;
          user.value = UserModel.fromJson(Map<String, dynamic>.from(map));
          debugPrint('Restored user from storage: role=${user.value?.role}, phone=${user.value?.phone}');
        }
      }
    } catch (e) {
      debugPrint('Error loading stored user in AuthController: $e');
    }
  }

  // Phone Auth State
  final phoneController = TextEditingController();
  String enteredPhoneNumber = '';
  final RxString selectedCountryCode = '+91'.obs;
  final RxString countryFlag = '🇮🇳'.obs;

  String get userPhoneClean => enteredPhoneNumber.isNotEmpty
      ? enteredPhoneNumber
      : (user.value?.phone?.replaceAll('+91', '').trim() ?? '');

  // OTP State (4 digits)
  final RxList<String> otpDigits = List.generate(4, (index) => '').obs;
  final RxInt resendSeconds = 25.obs;
  final RxBool canResend = false.obs;
  Timer? _resendTimer;

  String get fullPhoneNumber {
    final num = enteredPhoneNumber.isNotEmpty
        ? enteredPhoneNumber
        : phoneController.text.trim().replaceAll(' ', '');
    if (num.isNotEmpty) {
      return '${selectedCountryCode.value}$num';
    }
    return user.value?.phone ?? '';
  }

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
    if (!canResend.value) return;
    resetOtp();
    startResendTimer();
    Helpers.showSnackbar(
      title: 'OTP Sent',
      message:
          'A new 4-digit OTP has been sent to ${selectedCountryCode.value} ${phoneController.text.trim()}',
    );
  }

  void sendOtp() {
    final phone = phoneController.text.trim().replaceAll(' ', '');

    if (phone.isEmpty) {
      Helpers.showSnackbar(
        title: 'Error',
        message: 'Enter the number',
        isError: true,
      );
      return;
    }

    final indianPhoneRegex = RegExp(r'^[6-9]\d{9}$');
    if (!indianPhoneRegex.hasMatch(phone)) {
      Helpers.showSnackbar(
        title: 'Error',
        message: 'Enter a valid number',
        isError: true,
      );
      return;
    }

    enteredPhoneNumber = phone;
    resetOtp();
    startResendTimer();
    Get.toNamed(AppRoutes.otp);
  }

  /// Helper to persist user session locally so re-login by same number always works
  Future<void> saveUserLocally(UserModel userModel) async {
    try {
      if (Get.isRegistered<StorageService>()) {
        final storage = Get.find<StorageService>();
        await storage.write('user_profile_${userModel.phone}', userModel.toJson());
        final clean = userModel.phone?.replaceAll('+91', '').trim();
        if (clean != null && clean.isNotEmpty) {
          await storage.write('user_profile_$clean', userModel.toJson());
        }
        await storage.write('current_user', userModel.toJson());
      }
    } catch (e) {
      debugPrint('Error saving user locally: $e');
    }
  }

  /// Helper to get locally saved user for a phone number
  UserModel? getLocallySavedUser(String phone) {
    try {
      if (Get.isRegistered<StorageService>()) {
        final storage = Get.find<StorageService>();
        final raw = storage.read('user_profile_$phone');
        if (raw != null) {
          final map = raw is String ? jsonDecode(raw) : raw;
          return UserModel.fromJson(Map<String, dynamic>.from(map));
        }
        final clean = phone.replaceAll('+91', '').trim();
        final rawClean = storage.read('user_profile_$clean');
        if (rawClean != null) {
          final map = rawClean is String ? jsonDecode(rawClean) : rawClean;
          return UserModel.fromJson(Map<String, dynamic>.from(map));
        }
      }
    } catch (e) {
      debugPrint('Error reading local user: $e');
    }
    return null;
  }

  /// Verify OTP and route based on existing profile
  Future<void> verifyOtp(String enteredOtp) async {
    if (enteredOtp.length < 4) {
      Helpers.showSnackbar(
        title: 'Invalid OTP',
        message: 'Please enter all 4 digits of the verification code.',
        isError: true,
      );
      return;
    }

    if (enteredOtp != '1234') {
      Helpers.showSnackbar(
        title: 'Incorrect OTP',
        message: 'The OTP entered is incorrect. Please enter 1234.',
        isError: true,
      );
      return;
    }

    try {
      isLoading.value = true;
      final phone = fullPhoneNumber;
      final cleanPhone = enteredPhoneNumber.isNotEmpty ? enteredPhoneNumber : phone.replaceAll('+91', '').trim();

      // 1. Check in Supabase profiles (both formatted +91 and 10-digit clean phone)
      Map<String, dynamic>? existingProfile;
      try {
        final res = await SupabaseService.client
            .from('profiles')
            .select()
            .or('phone.eq.$phone,phone.eq.$cleanPhone')
            .maybeSingle();
        existingProfile = res;
      } catch (err) {
        debugPrint('Supabase select error: $err');
      }

      // 2. If not found in Supabase, check local storage (persisted profile)
      UserModel? matchedUser;
      if (existingProfile != null) {
        matchedUser = UserModel.fromJson(existingProfile);
      } else {
        matchedUser = getLocallySavedUser(phone);
      }

      // 3. Routing based on whether user is ALREADY REGISTERED
      if (matchedUser != null) {
        user.value = matchedUser;
        await saveUserLocally(matchedUser);

        Helpers.showSnackbar(
          title: 'Welcome Back',
          message: 'Logged in as ${matchedUser.role.toUpperCase()}',
        );

        if (matchedUser.isCustomer) {
          // EXISTING CUSTOMER: Direct to Dashboard (Home Screen)
          Get.offAllNamed(AppRoutes.dashboard);
        } else {
          // EXISTING WORKER: Always Direct to Worker Home Screen (Dashboard)!
          Get.offAllNamed(AppRoutes.dashboard);
        }
      } else {
        // NEW USER (First time on this phone number) -> Go to Role Selection
        user.value = UserModel(
          id: Helpers.generateUuid(),
          name: 'HomeFix User',
          phone: phone,
          role: 'customer',
        );

        Helpers.showSnackbar(
          title: 'Success',
          message: 'Phone verified successfully!',
        );
        Get.toNamed(AppRoutes.roleSelection);
      }
    } catch (e) {
      Helpers.showSnackbar(title: 'Error', message: e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  /// Set Role and route accordingly
  Future<void> setRole(String role) async {
    try {
      final phone = fullPhoneNumber.isNotEmpty
          ? fullPhoneNumber
          : user.value?.phone ?? '+919876543210';
      
      final isCustomer = role == 'customer';
      final existingId = user.value?.id;
      final newId = (existingId != null && existingId.contains('-'))
          ? existingId
          : Helpers.generateUuid();

      final profileData = {
        'id': newId,
        'phone': phone,
        'role': role,
        'full_name': isCustomer ? 'Customer User' : 'Service Worker',
        'is_profile_completed': isCustomer, // Customer profile is complete immediately
      };
      
      // Try Supabase upsert
      try {
        final response = await SupabaseService.client
            .from('profiles')
            .upsert(profileData, onConflict: 'phone')
            .select()
            .maybeSingle();

        if (response != null) {
          user.value = UserModel.fromJson(response);
        } else {
          user.value = UserModel(
            id: newId,
            name: isCustomer ? 'Customer User' : 'Service Worker',
            phone: phone,
            role: role,
            isProfileCompleted: isCustomer,
          );
        }
      } catch (err) {
        debugPrint('Supabase profile upsert error: $err');
        user.value = UserModel(
          id: newId,
          name: isCustomer ? 'Customer User' : 'Service Worker',
          phone: phone,
          role: role,
          isProfileCompleted: isCustomer,
        );
      }

      // Persist locally so subsequent logins recognize this user & role immediately
      if (user.value != null) {
        await saveUserLocally(user.value!);
      }
    } catch (e) {
      debugPrint('Error setting role: $e');
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
        phone: '+919999999999',
        role: 'customer',
      );
      Helpers.showSnackbar(
        title: 'Success',
        message: 'Signed in successfully!',
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
}
