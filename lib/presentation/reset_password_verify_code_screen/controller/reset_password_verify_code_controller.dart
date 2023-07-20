import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter/material.dart';

import '../models/reset_password_verify_code_model.dart';

class ResetPasswordVerifyCodeController extends GetxController
    with CodeAutoFill {
  Rx<TextEditingController> otpController = TextEditingController().obs;

  Rx<ResetPasswordVerifyCodeModel> resetPasswordVerifyCodeModelObj =
      ResetPasswordVerifyCodeModel().obs;

  @override
  void codeUpdated() {
    otpController.value.text = code!;
  }

  @override
  void onInit() {
    super.onInit();
    listenForCode();
  }


}
