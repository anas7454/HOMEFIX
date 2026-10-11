import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/custom_app_bar.dart';
import '../../controllers/auth_controller.dart';
import '../../data/repositories/booking_repository.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/helpers.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final BookingRepository _bookingRepository = BookingRepository();
  bool _isLoading = true;
  List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    final authCtrl = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
    final user = authCtrl?.user.value;

    final data = await _bookingRepository.fetchBookings(
      userId: user?.id,
      isWorker: user?.isWorker ?? false,
    );

    final List<Map<String, dynamic>> combined = [];

    // 1. Include inquiries
    try {
      if (Get.isRegistered<StorageService>()) {
        final storage = Get.find<StorageService>();
        final workerKey = 'inquiries_${user?.id}';
        final phoneKey = 'inquiries_${user?.phone}';
        final cleanPhoneKey = 'inquiries_${user?.phone?.replaceAll('+91', '').replaceAll(' ', '').trim()}';
        
        final localList = storage.read(workerKey) ??
            storage.read(phoneKey) ??
            storage.read(cleanPhoneKey) ??
            storage.read('inquiries_global');

        if (localList is List) {
          for (final inq in localList) {
            if (inq is Map) {
              combined.add({
                'name': inq['name'] ?? 'Customer',
                'number': inq['number'] ?? '',
                'location': inq['location'] ?? 'Current Location',
                'status': inq['status'] ?? 'New Inquiry',
                'time': inq['time'] ?? 'Just now',
              });
            }
          }
        }
      }
    } catch (_) {}

    // 2. Add remote bookings
    for (final b in data) {
      final customer = b['customer'] as Map<String, dynamic>?;
      final worker = b['worker'] as Map<String, dynamic>?;
      final service = b['service'] as Map<String, dynamic>?;

      combined.add({
        'name': (user?.isWorker ?? false)
            ? (customer?['full_name'] ?? 'Customer')
            : (worker?['full_name'] ?? service?['title'] ?? 'HomeFix Service'),
        'number': (customer?['phone'] ?? worker?['phone'] ?? '+91 98765 43210'),
        'location': b['address'] ?? 'Nearby Area',
        'status': (b['status'] ?? 'pending').toString().capitalizeFirst ?? 'New',
        'time': b['created_at'] != null ? 'Active' : 'Today',
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
        _bookings = combined;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
    final isWorker = authCtrl?.user.value?.isWorker ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: CustomAppBar(
        title: isWorker ? 'Customer Requests' : 'My Bookings',
        showBackButton: false,
        showDefaultActions: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: const Color(0xFF001F3F), size: 22.sp),
            onPressed: _loadBookings,
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepOrange))
          : _bookings.isEmpty
              ? RefreshIndicator(
                  color: Colors.deepOrange,
                  onRefresh: _loadBookings,
                  child: ListView(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80.r,
                              height: 80.r,
                              decoration: BoxDecoration(
                                color: Colors.deepOrange.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.calendar_month_outlined,
                                size: 40.sp,
                                color: Colors.deepOrange,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No Bookings Yet',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF001F3F),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'Aapki koi active ya previous booking nahi mili.',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton.icon(
                              onPressed: _loadBookings,
                              icon: Icon(Icons.refresh, size: 16.sp),
                              label: Text('Refresh', style: TextStyle(fontSize: 13.sp)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: Colors.deepOrange,
                  onRefresh: _loadBookings,
                  child: ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: _bookings.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final booking = _bookings[index];
                  final isNew = booking['status'] == 'New' || booking['status'] == 'Pending';

                  return Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8.r,
                          offset: Offset(0, 3.h),
                        ),
                      ],
                      border: isNew
                          ? Border.all(
                              color: Colors.deepOrange.withValues(alpha: 0.3),
                              width: 1.w,
                            )
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: isNew ? Colors.green.shade50 : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                booking['status'] ?? 'Upcoming',
                                style: TextStyle(
                                  color: isNew ? Colors.green.shade700 : Colors.orange.shade700,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              booking['time'] ?? 'Today',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Container(
                              width: 32.r,
                              height: 32.r,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.person, color: Colors.blue, size: 16.sp),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                booking['name'] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                  color: const Color(0xFF001F3F),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32.r,
                              height: 32.r,
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.location_on, color: Colors.red, size: 16.sp),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 2.h),
                                child: Text(
                                  booking['location'] ?? '',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade700,
                                    height: 1.3,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40.h,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    final phone = booking['number'] ?? '';
                                    Helpers.makePhoneCall(phone);
                                  },
                                  icon: Icon(Icons.call, size: 16.sp, color: Colors.orange),
                                  label: Text(
                                    'Call',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.sp,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.orange),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: SizedBox(
                                height: 40.h,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    final phone = booking['number'] ?? '';
                                    Helpers.openWhatsApp(phone);
                                  },
                                  icon: Icon(Icons.chat, size: 16.sp, color: Colors.white),
                                  label: Text(
                                    'WhatsApp',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF25D366),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}