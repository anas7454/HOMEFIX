import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/custom_app_bar.dart';
import '../../controllers/auth_controller.dart';
import 'edit_profile_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import 'about_us_screen.dart';
import 'contact_us_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: CustomAppBar(
        title: 'Profile',
        showBackButton: false,
        showDefaultActions: false,
        actions: [
          Icon(Icons.settings, color: const Color(0xFF001F3F), size: 24.sp),
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              
              // User Info Card
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Profile Image
                    Container(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1540569014015-19a7be504e3a?q=80&w=200&auto=format&fit=crop'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Online Status
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6.w,
                                  height: 6.w,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Online',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Rohit Kumar',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF001F3F),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Electrician',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 12.sp, color: Colors.deepOrange),
                              SizedBox(width: 4.w),
                              Text(
                                'Moradabad, UP',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
                  ],
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // Stats Card
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(Icons.star, '4.8', 'Rating'),
                    Container(width: 1.w, height: 35.h, color: Colors.grey.shade200),
                    _buildStatItem(Icons.work, '120', 'Jobs'),
                    Container(width: 1.w, height: 35.h, color: Colors.grey.shade200),
                    _buildStatItem(Icons.calendar_month, '2+', 'Years Exp.'),
                  ],
                ),
              ),
              
              SizedBox(height: 20.h),
              
              // Cards List
              _buildCardMenuItem(
                icon: Icons.location_on,
                title: 'Manage Addresses',
                subtitle: 'Add or update your addresses',
                onTap: () {},
              ),
              
              _buildCardMenuItem(
                icon: Icons.edit,
                title: 'Edit Profile',
                subtitle: 'Update your personal details',
                isHighlight: true,
                onTap: () {
                  Get.to(() => const EditProfileScreen());
                },
              ),
              
              _buildCardMenuItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help with your queries',
                onTap: () {
                  Get.to(() => const ContactUsScreen());
                },
              ),
              
              _buildCardMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () {
                  Get.to(() => const PrivacyPolicyScreen());
                },
              ),
              
              _buildCardMenuItem(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                subtitle: 'Read our terms of use',
                onTap: () {
                  Get.to(() => const TermsConditionsScreen());
                },
              ),
              
              _buildCardMenuItem(
                icon: Icons.info_outline,
                title: 'About HomeFix',
                subtitle: 'Know more about us',
                onTap: () {
                  Get.to(() => const AboutUsScreen());
                },
              ),
              
              SizedBox(height: 24.h),
              
              // Logout Button
              OutlinedButton(
                onPressed: () {
                  final authController = Get.find<AuthController>();
                  authController.logout();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text('Logout', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepOrange, size: 22.sp),
        SizedBox(height: 6.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF001F3F),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildCardMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    bool isHighlight = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isHighlight ? Colors.orange.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isHighlight ? Colors.deepOrange : Colors.orange.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isHighlight ? Colors.white : Colors.deepOrange,
            size: 20.sp,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isHighlight ? Colors.deepOrange : const Color(0xFF001F3F),
            fontSize: 14.sp,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  color: isHighlight ? Colors.deepOrange.withOpacity(0.7) : Colors.grey.shade500,
                  fontSize: 11.sp,
                ),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14.sp,
          color: isHighlight ? Colors.deepOrange : Colors.grey,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      ),
    );
  }
}

