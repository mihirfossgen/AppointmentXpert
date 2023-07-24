import 'dart:convert';

import 'package:appointmentxpert/core/utils/time_calculation_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/app_export.dart';
import '../../../core/utils/color_constant.dart';
import '../../../core/utils/size_utils.dart';
import '../../../models/getAllApointments.dart';
import '../../../network/endpoints.dart';
import '../../../routes/app_routes.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/app_style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/responsive.dart';
import '../controller/schedule_controller.dart';

// ignore: must_be_immutable
class ScheduleItemWidget extends StatelessWidget {
  AppointmentContent appointment;
  int patientId;
  int examninerId;
  String tab;
  //Datum? model2;

  ScheduleItemWidget(
      this.appointment, this.patientId, this.examninerId, this.tab,
      {super.key});

  ScheduleController controller = ScheduleController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.appointmentDetailsPage,
            arguments: AppointmentDetailsArguments(appointment));
      },
      child: SizedBox(
        child: Card(
          elevation: 4,
          color: ColorConstant.whiteA700,
          child: InkWell(
            child: loadCard(),
            onTap: () {
              // Navigator.push(
              //     Get.context!,
              //     MaterialPageRoute(
              //         builder: (context) => AppointmentDetailsPage(
              //               appointment: appointment,
              //               appointmentid: appointment.id!,
              //             )));
            },
          ),
        ),
      ),
    );
  }

  Widget loadCard() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
            width: 80,
            //decoration: BoxDecoration(
            //    color: Colors.black, borderRadius: BorderRadius.circular(12)),
            child: appointment.patient?.profilePicture != null
                ? CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: Uri.encodeFull(
                      Endpoints.baseURL +
                          Endpoints.downLoadPatientPhoto +
                          appointment.patient!.profilePicture.toString(),
                    ),
                    httpHeaders: {
                      "Authorization":
                          "Bearer ${SharedPrefUtils.readPrefStr("auth_token")}"
                    },
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) {
                      return Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                      );
                    },
                  )
                : CustomImageView(
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    imagePath: !Responsive.isDesktop(Get.context!)
                        ? 'assets' '/images/default_profile.png'
                        : '/images/default_profile.png',
                  ),
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${appointment.patient?.prefix.toString()}'
                    '${appointment.patient?.firstName.toString()} ${appointment.patient?.lastName.toString()}',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    " ${controller.getformattedDate(appointment.date.toString())} ${appointment.updateTimeInMin == 0 ? controller.getformattedtime(appointment.date ?? "", Get.context!).replaceAll(' AM', ' PM') : TimeCalculationUtils().startTimeCalCulation(appointment.startTime, appointment.updateTimeInMin)}",
                    style: AppStyle.txtInterRegular14Gray700,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Appointment id - ${appointment.id}",
                    style: AppStyle.txtManrope12,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    appointment.department?.name ?? "",
                    style: AppStyle.txtManrope12,
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Text(
                  //   appointment.purpose ?? 'N/A',
                  //   style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  // ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Note: ${appointment.note}',
                    style: AppStyle.txtInterRegular14,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  loadActionButtons(),
                ],
              ),
              // SizedBox(width: 50),
            ],
          ),
        ],
      ),
    );
  }

  Widget loadActionButtons() {
    return tab.toLowerCase() == 'today'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  // Call accept appointment
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    showDialog(
                      context: Get.context!,
                      builder: (context) => AlertDialog(
                        title: const Text(
                            'Are you sure appointment is completed?'),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  var data = {
                                    "active": false,
                                    "id": appointment.id,
                                    "date": appointment.date,
                                    "examinerId": appointment.examiner!.id,
                                    "note": appointment.note,
                                    "patientId": patientId,
                                    "purpose": appointment.purpose,
                                    "status": "Completed"
                                  };
                                  controller.updateAppointment(data);
                                },
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: ColorConstant.blue700,
                                      borderRadius: BorderRadius.circular(10)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Yes',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: AppStyle
                                        .txtRalewayRomanRegular14WhiteA700,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: ColorConstant.blue700,
                                      borderRadius: BorderRadius.circular(10)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'No',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: AppStyle
                                        .txtRalewayRomanRegular14WhiteA700,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: AppDecoration.txtFillGray10002.copyWith(
                    borderRadius: BorderRadiusStyle.txtRoundedBorder8,
                  ),
                  child: Text(
                    'Complete',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppStyle.txtRalewayRomanSemiBold14Gray700,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  // Call cancel appointment
                  var data = {
                    "active": false,
                    "id": appointment.id,
                    "date": appointment.date,
                    "examinerId": appointment.examiner!.id,
                    "note": appointment.note,
                    "patientId": patientId,
                    "purpose": appointment.purpose,
                    "status": "Canceled"
                  };
                  controller.updateAppointment(data);
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: AppDecoration.txtStyle.copyWith(
                    borderRadius: BorderRadiusStyle.txtRoundedBorder8,
                  ),
                  child: Text(
                    'Cancel',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppStyle.txtRalewayRomanSemiBold14,
                  ),
                ),
              ),
            ],
          )
        : tab.toLowerCase() == 'upcoming'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        showDialog(
                          context: Get.context!,
                          builder: (context) => AlertDialog(
                            title: const Text(
                                'Are you sure to cancel appointment?'),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // call cancel appointment
                                      var data = {
                                        "active": false,
                                        "id": appointment.id,
                                        "date": appointment.date,
                                        "examinerId": appointment.examiner!.id,
                                        "note": appointment.note,
                                        "patientId": patientId,
                                        "purpose": appointment.purpose,
                                        "status": "Canceled"
                                      };
                                      controller.updateAppointment(data);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: ColorConstant.blue700,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Yes',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: AppStyle
                                            .txtRalewayRomanRegular14WhiteA700,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: ColorConstant.blue700,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'No',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: AppStyle
                                            .txtRalewayRomanRegular14WhiteA700,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: AppDecoration.txtFillGray10002.copyWith(
                        borderRadius: BorderRadiusStyle.txtRoundedBorder8,
                      ),
                      child: Text(
                        'Cancel',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppStyle.txtRalewayRomanSemiBold14Gray700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      // Call reschedule appointment
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        showDialog(
                          context: Get.context!,
                          builder: (context) => AlertDialog(
                            title: const Text('Reschdule Appointment'),
                            actions: [
                              Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 0, 15, 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            child: InkWell(
                                              onTap: () async {
                                                DateTime a = await controller
                                                    .getRescheduleDate();

                                                final DateFormat formatter =
                                                    DateFormat('yyyy-MM-dd');
                                                controller.dob.text =
                                                    formatter.format(a);
                                              },
                                              child: AbsorbPointer(
                                                child: CustomTextFormField(
                                                    controller: controller.dob,
                                                    labelText: "Date",
                                                    size: size,
                                                    padding:
                                                        TextFormFieldPadding
                                                            .PaddingT14,
                                                    textInputType: TextInputType
                                                        .emailAddress,
                                                    suffix: Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 10),
                                                        child: const Icon(Icons
                                                            .calendar_month)),
                                                    suffixConstraints:
                                                        BoxConstraints(
                                                            maxHeight:
                                                                getVerticalSize(
                                                                    56))),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.02,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              controller
                                                  .selectTime(Get.context!);
                                            },
                                            child: AbsorbPointer(
                                              child: CustomTextFormField(
                                                  labelText: "From",
                                                  controller: controller
                                                      .from.value,
                                                  padding: TextFormFieldPadding
                                                      .PaddingT14,
                                                  textInputType: TextInputType
                                                      .emailAddress,
                                                  suffix: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child:
                                                        const Icon(Icons.alarm),
                                                  ),
                                                  suffixConstraints:
                                                      BoxConstraints(
                                                          maxHeight:
                                                              getVerticalSize(
                                                                  56))),
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.02,
                                          ),
                                          AbsorbPointer(
                                            child: CustomTextFormField(
                                                controller: controller.to,
                                                labelText: "To",
                                                padding: TextFormFieldPadding
                                                    .PaddingT14,
                                                textInputType: TextInputType
                                                    .datetime,
                                                suffix: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child:
                                                      const Icon(Icons.alarm),
                                                ),
                                                suffixConstraints:
                                                    BoxConstraints(
                                                        maxHeight:
                                                            getVerticalSize(
                                                                56))),
                                          ),
                                        ],
                                      )),
                                  Align(
                                    alignment: Alignment.center,
                                    child: CustomButton(
                                        height: getVerticalSize(56),
                                        width: getHorizontalSize(110),
                                        text: "Rechsdule Appointment",
                                        shape: ButtonShape.RoundedBorder8,
                                        padding: ButtonPadding.PaddingAll16,
                                        fontStyle: ButtonFontStyle
                                            .RalewayRomanSemiBold14WhiteA700,
                                        onTap: () async {
                                          var requestData = {
                                            "active": true,
                                            "date": DateTime.parse(
                                                    "${controller.dob.text} ${controller.from.value.text.replaceAll(" PM", "").replaceAll(" AM", "")}")
                                                .toIso8601String(),
                                            "startTime":
                                                controller.from.value.text,
                                            "endTime": controller.to.value.text,
                                            "examinerId":
                                                appointment.examiner!.id,
                                            "note": appointment.note,
                                            "id": appointment.id,
                                            "patientId":
                                                appointment.patient?.id,
                                            "purpose": "CHECKUP",
                                            "status": "Reschduled",
                                            "update_time_in_min": 0
                                          };
                                          print(jsonEncode(requestData));
                                          controller
                                              .updateAppointment(requestData);
                                        }),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: AppDecoration.txtStyle.copyWith(
                        borderRadius: BorderRadiusStyle.txtRoundedBorder8,
                      ),
                      child: Text(
                        'Reschedule',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppStyle.txtRalewayRomanSemiBold14,
                      ),
                    ),
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // InkWell(
                  //   onTap: () {
                  //     // Call generate precription
                  //     controller.callGeneratePrecription(patientId,
                  //         appointment.id!, appointment.examination?.id ?? 1);
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.all(15),
                  //     decoration: AppDecoration.txtFillGray10002.copyWith(
                  //       borderRadius: BorderRadiusStyle.txtRoundedBorder8,
                  //     ),
                  //     child: Text(
                  //       'Precription PDF',
                  //       overflow: TextOverflow.ellipsis,
                  //       textAlign: TextAlign.center,
                  //       style: AppStyle.txtRalewayRomanSemiBold14Gray700,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // Get.to(CreateInvoiceScreen(
                  //     //   appointment: appointment,
                  //     // ));
                  //     // Generate invoice
                  //     //controller.callGenerateInvoice(
                  //     //    patientId, appointment.id!, 7, examninerId);
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.all(15),
                  //     decoration: AppDecoration.txtStyle.copyWith(
                  //       borderRadius: BorderRadiusStyle.txtRoundedBorder8,
                  //     ),
                  //     child: Text(
                  //       'Invoice',
                  //       overflow: TextOverflow.ellipsis,
                  //       textAlign: TextAlign.center,
                  //       style: AppStyle.txtRalewayRomanSemiBold14,
                  //     ),
                  //   ),
                  // ),
                ],
              );
  }

  void refreshPage() {
    controller.isloading.value = true;
    controller.callGetAllAppointments(0, 20);
    Future.sync(() => tab.toLowerCase() == 'today'
        ? controller.todayPagingController.refresh()
        : tab.toLowerCase() == 'upcoming'
            ? controller.upcomingPagingController.refresh()
            : controller.completedPagingController.refresh());
  }
}

class AppointmentDetailsArguments {
  AppointmentContent appointment;
  AppointmentDetailsArguments(this.appointment);
}
