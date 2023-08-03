import 'package:appointmentxpert/network/api/staff_api.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Rx<TextEditingController> from = TextEditingController().obs;
  Rx<TextEditingController> to = TextEditingController().obs;
  TextEditingController dob = TextEditingController();
  TextEditingController timeInterval = TextEditingController();

  getDate() {
    DateTime? date = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    return Get.dialog(
        AlertDialog(
          title: const Text('Please select'),
          content: SizedBox(
            height: 250,
            width: 100,
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(),
              value: [DateTime.now()],
              onValueChanged: (value) {
                date = value[0];
              },
            ),
          ),
          actions: [
            TextButton(
                child: const Text("Continue"),
                onPressed: () {
                  Get.back(result: date);
                }),
          ],
        ),
        barrierDismissible: false);
  }

  Future<void> staffUpdate(Map<String, dynamic> req) async {
    try {
      bool a = await Get.find<StaffApi>().staffUpdate(req);
      Get.back();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => Get.snackbar(
          "Data Updated Successfully!!", '',
          snackPosition: SnackPosition.BOTTOM));
    } on Map catch (e) {
      print(e);
      rethrow;
    }
  }
}
