import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/onboarding_model.dart';
import '../core/constants/app_assets.dart';
import '../app/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  Timer? _autoSlideTimer;

  static const Duration _autoSlideInterval = Duration(seconds: 3, milliseconds: 500);

  final List<OnboardingItem> items = const [
    OnboardingItem(
      step: '01 / 03',
      title: 'All Home Services\nin One App',
      description:
          'From repairs to cleaning – find trusted\nprofessionals near you in just a few taps.',
      image: AppAssets.onboarding1,
    ),
    OnboardingItem(
      step: '02 / 03',
      title: 'Find Trusted\nProfessionals',
      description:
          'Connect with verified & experienced\nservice providers near your location.',
      image: AppAssets.onboarding2,
    ),
    OnboardingItem(
      step: '03 / 03',
      title: 'Book & Relax',
      description:
          'Schedule a service at your convenience\nand let our experts take care of the rest.',
      image: AppAssets.onboarding3,
    ),
  ];

  bool get isLastPage => currentPage.value == items.length - 1;

  @override
  void onInit() {
    super.onInit();
    _startAutoSlideTimer();
  }

  void _startAutoSlideTimer() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(_autoSlideInterval, (timer) {
      if (pageController.hasClients) {
        if (currentPage.value < items.length - 1) {
          pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
          );
        } else {
          // Reached last page, stop auto-timer so user can tap 'Get Started'
          _autoSlideTimer?.cancel();
        }
      }
    });
  }

  void onPageChanged(int index) {
    currentPage.value = index;
    // Reset timer on manual swipe so user has full interval time to read
    if (index < items.length - 1) {
      _startAutoSlideTimer();
    } else {
      _autoSlideTimer?.cancel();
    }
  }

  void nextPage() {
    if (currentPage.value < items.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
      _startAutoSlideTimer();
    } else {
      getStarted();
    }
  }

  void skip() {
    _autoSlideTimer?.cancel();
    getStarted();
  }

  void getStarted() {
    _autoSlideTimer?.cancel();
    Get.offAllNamed(AppRoutes.auth);
  }

  @override
  void onClose() {
    _autoSlideTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
