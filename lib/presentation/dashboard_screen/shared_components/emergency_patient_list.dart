import 'package:appointmentxpert/models/emergency_patient_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/image_constant.dart';
import '../../../network/endpoints.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/responsive.dart';
import '../../appointment_booking_screen/appointment_booking.dart';
import '../views/screens/dashboard_screen.dart';

class ListEmergencyPatientData {
  final String patientName;
  final String mobileNumber;
  final String emailId;
  final String date;
  final String patientType;

  ListEmergencyPatientData(
    this.patientName,
    this.mobileNumber,
    this.emailId,
    this.date,
    this.patientType,
  );

}

class ListEmergencyPatients extends StatelessWidget {
  const ListEmergencyPatients({
    required this.data,
    required this.onPressed,
    // required this.onPressedAssign,
    // required this.onPressedMember,
    Key? key,
  }) : super(key: key);

  final EmergencyContent data;
  final Function() onPressed;
  // final Function()? onPressedAssign;
  // final Function()? onPressedMember;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GFListTile(
        icon: const Icon(Icons.arrow_right),
        avatar: CustomImageView(
          width: 80,
          height: 80,
          imagePath: !Responsive.isDesktop(Get.context!)
              ? 'assets' + '/images/default_profile.png'
              : '/images/default_profile.png',
        ),
        //autofocus: true,
        color: Colors.white,
        description: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Text(
              'Email: ${data.emailId.toString()}',
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Mobile no.: ${data.mobileNumber}',
              style: const TextStyle(fontSize: 13, color: Colors.black),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Date: ${data.date}',
              style: const TextStyle(fontSize: 13, color: Colors.black),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Patient Type: ${data.patientType}',
              style: const TextStyle(fontSize: 13, color: Colors.black),
            ),
          ],
        ),
        enabled: true,
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
        radius: 2,
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
      leading: CustomImageView(
        imagePath: !Responsive.isDesktop(Get.context!)
            ? 'assets' + '/images/default_profile.png'
            : '/images/default_profile.png',
      ),
      //_buildIcon(),
      title: Text(
        '${data.patientName}',
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
            'Email: ${data.emailId.toString()}',
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Mobile No.: ${data.mobileNumber}',
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Date: ${data.date}',
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),const SizedBox(
            height: 5,
          ),
          Text(
            'Patient Type: ${data.patientType}',
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
      '${data.patientName}',
      style: const TextStyle(fontWeight: FontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

}
