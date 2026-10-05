import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/booking_controller.dart';
import '../../widgets/loading_widget.dart';
import '../../core/utils/helpers.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingController = Get.find<BookingController>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: Obx(() {
        if (bookingController.isLoading.value) {
          return const LoadingWidget(message: 'Loading bookings...');
        }

        if (bookingController.bookings.isEmpty) {
          return const Center(child: Text('No bookings found'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: bookingController.bookings.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final booking = bookingController.bookings[index];
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: ListTile(
                title: Text(booking.serviceName, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('Date: ${Helpers.formatDate(booking.bookingDate)}'),
                trailing: Text(
                  Helpers.formatCurrency(booking.price),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
