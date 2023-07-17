library dashboard;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:countup/countup.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/color_constant.dart';
import '../../../../core/utils/size_utils.dart';
import '../../../../models/getAllApointments.dart';
import '../../../../models/getallEmplyesList.dart';
import '../../../../models/patient_list_model.dart';
import '../../../../models/patient_model.dart';
import '../../../../network/endpoints.dart';
import '../../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../../../theme/app_style.dart';
import '../../../../widgets/app_bar/appbar_image.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/responsive.dart';
import '../../../add_patient_screens/add_patient_screen.dart';
import '../../../appointment_booking_screen/appointment_booking.dart';
import '../../../profile_page/profile_page.dart';
import '../../controller/dashboard_controller.dart';
import '../../shared_components/card_appointment.dart';
import '../../shared_components/header_text.dart';
import '../../shared_components/list_recent_patient.dart';
import '../../shared_components/list_task_date.dart';
import '../../shared_components/responsive_builder.dart';
import '../../shared_components/selection_button.dart';
import '../../shared_components/simple_selection_button.dart';
import '../../shared_components/simple_user_profile.dart';
import '../components/dashboard_header.dart';
import '../components/patients_list.dart';

part '../components/appointment_in_progress.dart';
// model

// component
part '../components/bottom_navbar.dart';
part '../components/header_recent_patients.dart';
part '../components/main_menu.dart';
part '../components/member.dart';
part '../components/recent_patients.dart';
part '../components/task_menu.dart';
part '../components/todays_appointment_group.dart';

enum pats { Existing, New }

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  Widget loadBody(int index, BuildContext context) {
    if (SharedPrefUtils.readPrefStr("role") == 'PATIENT') {
      switch (index) {
        case 0:
          return _buildHomePageContent(context: context);
        /*case 1:
          return _buildAppointmentPageContent();*/
        // case 2:
        //   return _buildChatPageContent();
        case 1:
          return _buildProfilePageContent();
        default:
          return Container();
      }
    } else {
      switch (index) {
        case 0:
          return _buildHomePageContent(context: context);
        case 1:
          return SharedPrefUtils.readPrefStr('role') == "DOCTOR"
              ? Container()
              : _buildAppointmentPageContent();
        case 2:
          return _buildPatientsListPageContent();
        // case 3:
        //   return _buildChatPageContent();
        case 3:
          return _buildProfilePageContent();
        default:
          return Container();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scafoldKey,
      // drawer: ResponsiveBuilder.isDesktop(context)
      //     ? null
      //     : Drawer(
      //         child: SafeArea(
      //           child: SingleChildScrollView(child: _buildSidebar(context)),
      //         ),
      //       ),
      appBar: ResponsiveBuilder.isDesktop(context)
          ? null
          : AppbarImage(
              backgroundColor: ColorConstant.whiteA70001,
              height: 70,
              width: width,
              imagePath: 'assets/images/login-logo.png',
            ),
      bottomNavigationBar: (ResponsiveBuilder.isDesktop(context) || kIsWeb)
          ? null
          : _BottomNavbar(onSelected: controller.onSelectedTabBarMainMenu),

      body: SafeArea(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() =>
                      loadBody(controller.selectedPageIndex.value, context)),
                  // _buildTaskContent(
                  //   onPressedMenu: () => controller.openDrawer(),
                  // ),
                  //_buildCalendarContent(),
                  // Obx(
                  //   () => controller.selectedPageIndex.value == 0
                  //       ? _buildCalendarContent()
                  //       : Container(),
                  // )
                ],
              ),
            );
          },
          tabletBuilder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: constraints.maxWidth > 800 ? 8 : 7,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Obx(() =>
                        loadBody(controller.selectedPageIndex.value, context)),
                    // _buildTaskContent(
                    //   onPressedMenu: () => controller.openDrawer(),
                    // ),
                  ),
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height,
                //   child: const VerticalDivider(),
                // ),
                // Obx(
                //   () => controller.selectedPageIndex.value == 0
                //       ? Flexible(
                //           flex: 4,
                //           child: SingleChildScrollView(
                //             controller: ScrollController(),
                //             child: _buildCalendarContent(),
                //           ),
                //         )
                //       : Container(),
                // ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: _buildSidebar(context),
                ),
                Flexible(
                  flex: constraints.maxWidth > 1350 ? 10 : 9,
                  child: Obx(() =>
                      loadBody(controller.selectedPageIndex.value, context)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: ColorConstant.gray400,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(30))),
      child: SizedBox(
        //width: 300,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(
                'assets/images/login-logo.png',
                width: width,
                height: 120,
              ),
              // child: UserProfile(
              //   data: controller.dataProfil,
              //   onPressed: controller.onPressedProfil,
              // ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _MainMenu(onSelected: controller.onSelectedMainMenu),
            ),
            const Divider(
              indent: 20,
              thickness: 1,
              endIndent: 20,
              height: 60,
            ),
            //_Member(member: controller.member),
            //const SizedBox(height: kSpacing),
            // _TaskMenu(
            //   onSelected: controller.onSelectedTaskMenu,
            // ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(kSpacing),
              child: Text(
                "2023 Fossgentechnologies Pvt Ltd.",
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomePageContent(
      {Function()? onPressedMenu, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: kSpacing),
            Row(
              children: [
                if (onPressedMenu != null)
                  Padding(
                    padding: const EdgeInsets.only(right: kSpacing / 2),
                    child: IconButton(
                      onPressed: onPressedMenu,
                      icon: const Icon(Icons.menu),
                    ),
                  ),
                HeaderDashboard(
                  role: SharedPrefUtils.readPrefStr("role"),
                ),
                // Expanded(
                //   child: SearchField(
                //     onSearch: controller.searchTask,
                //     hintText: "Search.. ",
                //   ),
                // ),
              ],
            ),
            ResponsiveBuilder.isDesktop(context)
                ? (SharedPrefUtils.readPrefStr("role") == 'PATIENT')
                    ? InkWell(
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text('Close'))
                                      ],
                                      title: Text('Book new appointment'),
                                      content: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ));
                          });

                          // Get.toNamed(AppRoutes.doctorDetailScreen,
                          //     arguments: DoctorDetailsArguments(
                          //         controller.getAllEmployesList.value.doctorList ??
                          //             [],
                          //         controller.patientData.value.patient));
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Card(
                            elevation: 4,
                            color: Colors.blue.shade900,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            shadowColor: ColorConstant.gray400,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('New Appointment',
                                  style: TextStyle(
                                      color: ColorConstant.whiteA700)),
                            ),
                          ),
                        ),
                      )
                    : SizedBox()
                : SizedBox(),
            const SizedBox(height: kSpacing),
            Obx(() => _welcomeWidget(
                (controller.staffData.value.firstName ??
                        controller.patientData.value.patient?.firstName) ??
                    "",
                (controller.staffData.value.lastName ??
                        controller.patientData.value.patient?.lastName) ??
                    "",
                controller.role,
                Get.context!,
                controller.staffData.value.id ?? 0,
                controller.patientData.value.patient?.id ?? 0,
                controller.staffData.value.profilePicture,
                controller.patientData.value.patient?.profilePicture)),
            const SizedBox(height: kSpacing),
            SharedPrefUtils.readPrefStr("role") == 'PATIENT'
                ? const SizedBox()
                : _dailyNumbers(controller.staffTodaysData),
            const SizedBox(height: kSpacing),
            SizedBox(
              child: ResponsiveBuilder.isMobile(context)
                  ? Column(
                      children: [
                        SharedPrefUtils.readPrefStr("role") == 'PATIENT'
                            ? Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                color: Colors.red.shade50,
                                shadowColor: Colors.grey.shade400,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  //child: ResponsiveBuilder.isMobile(Get.context!)
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Image.asset('assets/images/call.png',
                                              height: 50, width: 50),
                                          Text(
                                            "Emergency Appointment",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: ColorConstant.black900),
                                          )
                                        ]),
                                        Text(
                                          "We keep emergency appointments available everyday.",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              color: ColorConstant.gray600),
                                        ),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    alignment: Alignment.center,
                                                    backgroundColor:
                                                        Colors.red.shade900,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20,
                                                        vertical: 12),
                                                    textStyle: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                onPressed: () {
                                                  pats? pat = pats.Existing;
                                                  Get.defaultDialog(
                                                      title: '',
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            "Thanks for your enquiry.",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    ColorConstant
                                                                        .gray900),
                                                          ),
                                                          Text(
                                                            "We will co-ordinate with you shortly.",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color:
                                                                    ColorConstant
                                                                        .gray600),
                                                          ),

                                                          /*ListTile(
                                                        title: Text('Existing Patient'),
                                                        leading: Radio<pats>(
                                                          value: pats.Existing,
                                                          groupValue: pat,
                                                          onChanged: (pats? value) {
                                                            setState((){

                                                              pat = value;

                                                            });
                                                          },
                                                        ),
                                                      ),

                                                ListTile(
                                                    title: Text('New Patient'),
                                                    leading: Radio<pats>(
                                                      value: pats.New,
                                                      groupValue: pat,
                                                      onChanged: (pats? value) {
                                                        setState((){
                                                              pat = value;
                                                            });
                                                          },
                                                        ),
                                                      )
                                                ,
                                                const TextField(
                                                  //controller: settingsScreenController.categoryNameController,
                                                  keyboardType: TextInputType.text,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                      labelText: 'Patient name',
                                                      hintMaxLines: 1,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.green, width: 4.0))),
                                                ),

                                                const SizedBox(
                                                  height: 10.0,
                                                ),

                                                const TextField(
                                                  //controller: settingsScreenController.categoryNameController,
                                                  keyboardType: TextInputType.text,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                      labelText: 'Patient mobile no.',
                                                      hintMaxLines: 1,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.green, width: 4.0))),
                                                ),

                                                const SizedBox(
                                                  height: 10.0,
                                                ),

                                                const TextField(
                                                  //controller: settingsScreenController.categoryNameController,
                                                  keyboardType: TextInputType.text,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                      labelText: 'Patient Address',
                                                      hintMaxLines: 1,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.green, width: 4.0))),
                                                ),

                                                const SizedBox(
                                                  height: 30.0,
                                                ),

                                                ElevatedButton(
                                                  onPressed: () {
                                                    */ /*if (settingsScreenController
                                            .categoryNameController.text.isNotEmpty) {
                                          var expenseCategory = ExpenseCategory(
                                              settingsScreenController.categoryNameController.text,
                                              id: _addExpenseController.expenseCategories.length);
                                          settingsScreenController.addExpenseCategory(expenseCategory);
                                          _addExpenseController.expenseCategories.add(expenseCategory);
                                          Get.back();
                                        } else {
                                          Utils.showSnackBar("Enter category name");
                                        }*/ /*
                                                  },
                                                  style: ElevatedButton.styleFrom(backgroundColor:Colors.red.shade900),
                                                  child: const Text(
                                                    'Add Patient',
                                                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                                                  ),
                                                )*/
                                                        ],
                                                      ),
                                                      radius: 10.0);
                                                },
                                                child: Text('Book Now')))
                                      ]),
                                ))
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        Card(
                          elevation: 4,
                          color: Colors.white,
                          shadowColor: ColorConstant.gray400,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: HeaderText(
                                      //DateTime.now().formatdMMMMY(),
                                      "Today's Appointments"),
                                ),
                                const SizedBox(height: kSpacing),
                                Obx(() => controller.isloading.value
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : (SharedPrefUtils.readPrefStr("role") ==
                                            'PATIENT')
                                        ? controller
                                                .patientTodaysData.isNotEmpty
                                            ? _AppointmentInProgress(
                                                data: controller
                                                    .patientTodaysData)
                                            : Container(
                                                color: Colors.white,
                                                padding: EdgeInsets.all(10),
                                                child: const Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'No today\'s appointments found.',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                        : controller.staffTodaysData.isNotEmpty
                                            ? _AppointmentInProgress(
                                                data:
                                                    controller.staffTodaysData)
                                            : Container(
                                                color: Colors.white,
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: const Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'No today\'s appointments found.',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                              ],
                            ),
                          ),
                        ),
                        (SharedPrefUtils.readPrefStr("role") == 'RECEPTIONIST')
                            //? SharedPrefUtils.readPrefStr("role") == 'RECEPTIONIST'
                            ? Card(
                                elevation: 4,
                                color: Colors.white,
                                shadowColor: ColorConstant.gray400,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      (SharedPrefUtils.readPrefStr("role") ==
                                              'RECEPTIONIST')
                                          //? SharedPrefUtils.readPrefStr("role") == 'RECEPTIONIST'
                                          ? const _HeaderRecentPatients()
                                          : Container(),
                                      //: Container(),
                                      //const SizedBox(height: kSpacing),
                                      (SharedPrefUtils.readPrefStr("role") ==
                                              'RECEPTIONIST')
                                          //? (SharedPrefUtils.readPrefStr("role") == 'RECEPTIONIST')
                                          ? Obx(() => controller.isloading.value
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : controller.getAllPatientsList
                                                      .isNotEmpty
                                                  ? _RecentPatients(
                                                      data: controller
                                                          .getAllPatientsList,
                                                      onPressed: controller
                                                          .onPressedPatient,
                                                      // onPressedAssign: controller.onPressedAssignTask,
                                                      // onPressedMember: controller.onPressedMemberTask,
                                                    )
                                                  : Container(
                                                      color: Colors.white,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: const Center(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'No patients found.',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ))
                                          : Container()
                                    ],
                                  ),
                                ))
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        SharedPrefUtils.readPrefStr("role") == 'PATIENT'
                            ? Card(
                                elevation: 4,
                                shadowColor: ColorConstant.gray400,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  padding: EdgeInsets.all(
                                      ResponsiveBuilder.isMobile(context)
                                          ? 75
                                          : 40),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xff013f88)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 6.0,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '1',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 40.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Current Serving Patient",
                                        style: TextStyle(
                                            color: Colors.yellow.shade800,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(
                                height: 10,
                              )
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              Card(
                                elevation: 4,
                                color: Colors.white,
                                shadowColor: ColorConstant.gray400,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: HeaderText(
                                            //DateTime.now().formatdMMMMY(),
                                            "Today's Appointments"),
                                      ),
                                      const SizedBox(height: kSpacing),
                                      Obx(() => controller.isloading.value
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : (SharedPrefUtils.readPrefStr(
                                                      "role") ==
                                                  'PATIENT')
                                              ? controller.patientTodaysData
                                                      .isNotEmpty
                                                  ? _AppointmentInProgress(
                                                      data: controller
                                                          .patientTodaysData)
                                                  : Container(
                                                      color: Colors.white,
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: const Center(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'No today\'s appointments found.',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                              : controller.staffTodaysData
                                                      .isNotEmpty
                                                  ? _AppointmentInProgress(
                                                      data: controller
                                                          .staffTodaysData)
                                                  : Container(
                                                      color: Colors.white,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: const Center(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'No today\'s appointments found.',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                    ],
                                  ),
                                ),
                              ),
                              (SharedPrefUtils.readPrefStr("role") ==
                                      'RECEPTIONIST')
                                  //? SharedPrefUtils.readPrefStr("role") == 'RECEPTIONIST'
                                  ? Card(
                                      elevation: 4,
                                      color: Colors.white,
                                      shadowColor: ColorConstant.gray400,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            (SharedPrefUtils.readPrefStr(
                                                        "role") ==
                                                    'RECEPTIONIST')
                                                //? SharedPrefUtils.readPrefStr("role") == 'RECEPTIONIST'
                                                ? const _HeaderRecentPatients()
                                                : Container(),
                                            //: Container(),
                                            //const SizedBox(height: kSpacing),
                                            (SharedPrefUtils.readPrefStr(
                                                        "role") ==
                                                    'RECEPTIONIST')
                                                //? (SharedPrefUtils.readPrefStr("role") == 'RECEPTIONIST')
                                                ? Obx(() => controller
                                                        .isloading.value
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : controller
                                                            .getAllPatientsList
                                                            .isNotEmpty
                                                        ? _RecentPatients(
                                                            data: controller
                                                                .getAllPatientsList,
                                                            onPressed: controller
                                                                .onPressedPatient,
                                                            // onPressedAssign: controller.onPressedAssignTask,
                                                            // onPressedMember: controller.onPressedMemberTask,
                                                          )
                                                        : Container(
                                                            color: Colors.white,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: const Center(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'No patients found.',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ))
                                                : Container()
                                          ],
                                        ),
                                      ))
                                  : const SizedBox()
                            ],
                          ),
                        ),
                        const SizedBox(width: kSpacing),
                        Card(
                          elevation: 4,
                          shadowColor: ColorConstant.gray400,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xff013f88)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 6.0,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '1',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Mr. Mihir Rawal",
                                  style: TextStyle(
                                      color: Colors.yellow.shade800,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Symtoms - Fever/cough",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                                const Text(
                                  "Blood group - O+",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                                const Text(
                                  "Address - Pune",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                                const Text(
                                  "Contact - +918550978814",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
            ),
            const SizedBox(height: kSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentPageContent({Function()? onPressedMenu}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
        child: AppointmentBookingScreen(
            patientDetailsArguments: PatientDetailsArguments(
                controller.getAllEmployesList.value.doctorList ?? [],
                controller.patientData.value.patient)));
  }

  Widget _buildChatPageContent({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: SizedBox(
        height: MediaQuery.of(Get.context!).size.height,
      ),
    );
  }

  Widget _buildProfilePageContent({Function()? onPressedMenu}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
        child: SizedBox(
          height: MediaQuery.of(Get.context!).size.height,
          child: ProfilePage(
              controller.staffData.value, controller.patientData.value),
        ));
  }

  Widget _buildPatientsListPageContent({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: SharedPrefUtils.readPrefStr('role') == 'RECEPTIONIST'
          ? AddPatientScreen()
          : Column(
              children: [
                SizedBox(
                    width: MediaQuery.of(Get.context!).size.width,
                    height: MediaQuery.of(Get.context!).size.height,
                    //color: Colors.red,
                    child: PatientsList(
                      data: controller.getAllPatientsList,
                      onPressed: (index, data) {},
                    ))
              ],
            ),
    );
  }

  Widget _buildCalendarContent() {
    var outputFormat = DateFormat('d MMMM');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing),
          Row(
            children: [
              const Expanded(child: HeaderText("Upcoming Appointments")),
              IconButton(
                onPressed: controller.onPressedCalendar,
                icon: const Icon(EvaIcons.calendarOutline),
                tooltip: "calendar",
              )
            ],
          ),
          const SizedBox(height: 10),
          Obx(() => controller.isloading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    ...controller.upComingAppointments
                        .map(
                          (e) => _TodaysAppointmentGroup(
                            title: outputFormat
                                .format(DateTime.parse(e.date.toString())),
                            data: [e],
                            onPressed: null,
                            //controller.onPressedPatient,
                          ),
                        )
                        .toList()
                  ],
                ))
        ],
      ),
    );
  }

  Widget _welcomeWidget(
      String firstName,
      String lastName,
      String role,
      BuildContext context,
      int staffId,
      int patientId,
      String? staffProfile,
      String? patientProfile) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      shadowColor: Colors.grey.shade400,
      child: SizedBox(
        // decoration: const BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage('assets/images/bg-img-01.png'))),
        child: ResponsiveBuilder.isMobile(context)
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: staffId == 0
                          ? staffProfile != null
                              ? CachedNetworkImage(
                                  imageUrl: Uri.encodeFull(
                                    '${Endpoints.baseURL}${Endpoints.downLoadEmployePhoto}$staffId',
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
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          !Responsive.isDesktop(Get.context!)
                                              ? 'assets' +
                                                  '/images/default_profile.png'
                                              : '/images/default_profile.png'),
                                )
                              : Image.asset(!Responsive.isDesktop(Get.context!)
                                  ? 'assets' + '/images/default_profile.png'
                                  : '/images/default_profile.png')
                          : patientProfile != null
                              ? CachedNetworkImage(
                                  imageUrl: Uri.encodeFull(
                                    '${Endpoints.baseURL}${Endpoints.downLoadEmployePhoto}$patientId',
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
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          !Responsive.isDesktop(Get.context!)
                                              ? 'assets' +
                                                  '/images/default_profile.png'
                                              : '/images/default_profile.png'),
                                )
                              : Image.asset(!Responsive.isDesktop(Get.context!)
                                  ? 'assets' + '/images/default_profile.png'
                                  : '/images/default_profile.png'),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              controller.greeting(),
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize:
                                      Responsive.isDesktop(context) ? 30 : 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins"),
                            ),
                            role == "PATIENT"
                                ? Text(
                                    "${firstName} ${lastName}",
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: Responsive.isDesktop(context)
                                          ? 30
                                          : 18,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    (SharedPrefUtils.readPrefStr('role') ==
                                            "DOCTOR")
                                        ? 'Dr.' + "${firstName} ${lastName}"
                                        : "${firstName} ${lastName}",
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: Responsive.isDesktop(context)
                                          ? 30
                                          : 18,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          (SharedPrefUtils.readPrefStr('role') == "PATIENT")
                              ? 'Have a nice day'
                              : "Have a nice day at work",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: ColorConstant.gray600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          (SharedPrefUtils.readPrefStr('role') == "PATIENT")
                              ? 'Your Number - 1'
                              : "",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 100,
                    child: CachedNetworkImage(
                      imageUrl: Uri.encodeFull(
                        '${Endpoints.baseURL}${Endpoints.downLoadEmployePhoto}0',
                      ),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.asset(
                          !Responsive.isDesktop(Get.context!)
                              ? 'assets' + '/images/default_profile.png'
                              : '/images/default_profile.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              controller.greeting(),
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize:
                                      Responsive.isDesktop(context) ? 30 : 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins"),
                            ),
                            role == "PATIENT"
                                ? Text(
                                    "${firstName} ${lastName}",
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: Responsive.isDesktop(context)
                                          ? 30
                                          : 18,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    (SharedPrefUtils.readPrefStr('role') ==
                                            "DOCTOR")
                                        ? 'Dr.' + "${firstName} ${lastName}"
                                        : "${firstName} ${lastName}",
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: Responsive.isDesktop(context)
                                          ? 30
                                          : 18,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Have a nice day at work",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: ColorConstant.gray600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  !ResponsiveBuilder.isMobile(context)
                      ? const Spacer()
                      : const SizedBox(),
                  !ResponsiveBuilder.isMobile(context)
                      ? Image.asset(
                          'assets/images/bg-img-01.png',
                          height: 150,
                        )
                      : const SizedBox(),
                ],
              ),
      ),
    );
  }

  void setState(Null Function() param0) {
    return;
  }
}

Widget _dailyNumbers(List<AppointmentContent> list) {
  return SizedBox(
      width: MediaQuery.of(Get.context!).size.width,
      child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadowColor: Colors.grey.shade400,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ResponsiveBuilder.isMobile(Get.context!)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue.shade900),
                              child: const Icon(Icons.calendar_month_sharp,
                                  size: 60, color: Colors.white),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Countup(
                                    begin: 0,
                                    end: list.length.toDouble(),
                                    duration: const Duration(seconds: 3),
                                    separator: ',',
                                    style: TextStyle(
                                      fontSize:
                                          Responsive.isDesktop(Get.context!)
                                              ? 30
                                              : 18,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Today's Appointment",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: ColorConstant.black900),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue.shade900),
                              child: const Icon(Icons.person_outline_outlined,
                                  size: 60, color: Colors.white),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Countup(
                                    begin: 0,
                                    end: 4,
                                    duration: const Duration(seconds: 3),
                                    separator: ',',
                                    style: TextStyle(
                                      fontSize:
                                          Responsive.isDesktop(Get.context!)
                                              ? 30
                                              : 18,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Online Consultation",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: ColorConstant.black900),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xff013f88)),
                              child: const Icon(Icons.cut_outlined,
                                  size: 60, color: Colors.white),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Countup(
                                    begin: 0,
                                    end: 1,
                                    duration: const Duration(seconds: 3),
                                    separator: ',',
                                    style: TextStyle(
                                      fontSize:
                                          Responsive.isDesktop(Get.context!)
                                              ? 30
                                              : 18,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Opertions",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: ColorConstant.black900),
                                ),
                              ],
                            ),
                          ],
                        )
                      ])
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xff013f88)),
                              child: const Icon(Icons.calendar_month_sharp,
                                  size: 60, color: Colors.white),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Countup(
                                    begin: 0,
                                    end: list.length.toDouble(),
                                    duration: const Duration(seconds: 2),
                                    separator: ',',
                                    style: TextStyle(
                                      fontSize:
                                          Responsive.isDesktop(Get.context!)
                                              ? 30
                                              : 18,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Today's Appointment",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: ColorConstant.black900),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(
                          height: 8,
                          thickness: 1,
                          color: ColorConstant.gray400,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xff013f88)),
                              child: const Icon(Icons.person_outline_outlined,
                                  size: 60, color: Colors.white),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Countup(
                                    begin: 0,
                                    end: 4,
                                    duration: const Duration(seconds: 2),
                                    separator: ',',
                                    style: TextStyle(
                                      fontSize:
                                          Responsive.isDesktop(Get.context!)
                                              ? 30
                                              : 18,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Online Consultation",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: ColorConstant.black900),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(
                          height: 8,
                          thickness: 1,
                          color: ColorConstant.gray400,
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xff013f88)),
                                child: const Icon(Icons.cut_outlined,
                                    size: 60, color: Colors.white),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Countup(
                                      begin: 0,
                                      end: 1,
                                      duration: const Duration(seconds: 2),
                                      separator: ',',
                                      style: TextStyle(
                                        fontSize:
                                            Responsive.isDesktop(Get.context!)
                                                ? 30
                                                : 18,
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Opertions",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: ColorConstant.black900),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ]),
          )));
}

class DoctorDetailsArguments {
  AppointmentContent appointmentData;

  DoctorDetailsArguments(this.appointmentData);
}

class PatientDetailsArguments {
  List<DoctorList> list;
  Patients? details;
  PatientDetailsArguments(this.list, this.details);
}
