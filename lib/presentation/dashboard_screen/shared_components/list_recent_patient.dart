import 'package:appointmentxpert/presentation/dashboard_screen/controller/dashboard_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/image_constant.dart';
import '../../../models/patient_list_model.dart';
import '../../../network/endpoints.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/responsive.dart';
import '../../appointment_booking_screen/appointment_booking.dart';
import '../../patient_details_page/patient_details_page.dart';
import '../views/screens/dashboard_screen.dart';

class ListRecentPatientData {
  final int patientId;
  final Icon icon;
  final String name;
  final String age;
  final DateTime? dob;
  final String? diognosys;

  const ListRecentPatientData({
    required this.patientId,
    required this.icon,
    required this.name,
    required this.age,
    this.dob,
    this.diognosys,
  });
}

class ListRecentPatients extends StatelessWidget {
  ListRecentPatients({
    required this.data,
    required this.onPressed,
    // required this.onPressedAssign,
    // required this.onPressedMember,
    Key? key,
  }) : super(key: key);

  final Content data;
  final Function() onPressed;
  // final Function()? onPressedAssign;
  // final Function()? onPressedMember;

  getformattedDate(String date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(DateTime.parse(date));
  }

  DashboardController dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GFListTile(
        icon: const Icon(Icons.arrow_right),
        avatar: data.profilePicture != null
            ? CachedNetworkImage(
                width: 80,
                height: 80,
                fit: BoxFit.contain,
                imageUrl: Uri.encodeFull(
                  Endpoints.baseURL +
                      Endpoints.downLoadPatientPhoto +
                      data.profilePicture.toString(),
                ),
                httpHeaders: {
                  "Authorization":
                      "Bearer ${SharedPrefUtils.readPrefStr("auth_token")}"
                },
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) {
                  return CustomImageView(
                    imagePath: !Responsive.isDesktop(Get.context!)
                        ? 'assets' '/images/default_profile.png'
                        : '/images/default_profile.png',
                  );
                },
              )
            : CustomImageView(
                width: 60,
                height: 60,
                imagePath: !Responsive.isDesktop(Get.context!)
                    ? 'assets' '/images/default_profile.png'
                    : '/images/default_profile.png',
              ),
        //autofocus: true,
        color: Colors.white,
        description: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Email: ',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
                width: 180,
                child: Text(
                  data.email ?? 'N/A',
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                )),
            const SizedBox(
              height: 5,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Address: ',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${data.address}',
                style: const TextStyle(fontSize: 13, color: Colors.black),
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ]),
            const SizedBox(
              height: 5,
            ),
            Row(children: [
              const Text(
                'Date of birth: ',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${getformattedDate('${data.dob}')}',
                style: const TextStyle(fontSize: 13, color: Colors.black),
              ),
            ]),
          ],
        ),
        enabled: true,
        firstButtonTextStyle: const TextStyle(
            color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
        firstButtonTitle: 'View Details',
        secondButtonTitle: 'Book Appointment',
        secondButtonTextStyle: const TextStyle(
            color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
        onSecondButtonTap: () {
          Get.to(() => AppointmentBookingScreen(
              doctorsList: dashboardController.doctorsList,
              patientDetailsArguments: PatientDetailsArguments([], data)));
        },
        onFirstButtonTap: () {
          Get.to(() => (PatientDetailsPage(data)));
        },
        //focusColor: ,
        focusNode: FocusNode(),
        //hoverColor: Colors.blue,
        //icon: ,
        listItemTextColor: GFColors.DARK,
        //margin: getMarginOrPadding(all: 8.0),
        //onFirstButtonTap: ,
        //onLongPress: ,
        //onSecondButtonTap: ,
        onTap: () {},
        //padding: ,
        radius: 8,
        //secondButtonTextStyle: ,
        //secondButtonTitle: 'Delete',
        selected: false,
        //shadow: BoxShadow,
        //subTitleText: 'Address: ${data.address}',
        title: _buildTitle(),
        //titleText: '${data.firstName} ' + '${data.lastName}',
      ),
    );

    // ListTile(
    //   onTap: onPressed,
    //   hoverColor: Colors.transparent,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(kBorderRadius),
    //   ),
    //   leading: _buildIcon(),
    //   title: _buildTitle(),
    //   subtitle: _buildSubtitle(),
    //   trailing: _buildAssign(),
    // );
  }

  Widget loadListTile() {
    return ListTile(
      //isThreeLine: true,
      onTap: onPressed,
      hoverColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      leading: data.profilePicture != null
          ? CachedNetworkImage(
              fit: BoxFit.contain,
              imageUrl: Uri.encodeFull(
                Endpoints.baseURL +
                    Endpoints.downLoadPatientPhoto +
                    data.profilePicture.toString(),
              ),
              httpHeaders: {
                "Authorization":
                    "Bearer ${SharedPrefUtils.readPrefStr("auth_token")}"
              },
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) {
                return CustomImageView(
                  imagePath: !Responsive.isDesktop(Get.context!)
                      ? 'assets' '/images/default_profile.png'
                      : '/images/default_profile.png',
                );
              },
            )
          : CustomImageView(
              imagePath: !Responsive.isDesktop(Get.context!)
                  ? 'assets' '/images/default_profile.png'
                  : '/images/default_profile.png',
            ),
      //_buildIcon(),
      title: Text(
        '${data.prefix.toString()}'
        '${data.firstName} '
        '${data.lastName}',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      //_buildTitle(),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Text(
            'Email: ${data.email == '' ? 'N/A' : data.email}',
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Address: ${data.address}',
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Age: ${data.age}',
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),
        ],
      ),
      //_buildSubtitle(),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.calendar_month,
            size: 30,
            color: Colors.blue.shade600,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            dateFormatter(data.dob ?? ''),
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          // Text(
          //   data.dob ?? '',
          //   style: TextStyle(fontSize: 8, color: Colors.grey.shade600),
          // ),
          // Container(
          //   padding: EdgeInsets.all(15),
          //   decoration: AppDecoration.txtStyle.copyWith(
          //     borderRadius: BorderRadiusStyle.txtRoundedBorder8,
          //   ),
          //   child: Text(
          //     "lbl_reschedule".tr,
          //     overflow: TextOverflow.ellipsis,
          //     textAlign: TextAlign.center,
          //     style: AppStyle.txtRalewayRomanSemiBold14,
          //   ),
          // ),
        ],
      ),
      //_buildAssign(),
    );
  }

  String dateFormatter(String txt) {
    if (txt != '') {
      DateTime a = DateTime.parse(txt);
      final DateFormat formatter = DateFormat('dd/MMM/yyyy');
      return formatter.format(DateTime.parse(a.toString()));
    } else {
      return '';
    }
  }

  Widget _buildIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey.withOpacity(.1),
      ),
      child: CustomImageView(
        svgPath: ImageConstant.imageNotFound,
      ),
      //child: data.icon,
    );
  }

  Widget _buildTitle() {
    return Text(
      '${data.prefix.toString()}' '${data.firstName} ' '${data.lastName}',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle() {
    String edit = "";
    if (data.dob != null) {
      edit = data.dob ?? '';
    }
    return Text(
      data.address ?? edit,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildAssign() {
    return (data.bloodType != null)
        ? InkWell(
            //onTap: onPressedMember,
            borderRadius: BorderRadius.circular(22),
            child: Tooltip(
              message: data.bloodType!,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.orange.withOpacity(.2),
                child: const Text(
                  '5.5',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        : DottedBorder(
            color: kFontColorPallets[1],
            strokeWidth: .3,
            strokeCap: StrokeCap.round,
            borderType: BorderType.Circle,
            child: IconButton(
              onPressed: null,
              //onPressedAssign,
              color: kFontColorPallets[1],
              iconSize: 15,
              icon: const Icon(EvaIcons.plus),
              splashRadius: 24,
              tooltip: "assign",
            ),
          );
  }
}
