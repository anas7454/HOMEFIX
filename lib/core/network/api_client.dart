import 'package:get/get.dart';
import 'api_endpoints.dart';
import 'api_exception.dart';

class ApiClient extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiEndpoints.baseUrl;
    httpClient.timeout = ApiEndpoints.timeout;
    
    // Request Modifier (e.g. adding auth token)
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Accept'] = 'application/json';
      return request;
    });

    // Response Modifier
    httpClient.addResponseModifier((request, response) {
      return response;
    });

    super.onInit();
  }

  Future<dynamic> getRequest(String url, {Map<String, dynamic>? query}) async {
    try {
      final response = await get(url, query: query);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<dynamic> postRequest(String url, dynamic body) async {
    try {
      final response = await post(url, body);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  dynamic _handleResponse(Response response) {
    if (response.status.hasError) {
      throw ApiException(
        message: response.statusText ?? 'Network error occurred',
        statusCode: response.statusCode,
        data: response.body,
      );
    }
    return response.body;
  }
}
