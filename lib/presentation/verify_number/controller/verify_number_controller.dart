import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/verify_otp_model.dart';
import '../../../network/api/verify_otp.dart';

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

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    final bottomViewInsets = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardVisible = bottomViewInsets > 0;
    Timer(Duration(seconds: 2), () {
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
