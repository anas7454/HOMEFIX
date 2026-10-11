import 'package:get/get.dart';
import '../app/routes/app_routes.dart';
import '../core/services/storage_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));

    // Check if user has an active logged-in session
    bool hasActiveSession = false;
    try {
      if (Get.isRegistered<StorageService>()) {
        final storage = Get.find<StorageService>();
        final rawUser = storage.read('current_user');
        if (rawUser != null) {
          hasActiveSession = true;
        }
      }
    } catch (_) {}

    if (hasActiveSession) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }
}
