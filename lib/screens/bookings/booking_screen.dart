import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/custom_app_bar.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for premium UI display
    final List<Map<String, dynamic>> dummyBookings = [
      {
        'name': 'Aman Gupta',
        'number': '+91 98765 43210',
        'location': 'Sector 62, Noida, UP',
        'status': 'New',
        'time': 'Just now',
      },
      {
        'name': 'Priya Singh',
        'number': '+91 91234 56789',
        'location': 'Indirapuram, Ghaziabad, UP',
        'status': 'Upcoming',
        'time': 'Today, 2:00 PM',
      },
      {
        'name': 'Rahul Verma',
        'number': '+91 99887 76655',
        'location': 'Vaishali, Ghaziabad, UP',
        'status': 'Upcoming',
        'time': 'Tomorrow, 10:30 AM',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: CustomAppBar(
        title: 'My Bookings',
        showBackButton: false,
        showDefaultActions: false,
        actions: [
          Icon(Icons.filter_list, color: const Color(0xFF001F3F), size: 24.sp),
          SizedBox(width: 16.w),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: dummyBookings.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final booking = dummyBookings[index];
          final isNew = booking['status'] == 'New';

          return Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8.r,
                  offset: Offset(0, 3.h),
                ),
              ],
              border: isNew ? Border.all(color: Colors.deepOrange.withOpacity(0.3), width: 1.w) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row with Status and Time
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
                        booking['status'],
                        style: TextStyle(
                          color: isNew ? Colors.green : Colors.deepOrange,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      booking['time'],
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12.h),
                
                // Name Row
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: Colors.blue, size: 16.sp),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking['name'],
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF001F3F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 10.h),
                
                // Number Row
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.phone, color: Colors.green, size: 16.sp),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        booking['number'],
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 10.h),
                
                // Location Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
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
                          booking['location'],
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
                SizedBox(
                  width: double.infinity,
                  height: 40.h,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.call, size: 16.sp),
                    label: Text('Call', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
