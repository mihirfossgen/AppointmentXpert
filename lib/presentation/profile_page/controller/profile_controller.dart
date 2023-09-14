import 'package:appointmentxpert/network/api/patient_api.dart';
import 'package:appointmentxpert/network/api/staff_api.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/patient_model.dart';
import '../../../models/staff_model.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';

class ProfileController extends GetxController {
  Rx<TextEditingController> from = TextEditingController().obs;
  Rx<TextEditingController> to = TextEditingController().obs;
  TextEditingController dob = TextEditingController();
  TextEditingController timeInterval = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxBool sentNotification = false.obs;
  Rx<StaffData> staffData = StaffData().obs;
  Rx<PatientData> patientData = PatientData().obs;
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

  bool trySubmit() {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();

    if (isValid) {
      formKey.currentState!.save();

      return true;
    }
    return false;
  }

  dateValidator(String value) {
    if (value == '') {
      return 'Please select date';
    } else {
      DateTime a = DateTime(int.parse(value.split('-')[2]),
          int.parse(value.split('-')[1]), int.parse(value.split('-')[0]));

      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      if (formatter.format(a) == formatter.format(DateTime.now())) {
        return null;
      }
      if (a.isBefore(DateTime.now())) {
        return 'Please select proper date to reschedule';
      }
    }
    return null;
  }

  getnotification() async {
    bool notificationflag =
        await SharedPrefUtils.readPrefBool('notificationFlag');
    if (notificationflag == true) {
      sentNotification.value = true;
    } else {
      sentNotification.value = false;
    }
  }

  timeIntervalValidator(String value) {
    if (value == '') {
      return 'Please enter time interval';
    } else {
      int a = int.tryParse(value) ?? 0;
      if (a < 0) {
        return 'Please enter valid time in minutes';
      }
    }
    return null;
  }

  Future<void> staffUpdate(Map<String, dynamic> req) async {
    try {
      bool a = await Get.find<StaffApi>().staffUpdate(req);
      timeInterval.text = '';
      Get.back();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => Get.snackbar(
          "Data Updated Successfully!!", '',
          snackPosition: SnackPosition.BOTTOM));
    } on Map catch (e) {
      rethrow;
    }
  }

  Future<void> staffnotificationUpdate(Map<String, dynamic> req) async {
    try {
      var response = await Get.find<StaffApi>().staffNotificationUpdate(req);
      staffData.value = response;
    } on Map catch (e) {
      rethrow;
    }
  }

  Future<void> patientnotificationUpdate(Map<String, dynamic> req) async {
    try {
      var response = await Get.find<PatientApi>().patientUpdate(req);
      patientData.value = response;
    } on Map catch (e) {
      rethrow;
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getnotification();
  }
}
