import 'package:get/get.dart';
import '../app/routes/app_routes.dart';
import 'auth_controller.dart';

enum UserRoleType { customer, provider }

class RoleSelectionController extends GetxController {
  final Rx<UserRoleType> selectedRole = UserRoleType.customer.obs;
  final RxBool isLoading = false.obs;

  void selectRole(UserRoleType role) {
    selectedRole.value = role;
  }

  Future<void> onContinue() async {
    isLoading.value = true;
    final authController = Get.find<AuthController>();
    final isCustomer = selectedRole.value == UserRoleType.customer;

    // Save selected role to Supabase
    await authController.setRole(isCustomer ? 'customer' : 'worker');

    if (isCustomer) {
      // USER: Direct Home Screen (Dashboard)
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      // WORKER: Fill Profile (Basic Info, Skills, Experience)
      Get.toNamed(AppRoutes.basicInfo);
    }
    isLoading.value = false;
  }
}
