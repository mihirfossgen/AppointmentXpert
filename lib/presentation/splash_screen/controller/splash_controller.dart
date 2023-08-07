import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../models/splash_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SplashController extends GetxController {
  Rx<SplashModel> splashModelObj = SplashModel().obs;

  @override
  void onReady() {
    super.onReady();
    routeBasedOnUserProperties();
    _register();
  }

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  _register() {
    firebaseMessaging
        .getToken()
        .then((token) => print('fcm token ---- $token'));
  }

  void routeBasedOnUserProperties() async {
    dynamic user_Id = await SessionManager().get("user_Id");
    dynamic auth_token = await SessionManager().get("auth_token");
    dynamic role = await SessionManager().get("role");
    if (SharedPrefUtils.readPrefStr('auth_token').isNotEmpty &&
        SharedPrefUtils.readPrefINt("user_Id") != 0 &&
        SharedPrefUtils.readPrefStr("role").isNotEmpty &&
        SharedPrefUtils.readPrefBool('complete_profile_flag') == true) {
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
          AppRoutes.onboardingScreen,
        );
      });
    }
  }
}
