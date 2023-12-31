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
      _handleCreateLoginSuccess(loginModelObj);
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

  void _handleCreateLoginSuccess(LoginModel loginModelObj) {
    storingAuthKey(loginModelObj.jwt ?? "", loginModelObj.userId ?? 0,
        loginModelObj.roles?[0].name ?? "");
    getPatientOrEmplyeeId(loginModelObj.roles?[0].name ?? "",
        loginModelObj.userId ?? 0, loginModelObj);
  }

  getPatientOrEmplyeeId(String role, int id, LoginModel _model) async {
    if (role.toLowerCase() == "examiner" ||
        role.toLowerCase() == "receptionist" ||
        role.toLowerCase() == "admin" ||
        role.toLowerCase() == "doctor") {
      if (_model.staff != null) {
        SharedPrefUtils.saveInt('employee_Id', _model.staff!.id ?? 0);
        // AppointmentDetails.staffId = _model.staff!.id ?? 0;
        Get.offAllNamed(AppRoutes.dashboardScreen);
      } else {
        Get.toNamed(AppRoutes.create_profile_screen,
            arguments: ScreenArguments(_model.roles?[0].name ?? "",
                _model.userId ?? 0, _model.userName ?? ""));
      }
    } else {
      if (_model.patient != null) {
        SharedPrefUtils.saveInt('patient_Id', _model.patient!.id ?? 0);
        //Get.offNamed(AppRoutes.homeContainerScreen);
        Get.offAllNamed(AppRoutes.dashboardScreen);
      } else {
        Get.toNamed(AppRoutes.create_profile_screen,
            arguments: ScreenArguments(_model.roles?[0].name ?? "",
                _model.userId ?? 0, _model.userName ?? ""));
      }
    }
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

  void storingAuthKey(String key, int id, String role) {
    SharedPrefUtils.saveStr('auth_token', key);
    SharedPrefUtils.saveInt("user_Id", id);
    SharedPrefUtils.saveStr("role", role);
  }
}
