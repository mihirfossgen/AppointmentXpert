import 'dart:convert';

import 'package:appointmentxpert/core/app_export.dart';
import 'package:appointmentxpert/presentation/schedule_page/controller/schedule_controller.dart';
import 'package:appointmentxpert/widgets/loader.dart';
import 'package:appointmentxpert/widgets/responsive.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/color_constant.dart';
import '../../../core/utils/size_utils.dart';
import '../../../core/utils/time_calculation_utils.dart';
import '../../../models/getAllApointments.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../../widgets/custom_button.dart';
import '../controller/reschedule_appointment_controller.dart';
import '/widgets/app_bar/appbar_subtitle_2.dart';
import '/widgets/app_bar/custom_app_bar.dart';

class ReschduleAppointment extends GetWidget<RescheduleAppointmentController> {
  final AppointmentContent? appointment;
  final String? appointmentTime;
  ReschduleAppointment({super.key, this.appointment, this.appointmentTime});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 500,
        width: 800,
        child: WillPopScope(
          onWillPop: () async {
            controller.selectedStartTime.value = '';
            controller.isRescheduleLoading.value = false;
            Get.back();
            return false;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: ColorConstant.whiteA700,
            appBar: !Responsive.isDesktop(context)
                ? CustomAppBar(
                    height: getVerticalSize(40),
                    leadingWidth: 64,
                    elevation: 0,
                    backgroundColor: ColorConstant.blue700,
                    leading: !Responsive.isDesktop(context)
                        ? InkWell(
                            onTap: () {
                              controller.selectedStartTime.value = '';
                              controller.isRescheduleLoading.value = false;
                              Get.back();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          )
                        // AppbarImage(
                        //     height: getSize(40),
                        //     width: getSize(40),
                        //     backgroundColor: Colors.white,
                        //     svgPath: ImageConstant.imgArrowleft,
                        //     margin: getMargin(left: 24),
                        //     onTap: () {
                        //       onTapArrowleft1();
                        //     })
                        : null,
                    centerTitle: true,
                    title: AppbarSubtitle2(text: 'Reschedule Calendar'))
                : null,
            //key: controller.scaffoldMessengerKey,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: CalendarTimeline(
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 360)),
                      onDateSelected: (date) {
                        final DateFormat formatter = DateFormat('dd-MM-yyyy');
                        final DateFormat format = DateFormat('yyyy-MM-dd');
                        controller.reschduleDate.value = format.format(date);
                        controller.callGetAppointmentDetailsForDate(
                            formatter.format(date),
                            appointment?.examiner?.id ?? 0);
                        controller.getAppointmentDetailsByDate.value = [];

                        controller.fromTime.value = '';
                        controller.toTime.value = '';
                        controller.selectedStartTime.value = '';
                        controller.getAppointmentDetailsByDate.refresh();
                      },
                      monthColor: Colors.blueGrey,
                      dayColor: Colors.black,
                      activeDayColor: Colors.white,
                      activeBackgroundDayColor: ColorConstant.blue60001,
                      dotsColor: Colors.white,
                      locale: 'en_ISO',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => controller.isLoading.value
                      ? const SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : controller.getAppointmentDetailsByDate == []
                          ? const SizedBox(
                              height: 100,
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: Wrap(
                                  runSpacing: getVerticalSize(3),
                                  spacing: getHorizontalSize(3),
                                  children: List.generate(
                                      controller.times?.length ?? 0, (index) {
                                    return InkWell(
                                      onTap: () {
                                        if (controller
                                                .getAppointmentDetailsByDate
                                                .firstWhereOrNull((element) {
                                              return TimeCalculationUtils()
                                                      .startTimeCalCulation(
                                                          element.startTime,
                                                          element
                                                              .updateTimeInMin) ==
                                                  controller.times![index];
                                            }) !=
                                            null) {
                                          controller.selectedStartTime.value =
                                              "";
                                          // WidgetsBinding.instance
                                          //     .addPostFrameCallback((timeStamp) {
                                          //   showDialog(
                                          //     context: Get.context!,
                                          //     builder: (context) => AlertDialog(
                                          //       title: const Text(
                                          //           'Appointment for the selected time is already booked. Please select other time.'),
                                          //       actions: [
                                          //         Row(
                                          //           mainAxisAlignment:
                                          //               MainAxisAlignment.end,
                                          //           children: [
                                          //             CustomButton(
                                          //                 height: getVerticalSize(60),
                                          //                 width:
                                          //                     getHorizontalSize(80),
                                          //                 text: 'Close',
                                          //                 margin: getMargin(
                                          //                     left: 0, right: 10),
                                          //                 fontStyle: ButtonFontStyle
                                          //                     .RalewayRomanSemiBold14WhiteA700,
                                          //                 onTap: () async {
                                          //                   Get.back();
                                          //                 })
                                          //           ],
                                          //         )
                                          //       ],
                                          //     ),
                                          //   );
                                          // });
                                        } else {
                                          controller.selectedStartTime.value =
                                              controller.times?[index] ?? "";
                                          controller.index = index;
                                          int intervalTime = 15;

                                          TimeOfDay newSelectedTime = TimeOfDay(
                                              hour: int.parse(controller
                                                  .selectedStartTime.value
                                                  .split(":")[0]),
                                              minute: int.parse(controller
                                                  .selectedStartTime.value
                                                  .split(":")[1]
                                                  .replaceAll(' AM', '')
                                                  .replaceAll(' PM', '')));

                                          controller
                                              .fromTime.value = formatDate(
                                                  DateTime(
                                                      DateTime.now().year,
                                                      DateTime.now().month,
                                                      DateTime.now().day,
                                                      newSelectedTime.hour,
                                                      newSelectedTime.minute),
                                                  [hh, ':', nn, " ", am])
                                              .toString()
                                              .replaceAll(' AM', ' PM');
                                          controller.toTime.value = formatDate(
                                                  DateTime(
                                                      DateTime.now().year,
                                                      DateTime.now().month,
                                                      DateTime.now().day,
                                                      newSelectedTime.hour,
                                                      newSelectedTime.minute +
                                                          intervalTime),
                                                  [hh, ':', nn, " ", am])
                                              .toString()
                                              .replaceAll(' AM', ' PM');
                                        }

                                        print(controller.fromTime.value);
                                        print(controller.toTime.value);
                                      },
                                      child: Container(
                                          height: 40,
                                          width: 80,
                                          margin: const EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: controller
                                                          .getAppointmentDetailsByDate
                                                          .firstWhereOrNull(
                                                              (element) {
                                                        return TimeCalculationUtils()
                                                                .startTimeCalCulation(
                                                                    element
                                                                        .startTime,
                                                                    element
                                                                        .updateTimeInMin) ==
                                                            controller
                                                                .times![index];
                                                      }) !=
                                                      null
                                                  ? Colors.blue
                                                  : controller.times![index] ==
                                                          controller
                                                              .selectedStartTime
                                                              .value
                                                      ? Colors.green
                                                      : Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  color: controller
                                                              .getAppointmentDetailsByDate
                                                              .firstWhereOrNull(
                                                                  (element) {
                                                            return TimeCalculationUtils()
                                                                    .startTimeCalCulation(
                                                                        element
                                                                            .startTime,
                                                                        element
                                                                            .updateTimeInMin) ==
                                                                controller
                                                                        .times![
                                                                    index];
                                                          }) !=
                                                          null
                                                      ? Colors.transparent
                                                      : controller.times![
                                                                  index] ==
                                                              controller
                                                                  .selectedStartTime
                                                                  .value
                                                          ? Colors.green
                                                          : Colors.black)),
                                          child: Text(
                                            controller.times?[index] ?? "",
                                            style: TextStyle(
                                                color: controller
                                                            .getAppointmentDetailsByDate
                                                            .firstWhereOrNull(
                                                                (element) {
                                                          return TimeCalculationUtils()
                                                                  .startTimeCalCulation(
                                                                      element
                                                                          .startTime,
                                                                      element
                                                                          .updateTimeInMin) ==
                                                              controller.times![
                                                                  index];
                                                        }) !=
                                                        null
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                    );
                                  })),
                            )),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => controller.selectedStartTime.value == ''
                      ? CustomButton(
                          height: getVerticalSize(55),
                          text: "Reschedule Appointment",
                          margin: getMargin(left: 11, right: 11),
                          variant: ButtonVariant.FillGrey,
                          fontStyle:
                              ButtonFontStyle.RalewayRomanSemiBold14WhiteA700,
                        )
                      : controller.isRescheduleLoading.value
                          ? SizedBox(
                              height: 60,
                              child: ThreeDotLoader(),
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: CustomButton(
                                  height: getVerticalSize(55),
                                  margin: getMargin(left: 11, right: 11),
                                  //width: getHorizontalSize(110),
                                  text: "Reschedule Appointment",
                                  shape: ButtonShape.RoundedBorder8,
                                  padding: ButtonPadding.PaddingAll16,
                                  fontStyle: ButtonFontStyle
                                      .RalewayRomanSemiBold14WhiteA700,
                                  onTap: () async {
                                    if (appointment?.examiner != null) {
                                      print(controller.fromTime.value);
                                      DateTime date2 = DateFormat("hh:mm a")
                                          .parse(controller.fromTime.value);

                                      DateTime userdate = DateTime.parse(
                                          controller.reschduleDate.value);
                                      DateTime a = DateTime(
                                          userdate.year,
                                          userdate.month,
                                          userdate.day,
                                          date2.hour,
                                          date2.minute);

                                      print(a);
                                      print(DateTime.now());
                                      print(a.isAfter(DateTime.now()));

                                      if (a.isAfter(DateTime.now())) {
                                        var requestData = {
                                          "active": true,
                                          "date": DateTime.parse(
                                                  "${controller.reschduleDate.value} ${controller.fromTime.value.replaceAll(" PM", "").replaceAll(" AM", "")}")
                                              .toIso8601String(),
                                          "startTime":
                                              controller.fromTime.value,
                                          "endTime": controller.toTime.value,
                                          "examinerId":
                                              appointment?.examiner!.id,
                                          "note": appointment?.note,
                                          "id": appointment?.id,
                                          "patientId": appointment?.patient?.id,
                                          "updateBy":
                                              SharedPrefUtils.readPrefStr(
                                                          'role') !=
                                                      "PATIENT"
                                                  ? appointment?.examiner?.id
                                                      .toString()
                                                  : appointment?.patient?.id
                                                      .toString(),
                                          "purpose": "CHECKUP",
                                          "status": "Reschduled",
                                          "update_time_in_min": 0
                                        };
                                        print(jsonEncode(requestData));
                                        controller
                                            .updateAppointment(requestData);
                                      } else {
                                        controller.isRescheduleLoading.value =
                                            false;
                                        Get.back();
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((timeStamp) =>
                                                Get.snackbar(
                                                    "Appointment for the selected time has passed.",
                                                    '',
                                                    snackPosition:
                                                        SnackPosition.BOTTOM));
                                      }
                                    } else {
                                      controller.isRescheduleLoading.value =
                                          false;

                                      Get.back();
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((timeStamp) =>
                                              Get.snackbar(
                                                "Doctor assigned to this appointment is not active",
                                                '',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                duration:
                                                    const Duration(seconds: 5),
                                                borderRadius: 15,
                                                icon: Icon(
                                                  Icons.error_outline,
                                                  color:
                                                      ColorConstant.whiteA700,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(15),
                                                margin:
                                                    const EdgeInsets.all(40),
                                                colorText:
                                                    ColorConstant.whiteA700,
                                                backgroundColor:
                                                    ColorConstant.blue700,
                                              ));
                                    }
                                  }),
                            ))
                ],
              ),
            ),
          ),
        ));
  }
}
