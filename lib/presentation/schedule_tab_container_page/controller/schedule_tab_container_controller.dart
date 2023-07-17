import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ScheduleTabContainerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController group125Controller =
      Get.put(TabController(vsync: this, length: 3));
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
