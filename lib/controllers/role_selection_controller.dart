import 'package:get/get.dart';
import '../app/routes/app_routes.dart';

enum UserRoleType { customer, provider }

class RoleSelectionController extends GetxController {
  final Rx<UserRoleType> selectedRole = UserRoleType.customer.obs;
  final RxBool isLoading = false.obs;

  void selectRole(UserRoleType role) {
    selectedRole.value = role;
  }

  void onContinue() {
    isLoading.value = true;
    Get.toNamed(AppRoutes.basicInfo);
    isLoading.value = false;
  }
}
