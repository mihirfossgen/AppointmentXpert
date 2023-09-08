import 'dart:convert';

import 'package:appointmentxpert/core/utils/color_constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/utils/size_utils.dart';
import '../../models/patient_model.dart';
import '../../models/staff_model.dart';
import '../../network/endpoints.dart';
import '../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../theme/app_style.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/responsive.dart';
import '../log_out_pop_up_dialog/controller/log_out_pop_up_controller.dart';
import '../log_out_pop_up_dialog/log_out_pop_up_dialog.dart';
import 'controller/profile_controller.dart';

class ProfilePage extends GetWidget<ProfileController> {
  StaffData? staffData;
  PatientData? patientData;
  ProfilePage(this.staffData, this.patientData, {super.key});

  @override
  ProfileController controller = Get.put(ProfileController());

  Widget doctorProfile() {
    return SizedBox(
      child: ListView.builder(
          itemCount: 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return doctorCard(
                id: staffData?.id,
                userid: staffData?.userId,
                firstName: staffData?.firstName,
                lastName: staffData?.lastName,
                prefix: staffData?.prefix,
                specialty: staffData?.profession,
                imagePath: staffData?.profilePicture,
                rank: 5,
                medicalEducation: staffData?.qualification,
                residency: staffData?.departmentName,
                internship: staffData?.clinicName,
                fellowship: staffData?.employment,
                address: staffData?.address,
                profile: staffData?.profilePicture,
                startTime: staffData?.startTime,
                endTime: staffData?.endTime,
                notificationFlag: staffData?.notificationFlag);
          }),
    );
  }

  Widget patientProfile() {
    return SizedBox(
      child: ListView.builder(
          itemCount: 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return patientCard(
                id: patientData?.patient?.id,
                userId: patientData?.patient?.userId,
                firstName: patientData?.patient?.firstName,
                lastName: patientData?.patient?.lastName,
                prefix: patientData?.patient?.prefix ?? '',
                imagePath: patientData?.patient?.profilePicture,
                address: patientData?.patient?.address,
                age: patientData?.patient?.age.toString(),
                email: patientData?.patient?.email,
                mobile: patientData?.patient?.mobile,
                profile: patientData?.patient?.profilePicture);
          }),
    );
  }

  Widget doctorCard(
      {int? id,
      int? userid,
      String? firstName,
      String? lastName,
      String? prefix,
      String? specialty,
      String? imagePath,
      double? rank,
      String? medicalEducation,
      String? residency,
      String? internship,
      String? fellowship,
      String? address,
      String? profile,
      String? startTime,
      String? endTime,
      bool? notificationFlag}) {
    return Container(
      width: MediaQuery.of(Get.context!).size.width * 1.0,
      alignment: Alignment.center, // where to position the child
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(
                top: 20.0,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20.0,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    //transform: Matrix4.translationValues(0.0, -16.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 15.0,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              transform:
                                  Matrix4.translationValues(0.0, -15.0, 0.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 70,
                                child: ClipOval(
                                    child:
                                        // imagePath != null
                                        //     ?
                                        profile != null
                                            ? CachedNetworkImage(
                                                imageUrl: Uri.encodeFull(
                                                  '${Endpoints.baseURL}${Endpoints.downLoadEmployePhoto}$profile',
                                                ),
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(!Responsive
                                                            .isDesktop(
                                                                Get.context!)
                                                        ? 'assets'
                                                            '/images/default_profile.png'
                                                        : '/images/default_profile.png'),
                                              )
                                            : Image.asset(!Responsive.isDesktop(
                                                    Get.context!)
                                                ? 'assets'
                                                    '/images/default_profile.png'
                                                : '/images/default_profile.png')),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 15.0,
                      bottom: 5.0,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${prefix ?? ''} $firstName $lastName',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Color(0xFF6f6f6f),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            // color: Colors.transparent,
                            // splashColor: Colors.black26,
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //           CategoryPage(specialty)),
                              // );
                            },
                            child: Text(
                              specialty ?? "specialty not found",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(Get.context!).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Notifications",
                                style: TextStyle(fontSize: 18)),
                            Row(
                              children: [
                                const Text("No",
                                    style: TextStyle(fontSize: 18)),
                                Obx(() => Switch(
                                      onChanged: (value) async {
                                        controller.sentNotification.value =
                                            value;
                                        SharedPrefUtils.saveBool(
                                            'notificationFlag', value);
                                        var req = {
                                          "id": id,
                                          "notificationFlag":
                                              controller.sentNotification.value,
                                          "status": "ACTIVE",
                                          "userId": userid
                                        };
                                        print(jsonEncode(req));
                                        await controller
                                            .staffnotificationUpdate(req)
                                            .then((value) {
                                          staffData =
                                              controller.staffData.value;
                                        });
                                      },
                                      activeColor: Colors.white,
                                      activeTrackColor: Colors.blue,
                                      inactiveThumbColor:
                                          Colors.blueGrey.shade600,
                                      inactiveTrackColor: Colors.grey.shade400,
                                      splashRadius: 50.0,
                                      value: controller.sentNotification.value,
                                    )),
                                const Text("Yes",
                                    style: TextStyle(fontSize: 18)),
                              ],
                            )
                          ],
                        )

                        // RatingBar.builder(
                        //   initialRating: rank ?? 0.0,
                        //   minRating: 1,
                        //   direction: Axis.horizontal,
                        //   allowHalfRating: true,
                        //   unratedColor: Colors.amber.withAlpha(50),
                        //   itemCount: 5,
                        //   itemSize: 30.0,
                        //   itemPadding:
                        //       const EdgeInsets.symmetric(horizontal: 4.0),
                        //   itemBuilder: (context, _) => const Icon(
                        //     Icons.star,
                        //     color: Colors.amber,
                        //   ),
                        //   onRatingUpdate: (rating) {},
                        //   updateOnDrag: true,
                        // ),
                        ),
                  ),
                  address != null
                      ? sectionTitle(Get.context!, "Address")
                      : Container(),
                  address != null
                      ? Container(
                          margin: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              address,
                              style: const TextStyle(
                                color: Color(0xFF9f9f9f),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  sectionTitle(Get.context!, "Physician History"),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (medicalEducation != null)
                                    ? SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'MEDICAL EDUCATION',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Color(0xFF6f6f6f),
                                              ),
                                            ),
                                            Text(
                                              medicalEducation,
                                              style: const TextStyle(
                                                color: Color(0xFF9f9f9f),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(),
                                (fellowship != null)
                                    ? Container(
                                        margin: const EdgeInsets.only(
                                          top: 20.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'FELLOWSHIP',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Color(0xFF6f6f6f),
                                              ),
                                            ),
                                            Text(
                                              fellowship,
                                              style: const TextStyle(
                                                color: Color(0xFF9f9f9f),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (startTime != null && endTime != null)
                                    ? SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Clinic Timmings',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Color(0xFF6f6f6f),
                                              ),
                                            ),
                                            Text(
                                              '$startTime - $endTime',
                                              style: const TextStyle(
                                                color: Color(0xFF9f9f9f),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(),
                                (residency != null)
                                    ? SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'RESIDENCY',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Color(0xFF6f6f6f),
                                              ),
                                            ),
                                            Text(
                                              residency,
                                              style: const TextStyle(
                                                color: Color(0xFF9f9f9f),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(),
                                // (fellowship != null)
                                //     ? Container(
                                //         margin: const EdgeInsets.only(
                                //           top: 20.0,
                                //         ),
                                //         child: Column(
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.start,
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.start,
                                //           children: [
                                //             const Text(
                                //               'FELLOWSHIP',
                                //               style: TextStyle(
                                //                 fontWeight: FontWeight.bold,
                                //                 fontSize: 12,
                                //                 color: Color(0xFF6f6f6f),
                                //               ),
                                //             ),
                                //             Text(
                                //               fellowship,
                                //               style: const TextStyle(
                                //                 color: Color(0xFF9f9f9f),
                                //               ),
                                //             )
                                //           ],
                                //         ),
                                //       )
                                //     : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  sectionTitle(Get.context!, "Awards & Recognition"),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        officePhotos(Get.context!,
                            "https://marianheart.org/wp-content/uploads/2020/05/IMG_0203-2-rotated.jpg"),
                        officePhotos(Get.context!,
                            "https://marianheart.org/wp-content/uploads/2020/05/IMG_0205-2-rotated.jpg"),
                        officePhotos(Get.context!,
                            "https://marianheart.org/wp-content/uploads/2020/05/IMG_2932-1-scaled.jpg"),
                        officePhotos(Get.context!,
                            "https://marianheart.org/wp-content/uploads/2020/05/IMG_2934-scaled.jpg"),
                        // officePhotos(
                        //     Get.context!, "https://i.imgur.com/eY1lW0A.jpg"),
                      ],
                    ),
                  ),
                  // sectionTitle(context, "Appointments"),
                  // Container(
                  //   margin: const EdgeInsets.only(
                  //     bottom: 15.0,
                  //   ),
                  //   height: 60,
                  //   child: ListView(
                  //     padding: EdgeInsets.zero,
                  //     scrollDirection: Axis.horizontal,
                  //     children: <Widget>[
                  //       appointmentDays("Monday", "June 15th", context),
                  //       appointmentDays("Tuesday", "June 19th`", context),
                  //       appointmentDays("Wednesday", "July 24th", context),
                  //       appointmentDays("Thursday", "July 12th", context),
                  //       appointmentDays("Friday", "July 13th", context),
                  //       appointmentDays("Saturday", "August 7th", context),
                  //       appointmentDays("Sunday", "August 9th", context),
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   margin: const EdgeInsets.only(
                  //     bottom: 15.0,
                  //   ),
                  //   height: 50,
                  //   child: ListView(
                  //     padding: EdgeInsets.zero,
                  //     scrollDirection: Axis.horizontal,
                  //     children: <Widget>[
                  //       appointmentTimes("9:00 AM", context),
                  //       appointmentTimes("9:30 AM", context),
                  //       appointmentTimes("10:00 AM", context),
                  //       appointmentTimes("10:30 AM", context),
                  //       appointmentTimes("11:00 AM", context),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 50),

                  Card(
                    elevation: 10,
                    child: QrImageView(
                      semanticsLabel: 'AppointmentXpert',
                      data: 'https://marianheart.org/',
                      version: QrVersions.auto,
                      size: 220,
                      gapless: false,
                      padding: const EdgeInsets.all(20.0),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  ElevatedButton.icon(
                      onPressed: () {
                        onTapLogout();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Log Out')),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Powered By',
                          style: AppStyle.txtInterRegular16,
                        ),
                        const SizedBox(
                          height: 75,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image(
                              image: AssetImage('assets/images/logof.png'),
                              fit: BoxFit.contain, // use this
                            ),
                          ),
                        ),
                        const Text('Fossgen Technologies Pvt Ltd',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget patientCard({
    int? id,
    int? userId,
    String? firstName,
    String? lastName,
    String? prefix,
    String? address,
    String? imagePath,
    String? age,
    String? email,
    String? mobile,
    String? profile,
  }) {
    return Container(
      width: MediaQuery.of(Get.context!).size.width * 1.0,
      alignment: Alignment.center, // where to position the child
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 45.0,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20.0,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  //transform: Matrix4.translationValues(0.0, -16.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 15.0,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            transform:
                                Matrix4.translationValues(0.0, -15.0, 0.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: 70,
                                child: ClipOval(
                                    child:
                                        // imagePath != null
                                        //     ?
                                        profile != null
                                            ? CachedNetworkImage(
                                                imageUrl: Uri.encodeFull(
                                                  '${Endpoints.baseURL}${Endpoints.downLoadPatientPhoto}$profile',
                                                ),
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(!Responsive
                                                            .isDesktop(
                                                                Get.context!)
                                                        ? 'assets'
                                                            '/images/default_profile.png'
                                                        : '/images/default_profile.png'),
                                              )
                                            : Image.asset(!Responsive.isDesktop(
                                                    Get.context!)
                                                ? 'assets'
                                                    '/images/default_profile.png'
                                                : '/images/default_profile.png')
                                    // : CustomImageView(
                                    //     imagePath: !Responsive.isDesktop(
                                    //             Get.context!)
                                    //         ? 'assets' +
                                    //             '/images/default_profile.png'
                                    //         : '/images/default_profile.png',
                                    //   ),
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 15.0,
                    bottom: 5.0,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '$prefix $firstName $lastName',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color(0xFF6f6f6f),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          // color: Colors.transparent,
                          // splashColor: Colors.black26,
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           CategoryPage(specialty)),
                            // );
                          },
                          child: Text(
                            address ?? 'N/A',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(Get.context!).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Notifications",
                              style: TextStyle(fontSize: 18)),
                          Row(
                            children: [
                              const Text("No", style: TextStyle(fontSize: 18)),
                              Obx(() => Switch(
                                    onChanged: (value) async {
                                      controller.sentNotification.value = value;
                                      SharedPrefUtils.saveBool(
                                          'notificationFlag', value);
                                      var req = {
                                        "id": id,
                                        "notificationFlag":
                                            controller.sentNotification.value,
                                        "userId": userId
                                      };
                                      print(jsonEncode(req));
                                      await controller
                                          .patientnotificationUpdate(req)
                                          .then((value) {
                                        patientData =
                                            controller.patientData.value;
                                      });
                                    },
                                    activeColor: Colors.white,
                                    activeTrackColor: Colors.blue,
                                    inactiveThumbColor:
                                        Colors.blueGrey.shade600,
                                    inactiveTrackColor: Colors.grey.shade400,
                                    splashRadius: 50.0,
                                    value: controller.sentNotification.value,
                                  )),
                              const Text("Yes", style: TextStyle(fontSize: 18)),
                            ],
                          )
                        ],
                      )

                      // RatingBar.builder(
                      //   initialRating: rank ?? 0.0,
                      //   minRating: 1,
                      //   direction: Axis.horizontal,
                      //   allowHalfRating: true,
                      //   unratedColor: Colors.amber.withAlpha(50),
                      //   itemCount: 5,
                      //   itemSize: 30.0,
                      //   itemPadding:
                      //       const EdgeInsets.symmetric(horizontal: 4.0),
                      //   itemBuilder: (context, _) => const Icon(
                      //     Icons.star,
                      //     color: Colors.amber,
                      //   ),
                      //   onRatingUpdate: (rating) {},
                      //   updateOnDrag: true,
                      // ),
                      ),
                ),
                sectionTitle(Get.context!, "Basic information"),
                Container(
                  margin: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'AGE',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Color(0xFF6f6f6f),
                                      ),
                                    ),
                                    Text(
                                      patientData?.patient?.age.toString() ??
                                          '',
                                      style: const TextStyle(
                                        color: Color(0xFF9f9f9f),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 20.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Gender',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Color(0xFF6f6f6f),
                                      ),
                                    ),
                                    Text(
                                      patientData?.patient?.sex.toString() ??
                                          '',
                                      style: const TextStyle(
                                        color: Color(0xFF9f9f9f),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Email',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Color(0xFF6f6f6f),
                                      ),
                                    ),
                                    Text(
                                      patientData?.patient?.email ?? '',
                                      style: const TextStyle(
                                        color: Color(0xFF9f9f9f),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 20.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Mobile',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Color(0xFF6f6f6f),
                                      ),
                                    ),
                                    Text(
                                      patientData?.patient?.mobile ?? '',
                                      style: const TextStyle(
                                        color: Color(0xFF9f9f9f),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Card(
                  elevation: 10,
                  child: QrImageView(
                    semanticsLabel: 'AppointmentXpert',
                    data: 'https://marianheart.org/',
                    version: QrVersions.auto,
                    size: 220,
                    gapless: false,
                    padding: const EdgeInsets.all(20.0),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      onTapLogout();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Log Out')),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 1.0,
          alignment: Alignment.center, // where to position the child
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              SharedPrefUtils.readPrefStr('role') == "DOCTOR"
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Update'),
                                actions: [
                                  Form(
                                    key: controller.formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.02,
                                          ),
                                          SizedBox(
                                            child: InkWell(
                                              onTap: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                DateTime a =
                                                    await controller.getDate();

                                                final DateFormat formatter =
                                                    DateFormat('dd-MM-yyyy');
                                                controller.dob.text =
                                                    formatter.format(a);
                                              },
                                              child: AbsorbPointer(
                                                child: CustomTextFormField(
                                                    controller: controller.dob,
                                                    labelText: "Date",
                                                    isRequired: true,
                                                    validator: (value) {
                                                      return controller
                                                          .dateValidator(
                                                              value ?? "");
                                                    },
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
                                          CustomTextFormField(
                                              labelText: "Time Interval",
                                              isRequired: true,
                                              controller:
                                                  controller.timeInterval,
                                              validator: (value) {
                                                return controller
                                                    .timeIntervalValidator(
                                                        value ?? "");
                                              },
                                              padding: TextFormFieldPadding
                                                  .PaddingT14,
                                              textInputType:
                                                  TextInputType.number,
                                              prefixConstraints: BoxConstraints(
                                                  maxHeight:
                                                      getVerticalSize(56))),
                                          SizedBox(
                                            height: size.height * 0.02,
                                          ),
                                          ElevatedButton(
                                              // height: 60,
                                              // shape: ButtonShape.RoundedBorder8,
                                              child: const Text("Update"),
                                              onPressed: () async {
                                                bool a = controller.trySubmit();
                                                if (a) {
                                                  Map<String, dynamic> data = {
                                                    "rescheduleDate":
                                                        controller.dob.text,
                                                    "rescheduleTimeInMin":
                                                        controller
                                                            .timeInterval.text,
                                                    "status": "ACTIVE",
                                                    "id": staffData?.id ?? 0
                                                  };
                                                  print(jsonEncode(data));

                                                  await controller
                                                      .staffUpdate(data);
                                                }
                                              })
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ).then((value) {
                              if (value == null) {
                                controller.dob.clear();
                                controller.timeInterval.clear();
                              }
                            });
                          });
                        },
                        child: Text(
                          'Edit Time Slot',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorConstant.black900,
                            fontSize: getFontSize(
                              14,
                            ),
                            decoration: TextDecoration.underline,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              (SharedPrefUtils.readPrefStr("role") != 'PATIENT')
                  ? doctorProfile()
                  : patientProfile(),
            ],
          ),
        ),
      ),
    );
  }
}

onTapLogout() {
  Get.dialog(AlertDialog(
    backgroundColor: Colors.transparent,
    contentPadding: EdgeInsets.zero,
    insetPadding: const EdgeInsets.only(left: 0),
    content: LogOutPopUpDialog(
      Get.put(
        LogOutPopUpController(),
      ),
    ),
  ));
}

Material appointmentDays(
    String appointmentDay, String appointmentDate, context) {
  return Material(
    color: Colors.white,
    child: Container(
      margin: const EdgeInsets.only(
        right: 1.0,
        left: 20.0,
        top: 5.0,
        bottom: 5.0,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              appointmentDay,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              appointmentDate,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    ),
  );
}

Material appointmentTimes(String appointmentDay, context) {
  return Material(
    color: Colors.white,
    child: Container(
      margin: const EdgeInsets.only(
        right: 1.0,
        left: 20.0,
        top: 5.0,
        bottom: 5.0,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          appointmentDay,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}

Widget officePhotos(context, String officePhotoUrl) {
  return Container(
      margin: const EdgeInsets.only(
        left: 20.0,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: ImageNetwork(
        image: officePhotoUrl,
        height: 150,
        width: 150,
        duration: 1500,
        curve: Curves.easeIn,
        onPointer: true,
        debugPrint: false,
        fullScreen: false,
        fitAndroidIos: BoxFit.cover,
        fitWeb: BoxFitWeb.cover,
        onLoading: const CircularProgressIndicator(
          color: Colors.indigoAccent,
        ),
        onError: const Icon(
          Icons.error,
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          showDialog(
              context: context,
              builder: (_) => const AlertDialog(
                    content: Text("©gabrielpatricksouza"),
                  ));
          debugPrint("©gabriel_patrick_souza");
        },
      )
      // Material(
      //   child: Ink(
      //     decoration: BoxDecoration(
      //       image: DecorationImage(
      //         fit: BoxFit.cover,
      //         image: Responsive.isDesktop(context)
      //             ? Image.network(
      //                 officePhotoUrl,
      //                 loadingBuilder: (context, url, progress) => const Center(
      //                   child: CircularProgressIndicator(),
      //                 ),
      //               ).image
      //             : CachedNetworkImageProvider(
      //                 officePhotoUrl,
      //               ),
      //       ),
      //     ),
      //     child: InkWell(
      //       onTap: () async {
      //         // Navigator.push(
      //         //   context,
      //         //   MaterialPageRoute(
      //         //       builder: (context) => ImageGallery(officePhotoUrl)),
      //         // );
      //       },
      //       child: Container(
      //         width: 150.0,
      //       ),
      //     ),
      //   ),
      // ),
      );
}

class SimpleDialogItem extends StatelessWidget {
  const SimpleDialogItem(
      {Key? key,
      required this.icon,
      required this.color,
      required this.text,
      required this.onPressed})
      : super(key: key);

  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 36.0, color: color),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 16.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

Widget sectionTitle(context, String title) {
  return Container(
    margin: const EdgeInsets.only(
      top: 20.0,
      left: 20.0,
      right: 20.0,
      bottom: 20.0,
    ),
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
            top: 20,
          ),
          child: Divider(
            color: Colors.black12,
            height: 1,
            thickness: 1,
          ),
        ),
      ],
    ),
  );
}
