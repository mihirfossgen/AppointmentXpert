import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/color_constant.dart';
import '../../../../core/utils/size_utils.dart';
import '../../../../core/utils/time_calculation_utils.dart';
import '../../../../models/getAllApointments.dart';
import '../../../../network/endpoints.dart';
import '../../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../../../theme/app_style.dart';
import '../../../../widgets/app_bar/appbar_subtitle_2.dart';
import '../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/responsive.dart';

class Completedappointments extends StatefulWidget {
  final List<AppointmentContent> completedAppointments;
  const Completedappointments({super.key, required this.completedAppointments});

  @override
  State<Completedappointments> createState() => _CompletedappointmentsState();
}

getformattedDate(String date) {
  final DateFormat formatter = DateFormat.yMMMEd();
  return formatter.format(DateTime.parse(date));
}

getformattedtime(String date, BuildContext context) {
  DateTime a = DateTime.parse(date);
  final time = TimeOfDay(hour: a.hour, minute: a.minute);
  return time.format(context);
}

class _CompletedappointmentsState extends State<Completedappointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: !Responsive.isDesktop(context)
            ? CustomAppBar(
                backgroundColor: ColorConstant.blue700,
                height: getVerticalSize(60),
                leadingWidth: 64,
                elevation: 0,
                leading: !Responsive.isDesktop(context)
                    ? IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ))
                    : null,
                centerTitle: true,
                title: AppbarSubtitle2(text: "Completed Appointments"))
            : null,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: widget.completedAppointments.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.grey.shade400,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          //decoration: BoxDecoration(
                          //    color: Colors.black, borderRadius: BorderRadius.circular(12)),
                          child: widget.completedAppointments[index].patient
                                      ?.profilePicture !=
                                  null
                              ? CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  imageUrl: Uri.encodeFull(
                                    SharedPrefUtils.readPrefStr('role') ==
                                            "PATIENT"
                                        ? Endpoints.baseURL +
                                            Endpoints.downLoadPatientPhoto +
                                            widget.completedAppointments[index]
                                                .examiner!.uploadedProfilePath
                                                .toString()
                                        : Endpoints.baseURL +
                                            Endpoints.downLoadEmployePhoto +
                                            widget.completedAppointments[index]
                                                .patient!.profilePicture
                                                .toString(),
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                                SharedPrefUtils.readPrefStr('role') == "PATIENT"
                                    ? Text(
                                        'Dr.'
                                        '${widget.completedAppointments[index].examiner?.firstName.toString()} ${widget.completedAppointments[index].examiner?.lastName.toString()}',
                                        style: AppStyle.txtInterSemiBold14,
                                      )
                                    : Text(
                                        '${widget.completedAppointments[index].patient?.prefix.toString()}'
                                        '${widget.completedAppointments[index].patient?.firstName.toString()} ${widget.completedAppointments[index].patient?.lastName.toString()}',
                                        style: AppStyle.txtInterSemiBold14,
                                      ),
                                SharedPrefUtils.readPrefStr('role') ==
                                            "RECEPTIONIST" ||
                                        SharedPrefUtils.readPrefStr('role') ==
                                            "ASSISTANT"
                                    ? Column(
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Dr.'
                                            '${widget.completedAppointments[index].examiner?.firstName.toString()} ${widget.completedAppointments[index].examiner?.lastName.toString()}',
                                            style: AppStyle.txtInterSemiBold14,
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${getformattedDate(widget.completedAppointments[index].date.toString())} ${widget.completedAppointments[index].updateTimeInMin == 0 ? getformattedtime(widget.completedAppointments[index].date ?? "", Get.context!).replaceAll(' AM', ' PM') : TimeCalculationUtils().startTimeCalCulation(widget.completedAppointments[index].startTime, widget.completedAppointments[index].updateTimeInMin)}",
                                  style: AppStyle.txtInterRegular14Gray700,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Status - ${widget.completedAppointments[index].status}",
                                  style: AppStyle.txtManrope12,
                                ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // Text(
                                //   appointment.department?.name ?? "",
                                //   style: AppStyle.txtManrope12,
                                // ),
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
                                SizedBox(
                                  width: 220,
                                  child: Text(
                                    'Note: ${widget.completedAppointments[index].note}',
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyle.txtInterRegular14,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            // SizedBox(width: 50),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
