import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../core/services/supabase_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/notification_service.dart';

class BookingRepository {
  BookingRepository();

  /// Fetch bookings for customer or worker from Supabase
  Future<List<Map<String, dynamic>>> fetchBookings({
    String? userId,
    String? userPhone,
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
      debugPrint('fetchBookings error: $e');
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

  /// Log customer inquiry (Call or WhatsApp) so worker gets an inquiry card
  Future<void> logInquiry({
    required String? workerId,
    required String? workerPhone,
    required String? customerId,
    required String customerName,
    required String customerPhone,
    required String location,
    required String contactMethod, // 'Call' or 'WhatsApp'
  }) async {
    final now = DateTime.now();
    final formattedTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final effectiveCustomerId = (customerId != null && customerId.isNotEmpty)
        ? customerId
        : (SupabaseService.client.auth.currentUser?.id);

    // 1. Try Supabase insert so worker can see it across different devices
    if (workerId != null && workerId.isNotEmpty && effectiveCustomerId != null && effectiveCustomerId.isNotEmpty) {
      try {
        await SupabaseService.client.from('bookings').insert({
          'customer_id': effectiveCustomerId,
          'worker_id': workerId,
          'address': location.isNotEmpty ? location : 'Current Location',
          'total_amount': 0.0,
          'status': '$contactMethod Inquiry',
          'booking_date': now.toIso8601String(),
        });
        debugPrint('Successfully logged inquiry to Supabase for worker: $workerId');
      } catch (err) {
        debugPrint('Supabase inquiry insert note: $err');
      }
    }

    // 2. Save locally for instantaneous offline reflection in worker's inquiry list
    try {
      if (Get.isRegistered<StorageService>()) {
        final storage = Get.find<StorageService>();
        final entry = {
          'name': customerName,
          'number': customerPhone,
          'location': location.isNotEmpty ? location : 'Current Location',
          'status': '$contactMethod Inquiry',
          'time': 'Today, $formattedTime',
          'created_at': now.toIso8601String(),
          'worker_id': workerId,
          'worker_phone': workerPhone,
        };

        // Write to multiple keys so it's guaranteed to be found by worker id, phone, or globally
        final keysToUpdate = <String>{
          'inquiries_global',
          if (workerId != null && workerId.isNotEmpty) 'inquiries_$workerId',
          if (workerPhone != null && workerPhone.isNotEmpty) 'inquiries_$workerPhone',
          if (workerPhone != null && workerPhone.isNotEmpty)
            'inquiries_${workerPhone.replaceAll('+91', '').replaceAll(' ', '').trim()}',
        };

        for (final k in keysToUpdate) {
          final List<dynamic> currentList = storage.read(k) is List
              ? List.from(storage.read(k) as List)
              : [];
          currentList.insert(0, entry);
          if (currentList.length > 50) currentList.removeLast();
          await storage.write(k, currentList);
        }
        debugPrint('Successfully stored local inquiry for keys: $keysToUpdate');
      }

      // 3. Trigger immediate notification for worker
      if (Get.isRegistered<NotificationService>()) {
        Get.find<NotificationService>().showNotification(
          title: 'New Customer Inquiry!',
          body: '$customerName is inquiring via $contactMethod ($customerPhone)',
          payload: 'inquiry_$workerId',
        );
      }
    } catch (e) {
      debugPrint('Local inquiry storage error: $e');
    }
  }
}
