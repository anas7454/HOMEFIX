class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.example.com/v1';
  static const Duration timeout = Duration(seconds: 30);

  // Auth
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String profile = '$baseUrl/auth/profile';

  // Bookings
  static const String bookings = '$baseUrl/bookings';

  // Properties
  static const String properties = '$baseUrl/properties';
}
