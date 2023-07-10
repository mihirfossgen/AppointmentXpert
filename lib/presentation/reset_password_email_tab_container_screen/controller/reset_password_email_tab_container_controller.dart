import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/reset_password_email_tab_container_model.dart';

class ResetPasswordEmailTabContainerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Rx<ResetPasswordEmailTabContainerModel>
      resetPasswordEmailTabContainerModelObj =
      ResetPasswordEmailTabContainerModel().obs;

  late TabController tabController =
      Get.put(TabController(vsync: this, length: 2));

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
