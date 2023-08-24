import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/getAllApointments.dart';
import '../../../network/api/appointment_api.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';

class RescheduleAppointmentController extends GetxController {
  TextEditingController reschduleDate = TextEditingController();
  RxString fromTime = ''.obs;
  RxString toTime = ''.obs;
  List<String>? times;
  RxString selectedStartTime = ''.obs;
  RxBool isLoading = false.obs;
  RxList<AppointmentContent> getAppointmentDetailsByDate =
      <AppointmentContent>[].obs;
  int? index;
  RxBool isRescheduleLoading = false.obs;
  bool value = false;
  getTimes(String? stime, String? etime, String? interval) {
    Duration spaceDuration = Duration(
        minutes: int.parse(interval!.split(':')[1]),
        hours: int.parse(interval.split(':')[0]));
    TimeOfDay start = TimeOfDay(
        hour: int.parse(stime!.split(':')[0]),
        minute: int.parse(stime.split(':')[1]));
    TimeOfDay close = TimeOfDay(
        hour: int.parse(etime!.split(':')[0]),
        minute: int.parse(etime.split(':')[1]));
    List<String> timeSlots = [];
    while (start.hour < close.hour ||
        (start.hour == close.hour && start.minute <= close.minute)) {
      final time =
          DateTime(0, 0, 0, start.hour, start.minute).add(spaceDuration);
      String date2 = DateFormat("hh:mm a").format(time);
      timeSlots.add(date2);

      start = TimeOfDay(hour: time.hour, minute: time.minute);
    }

    times = timeSlots;
  }

  // @override
  // void onClose() {
  //   // TODO: implement onClose
  //   super.onClose();

  // }

  @override
  void dispose() {
    selectedStartTime.value = '';
    isRescheduleLoading.value = false;
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit;
    selectedStartTime.value = '';
    isRescheduleLoading.value = false;
  }

  Future<List<AppointmentContent>> callGetAppointmentDetailsForDate(
      String date, int doctorsId) async {
    try {
      isLoading.value = true;
      var response = (await Get.find<AppointmentApi>()
          .getAppointmentDetailsViaDateForStaff(date, doctorsId));
      List<dynamic> data = response.data;
      List<AppointmentContent> list =
          data.map((e) => AppointmentContent.fromJson(e)).toList();
      getAppointmentDetailsByDate.value = list;
      return list;
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAppointment(var data) async {
    try {
      isRescheduleLoading.value = true;
      value = (await Get.find<AppointmentApi>().updateAppointment(data));
      // if (SharedPrefUtils.readPrefStr('role') != "PATIENT") {
      isRescheduleLoading.value = false;
      selectedStartTime.value = '';

      Get.back();
    }
    //   callGetAllAppointments(0, 1);
    // } else {
    //   callAppointmentsByPatientId(SharedPrefUtils.readPrefINt('patient_Id'));
    // }
    on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isRescheduleLoading.value = false;
      selectedStartTime.value = '';
    }
  }
}
