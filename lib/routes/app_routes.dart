import 'package:appointmentxpert/presentation/splash_screen/onboarding_screen.dart';
import 'package:get/get.dart';

import '../presentation/create_new_password_screen/binding/create_new_password_binding.dart';
import '../presentation/create_new_password_screen/create_new_password_screen.dart';
import '../presentation/create_profile/binding/create_profile_binding.dart';
import '../presentation/create_profile/create_profile_screen.dart';
import '../presentation/dashboard_screen/binding/dashboard_binding.dart';
import '../presentation/dashboard_screen/views/screens/dashboard_screen.dart';
import '../presentation/login_screen/binding/login_binding.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/reset_password_email_tab_container_screen/binding/reset_password_email_tab_container_binding.dart';
import '../presentation/reset_password_email_tab_container_screen/reset_password_email_tab_container_screen.dart';
import '../presentation/reset_password_verify_code_screen/binding/reset_password_verify_code_binding.dart';
import '../presentation/reset_password_verify_code_screen/reset_password_verify_code_screen.dart';
import '../presentation/sign_up_screen/binding/sign_up_binding.dart';
import '../presentation/sign_up_screen/sign_up_screen.dart';
import '../presentation/splash_screen/binding/splash_binding.dart';
import '../presentation/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';

  static const String onboardingScreen = '/onboarding_screen';

  static const String loginScreen = '/login_screen';

  static const String signUpScreen = '/sign_up_screen';

  static const String resetPasswordEmailPage = '/reset_password_email_page';

  static const String resetPasswordEmailTabContainerScreen =
      '/reset_password_email_tab_container_screen';

  static const String resetPasswordPhonePage = '/reset_password_phone_page';

  static const String resetPasswordVerifyCodeScreen =
      '/reset_password_verify_code_screen';

  static const String createNewPasswordScreen = '/create_new_password_screen';

  static const String homePage = '/home_page';

  static const String dashboardScreen = '/dashboard_screen';

  static const String topDoctorScreen = '/top_doctor_screen';

  static const String findDoctorsScreen = '/find_doctors_screen';

  static const String doctorDetailScreen = '/doctor_detail_screen';

  static const String bookingDoctorScreen = '/booking_doctor_screen';

  static const String chatWithDoctorScreen = '/chat_with_doctor_screen';

  static const String audioCallScreen = '/audio_call_screen';

  static const String videoCallScreen = '/video_call_screen';

  static const String schedulePage = '/schedule_page';

  static const String scheduleTabContainerPage = '/schedule_tab_container_page';

  static const String messageHistoryPage = '/message_history_page';

  static const String messageHistoryTabContainerPage =
      '/message_history_tab_container_page';

  static const String articlesScreen = '/articles_screen';

  static const String pharmacyScreen = '/pharmacy_screen';

  static const String drugsDetailScreen = '/drugs_detail_screen';

  static const String myCartScreen = '/my_cart_screen';

  static const String locationScreen = '/location_screen';

  static const String profilePage = '/profile_page';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';

  static const String appointmentDetailsPage = '/appointment_details_page';
  static const String add_patient_visit = '/add_patient_visit';
  static const String add_patient_dignosys = '/add_patient_dignosys';
  static const String add_patient_treatment = '/add_patient_treatment';
  static const String create_profile_screen = '/create_profile_screen';
  static const String speciallizationScreen = '/speciallization_screen';
  static const String doctorProfilePage = '/doctor_profile_page';
  static const String settingsScreen = '/settings_screen';
  static const String personalInfoScreen = '/personal_info_screen';
  static const String experienceSettingScreen = '/experience_setting_screen';
  static const String newPositionScreen = '/new_position_screen';
  static const String addNewEducationScreen = '/add_new_education_screen';
  static const String createInvoiceScreen = '/create_invoice_screen';

  static List<GetPage> pages = [
    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
      bindings: [
        SplashBinding(),
      ],
    ),
    GetPage(
      name: loginScreen,
      page: () => LoginScreen(),
      bindings: [
        LoginBinding(),
      ],
    ),
    GetPage(
      name: signUpScreen,
      page: () => SignUpScreen(),
      bindings: [
        SignUpBinding(),
      ],
    ),
    GetPage(
      name: resetPasswordEmailTabContainerScreen,
      page: () => ResetPasswordEmailTabContainerScreen(),
      bindings: [
        ResetPasswordEmailTabContainerBinding(),
      ],
    ),
    GetPage(
      name: resetPasswordVerifyCodeScreen,
      page: () => ResetPasswordVerifyCodeScreen(),
      bindings: [
        ResetPasswordVerifyCodeBinding(),
      ],
    ),
    GetPage(
      name: createNewPasswordScreen,
      page: () => CreateNewPasswordScreen(),
      bindings: [
        CreateNewPasswordBinding(),
      ],
    ),
    GetPage(
      name: dashboardScreen,
      page: () => DashboardScreen(),
      bindings: [
        DasboardMainBinding(),
      ],
    ),

    GetPage(
      name: onboardingScreen,
      page: () => const OnBoardingPage(),
    ),
    GetPage(
      name: initialRoute,
      page: () => SplashScreen(),
      bindings: [
        SplashBinding(),
      ],
    ),
    GetPage(
      name: create_profile_screen,
      page: () => CreateProfileScreen(),
      bindings: [
        CreateProfileBinding(),
      ],
    ),

    // GetPage(
    //   name: createInvoiceScreen,
    //   page: () => CreateInvoiceScreen(),
    //   bindings: [
    //     CreateInvoiceBinding(),
    //   ],
    // ),
  ];
}
