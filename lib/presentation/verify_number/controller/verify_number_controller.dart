import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/verify_otp_model.dart';
import '../../../network/api/verify_otp.dart';
import '../../../routes/app_routes.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../create_profile/controller/create_profile_controller.dart';

class VerifyNumberController extends GetxController {
  bool isKeyboardVisible = false;
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  late final ScrollController? scrollController;
  RxBool isSendingCode = true.obs;
  OtpModel? getOtp;
  RxBool showResendText = false.obs;

  // scroll to bottom of screen, when pin input field is in focus.
  Future<void> scrollToBottomOnKeyboardOpen() async {
    while (!isKeyboardVisible) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    await Future.delayed(const Duration(milliseconds: 250));

    await scrollController?.animateTo(
      scrollController!.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  RxString enteredOtpp = ''.obs;

  void showSnackBar(
    String text, {
    Duration duration = const Duration(seconds: 2),
  }) {
    scaffoldMessengerKey.currentState
      ?..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text(text), duration: duration),
      );
  }

  Future<void> verifyOtp(
    String otp,
    String number,
  ) async {
    try {
      getOtp = await Get.find<VerifyOtpApi>().verifyOtp(number, otp);

      _handleCreateLoginSuccess(getOtp!);
    } on Map catch (e) {
      print(e);
      rethrow;
    }
  }

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

  void _handleCreateLoginSuccess(OtpModel otpModel) {
    print(otpModel.response?.body?.roles?[0].name);
    storingAuthKey(
        otpModel.response?.body?.jwt ?? "",
        otpModel.response?.body?.userId ?? 0,
        otpModel.response?.body?.roles?[0].name ?? "");
    getPatientOrEmplyeeId(otpModel.response?.body?.roles?[0].name ?? "",
        otpModel.response?.body?.userId ?? 0, otpModel);
  }

  getPatientOrEmplyeeId(String role, int id, OtpModel model) async {
    if (role.toLowerCase() == "examiner" ||
        role.toLowerCase() == "receptionist" ||
        role.toLowerCase() == "admin" ||
        role.toLowerCase() == "doctor") {
      if (model.response?.body?.staff != null) {
        SharedPrefUtils.saveInt(
            'employee_Id', model.response?.body?.staff?.id ?? 0);
        // AppointmentDetails.staffId = _model.staff!.id ?? 0;
        Get.offAllNamed(AppRoutes.dashboardScreen);
      } else {
        Get.toNamed(AppRoutes.create_profile_screen,
            arguments: ScreenArguments(
                model.response?.body?.roles?[0].name ?? "",
                model.response?.body?.userId ?? 0,
                model.response?.body?.userName ?? ""));
      }
    } else {
      if (model.response?.body?.patient != null) {
        SharedPrefUtils.saveInt(
            'patient_Id', model.response?.body?.patient!.id ?? 0);
        //Get.offNamed(AppRoutes.homeContainerScreen);
        Get.offAllNamed(AppRoutes.dashboardScreen);
      } else {
        Get.back();
        Get.toNamed(AppRoutes.create_profile_screen,
            arguments: ScreenArguments(
                model.response?.body?.roles?[0].name ?? "",
                model.response?.body?.userId ?? 0,
                model.response?.body?.userName ?? ""));
      }
    }
  }

  void storingAuthKey(String key, int id, String role) {
    SharedPrefUtils.saveStr('auth_token', key);
    SharedPrefUtils.saveInt("user_Id", id);
    SharedPrefUtils.saveStr("role", role);
  }

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    final bottomViewInsets = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardVisible = bottomViewInsets > 0;
    Timer(const Duration(seconds: 2), () {
      showResendText.value = true;
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    scrollController?.dispose();
  }
}
