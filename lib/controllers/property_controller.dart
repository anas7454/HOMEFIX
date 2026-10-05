import 'package:get/get.dart';
import '../data/models/property_model.dart';
import '../data/repositories/property_repository.dart';
import '../core/utils/helpers.dart';

class PropertyController extends GetxController {
  final PropertyRepository propertyRepository;

  PropertyController({required this.propertyRepository});

  final RxList<PropertyModel> properties = <PropertyModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    try {
      isLoading.value = true;
      final list = await propertyRepository.fetchProperties();
      properties.assignAll(list);
    } catch (e) {
      Helpers.showSnackbar(title: 'Error', message: e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
