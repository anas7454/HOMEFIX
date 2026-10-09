import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/notification_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/booking_repository.dart';
import '../../data/repositories/property_repository.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/property_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put<StorageService>(StorageService(), permanent: true);
    if (!Get.isRegistered<NotificationService>()) {
      Get.put<NotificationService>(NotificationService(), permanent: true);
    }

    // Network Client
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Repositories
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<BookingRepository>(
      () => BookingRepository(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<PropertyRepository>(
      () => PropertyRepository(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    // Controllers
    Get.lazyPut<AuthController>(
      () => AuthController(authRepository: Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<BookingController>(
      () => BookingController(bookingRepository: Get.find<BookingRepository>()),
      fenix: true,
    );
    Get.lazyPut<PropertyController>(
      () => PropertyController(propertyRepository: Get.find<PropertyRepository>()),
      fenix: true,
    );
  }
}
