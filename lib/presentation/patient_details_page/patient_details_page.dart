import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../core/app_export.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../models/patient_list_model.dart';
import '../../models/patient_model.dart';
import '../../models/staff_model.dart';
import '../../network/endpoints.dart';
import '../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/responsive.dart';
import '../dashboard_screen/shared_components/responsive_builder.dart';
import '../dashboard_screen/views/screens/dashboard_screen.dart';
import '../log_out_pop_up_dialog/controller/log_out_pop_up_controller.dart';
import '../log_out_pop_up_dialog/log_out_pop_up_dialog.dart';

class PatientDetailsPage extends StatefulWidget {

  Content patientData;
  //int? id;

  PatientDetailsPage(this.patientData);

  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState(patientData);
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {

  Content patientData;
  //int? id;
  _PatientDetailsPageState(this.patientData);

  @override
  void initState() {
    super.initState();

  }

  Widget patientDetails() {
    return SizedBox(
      child: ListView.builder(
          itemCount: 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return patientDetailsCard(
                firstName: patientData?.firstName,
                lastName: patientData?.lastName,
                prefix: patientData?.prefix ?? '',
                imagePath: patientData?.profilePicture,
                address: patientData?.address,
                age: patientData?.age.toString(),
                email: patientData?.email,
                mobile: patientData?.mobile,
                profile: patientData?.profilePicture);
          }),
    );
  }

  Widget patientDetailsCard({
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
      width: MediaQuery.of(context).size.width * 1.0,
      alignment: Alignment.center, // where to position the child
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
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
                                        Endpoints.baseURL +
                                            Endpoints
                                                .downLoadPatientPhoto + patientData.profilePicture
/*                                            SharedPrefUtils
                                                .readPrefINt(
                                                'patient_Id')*/
                                                .toString(),
                                      ),
                                      imageBuilder:
                                          (context, imageProvider) =>
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                      placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                      errorWidget: (context, url,
                                          error) =>
                                          Image.asset(!Responsive
                                              .isDesktop(
                                              Get.context!)
                                              ? 'assets' +
                                              '/images/default_profile.png'
                                              : '/images/default_profile.png'),
                                    )
                                        : Image.asset(!Responsive.isDesktop(
                                        Get.context!)
                                        ? 'assets' +
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
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                sectionTitle(context, "Patient information"),
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
                                      patientData?.age.toString() ??
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
                                      patientData?.sex.toString() ??
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
                                      patientData?.email ?? '',
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
                                      patientData?.mobile ?? '',
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
      appBar: ResponsiveBuilder.isDesktop(context)
          ? null
          : AppbarImage(
        backgroundColor: ColorConstant.whiteA70001,
        height: 70,
        width: width,
        leading: IconButton(
            onPressed: () {
              //controller.onClose();
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        imagePath: 'assets/images/login-logo.png',
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 1.0,
          alignment: Alignment.center, // where to position the child
          child: Column(
            children: [
              patientDetails(),
            ],
          ),
        ),
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
