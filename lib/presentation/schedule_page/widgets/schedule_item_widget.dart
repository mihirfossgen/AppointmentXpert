import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../core/utils/color_constant.dart';
import '../../../models/getAllApointments.dart';
import '../../../network/endpoints.dart';
import '../../../routes/app_routes.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/app_style.dart';
import '../../../widgets/custom_image_view.dart';
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
      this.appointment, this.patientId, this.examninerId, this.tab);

  ScheduleController controller = ScheduleController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.appointmentDetailsPage,
            arguments: AppointmentDetailsArguments(appointment));
      },
      child: Container(
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
          Container(
            height: 80,
            width: 80,
            //decoration: BoxDecoration(
            //    color: Colors.black, borderRadius: BorderRadius.circular(12)),
            child: appointment.patient?.profilePicture != null
                ? CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: Uri.encodeFull(
                      Endpoints.baseURL +
                          Endpoints.downLoadPatientPhoto +
                          patientId.toString(),
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
                      print(error);
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
                        ? 'assets' + '/images/default_profile.png'
                        : '/images/default_profile.png',
                  ),
          ),
          SizedBox(
            width: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${appointment.examiner?.firstName.toString()} ${appointment.examiner?.lastName.toString()}',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    controller.getformattedDate(appointment.date.toString()) +
                        ' ' +
                        controller.getformattedtime(
                            appointment.date ?? "", Get.context!),
                    style: AppStyle.txtInterRegular14Gray700,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Appointment id - ${appointment.id}",
                    style: AppStyle.txtManrope12,
                  ),
                  SizedBox(
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
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Note: ' + appointment.note.toString(),
                    style: AppStyle.txtInterRegular14,
                  ),
                  SizedBox(
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
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: AppDecoration.txtFillGray10002.copyWith(
                    borderRadius: BorderRadiusStyle.txtRoundedBorder8,
                  ),
                  child: Text(
                    'Accecpt',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppStyle.txtRalewayRomanSemiBold14Gray700,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  // Call cancel appointment
                },
                child: Container(
                  padding: EdgeInsets.all(15),
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
                      // call cancel appointment
                      // var data = {
                      //   "active": false,
                      //   "id": appointment.id,
                      //   "date": appointment.date,
                      //   "examinerId": examninerId,
                      //   "note": appointment.note,
                      //   "patientId": patientId,
                      //   "purpose": appointment.purpose,
                      //   "status": "Cancel"
                      // };
                      // controller.updateAppointment(data);
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
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
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      // Call reschedule appointment
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
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
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      // Call generate precription
                      controller.callGeneratePrecription(patientId,
                          appointment.id!, appointment.examination?.id ?? 1);
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: AppDecoration.txtFillGray10002.copyWith(
                        borderRadius: BorderRadiusStyle.txtRoundedBorder8,
                      ),
                      child: Text(
                        'Precription PDF',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppStyle.txtRalewayRomanSemiBold14Gray700,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      // Get.to(CreateInvoiceScreen(
                      //   appointment: appointment,
                      // ));
                      // Generate invoice
                      //controller.callGenerateInvoice(
                      //    patientId, appointment.id!, 7, examninerId);
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: AppDecoration.txtStyle.copyWith(
                        borderRadius: BorderRadiusStyle.txtRoundedBorder8,
                      ),
                      child: Text(
                        'Invoice',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppStyle.txtRalewayRomanSemiBold14,
                      ),
                    ),
                  ),
                ],
              );
  }
}

class AppointmentDetailsArguments {
  AppointmentContent appointment;
  AppointmentDetailsArguments(this.appointment);
}
