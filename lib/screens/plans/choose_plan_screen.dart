import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/supabase_service.dart';
import '../../controllers/auth_controller.dart';
import '../../app/routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_app_bar.dart';

class ChoosePlanScreen extends StatelessWidget {
  final bool showBackButton;
  const ChoosePlanScreen({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.bgWarm,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bgGradientTop,
        appBar: CustomAppBar(
          title: 'Choose Plan',
          showBackButton: showBackButton,
          showDefaultActions: false,
          actions: [
            IconButton(
              icon: Icon(Icons.help_outline, color: const Color(0xFF001F3F), size: 24.sp),
              tooltip: 'Help',
              onPressed: () {
                Get.snackbar(
                  'Help',
                  'Choose a plan that fits your business needs. You can upgrade anytime.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final contentWidth = constraints.maxWidth > 620 ? 560.0 : double.infinity;

              return Column(
                children: [

                  // ========================================================
                  // SCROLLABLE BODY
                  // ========================================================
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: contentWidth),
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 12.h),

                              // Banner
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppColors.peachGlow2, AppColors.peachGlow1],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Get More Work with\nHomeFix Pro',
                                            style: AppTextStyles.headingMedium.copyWith(
                                              color: AppColors.primaryDark,
                                              height: 1.2,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'Boost your profile visibility and get top priority for customer bookings in your area.',
                                            style: AppTextStyles.bodyMedium.copyWith(
                                              color: AppColors.textTitle,
                                              fontSize: 11.sp,
                                              height: 1.35,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Container(
                                      width: 74.w,
                                      height: 74.w,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white24,
                                      ),
                                      child: Icon(
                                        Icons.workspace_premium_rounded,
                                        size: 40.sp,
                                        color: AppColors.primaryOrange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              SizedBox(height: 18.h),
                              Text(
                                'How It Works',
                                style: AppTextStyles.headingSmall.copyWith(fontSize: 16.sp),
                              ),
                              SizedBox(height: 8.h),
                              _buildFlowInfo(),
                              
                              SizedBox(height: 20.h),
                              
                              // Plans
                              _buildPlanCard(
                                title: 'Basic (Free)',
                                price: '₹0',
                                duration: 'Forever',
                                iconData: Icons.send_rounded,
                                iconBgColor: AppColors.blueTint,
                                iconColor: AppColors.blueIcon,
                                features: [
                                  'Receive nearby job requests',
                                  'Standard search listing',
                                ],
                              ),
                              
                              _buildPlanCard(
                                title: 'HomeFix Pro (3 Months)',
                                price: '₹49',
                                duration: 'For 3 Months',
                                iconData: Icons.workspace_premium_rounded,
                                iconBgColor: AppColors.primaryOrange,
                                iconColor: Colors.white,
                                isRecommended: true,
                                features: [
                                  'Top priority in job requests',
                                  'Rank #1 in search results',
                                  'Verified Pro badge on profile',
                                  'Maximum job leads in your locality',
                                ],
                              ),
                              
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ========================================================
                  // BOTTOM SUBSCRIBE BUTTON (RAZORPAY INTEGRATED)
                  // ========================================================
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12.0.r,
                          offset: Offset(0, -4.h),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: contentWidth),
                        child: CustomButton(
                          text: 'Pay ₹49 Now (3 Months Pro)',
                          height: 52.h,
                          icon: Icons.lock_outline_rounded,
                          onPressed: () async {
                            final authCtrl = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
                            final workerId = authCtrl?.user.value?.id;
                            
                            // 1. Open Razorpay secure checkout link
                            final Uri paymentUri = Uri.parse('https://rzp.io/rzp/B6KkdsdD');
                            try {
                              await launchUrl(paymentUri, mode: LaunchMode.externalApplication);
                            } catch (_) {}

                            // 2. Update worker profile in Supabase to pro plan
                            if (workerId != null) {
                              try {
                                await SupabaseService.client
                                    .from('worker_details')
                                    .update({'active_plan': 'pro'})
                                    .eq('worker_id', workerId);
                              } catch (_) {}
                            }

                            if (Get.isRegistered<NotificationService>()) {
                              await Get.find<NotificationService>().showNotification(
                                title: 'HomeFix Pro Activated',
                                body: 'Your profile now has maximum visibility and priority.',
                                payload: 'plan_subscribed',
                              );
                            }
                            
                            Get.snackbar(
                              'Pro Plan Activated',
                              'Your 3-month Pro plan is now active.',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.white,
                              colorText: const Color(0xFF001F3F),
                              duration: const Duration(seconds: 3),
                            );

                            // Direct navigation to App Dashboard
                            await Future.delayed(const Duration(milliseconds: 600));
                            Get.offAllNamed(AppRoutes.dashboard);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFlowInfo() {
    final items = [
      (Icons.person_search_rounded, 'Customers discover your profile & verified ratings'),
      (Icons.notifications_active_rounded, 'Instant alerts when new job requests arrive'),
      (Icons.handshake_rounded, 'Accept inquiries and complete bookings easily'),
    ];

    return Column(
      children: items
          .map(
            (item) => Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Icon(item.$1, color: AppColors.primaryOrange, size: 20.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      item.$2,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 12.sp,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String duration,
    required IconData iconData,
    required Color iconBgColor,
    required Color iconColor,
    bool isRecommended = false,
    required List<String> features,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isRecommended ? AppColors.primaryOrange : AppColors.borderLight,
          width: isRecommended ? 1.2 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isRecommended
                ? AppColors.primaryOrange.withOpacity(0.12)
                : Colors.black.withOpacity(0.02),
            blurRadius: isRecommended ? 10.0.r : 4.0.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 46.w,
                      height: 46.w,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Icon(
                          iconData,
                          color: iconColor,
                          size: 24.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.headingSmall.copyWith(fontSize: 15.sp),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          price,
                          style: AppTextStyles.headingMedium.copyWith(
                            color: isRecommended ? AppColors.primaryOrange : AppColors.textTitle,
                            fontWeight: FontWeight.w800,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          duration,
                          style: AppTextStyles.bodyMedium.copyWith(fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                const Divider(color: AppColors.borderLight, height: 1),
                SizedBox(height: 12.h),
                ...features.map((feature) => Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.success,
                            size: 14.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              feature,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                height: 1.25,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          if (isRecommended)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.r),
                    bottomLeft: Radius.circular(12.r),
                  ),
                ),
                child: Text(
                  'BEST VALUE',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: Colors.white,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
