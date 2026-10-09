import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/custom_button.dart';

class ChoosePlanScreen extends StatelessWidget {
  const ChoosePlanScreen({super.key});

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
        body: SafeArea(
          child: Column(
            children: [
              // ========================================================
              // TOP APP BAR
              // ========================================================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p16,
                  vertical: AppSizes.p8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(AppSizes.r20),
                      child: const Padding(
                        padding: EdgeInsets.all(AppSizes.p6),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: AppSizes.iconLg,
                          color: AppColors.iconDark,
                        ),
                      ),
                    ),
                    const Text(
                      'Choose Plan',
                      style: AppTextStyles.headingSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.help_outline, color: AppColors.iconDark),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // ========================================================
              // SCROLLABLE BODY
              // ========================================================
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSizes.p12),

                      // Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSizes.p16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.peachGlow2, AppColors.peachGlow1],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(AppSizes.r16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Get more jobs\nwith HomeFix Pro',
                                    style: AppTextStyles.headingMedium.copyWith(
                                      color: AppColors.primaryDark,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.p8),
                                  Text(
                                    'Increase your visibility and\nget priority jobs in your area.',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textTitle,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 80,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white24,
                                ),
                                child: const Icon(
                                  Icons.workspace_premium_rounded,
                                  size: 48,
                                  color: AppColors.primaryOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: AppSizes.p24),
                      
                      // Plans
                      _buildPlanCard(
                        title: 'Basic',
                        price: '₹0',
                        duration: 'Free for lifetime',
                        iconData: Icons.send_rounded,
                        iconBgColor: AppColors.blueTint,
                        iconColor: AppColors.blueIcon,
                        features: [
                          'Receive nearby job requests',
                          'Show in search results',
                        ],
                      ),
                      
                      _buildPlanCard(
                        title: 'Standard',
                        price: '₹299',
                        duration: '/ month',
                        iconData: Icons.workspace_premium_rounded,
                        iconBgColor: AppColors.primaryOrange,
                        iconColor: Colors.white,
                        isRecommended: true,
                        features: [
                          'Priority in job requests',
                          'Show at top in search results',
                          'Full profile visibility',
                          'Get more jobs in your area',
                        ],
                      ),
                      
                      _buildPlanCard(
                        title: 'Premium',
                        price: '₹499',
                        duration: '/ month',
                        iconData: Icons.diamond_rounded,
                        iconBgColor: AppColors.peachGlow2,
                        iconColor: AppColors.primaryOrange,
                        features: [
                          'Highest priority in job requests',
                          'Show at top always',
                          'Full profile visibility',
                          'Dedicated support manager',
                        ],
                      ),
                      
                      const SizedBox(height: AppSizes.p24),
                    ],
                  ),
                ),
              ),

              // ========================================================
              // BOTTOM SUBSCRIBE BUTTON
              // ========================================================
              Container(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.p16,
                  AppSizes.p16,
                  AppSizes.p16,
                  AppSizes.p16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12.0,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: CustomButton(
                  text: 'Subscribe Now',
                  height: AppSizes.buttonHeightSm ?? 52.0,
                  icon: Icons.rocket_launch_rounded,
                  onPressed: () {
                    // Navigate to dashboard after successful subscription
                    Get.offAllNamed(AppRoutes.dashboard);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
      margin: const EdgeInsets.only(bottom: AppSizes.p12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(
          color: isRecommended ? AppColors.primaryOrange : AppColors.borderLight,
          width: isRecommended ? 1.2 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isRecommended
                ? AppColors.primaryOrange.withOpacity(0.12)
                : Colors.black.withOpacity(0.02),
            blurRadius: isRecommended ? 10.0 : 4.0,
            offset: const Offset(0, 2.0),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p12, vertical: AppSizes.p14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(AppSizes.r12),
                      ),
                      child: Center(
                        child: Icon(
                          iconData,
                          color: iconColor,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.p12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.headingSmall,
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
                          ),
                        ),
                        Text(
                          duration,
                          style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.p12),
                const Divider(color: AppColors.borderLight, height: 1),
                const SizedBox(height: AppSizes.p12),
                ...features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.success,
                            size: 16,
                          ),
                          const SizedBox(width: AppSizes.p8),
                          Expanded(
                            child: Text(
                              feature,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                height: 1.25,
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: const BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(AppSizes.r12),
                    bottomLeft: Radius.circular(AppSizes.r12),
                  ),
                ),
                child: const Text(
                  'RECOMMENDED',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
