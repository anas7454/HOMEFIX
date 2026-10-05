import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.postRequest(ApiEndpoints.login, {
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(response);
  }

  Future<UserModel> register(Map<String, dynamic> data) async {
    final response = await apiClient.postRequest(ApiEndpoints.register, data);
    return UserModel.fromJson(response);
  }

  Future<UserModel> getProfile() async {
    final response = await apiClient.getRequest(ApiEndpoints.profile);
    return UserModel.fromJson(response);
  }
}
