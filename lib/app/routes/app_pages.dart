import 'package:get/get.dart';
import 'app_routes.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/auth/otp_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/bookings/booking_screen.dart';
import '../../screens/properties/property_screen.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.bookings,
      page: () => const BookingScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.properties,
      page: () => const PropertyScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
