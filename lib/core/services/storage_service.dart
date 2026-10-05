import 'package:get/get.dart';

class StorageService extends GetxService {
  Future<StorageService> init() async {
    // Initialize SharedPreferences or GetStorage here
    return this;
  }

  Future<void> write(String key, dynamic value) async {
    // Write data to local storage
  }

  dynamic read(String key) {
    // Read data from local storage
    return null;
  }

  Future<void> remove(String key) async {
    // Remove specific key
  }

  Future<void> clearAll() async {
    // Clear all storage
  }
}
