import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../network/api/user_api.dart';
import '../models/create_new_password_model.dart';

class CreateNewPasswordController extends GetxController {
  TextEditingController inputController = TextEditingController();

  TextEditingController inputOneController = TextEditingController();

  Rx<CreateNewPasswordModel> createNewPasswordModelObj =
      CreateNewPasswordModel().obs;

  Rx<bool> isShowPassword = true.obs;
  bool value = false;

  Future<bool> callForgotPassword(
      String? newPassword, String? confirmPassword, String? username) async {
    try {
      value = (await Get.find<UserApi>().callForgotPassword(
          headers: {
            'Content-type': 'application/json',
          },
          confirmPassword: confirmPassword,
          newPassword: newPassword,
          username: username));
      if (value) {
        return true;
      }
      return false;
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  @override
  void onClose() {
    super.onClose();
    inputController.clear();
    inputOneController.clear();
  }
}
