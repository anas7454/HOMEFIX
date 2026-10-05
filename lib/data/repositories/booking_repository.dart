import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final ApiClient apiClient;

  BookingRepository({required this.apiClient});

  Future<List<BookingModel>> fetchBookings() async {
    final response = await apiClient.getRequest(ApiEndpoints.bookings);
    if (response is List) {
      return response.map((item) => BookingModel.fromJson(item)).toList();
    }
    return [];
  }

  Future<BookingModel> createBooking(Map<String, dynamic> data) async {
    final response = await apiClient.postRequest(ApiEndpoints.bookings, data);
    return BookingModel.fromJson(response);
  }
}
