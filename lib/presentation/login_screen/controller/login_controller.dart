import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/color_constant.dart';
import '../../../models/verify_otp_model.dart';
import '../../../network/api/user_api.dart';
import '../../../network/api/verify_otp.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../models/login_model.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  LoginModel loginModelObj = LoginModel();

  Rx<bool> isShowPassword = true.obs;

  Rx<bool> isRememberMe = false.obs;
  RxBool isloading = false.obs;

  final formKey = GlobalKey<FormState>();
  String userNumber = '';

  //LoginModel postLoginResp = LoginModel();

  isObscureActive() {
    isShowPassword.value = !isShowPassword.value;
  }

  @override
  void onReady() {
    super.onReady();
    _register();
  }

  @override
  void onClose() {
    super.onClose();
    //formKey.currentState?.close();
    isloading.value = false;
    emailController.clear();
    passwordController.clear();
  }

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  _register() {
    firebaseMessaging.getToken().then((token) {
      print('fcm token ---- $token');
      if (token != null) {
        SharedPrefUtils.saveStr('device_token', token);
      }
    });
  }

  Future<void> callCreateLogin(Map<String, dynamic> req) async {
    try {
      loginModelObj = (await Get.find<UserApi>().callLogin(
        headers: {
          'Content-type': 'application/json',
        },
        data: req,
      ));
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  String? userNameValidator(String value) {
    if (value.isEmpty) {
      return "Please enter username";
    } else if (value.length < 4) {
      return 'Username must be at least 4 characters long.';
    }
    return null;
  }

  String? numberValidator(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    } else {
      userNumber = value;
    }
    return null;
  }

  String? passwordValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Password must be at least 4 characters long.';
    }
    return null;
  }

  bool trySubmit() {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();

    if (isValid) {
      formKey.currentState!.save();

      return true;
    }
    return false;
  }

  OtpModel? getOtp;
  Future<bool> callOtp(String number, String type) async {
    try {
      getOtp = await Get.find<VerifyOtpApi>().callOtp(headers: {
        'Content-type': 'application/x-www-form-urlencoded',
      }, number: number, type: type);
      isloading.value = false;
      if (getOtp?.result == false) {
        isloading.value = false;
        Get.back();
        WidgetsBinding.instance
            .addPostFrameCallback((timeStamp) => Get.snackbar(
                  "Uh oh!!",
                  getOtp?.message ?? "",
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 5),
                  borderRadius: 15,
                  icon: Icon(
                    Icons.error_outline,
                    color: ColorConstant.whiteA700,
                  ),
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.all(40),
                  colorText: ColorConstant.whiteA700,
                  backgroundColor: ColorConstant.blue700,
                ));
        return false;
      } else {
        return true;
      }
    } on Map catch (e) {
      print(e);
      return false;
    }
  }

  _handleCallOtp(OtpModel? otpModel) {}
}
