import 'package:get/get.dart';
import '../data/models/booking_model.dart';
import '../data/repositories/booking_repository.dart';
import '../core/utils/helpers.dart';

class BookingController extends GetxController {
  final BookingRepository bookingRepository;

  BookingController({required this.bookingRepository});

  final RxList<BookingModel> bookings = <BookingModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      final list = await bookingRepository.fetchBookings();
      bookings.assignAll(list);
    } catch (e) {
      Helpers.showSnackbar(title: 'Error', message: e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
