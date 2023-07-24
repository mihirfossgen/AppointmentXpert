library dashboard;

import 'dart:convert';

import 'package:appointmentxpert/presentation/schedule_tab_container_page/schedule_tab_container_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:countup/countup.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
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
import '../components/emergency_list.dart';
import '../components/patients_list.dart';
import '../components/upcoming_appointments.dart';

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
          return _buildAppointmentPageContent();
        // SharedPrefUtils.readPrefStr('role') == "DOCTOR"
        //     ? Container()
        //     : _buildAppointmentPageContent();
        case 2:
          return _buildPatientsListPageContent();
        case 3:
          return _buildEmergencyPatientsListPage();
        case 4:
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
            return Obx(
                () => loadBody(controller.selectedPageIndex.value, context));
          },
          tabletBuilder: (context, constraints) {
            return Obx(
                () => loadBody(controller.selectedPageIndex.value, context));
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
                style: Theme.of(context).textTheme.bodySmall,
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
      child: LiquidPullToRefresh(
        showChildOpacityTransition: false,
        onRefresh: () async {
          if (controller.role == "PATIENT") {
            controller
                .getPatientDetails(SharedPrefUtils.readPrefINt('patient_Id'));
            controller.callTodayAppointmentsByPatient();
            controller.getUpcomingAppointments(0, true);
          } else {
            controller.patientPagingController =
                PagingController(firstPageKey: 0);
            controller.patientPagingController.itemList = [];
            controller
                .callStaffData(SharedPrefUtils.readPrefINt('employee_Id'));
            controller.callStaffTodayAppointments();
            controller.callStaffUpcomingAppointments();
            controller.callStaffList(0);
            controller.callRecentPatientList(0);
            controller.callEmergencyPatientList();
            final DateFormat formatter = DateFormat('dd-MM-yyyy');
            controller.callGetAppointmentDetailsForDate(
                formatter.format(DateTime.now()));
          }
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView(shrinkWrap: true, children: [
            Column(
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
                ResponsiveBuilder.isDesktop(context) &&
                        (SharedPrefUtils.readPrefStr("role") == 'PATIENT')
                    ? InkWell(onTap: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(actions: [
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          alignment: Alignment.center,
                                          backgroundColor: Colors.red.shade900,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          textStyle: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                      onPressed: () {
                                        pats? pat = pats.Existing;
                                        controller.radioButtonIndex.value = 0;
                                        controller.nameController.text =
                                            controller.patientData.value.patient
                                                    ?.firstName
                                                    .toString() ??
                                                '';
                                        controller.mobileController.text =
                                            controller.patientData.value.patient
                                                    ?.mobile
                                                    .toString() ??
                                                '';
                                        controller.addressController.text =
                                            controller.patientData.value.patient
                                                    ?.address
                                                    .toString() ??
                                                '';
                                        Get.defaultDialog(
                                            titlePadding:
                                                const EdgeInsets.all(10),
                                            title: 'Select an Option',
                                            titleStyle: TextStyle(
                                                color: Colors.red.shade900,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                            content: Column(
                                              // mainAxisSize:
                                              //     MainAxisSize.max,
                                              children: [
                                                ListTile(
                                                  title: const Text(
                                                      'Existing Patient'),
                                                  leading: Obx(
                                                    () => Radio<pats>(
                                                      value: pats.Existing,
                                                      groupValue: controller
                                                                  .radioButtonIndex
                                                                  .value ==
                                                              0
                                                          ? pats.Existing
                                                          : pats.New,
                                                      onChanged: (pats? value) {
                                                        controller
                                                            .nameController
                                                            .text = controller
                                                                .patientData
                                                                .value
                                                                .patient
                                                                ?.firstName
                                                                .toString() ??
                                                            '';
                                                        controller
                                                            .mobileController
                                                            .text = controller
                                                                .patientData
                                                                .value
                                                                .patient
                                                                ?.mobile
                                                                .toString() ??
                                                            '';
                                                        controller
                                                            .addressController
                                                            .text = controller
                                                                .patientData
                                                                .value
                                                                .patient
                                                                ?.address
                                                                .toString() ??
                                                            '';
                                                        controller
                                                                .radioButtonVal
                                                                .value =
                                                            'Existing Patient';
                                                        controller
                                                            .radioButtonIndex
                                                            .value = 0;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                ListTile(
                                                  title:
                                                      const Text('New Patient'),
                                                  leading: Obx(
                                                    () => Radio<pats>(
                                                      value: pats.New,
                                                      groupValue: controller
                                                                  .radioButtonIndex
                                                                  .value ==
                                                              0
                                                          ? pats.Existing
                                                          : pats.New,
                                                      onChanged: (pats? value) {
                                                        controller
                                                            .nameController
                                                            .text = '';
                                                        controller
                                                            .mobileController
                                                            .text = '';
                                                        controller
                                                            .addressController
                                                            .text = '';
                                                        controller
                                                                .radioButtonVal
                                                                .value =
                                                            'New Patient';
                                                        controller
                                                            .radioButtonIndex
                                                            .value = 1;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Obx(() => controller
                                                                .radioButtonIndex
                                                                .value ==
                                                            0
                                                        ? loadEmergencyDetails(
                                                            true)
                                                        : loadEmergencyDetails(
                                                            false)
                                                    // Column(
                                                    //     children: [
                                                    //       Text(
                                                    //         "Thanks for your enquiry.",
                                                    //         style: TextStyle(
                                                    //             fontSize:
                                                    //                 20,
                                                    //             fontWeight:
                                                    //                 FontWeight.bold,
                                                    //             color: ColorConstant.gray900),
                                                    //       ),
                                                    //       Text(
                                                    //         "We will co-ordinate with you shortly.",
                                                    //         style: TextStyle(
                                                    //             fontSize:
                                                    //                 15,
                                                    //             fontWeight:
                                                    //                 FontWeight.normal,
                                                    //             color: ColorConstant.gray600),
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    )
                                              ],
                                            ),
                                            radius: 10.0);
                                      },
                                      child: const Text('Book Now')))
                            ]),
                          );
                        });
                      })
                    : const SizedBox(),
                const SizedBox(height: 10),
                // Card(
                //   elevation: 4,
                //   color: Colors.white,
                //   shadowColor: ColorConstant.gray400,
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10)),
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         const Align(
                //           alignment: Alignment.centerLeft,
                //           child: HeaderText(
                //               //DateTime.now().formatdMMMMY(),
                //               "Today's Appointments"),
                //         ),
                //         const SizedBox(height: kSpacing),
                //         Obx(() => controller.isloading.value
                //             ? const Center(child: CircularProgressIndicator())
                //             : (SharedPrefUtils.readPrefStr("role") == 'PATIENT')
                //                 ? controller.patientTodaysData.isNotEmpty
                //                     ? _AppointmentInProgress(
                //                         data: controller.patientTodaysData)
                //                     : Container(
                //                         color: Colors.white,
                //                         padding: EdgeInsets.all(10),
                //                         child: const Center(
                //                           child: Column(
                //                             crossAxisAlignment:
                //                                 CrossAxisAlignment.center,
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.center,
                //                             children: [
                //                               Text(
                //                                 'No today\'s appointments found.',
                //                                 style: TextStyle(
                //                                   fontSize: 18,
                //                                 ),
                //                               ),
                //                             ],
                //                           ),
                //                         ),
                //                       )
                //                 : controller.staffTodaysData.isNotEmpty
                //                     ? _AppointmentInProgress(
                //                         data: controller.staffTodaysData)
                //                     : Container(
                //                         color: Colors.white,
                //                         padding: const EdgeInsets.all(20),
                //                         child: const Center(
                //                           child: Column(
                //                             crossAxisAlignment:
                //                                 CrossAxisAlignment.start,
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.center,
                //                             children: [
                //                               Text(
                //                                 'No today\'s appointments found.',
                //                                 style: TextStyle(
                //                                   fontSize: 18,
                //                                 ),
                //                               ),
                //                             ],
                //                           ),
                //                         ),
                //                       )),
                //       ],
                //     ),
                //   ),
                // ),
                //const SizedBox(height: kSpacing),
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
                  child: ResponsiveBuilder.isMobile(context) ||
                          ResponsiveBuilder.isTablet(context)
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
                                              Image.asset(
                                                  'assets/images/call.png',
                                                  height: 50,
                                                  width: 50),
                                              Text(
                                                "Emergency Appointment",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        ColorConstant.black900),
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
                                                alignment: Alignment
                                                    .centerRight,
                                                child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        alignment: Alignment
                                                            .center,
                                                        backgroundColor: Colors
                                                            .red.shade900,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20,
                                                                vertical: 12),
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                    onPressed: () {
                                                      pats? pat = pats.Existing;
                                                      controller
                                                          .radioButtonIndex
                                                          .value = 0;
                                                      controller.nameController
                                                          .text = controller
                                                              .patientData
                                                              .value
                                                              .patient
                                                              ?.firstName
                                                              .toString() ??
                                                          '';
                                                      controller
                                                          .mobileController
                                                          .text = controller
                                                              .patientData
                                                              .value
                                                              .patient
                                                              ?.mobile
                                                              .toString() ??
                                                          '';
                                                      controller
                                                          .addressController
                                                          .text = controller
                                                              .patientData
                                                              .value
                                                              .patient
                                                              ?.address
                                                              .toString() ??
                                                          '';
                                                      Get.defaultDialog(
                                                          titlePadding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          title:
                                                              'Select an Option',
                                                          titleStyle: TextStyle(
                                                              color: Colors
                                                                  .red.shade900,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          content: Column(
                                                            // mainAxisSize:
                                                            //     MainAxisSize.max,
                                                            children: [
                                                              ListTile(
                                                                title: const Text(
                                                                    'Existing Patient'),
                                                                leading: Obx(
                                                                  () => Radio<
                                                                      pats>(
                                                                    value: pats
                                                                        .Existing,
                                                                    groupValue: controller
                                                                                .radioButtonIndex.value ==
                                                                            0
                                                                        ? pats
                                                                            .Existing
                                                                        : pats
                                                                            .New,
                                                                    onChanged:
                                                                        (pats?
                                                                            value) {
                                                                      controller
                                                                          .nameController
                                                                          .text = controller
                                                                              .patientData
                                                                              .value
                                                                              .patient
                                                                              ?.firstName
                                                                              .toString() ??
                                                                          '';
                                                                      controller
                                                                          .mobileController
                                                                          .text = controller
                                                                              .patientData
                                                                              .value
                                                                              .patient
                                                                              ?.mobile
                                                                              .toString() ??
                                                                          '';
                                                                      controller
                                                                          .addressController
                                                                          .text = controller
                                                                              .patientData
                                                                              .value
                                                                              .patient
                                                                              ?.address
                                                                              .toString() ??
                                                                          '';
                                                                      controller
                                                                          .radioButtonVal
                                                                          .value = 'Existing Patient';
                                                                      controller
                                                                          .radioButtonIndex
                                                                          .value = 0;
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                title: const Text(
                                                                    'New Patient'),
                                                                leading: Obx(
                                                                  () => Radio<
                                                                      pats>(
                                                                    value: pats
                                                                        .New,
                                                                    groupValue: controller
                                                                                .radioButtonIndex.value ==
                                                                            0
                                                                        ? pats
                                                                            .Existing
                                                                        : pats
                                                                            .New,
                                                                    onChanged:
                                                                        (pats?
                                                                            value) {
                                                                      controller
                                                                          .nameController
                                                                          .text = '';
                                                                      controller
                                                                          .mobileController
                                                                          .text = '';
                                                                      controller
                                                                          .addressController
                                                                          .text = '';
                                                                      controller
                                                                          .radioButtonVal
                                                                          .value = 'New Patient';
                                                                      controller
                                                                          .radioButtonIndex
                                                                          .value = 1;
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              Obx(() => controller
                                                                              .radioButtonIndex
                                                                              .value ==
                                                                          0
                                                                      ? loadEmergencyDetails(
                                                                          true)
                                                                      : loadEmergencyDetails(
                                                                          false)
                                                                  // Column(
                                                                  //     children: [
                                                                  //       Text(
                                                                  //         "Thanks for your enquiry.",
                                                                  //         style: TextStyle(
                                                                  //             fontSize:
                                                                  //                 20,
                                                                  //             fontWeight:
                                                                  //                 FontWeight.bold,
                                                                  //             color: ColorConstant.gray900),
                                                                  //       ),
                                                                  //       Text(
                                                                  //         "We will co-ordinate with you shortly.",
                                                                  //         style: TextStyle(
                                                                  //             fontSize:
                                                                  //                 15,
                                                                  //             fontWeight:
                                                                  //                 FontWeight.normal,
                                                                  //             color: ColorConstant.gray600),
                                                                  //       ),
                                                                  //     ],
                                                                  //   ),
                                                                  )
                                                            ],
                                                          ),
                                                          radius: 10.0);
                                                    },
                                                    child:
                                                        const Text('Book Now')))
                                          ]),
                                    ))
                                : const SizedBox(),
                            const SizedBox(height: 10),
                            Card(
                              elevation: 4,
                              color: Colors.white,
                              shadowColor: ColorConstant.gray400,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
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
                                    Obx(() => controller
                                            .isloadingPatientTodaysAppointments
                                            .value
                                        ? const Center(
                                            child: CircularProgressIndicator())
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
                                                        const EdgeInsets.all(
                                                            10),
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
                                            : controller
                                                    .staffTodaysData.isNotEmpty
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
                            const SizedBox(height: 10),
                            Card(
                              elevation: 4,
                              color: Colors.white,
                              shadowColor: ColorConstant.gray400,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: HeaderText(
                                          //DateTime.now().formatdMMMMY(),
                                          "Upcoming Appointments"),
                                    ),
                                    const SizedBox(height: kSpacing),
                                    Obx(() => controller
                                            .isloadingStaffUpcomingAppointments
                                            .value
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : (SharedPrefUtils.readPrefStr(
                                                    "role") ==
                                                'PATIENT')
                                            ? controller.upComingAppointments
                                                    .isNotEmpty
                                                ? UpcomingAppointments(
                                                    data: controller
                                                        .upComingAppointments)
                                                : Container(
                                                    color: Colors.white,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
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
                                                            'No upcomming appointments found.',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                            : controller.upComingAppointments
                                                    .isNotEmpty
                                                ? UpcomingAppointments(
                                                    data: controller
                                                        .upComingAppointments)
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
                                                            'No upcoming appointments found.',
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
                            const SizedBox(height: 20),
                            Column(
                              children: [
                                CalendarTimeline(
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 360)),
                                  onDateSelected: (date) {
                                    final DateFormat formatter =
                                        DateFormat('dd-MM-yyyy');
                                    controller.callGetAppointmentDetailsForDate(
                                        formatter.format(date));
                                  },
                                  //leftMargin: 20,
                                  monthColor: Colors.blueGrey,
                                  dayColor: Colors.black,
                                  activeDayColor: Colors.white,
                                  activeBackgroundDayColor:
                                      ColorConstant.blue60001,
                                  dotsColor: Colors.white,
                                  locale: 'en_ISO',
                                ),
                                const SizedBox(height: 10),
                                Obx(() => controller.getAppointmentDetailsByDate
                                            .value ==
                                        []
                                    ? const SizedBox()
                                    : Align(
                                        alignment: Alignment.center,
                                        child: Wrap(
                                            runSpacing: getVerticalSize(5),
                                            spacing: getHorizontalSize(5),
                                            children: List.generate(
                                                controller.times?.length ?? 0,
                                                (index) {
                                              return Container(
                                                  height: 40,
                                                  width: 100,
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          controller.getAppointmentDetailsByDate.any((element) => element.startTime.toString().contains(controller.times?[index].toString() ?? ""))
                                                              ? Colors.blue
                                                              : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      border: Border.all(
                                                          color: controller
                                                                  .getAppointmentDetailsByDate
                                                                  .any((element) => element
                                                                      .startTime
                                                                      .toString()
                                                                      .contains(controller.times?[index].toString() ?? ""))
                                                              ? Colors.transparent
                                                              : Colors.black)),
                                                  child: Text(
                                                    controller.times?[index] ??
                                                        "",
                                                    style: TextStyle(
                                                        color: controller
                                                                .getAppointmentDetailsByDate
                                                                .any((element) => element
                                                                    .startTime
                                                                    .toString()
                                                                    .contains(controller
                                                                            .times?[index]
                                                                            .toString() ??
                                                                        ""))
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ));
                                            })),
                                      )),
                              ],
                            ),
                            const SizedBox(height: 10),
                            (SharedPrefUtils.readPrefStr("role") ==
                                    'RECEPTIONIST')
                                //? SharedPrefUtils.readPrefStr("role") == 'RECEPTIONIST'
                                ? Card(
                                    elevation: 4,
                                    color: Colors.white,
                                    shadowColor: ColorConstant.gray400,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          (SharedPrefUtils.readPrefStr(
                                                      "role") ==
                                                  'RECEPTIONIST')
                                              //? SharedPrefUtils.readPrefStr("role") == 'RECEPTIONIST'
                                              ? const _HeaderRecentPatients()
                                              : Container(),
                                          //: Container(),
                                          const SizedBox(height: kSpacing),
                                          (SharedPrefUtils.readPrefStr(
                                                      "role") ==
                                                  'RECEPTIONIST')
                                              //? (SharedPrefUtils.readPrefStr("role") == 'RECEPTIONIST')
                                              ? Obx(() => controller
                                                      .isloadingRecentPatients
                                                      .value
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : controller
                                                          .patientPagingController
                                                          .itemList!
                                                          .isNotEmpty
                                                      ? _RecentPatients(
                                                          data: controller
                                                                  .patientPagingController
                                                                  .itemList ??
                                                              [],
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
                                : const SizedBox(),
                            const SizedBox(
                              height: 10,
                            ),
                            SharedPrefUtils.readPrefStr("role") == 'PATIENT'
                                ? Card(
                                    elevation: 4,
                                    shadowColor: ColorConstant.gray400,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          ResponsiveBuilder.isMobile(context)
                                              ? 75
                                              : 40),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                            child: Center(
                                              child: Obx(
                                                () => Text(
                                                  SharedPrefUtils.readPrefStr(
                                                              "role") ==
                                                          'PATIENT'
                                                      ? controller
                                                          .patientTodaysData
                                                          .value
                                                          .length
                                                          .toString()
                                                      : controller
                                                          .staffTodaysData
                                                          .value
                                                          .length
                                                          .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 40.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
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
                                          Obx(() => controller
                                                  .isloadingPatientTodaysAppointments
                                                  .value
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
                                                              const EdgeInsets
                                                                  .all(10),
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
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
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
                                                              const EdgeInsets
                                                                  .all(20),
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
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
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
                                                            .isloadingRecentPatients
                                                            .value
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
                                                                onPressed:
                                                                    controller
                                                                        .onPressedPatient,
                                                                // onPressedAssign: controller.onPressedAssignTask,
                                                                // onPressedMember: controller.onPressedMemberTask,
                                                              )
                                                            : Container(
                                                                color: Colors
                                                                    .white,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                child:
                                                                    const Center(
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
                                      child: Center(
                                        child: Text(
                                          controller.patientTodaysData.length
                                              .toString(),
                                          style: const TextStyle(
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
                                      '${controller.patientData.value.patient?.firstName} '
                                      '${controller.patientData.value.patient?.lastName}',
                                      style: TextStyle(
                                          color: Colors.yellow.shade800,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      controller.patientData.value.patient?.sex
                                              .toString() ??
                                          '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      "Blood group - ${controller.patientData.value.patient?.bloodType?.toString()}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      "Address - ${controller.patientData.value.patient?.address?.toString()}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      "Contact - ${controller.patientData.value.patient?.mobile?.toString()}",
                                      style: const TextStyle(
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
          ]),
        ),
      ),
    );
  }

  Widget loadEmergencyDetails(bool isForExistingPatient) {
    return Column(
      children: [
        TextField(
          controller: controller.nameController,
          keyboardType: TextInputType.text,
          maxLines: 1,
          decoration: const InputDecoration(
              // label: isForExistingPatient == true
              //     ? Obx(
              //         () => Text(
              //             '${controller.patientData.value.patient?.firstName.toString()} + ${controller.patientData.value.patient?.lastName.toString()}'),
              //       )
              //     : null,
              labelText: 'Patient name',
              hintMaxLines: 1,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 4.0))),
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextField(
          controller: controller.mobileController,
          keyboardType: TextInputType.text,
          maxLines: 1,
          decoration: const InputDecoration(
              labelText: 'Patient mobile no.',
              // label: isForExistingPatient == true
              //     ? Obx(() => Text(
              //         controller.patientData.value.patient?.mobile.toString() ??
              //             ''))
              //     : null,
              hintMaxLines: 1,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 4.0))),
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextField(
          controller: controller.addressController,
          keyboardType: TextInputType.text,
          maxLines: 1,
          decoration: const InputDecoration(
              labelText: 'Patient EmailID',
              // label: isForExistingPatient == true
              //     ? Obx(() => Text(controller.patientData.value.patient?.address
              //             .toString() ??
              //         ''))
              //     : null,
              hintMaxLines: 1,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 4.0))),
        ),
        const SizedBox(
          height: 30.0,
        ),
        ElevatedButton(
          onPressed: () {
            isForExistingPatient == true
                ? onTapBookEmergencyAppointment("existing")
                : onTapBookEmergencyAppointment("new");

            // if (settingsScreenController
            //     .categoryNameController
            //     .text
            //     .isNotEmpty) {
            //   var expenseCategory = ExpenseCategory(
            //       settingsScreenController
            //           .categoryNameController
            //           .text,
            //       id: _addExpenseController
            //           .expenseCategories
            //           .length);
            //   settingsScreenController
            //       .addExpenseCategory(
            //           expenseCategory);
            //   _addExpenseController
            //       .expenseCategories
            //       .add(
            //           expenseCategory);
            //   Get.back();
            // } else {
            //   Utils.showSnackBar(
            //       "Enter category name");
            // }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900),
          child: Text(
            isForExistingPatient == true ? 'Submit' : 'Add Patient',
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        )
      ],
    );
  }

  Future<void> onTapBookEmergencyAppointment(String type) async {
    Map<String, dynamic> requestData = {
      "date": DateTime.now().toIso8601String(),
      "patientName": controller.nameController.text,
      "mobileNumber": controller.mobileController.text,
      "patientType": type,
      "emailId": controller.addressController.text
      //"address": controller.addressController.text
    };
    print(jsonEncode(requestData));
    try {
      await controller.addEmergencyAppointment(requestData);
      Fluttertoast.showToast(
        msg: "Emergency appointment raised we will connect you shortly...",
      );
      Get.back();
    } on Map {
      _onTapBookEmergencyAppointmentError();
    } on NoInternetException catch (e) {
      Get.rawSnackbar(message: e.toString());
    } catch (e) {
      Get.rawSnackbar(message: e.toString());
    }
  }

  Widget _buildAppointmentPageContent() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: kSpacing, vertical: kSpacing),
      child: SizedBox(
        width: MediaQuery.of(Get.context!).size.width,
        height: MediaQuery.of(Get.context!).size.height,
        //color: Colors.red,
        child: ScheduleTabContainerPage(),
      ),
    );
    // AppointmentBookingScreen(
    //     patientDetailsArguments: PatientDetailsArguments(
    //         controller.getAllEmployesList.value.doctorList ?? [],
    //         controller.patientData.value.patient)));
  }

  Widget _buildChatPageContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: SizedBox(
        height: MediaQuery.of(Get.context!).size.height,
      ),
    );
  }

  Widget _buildProfilePageContent() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
        child: SizedBox(
          height: MediaQuery.of(Get.context!).size.height,
          child: ProfilePage(
              controller.staffData.value, controller.patientData.value),
        ));
  }

  Widget _buildPatientsListPageContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: SizedBox(
          width: MediaQuery.of(Get.context!).size.width,
          height: MediaQuery.of(Get.context!).size.height,
          //color: Colors.red,
          child: PatientsList(
            data: controller.getAllPatientsList,
          )),
      // SharedPrefUtils.readPrefStr('role') == 'RECEPTIONIST'
      //     ? AddPatientScreen()
      //     : Column(
      //         children: [
      //           SizedBox(
      //               width: MediaQuery.of(Get.context!).size.width,
      //               height: MediaQuery.of(Get.context!).size.height,
      //               //color: Colors.red,
      //               child: PatientsList(
      //                 data: controller.getAllPatientsList,
      //                 onPressed: (index, data) {},
      //               ))
      //         ],
      //       ),
    );
  }

  Widget _buildEmergencyPatientsListPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: SizedBox(
          width: MediaQuery.of(Get.context!).size.width,
          height: MediaQuery.of(Get.context!).size.height,
          child: LiquidPullToRefresh(
              showChildOpacityTransition: false,
              onRefresh: () async {
                controller.isloadingEmergancyPatients.value = true;
                controller.callEmergencyPatientList();
              },
              child: ListView(children: [
                Obx(() => controller.isloadingEmergancyPatients.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.getEmergencyPatientsList.value.isEmpty
                        ? loadEmptyWidget()
                        : EmergencyList(
                            data: controller.getEmergencyPatientsList.value,
                            onPressed: (index, data) {},
                          ))
              ]))),
      // SharedPrefUtils.readPrefStr('role') == 'RECEPTIONIST'
      //     ? AddPatientScreen()
      //     : Column(
      //         children: [
      //           SizedBox(
      //               width: MediaQuery.of(Get.context!).size.width,
      //               height: MediaQuery.of(Get.context!).size.height,
      //               //color: Colors.red,
      //               child: PatientsList(
      //                 data: controller.getAllPatientsList,
      //                 onPressed: (index, data) {},
      //               ))
      //         ],
      //       ),
    );
  }

  Widget loadEmptyWidget() {
    return EmptyWidget(
      image: null,
      hideBackgroundAnimation: true,
      packageImage: PackageImage.Image_1,
      title: 'No data',
      subTitle: 'No emergency requests today.',
      titleTextStyle: const TextStyle(
        fontSize: 22,
        color: Colors.grey,
        fontWeight: FontWeight.w600,
      ),
      subtitleTextStyle: const TextStyle(
        fontSize: 14,
        color: Colors.black,
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
          Obx(() => controller.isloadingStaffUpcomingAppointments.value
              ? const Center(
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
        child: ResponsiveBuilder.isMobile(context) ||
                ResponsiveBuilder.isTablet(context)
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: staffProfile != null
                          ? CachedNetworkImage(
                              imageUrl: Uri.encodeFull(
                                '${Endpoints.baseURL}${Endpoints.downLoadEmployePhoto}$staffProfile',
                              ),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Image.asset(
                                  !Responsive.isDesktop(Get.context!)
                                      ? 'assets' '/images/default_profile.png'
                                      : '/images/default_profile.png'),
                            )
                          : patientProfile != null
                              ? CachedNetworkImage(
                                  imageUrl: Uri.encodeFull(
                                    '${Endpoints.baseURL}${Endpoints.downLoadPatientPhoto}$patientProfile',
                                  ),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          !Responsive.isDesktop(Get.context!)
                                              ? 'assets'
                                                  '/images/default_profile.png'
                                              : '/images/default_profile.png'),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                      !Responsive.isDesktop(Get.context!)
                                          ? 'assets'
                                              '/images/default_profile.png'
                                          : '/images/default_profile.png'),
                                ),
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
                                    "$firstName $lastName",
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
                                        ? 'Dr.' "$firstName $lastName"
                                        : "$firstName $lastName",
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
                              ? ''
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
                    child: staffProfile != null
                        ? CachedNetworkImage(
                            imageUrl: Uri.encodeFull(
                              '${Endpoints.baseURL}${Endpoints.downLoadEmployePhoto}$staffProfile',
                            ),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                                !Responsive.isDesktop(Get.context!)
                                    ? 'assets' '/images/default_profile.png'
                                    : '/images/default_profile.png'),
                          )
                        : patientProfile != null
                            ? CachedNetworkImage(
                                imageUrl: Uri.encodeFull(
                                  '${Endpoints.baseURL}${Endpoints.downLoadPatientPhoto}$patientProfile',
                                ),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                        !Responsive.isDesktop(Get.context!)
                                            ? 'assets'
                                                '/images/default_profile.png'
                                            : '/images/default_profile.png'),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                    !Responsive.isDesktop(Get.context!)
                                        ? 'assets' '/images/default_profile.png'
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
                                    "$firstName $lastName",
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
                                        ? 'Dr.' "$firstName $lastName"
                                        : "$firstName $lastName",
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
                  ResponsiveBuilder.isMobile(context) ||
                          ResponsiveBuilder.isTablet(context)
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

  void _onTapBookEmergencyAppointmentError() {
    Fluttertoast.showToast(
      msg: "Facing technical difficulties",
    );
  }

  Widget _dailyNumbers(List<AppointmentContent> list) {
    return SizedBox(
        width: MediaQuery.of(Get.context!).size.width,
        child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            shadowColor: Colors.grey.shade400,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ResponsiveBuilder.isMobile(Get.context!) ||
                      ResponsiveBuilder.isTablet(Get.context!)
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: ColorConstant.blue60001,
                                ),
                                child: const Icon(Icons.calendar_month_sharp,
                                    size: 40, color: Colors.white),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Countup(
                                      begin: 0,
                                      end: controller
                                          .staffTodaysTotalData.length
                                          .toDouble(),
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
                                    "Today's Total Appointments",
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
                                  color: ColorConstant.blue60001,
                                ),
                                child: const Icon(Icons.person_outline_outlined,
                                    size: 40, color: Colors.white),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Countup(
                                      begin: 0,
                                      end: double.parse(controller
                                          .getEmergencyPatientsList.length
                                          .toString()),
                                      duration: const Duration(seconds: 3),
                                      separator: ',',
                                      style: TextStyle(
                                        fontSize:
                                            Responsive.isDesktop(Get.context!)
                                                ? 30
                                                : 18,
                                        color: Colors.red.shade900,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Emergency Requests",
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
                                  color: ColorConstant.blue60001,
                                ),
                                child: const Icon(
                                    Icons.access_time_filled_outlined,
                                    size: 40,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Countup(
                                      begin: 0,
                                      end: double.parse(controller
                                          .staffTodaysCompletedData.length
                                          .toString()),
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
                                    "Completed Appointments",
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
                                      end: controller
                                          .staffTodaysTotalData.length
                                          .toDouble(),
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
                                    "Today's Total Appointments",
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
                                    color: const Color(0xff013f88)),
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
                                      end: controller
                                          .getEmergencyPatientsList.length
                                          .toDouble(),
                                      duration: const Duration(seconds: 2),
                                      separator: ',',
                                      style: TextStyle(
                                        fontSize:
                                            Responsive.isDesktop(Get.context!)
                                                ? 30
                                                : 18,
                                        color: Colors.red.shade900,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Emergency Request",
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
                                  child: const Icon(
                                      Icons.access_time_filled_outlined,
                                      size: 60,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Countup(
                                        begin: 0,
                                        end: double.parse(controller
                                            .staffTodaysCompletedData.length
                                            .toString()),
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
                                      "Completed Appointments",
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
}

class DoctorDetailsArguments {
  AppointmentContent appointmentData;

  DoctorDetailsArguments(this.appointmentData);
}

class PatientDetailsArguments {
  List<DoctorList> list;
  Content? details;

  PatientDetailsArguments(this.list, this.details);
}

class EmergencyPatientDetailsArguments {
  List<DoctorList> list;
  Patients? details;
  EmergencyPatientDetailsArguments(this.list, this.details);
}
