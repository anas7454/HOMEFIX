import 'package:get/get.dart';

class NotificationService extends GetxService {
  Future<NotificationService> init() async {
    // Initialize Firebase Messaging or Local Notifications
    return this;
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    // Show local notification logic
  }
}
