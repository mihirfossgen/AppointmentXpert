import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../models/splash_model.dart';

class SplashController extends GetxController {
  Rx<SplashModel> splashModelObj = SplashModel().obs;

  @override
  void onReady() {
    super.onReady();
    routeBasedOnUserProperties();
  }

  void routeBasedOnUserProperties() {
    if (SharedPrefUtils.readPrefStr('auth_token').isNotEmpty &&
        SharedPrefUtils.readPrefINt("user_Id") != 0 &&
        SharedPrefUtils.readPrefStr("role").isNotEmpty &&
        SharedPrefUtils.readPrefStr("role").isNotEmpty) {
      //  && SharedPrefUtils.readPrefBool('complete_profile_flag') == true) {
      // if (SharedPrefUtils.readPrefINt("employee_Id") == 0) {
      //   Future.delayed(const Duration(seconds: 3), () {
      //     Get.offAllNamed(AppRoutes.homeContainerScreen);
      //   });
      // } else {
      //   Future.delayed(const Duration(seconds: 3), () {
      //     Get.offAllNamed(AppRoutes.homeContainerScreen);
      //   });
      // }
      Future.delayed(const Duration(seconds: 3), () {
        Get.offAllNamed(AppRoutes.dashboardScreen);
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Get.offAllNamed(
          AppRoutes.onboardingFourScreen,
        );
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
