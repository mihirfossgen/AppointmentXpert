import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/reset_password_email_model.dart';

class ResetPasswordEmailController extends GetxController {
  ResetPasswordEmailController(this.resetPasswordEmailModelObj);

  TextEditingController emailController = TextEditingController();

  Rx<ResetPasswordEmailModel> resetPasswordEmailModelObj;

  @override
  void onClose() {
    super.onClose();
    emailController.clear();
  }
}
