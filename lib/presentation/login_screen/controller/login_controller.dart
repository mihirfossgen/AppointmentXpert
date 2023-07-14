import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/verify_otp_model.dart';
import '../../../network/api/user_api.dart';
import '../../../network/api/verify_otp.dart';
import '../../../routes/app_routes.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../create_profile/controller/create_profile_controller.dart';
import '../models/login_model.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  LoginModel loginModelObj = LoginModel();

  Rx<bool> isShowPassword = true.obs;

  Rx<bool> isRememberMe = false.obs;

  final formKey = GlobalKey<FormState>();
  String userNumber = '';

  //LoginModel postLoginResp = LoginModel();

  isObscureActive() {
    isShowPassword.value = !isShowPassword.value;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    //formKey.currentState?.close();
    emailController.dispose();
    passwordController.dispose();
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
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
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

      return true;
    } on Map catch (e) {
      print(e);
      return false;
    }
  }
}
