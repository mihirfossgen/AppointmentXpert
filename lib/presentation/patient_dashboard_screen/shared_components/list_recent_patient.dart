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

class ListRecentPatientData {
  final Icon icon;
  final String name;
  final String age;
  final DateTime? dob;
  final String? diognosys;

  const ListRecentPatientData({
    required this.icon,
    required this.name,
    required this.age,
    this.dob,
    this.diognosys,
  });
}

class ListRecentPatients extends StatelessWidget {
  const ListRecentPatients({
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GFListTile(
        icon: Icon(Icons.arrow_right),
        avatar: data.profilePicture != null
            ? CachedNetworkImage(
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                imageUrl: Uri.encodeFull(
                  Endpoints.baseURL +
                      Endpoints.downLoadPatientPhoto +
                      data.id.toString(),
                ),
                httpHeaders: {
                  "Authorization":
                      "Bearer ${SharedPrefUtils.readPrefStr("auth_token")}"
                },
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) {
                  print(error);
                  return CustomImageView(
                    imagePath: !Responsive.isDesktop(Get.context!)
                        ? 'assets' + '/images/default_profile.png'
                        : '/images/default_profile.png',
                  );
                },
              )
            : CustomImageView(
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
            SizedBox(
              height: 5,
            ),
            Text(
              'Email: ${data.email.toString()}',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Address: ${data.address}',
              style: TextStyle(fontSize: 13, color: Colors.black),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Age: ${data.age}',
              style: TextStyle(fontSize: 13, color: Colors.black),
            ),
          ],
        ),
        enabled: true,
        //firstButtonTextStyle: ,
        firstButtonTitle: 'View Details',
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
      leading: data.profilePicture != null
          ? CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: Uri.encodeFull(
                Endpoints.baseURL +
                    Endpoints.downLoadPatientPhoto +
                    data.id.toString(),
              ),
              httpHeaders: {
                "Authorization":
                    "Bearer ${SharedPrefUtils.readPrefStr("auth_token")}"
              },
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) {
                print(error);
                return CustomImageView(
                  imagePath: !Responsive.isDesktop(Get.context!)
                      ? 'assets' + '/images/default_profile.png'
                      : '/images/default_profile.png',
                );
              },
            )
          : CustomImageView(
              imagePath: !Responsive.isDesktop(Get.context!)
                  ? 'assets' + '/images/default_profile.png'
                  : '/images/default_profile.png',
            ),
      //_buildIcon(),
      title: Text(
        '${data.firstName} ' + '${data.lastName}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      //_buildTitle(),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Text(
            'Email: ${data.email.toString()}',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Address: ${data.address}',
            style: TextStyle(fontSize: 13, color: Colors.black),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Age: ${data.age}',
            style: TextStyle(fontSize: 13, color: Colors.black),
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
          SizedBox(
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
      '${data.firstName} ' + '${data.lastName}',
      style: const TextStyle(fontWeight: FontWeight.bold),
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
      data.address ?? '' + edit,
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
