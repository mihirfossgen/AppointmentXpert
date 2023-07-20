import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/verify_otp_model.dart';
import '../../../network/api/verify_otp.dart';

class ResetPasswordPhoneController extends GetxController {
  TextEditingController mobileNoController = TextEditingController();

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

  @override
  void onClose() {
    super.onClose();
    mobileNoController.clear();
  }
}
