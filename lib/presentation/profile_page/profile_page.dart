import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../core/app_export.dart';
import '../../models/patient_model.dart';
import '../../models/staff_model.dart';
import '../../network/endpoints.dart';
import '../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../widgets/responsive.dart';
import '../log_out_pop_up_dialog/controller/log_out_pop_up_controller.dart';
import '../log_out_pop_up_dialog/log_out_pop_up_dialog.dart';

class ProfilePage extends StatefulWidget {
  final StaffData? staffData;
  final PatientData? patientData;
  ProfilePage(this.staffData, this.patientData);

  @override
  _ProfilePageState createState() => _ProfilePageState(staffData, patientData);
}

class _ProfilePageState extends State<ProfilePage> {
  final StaffData? staffData;
  final PatientData? patientData;
  _ProfilePageState(this.staffData, this.patientData);

  @override
  void initState() {
    super.initState();
  }

  Widget doctorProfile() {
    return Container(
      child: ListView.builder(
          itemCount: 1,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return doctorCard(
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
            );
          }),
    );
    // : Container(
    //     height: MediaQuery.of(context).size.height,
    //     decoration: BoxDecoration(
    //       gradient: LinearGradient(
    //         begin: Alignment(-1.0, 0.0),
    //         end: Alignment(1.0, 0.0),
    //         colors: [
    //           Theme.of(context).primaryColorLight,
    //           Theme.of(context).primaryColorDark,
    //         ], // whitish to gray
    //       ),
    //     ),
    //     alignment: Alignment.center,
    //     child: CircularProgressIndicator(
    //       valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
    //     ),
    //   );
  }

  Widget patientProfile() {
    return Container(
      child: ListView.builder(
          itemCount: 1,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return patientCard(
                firstName: patientData?.patient?.firstName,
                lastName: patientData?.patient?.lastName,
                prefix: patientData?.patient?.prefix ?? '',
                imagePath: patientData?.patient?.profilePicture,
                address: patientData?.patient?.address,
                age: patientData?.patient?.age.toString(),
                email: patientData?.patient?.email,
                mobile: patientData?.patient?.mobile);
          }),
    );
  }

  Widget doctorCard({
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
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 1.0,
      alignment: Alignment.center, // where to position the child
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 45.0,
            ),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Colors.white,
              boxShadow: [
                new BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20.0,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //transform: Matrix4.translationValues(0.0, -16.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 15.0,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            transform:
                                Matrix4.translationValues(0.0, -15.0, 0.0),
                            child: CircleAvatar(
                              radius: 70,
                              child: ClipOval(
                                  child:
                                      // imagePath != null
                                      //     ?
                                      CachedNetworkImage(
                                imageUrl: imagePath ?? '',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                        !Responsive.isDesktop(Get.context!)
                                            ? 'assets' +
                                                '/images/default_profile.png'
                                            : '/images/default_profile.png'),
                              )
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
                          '${prefix ?? ''} ${firstName} ${lastName}',
                          style: TextStyle(
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
                              color: Theme.of(context).primaryColor,
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
                    child: RatingBar.builder(
                      initialRating: rank ?? 0.0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      unratedColor: Colors.amber.withAlpha(50),
                      itemCount: 5,
                      itemSize: 30.0,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          //_rating = rating;
                        });
                      },
                      updateOnDrag: true,
                    ),
                  ),
                ),
                address != null
                    ? sectionTitle(context, "Address")
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
                            style: TextStyle(
                              color: Color(0xFF9f9f9f),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                sectionTitle(context, "Physician History"),
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
                                  ? Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'MEDICAL EDUCATION',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Color(0xFF6f6f6f),
                                            ),
                                          ),
                                          Text(
                                            medicalEducation,
                                            style: TextStyle(
                                              color: Color(0xFF9f9f9f),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                              (internship != null)
                                  ? Container(
                                      margin: EdgeInsets.only(
                                        top: 20.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'INTERNSHIP',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Color(0xFF6f6f6f),
                                            ),
                                          ),
                                          Text(
                                            internship,
                                            style: TextStyle(
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
                              (residency != null)
                                  ? Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'RESIDENCY',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Color(0xFF6f6f6f),
                                            ),
                                          ),
                                          Text(
                                            residency,
                                            style: TextStyle(
                                              color: Color(0xFF9f9f9f),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                              (fellowship != null)
                                  ? Container(
                                      margin: EdgeInsets.only(
                                        top: 20.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'FELLOWSHIP',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Color(0xFF6f6f6f),
                                            ),
                                          ),
                                          Text(
                                            fellowship,
                                            style: TextStyle(
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
                      ],
                    ),
                  ),
                ),
                sectionTitle(context, "Office Gallery"),
                Container(
                  height: 150,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      officePhotos(context, "https://i.imgur.com/gKdDh8p.jpg"),
                      officePhotos(context, "https://i.imgur.com/bJ6gU02.jpg"),
                      officePhotos(context, "https://i.imgur.com/ZJZIrIB.jpg"),
                      officePhotos(context, "https://i.imgur.com/pTAuS44.jpg"),
                      officePhotos(context, "https://i.imgur.com/eY1lW0A.jpg"),
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
                SizedBox(height: 50),
                ElevatedButton.icon(
                    onPressed: () {
                      onTapLogout();
                    },
                    icon: Icon(Icons.logout),
                    label: Text('Log Out')),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget patientCard({
    String? firstName,
    String? lastName,
    String? prefix,
    String? address,
    String? imagePath,
    String? age,
    String? email,
    String? mobile,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 1.0,
      alignment: Alignment.center, // where to position the child
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 45.0,
            ),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Colors.white,
              boxShadow: [
                new BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20.0,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //transform: Matrix4.translationValues(0.0, -16.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                              boxShadow: [
                                new BoxShadow(
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
                                        CachedNetworkImage(
                                  imageUrl: Uri.encodeFull(
                                    Endpoints.baseURL +
                                        Endpoints.downLoadPatientPhoto +
                                        SharedPrefUtils.readPrefINt(
                                                'patient_Id')
                                            .toString(),
                                  ),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          !Responsive.isDesktop(Get.context!)
                                              ? 'assets' +
                                                  '/images/default_profile.png'
                                              : '/images/default_profile.png'),
                                )
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
                          '${prefix} ${firstName} ${lastName}',
                          style: TextStyle(
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
                sectionTitle(context, "Basic information"),
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
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
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
                                      style: TextStyle(
                                        color: Color(0xFF9f9f9f),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 20.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
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
                                      style: TextStyle(
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
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Color(0xFF6f6f6f),
                                      ),
                                    ),
                                    Text(
                                      patientData?.patient?.email ?? '',
                                      style: TextStyle(
                                        color: Color(0xFF9f9f9f),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 20.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mobile',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Color(0xFF6f6f6f),
                                      ),
                                    ),
                                    Text(
                                      patientData?.patient?.mobile ?? '',
                                      style: TextStyle(
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
                SizedBox(height: 50),
                ElevatedButton.icon(
                    onPressed: () {
                      onTapLogout();
                    },
                    icon: Icon(Icons.logout),
                    label: Text('Log Out')),
                SizedBox(
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
    insetPadding: EdgeInsets.only(left: 0),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              appointmentDate,
              style: TextStyle(fontWeight: FontWeight.normal),
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
          style: TextStyle(fontWeight: FontWeight.bold),
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
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    child: Material(
      child: Ink(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(officePhotoUrl),
          ),
        ),
        child: InkWell(
          onTap: () async {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => ImageGallery(officePhotoUrl)),
            // );
          },
          child: Container(
            width: 150.0,
          ),
        ),
      ),
    ),
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
        Padding(
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
