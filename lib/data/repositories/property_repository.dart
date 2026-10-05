import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/property_model.dart';

class PropertyRepository {
  final ApiClient apiClient;

  PropertyRepository({required this.apiClient});

  Future<List<PropertyModel>> fetchProperties() async {
    final response = await apiClient.getRequest(ApiEndpoints.properties);
    if (response is List) {
      return response.map((item) => PropertyModel.fromJson(item)).toList();
    }
    return [];
  }
}
