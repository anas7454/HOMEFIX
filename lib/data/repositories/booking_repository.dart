import '../../core/services/supabase_service.dart';

class BookingRepository {
  BookingRepository();

  /// Fetch bookings for customer or worker from Supabase
  Future<List<Map<String, dynamic>>> fetchBookings({
    String? userId,
    bool isWorker = false,
  }) async {
    try {
      var query = SupabaseService.client
          .from('bookings')
          .select('*, customer:customer_id(full_name, phone), worker:worker_id(full_name, phone), service:service_id(title)');

      if (userId != null && userId.isNotEmpty) {
        if (isWorker) {
          query = query.eq('worker_id', userId);
        } else {
          query = query.eq('customer_id', userId);
        }
      }

      final response = await query.order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      // Fallback if no data or network
      return [];
    }
  }

  /// Create a new booking
  Future<Map<String, dynamic>?> createBooking({
    required String customerId,
    required String? workerId,
    required String? serviceId,
    required String address,
    required double totalAmount,
    DateTime? bookingDate,
  }) async {
    try {
      final response = await SupabaseService.client.from('bookings').insert({
        'customer_id': customerId,
        'worker_id': workerId,
        'service_id': serviceId,
        'address': address,
        'total_amount': totalAmount,
        'status': 'pending',
        'booking_date': (bookingDate ?? DateTime.now()).toIso8601String(),
      }).select().single();

      return response;
    } catch (e) {
      return null;
    }
  }

  /// Update booking status ('accepted', 'completed', 'cancelled')
  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    await SupabaseService.client
        .from('bookings')
        .update({'status': newStatus})
        .eq('id', bookingId);
  }
}
