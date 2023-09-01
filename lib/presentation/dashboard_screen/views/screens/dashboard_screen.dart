library dashboard;

import 'dart:convert';

import 'package:appointmentxpert/core/utils/time_calculation_utils.dart';
import 'package:appointmentxpert/presentation/dashboard_screen/views/components/staff_list.dart';
import 'package:appointmentxpert/presentation/schedule_tab_container_page/schedule_tab_container_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:countup/countup.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../../widgets/responsive.dart';
import '../../../appointment_booking_screen/appointment_booking.dart';
import '../../../patient_details_page/patient_details_page.dart';
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
import '../components/cancelled_appointments.dart';
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
  DashboardScreen({Key? key}) : super(key: key);

  DashboardController controller = Get.put(DashboardController());

  Widget loadBody(int index, BuildContext context) {
    if (SharedPrefUtils.readPrefStr("role") == 'PATIENT') {
      switch (index) {
        case 0:
          return _buildHomePageContent(context: context);
        case 1:
          return _buildAppointmentPageContent();
        // case 2:
        //   return _buildChatPageContent();
        case 2:
          return _buildProfilePageContent();
        default:
          return Container();
      }
    } else if (SharedPrefUtils.readPrefStr("role") == 'RECEPTIONIST') {
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
    } else {
      switch (index) {
        case 0:
          return _buildHomePageContent(context: context);
        case 1:
          return _buildAppointmentPageContent();
        case 2:
          return _buildPatientsListPageContent();
        case 3:
          return _buildStaffListPageContent();
        case 4:
          return _buildEmergencyPatientsListPage();
        case 5:
          return _buildProfilePageContent();
        default:
          return Container();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure you want to exit the app?'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                      height: getVerticalSize(60),
                      width: getHorizontalSize(80),
                      text: 'Yes',
                      margin: getMargin(left: 10, right: 00),
                      fontStyle:
                          ButtonFontStyle.RalewayRomanSemiBold14WhiteA700,
                      onTap: () async {
                        SystemNavigator.pop();
                      }),
                  CustomButton(
                      height: getVerticalSize(60),
                      width: getHorizontalSize(80),
                      text: 'No',
                      margin: getMargin(left: 0, right: 10),
                      fontStyle:
                          ButtonFontStyle.RalewayRomanSemiBold14WhiteA700,
                      onTap: () async {
                        Get.back();
                      })
                ],
              )
            ],
          ),
        );

        return false;
      },
      child: Scaffold(
        key: controller.scafoldKey,
        resizeToAvoidBottomInset: true,
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
        //width: 400,
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
              child: MainMenu(onSelected: controller.onSelectedMainMenu),
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
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 10),
              child: SizedBox(
                height: 75,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image(
                    image: AssetImage('assets/images/logof.png'),
                    fit: BoxFit.contain, // use this
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Text(
                "2023 Fossgentechnologies Pvt Ltd.",
                style: Theme.of(context).textTheme.labelMedium,
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
            // controller.patientPagingController =
            //     PagingController(firstPageKey: 0);
            controller.patientPagingController.itemList = [];
            controller
                .callStaffData(SharedPrefUtils.readPrefINt('employee_Id'));
            SharedPrefUtils.readPrefStr("role") == "DOCTOR"
                ? controller.callStaffTodayAppointmentsByStaffid()
                : controller.callStaffTodayAppointments();
            controller.callAllCancelledAppointments();
            controller.callStaffUpcomingAppointments();
            controller.callStaffList(0);
            controller.callRecentPatientList(0);
            controller.callRecentPatientListForDashboaard();
            controller.callEmergencyPatientList();

            final DateFormat formatter = DateFormat('dd-MM-yyyy');
            SharedPrefUtils.readPrefStr("role") == "DOCTOR"
                ? controller.callGetAppointmentDetailsForDateByExaminerId(
                    formatter.format(DateTime.now()))
                : controller.callGetAppointmentDetailsForDate(
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
                (ResponsiveBuilder.isDesktop(context) ||
                            ResponsiveBuilder.isTablet(context)) &&
                        (SharedPrefUtils.readPrefStr("role") == 'PATIENT')
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                alignment: Alignment.center,
                                backgroundColor: Colors.red.shade900,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                textStyle: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              pats? pat = pats.Existing;
                              controller.radioButtonIndex.value = 0;
                              controller.nameController.text = controller
                                      .patientData.value.patient?.firstName
                                      .toString() ??
                                  '';
                              controller.mobileController.text = controller
                                      .patientData.value.patient?.mobile
                                      .toString() ??
                                  '';
                              controller.addressController.text = controller
                                      .patientData.value.patient?.address
                                      .toString() ??
                                  '';
                              Get.defaultDialog(
                                  titlePadding: const EdgeInsets.all(10),
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
                                        title: const Text('Existing Patient'),
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
                                              controller.nameController.text =
                                                  controller.patientData.value
                                                          .patient?.firstName
                                                          .toString() ??
                                                      '';
                                              controller.mobileController.text =
                                                  controller.patientData.value
                                                          .patient?.mobile
                                                          .toString() ??
                                                      '';
                                              controller.addressController
                                                  .text = controller.patientData
                                                      .value.patient?.address
                                                      .toString() ??
                                                  '';
                                              controller.radioButtonVal.value =
                                                  'Existing Patient';
                                              controller
                                                  .radioButtonIndex.value = 0;
                                            },
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        title: const Text('New Patient'),
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
                                              controller.nameController.text =
                                                  '';
                                              controller.mobileController.text =
                                                  '';
                                              controller
                                                  .addressController.text = '';
                                              controller.radioButtonVal.value =
                                                  'New Patient';
                                              controller
                                                  .radioButtonIndex.value = 1;
                                            },
                                          ),
                                        ),
                                      ),
                                      Obx(() => controller
                                                      .radioButtonIndex.value ==
                                                  0
                                              ? loadEmergencyDetails(true)
                                              : loadEmergencyDetails(false)
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
                            child: const Text(' +   Emergency Booking')))
                    // InkWell(onTap: () {
                    //     WidgetsBinding.instance.addPostFrameCallback((_) {
                    //       showDialog(
                    //         context: context,
                    //         builder: (context) => AlertDialog(actions: [

                    //         ]),
                    //       );
                    //     });
                    //   })
                    : const SizedBox(
                        height: 10,
                      ),
                const SizedBox(height: 10),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                    onPressed: () async {
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
                                                              ?.email
                                                              .toString() ??
                                                          '';

                                                      await showModalBottomSheet<
                                                          dynamic>(
                                                        context: Get.context!,
                                                        isDismissible: true,
                                                        isScrollControlled:
                                                            true,
                                                        enableDrag: false,
                                                        elevation: 2.0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        builder: (context) {
                                                          return FractionallySizedBox(
                                                            heightFactor: 0.9,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        20.0),
                                                                child: ListView(
                                                                    children: [
                                                                      Column(
                                                                        // mainAxisSize:
                                                                        //     MainAxisSize.max,
                                                                        children: [
                                                                          ListTile(
                                                                            title:
                                                                                const Text('Existing Patient'),
                                                                            leading:
                                                                                Obx(
                                                                              () => Radio<pats>(
                                                                                value: pats.Existing,
                                                                                groupValue: controller.radioButtonIndex.value == 0 ? pats.Existing : pats.New,
                                                                                onChanged: (pats? value) {
                                                                                  controller.nameController.text = controller.patientData.value.patient?.firstName.toString() ?? '';
                                                                                  controller.mobileController.text = controller.patientData.value.patient?.mobile.toString() ?? '';
                                                                                  controller.addressController.text = controller.patientData.value.patient?.email.toString() ?? '';
                                                                                  controller.radioButtonVal.value = 'Existing Patient';
                                                                                  controller.radioButtonIndex.value = 0;
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          ListTile(
                                                                            title:
                                                                                const Text('New Patient'),
                                                                            leading:
                                                                                Obx(
                                                                              () => Radio<pats>(
                                                                                value: pats.New,
                                                                                groupValue: controller.radioButtonIndex.value == 0 ? pats.Existing : pats.New,
                                                                                onChanged: (pats? value) {
                                                                                  controller.nameController.text = '';
                                                                                  controller.mobileController.text = '';
                                                                                  controller.addressController.text = '';
                                                                                  controller.radioButtonVal.value = 'New Patient';
                                                                                  controller.radioButtonIndex.value = 1;
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Obx(() => controller.radioButtonIndex.value == 0 ? loadEmergencyDetails(true) : loadEmergencyDetails(false)
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
                                                                    ]),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                      // Get.defaultDialog(
                                                      //     titlePadding:
                                                      //         const EdgeInsets
                                                      //             .all(10),
                                                      //     title:
                                                      //         'Select an Option',
                                                      //     titleStyle: TextStyle(
                                                      //         color: Colors
                                                      //             .red.shade900,
                                                      //         fontSize: 20,
                                                      //         fontWeight:
                                                      //             FontWeight
                                                      //                 .bold),
                                                      //     content:
                                                      //     Column(
                                                      //       // mainAxisSize:
                                                      //       //     MainAxisSize.max,
                                                      //       children: [
                                                      //         ListTile(
                                                      //           title: const Text(
                                                      //               'Existing Patient'),
                                                      //           leading: Obx(
                                                      //             () => Radio<
                                                      //                 pats>(
                                                      //               value: pats
                                                      //                   .Existing,
                                                      //               groupValue: controller
                                                      //                           .radioButtonIndex.value ==
                                                      //                       0
                                                      //                   ? pats
                                                      //                       .Existing
                                                      //                   : pats
                                                      //                       .New,
                                                      //               onChanged:
                                                      //                   (pats?
                                                      //                       value) {
                                                      //                 controller
                                                      //                     .nameController
                                                      //                     .text = controller
                                                      //                         .patientData
                                                      //                         .value
                                                      //                         .patient
                                                      //                         ?.firstName
                                                      //                         .toString() ??
                                                      //                     '';
                                                      //                 controller
                                                      //                     .mobileController
                                                      //                     .text = controller
                                                      //                         .patientData
                                                      //                         .value
                                                      //                         .patient
                                                      //                         ?.mobile
                                                      //                         .toString() ??
                                                      //                     '';
                                                      //                 controller
                                                      //                     .addressController
                                                      //                     .text = controller
                                                      //                         .patientData
                                                      //                         .value
                                                      //                         .patient
                                                      //                         ?.email
                                                      //                         .toString() ??
                                                      //                     '';
                                                      //                 controller
                                                      //                     .radioButtonVal
                                                      //                     .value = 'Existing Patient';
                                                      //                 controller
                                                      //                     .radioButtonIndex
                                                      //                     .value = 0;
                                                      //               },
                                                      //             ),
                                                      //           ),
                                                      //         ),
                                                      //         ListTile(
                                                      //           title: const Text(
                                                      //               'New Patient'),
                                                      //           leading: Obx(
                                                      //             () => Radio<
                                                      //                 pats>(
                                                      //               value: pats
                                                      //                   .New,
                                                      //               groupValue: controller
                                                      //                           .radioButtonIndex.value ==
                                                      //                       0
                                                      //                   ? pats
                                                      //                       .Existing
                                                      //                   : pats
                                                      //                       .New,
                                                      //               onChanged:
                                                      //                   (pats?
                                                      //                       value) {
                                                      //                 controller
                                                      //                     .nameController
                                                      //                     .text = '';
                                                      //                 controller
                                                      //                     .mobileController
                                                      //                     .text = '';
                                                      //                 controller
                                                      //                     .addressController
                                                      //                     .text = '';
                                                      //                 controller
                                                      //                     .radioButtonVal
                                                      //                     .value = 'New Patient';
                                                      //                 controller
                                                      //                     .radioButtonIndex
                                                      //                     .value = 1;
                                                      //               },
                                                      //             ),
                                                      //           ),
                                                      //         ),
                                                      //         Obx(() => controller
                                                      //                         .radioButtonIndex
                                                      //                         .value ==
                                                      //                     0
                                                      //                 ? loadEmergencyDetails(
                                                      //                     true)
                                                      //                 : loadEmergencyDetails(
                                                      //                     false)
                                                      //             // Column(
                                                      //             //     children: [
                                                      //             //       Text(
                                                      //             //         "Thanks for your enquiry.",
                                                      //             //         style: TextStyle(
                                                      //             //             fontSize:
                                                      //             //                 20,
                                                      //             //             fontWeight:
                                                      //             //                 FontWeight.bold,
                                                      //             //             color: ColorConstant.gray900),
                                                      //             //       ),
                                                      //             //       Text(
                                                      //             //         "We will co-ordinate with you shortly.",
                                                      //             //         style: TextStyle(
                                                      //             //             fontSize:
                                                      //             //                 15,
                                                      //             //             fontWeight:
                                                      //             //                 FontWeight.normal,
                                                      //             //             color: ColorConstant.gray600),
                                                      //             //       ),
                                                      //             //     ],
                                                      //             //   ),
                                                      //             )
                                                      //       ],
                                                      //     ),
                                                      //     radius: 10.0);
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
                            (SharedPrefUtils.readPrefStr("role") == 'DOCTOR')
                                ? Card(
                                    elevation: 4,
                                    color: Colors.white,
                                    shadowColor: ColorConstant.gray400,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                                "Cancelled Appointments"),
                                          ),
                                          const SizedBox(height: kSpacing),
                                          Obx(() => controller
                                                  .isloadingCancelledAppointments
                                                  .value
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : controller.cancelledAppointments
                                                      .isNotEmpty
                                                  ? CancelledAppointments(
                                                      data: controller
                                                          .cancelledAppointments)
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
                                                              'No cancelled appointments found.',
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
                                  )
                                : const SizedBox(),
                            SharedPrefUtils.readPrefStr('role') == 'PATIENT'
                                ? const SizedBox()
                                : Card(
                                    color: ColorConstant.whiteA70001,
                                    elevation: 4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: HeaderText(
                                                //DateTime.now().formatdMMMMY(),
                                                "Booking Slots"),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 0),
                                          child: CalendarTimeline(
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now()
                                                .add(const Duration(days: 360)),
                                            onDateSelected: (date) {
                                              final DateFormat formatter =
                                                  DateFormat('dd-MM-yyyy');
                                              SharedPrefUtils.readPrefStr(
                                                          "role") ==
                                                      "DOCTOR"
                                                  ? controller
                                                      .callGetAppointmentDetailsForDateByExaminerId(
                                                          formatter
                                                              .format(date))
                                                  : controller
                                                      .callGetAppointmentDetailsForDate(
                                                          formatter
                                                              .format(date));
                                              controller
                                                  .getAppointmentDetailsByDate
                                                  .value = [];
                                              controller
                                                  .getAppointmentDetailsByDate
                                                  .refresh();
                                            },
                                            monthColor: Colors.blueGrey,
                                            dayColor: Colors.black,
                                            activeDayColor: Colors.white,
                                            activeBackgroundDayColor:
                                                ColorConstant.blue60001,
                                            dotsColor: Colors.white,
                                            locale: 'en_ISO',
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Obx(() => controller
                                                .isloadingStaffData.value
                                            ? const SizedBox(
                                                height: 200,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              )
                                            : controller.getAppointmentDetailsByDate
                                                        .value ==
                                                    []
                                                ? const SizedBox(
                                                    height: 100,
                                                  )
                                                : Align(
                                                    alignment: Alignment.center,
                                                    child: Wrap(
                                                        runSpacing:
                                                            getVerticalSize(5),
                                                        spacing:
                                                            getHorizontalSize(
                                                                5),
                                                        children: List.generate(
                                                            controller.times
                                                                    ?.length ??
                                                                0, (index) {
                                                          return controller
                                                                      .getAppointmentDetailsByDate
                                                                      .where(
                                                                          (e) {
                                                                    return TimeCalculationUtils().startTimeCalCulation(
                                                                            e.startTime,
                                                                            e.updateTimeInMin) ==
                                                                        controller.times![index];
                                                                  }).length >
                                                                  1
                                                              ? Badge(
                                                                  offset:
                                                                      const Offset(
                                                                          -1,
                                                                          1),
                                                                  label: Text(controller
                                                                      .getAppointmentDetailsByDate
                                                                      .where(
                                                                          (e) {
                                                                        return TimeCalculationUtils().startTimeCalCulation(e.startTime,
                                                                                e.updateTimeInMin) ==
                                                                            controller.times![index];
                                                                      })
                                                                      .length
                                                                      .toString()),
                                                                  child: Container(
                                                                      height: 40,
                                                                      width: 100,
                                                                      margin: const EdgeInsets.all(5),
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(
                                                                          color: controller.getAppointmentDetailsByDate.firstWhereOrNull((element) {
                                                                                    return TimeCalculationUtils().startTimeCalCulation(element.startTime, element.updateTimeInMin) == controller.times![index];
                                                                                  }) !=
                                                                                  null
                                                                              ? Colors.blue
                                                                              : Colors.grey.shade100,
                                                                          borderRadius: BorderRadius.circular(6),
                                                                          border: Border.all(
                                                                              color: controller.getAppointmentDetailsByDate.firstWhereOrNull((element) {
                                                                                        return TimeCalculationUtils().startTimeCalCulation(element.startTime, element.updateTimeInMin) == controller.times![index];
                                                                                      }) !=
                                                                                      null
                                                                                  ? Colors.transparent
                                                                                  : Colors.black)),
                                                                      child: Text(
                                                                        controller.times?[index] ??
                                                                            "",
                                                                        style: TextStyle(
                                                                            color: controller.getAppointmentDetailsByDate.firstWhereOrNull((element) {
                                                                                      return TimeCalculationUtils().startTimeCalCulation(element.startTime, element.updateTimeInMin) == controller.times![index];
                                                                                    }) !=
                                                                                    null
                                                                                ? Colors.white
                                                                                : Colors.black),
                                                                      )),
                                                                )
                                                              : Container(
                                                                  height: 40,
                                                                  width: 100,
                                                                  margin:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      color: controller.getAppointmentDetailsByDate.firstWhereOrNull((element) {
                                                                                return TimeCalculationUtils().startTimeCalCulation(element.startTime, element.updateTimeInMin) == controller.times![index];
                                                                              }) !=
                                                                              null
                                                                          ? Colors.blue
                                                                          : Colors.grey.shade100,
                                                                      borderRadius: BorderRadius.circular(6),
                                                                      border: Border.all(
                                                                          color: controller.getAppointmentDetailsByDate.firstWhereOrNull((element) {
                                                                                    return TimeCalculationUtils().startTimeCalCulation(element.startTime, element.updateTimeInMin) == controller.times![index];
                                                                                  }) !=
                                                                                  null
                                                                              ? Colors.transparent
                                                                              : Colors.black)),
                                                                  child: Text(
                                                                    controller.times?[
                                                                            index] ??
                                                                        "",
                                                                    style: TextStyle(
                                                                        color: controller.getAppointmentDetailsByDate.firstWhereOrNull((element) {
                                                                                  return TimeCalculationUtils().startTimeCalCulation(element.startTime, element.updateTimeInMin) == controller.times![index];
                                                                                }) !=
                                                                                null
                                                                            ? Colors.white
                                                                            : Colors.black),
                                                                  ));
                                                        })),
                                                  )),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  const Text('Booked Slots'),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    height: 15,
                                                    width: 15,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Colors.blue,
                                                            shape: BoxShape
                                                                .circle),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Obx(() => Text(controller
                                                      .getAppointmentDetailsByDate
                                                      .length
                                                      .toString())),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const Text('Remaning Slots'),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    height: 15,
                                                    width: 15,
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade100,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.black,
                                                            width: 1)),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Obx(() => Text(((controller
                                                                  .times
                                                                  ?.length ??
                                                              0) -
                                                          controller
                                                              .getAppointmentDetailsByDate
                                                              .length)
                                                      .toString())),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
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
                                                  : controller.recentPatientList
                                                              .value !=
                                                          []
                                                      ? _RecentPatients(
                                                          data: controller
                                                                  .recentPatientList
                                                                  .value ??
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
                                  Card(
                                    elevation: 4,
                                    color: Colors.white,
                                    shadowColor: ColorConstant.gray400,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                                "Upcoming Appointments"),
                                          ),
                                          const SizedBox(height: kSpacing),
                                          Obx(() => controller
                                                  .isloadingStaffUpcomingAppointments
                                                  .value
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : (SharedPrefUtils.readPrefStr(
                                                          "role") ==
                                                      'PATIENT')
                                                  ? controller
                                                          .upComingAppointments
                                                          .isNotEmpty
                                                      ? UpcomingAppointments(
                                                          data: controller
                                                              .upComingAppointments)
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
                                                                  'No upcomming appointments found.',
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
                                                  : controller
                                                          .upComingAppointments
                                                          .isNotEmpty
                                                      ? UpcomingAppointments(
                                                          data: controller
                                                              .upComingAppointments)
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
                                                                  'No upcoming appointments found.',
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
                                                                .recentPatientList
                                                                .isNotEmpty
                                                            ? _RecentPatients(
                                                                data: controller
                                                                    .recentPatientList,
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
                                      : const SizedBox(),
                                  SharedPrefUtils.readPrefStr('role') ==
                                          'PATIENT'
                                      ? const SizedBox()
                                      : Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          elevation: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 20),
                                                const Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: HeaderText(
                                                      //DateTime.now().formatdMMMMY(),
                                                      "Booking Slots"),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 10, 10, 0),
                                                  child: CalendarTimeline(
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime.now()
                                                        .add(const Duration(
                                                            days: 360)),
                                                    onDateSelected: (date) {
                                                      final DateFormat
                                                          formatter =
                                                          DateFormat(
                                                              'dd-MM-yyyy');
                                                      controller
                                                          .callGetAppointmentDetailsForDate(
                                                              formatter.format(
                                                                  date));
                                                      controller
                                                          .getAppointmentDetailsByDate
                                                          .value = [];
                                                      controller
                                                          .getAppointmentDetailsByDate
                                                          .refresh();
                                                    },
                                                    monthColor: Colors.blueGrey,
                                                    dayColor: Colors.black,
                                                    activeDayColor:
                                                        Colors.white,
                                                    activeBackgroundDayColor:
                                                        ColorConstant.blue60001,
                                                    dotsColor: Colors.white,
                                                    locale: 'en_ISO',
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Obx(() => controller
                                                        .isloadingStaffData
                                                        .value
                                                    ? const SizedBox(
                                                        height: 200,
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      )
                                                    : controller.getAppointmentDetailsByDate
                                                                .value ==
                                                            []
                                                        ? const SizedBox(
                                                            height: 100,
                                                          )
                                                        : Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Wrap(
                                                                runSpacing:
                                                                    getVerticalSize(
                                                                        5),
                                                                spacing:
                                                                    getHorizontalSize(
                                                                        5),
                                                                children: List.generate(
                                                                    controller
                                                                            .times
                                                                            ?.length ??
                                                                        0,
                                                                    (index) {
                                                                  return Container(
                                                                      height:
                                                                          40,
                                                                      width:
                                                                          100,
                                                                      margin:
                                                                          const EdgeInsets.all(
                                                                              5),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: controller.getAppointmentDetailsByDate.any((element) {
                                                                            return TimeCalculationUtils().startTimeCalCulation(element.startTime, element.updateTimeInMin).contains(controller.times?[index].toString() ??
                                                                                "");
                                                                          })
                                                                              ? Colors.blue
                                                                              : Colors.grey.shade100,
                                                                          borderRadius: BorderRadius.circular(6),
                                                                          border: Border.all(
                                                                              color: controller.getAppointmentDetailsByDate.any((element) {
                                                                            return TimeCalculationUtils().startTimeCalCulation(element.startTime, element.updateTimeInMin).contains(controller.times?[index].toString() ??
                                                                                "");
                                                                          })
                                                                                  ? Colors.transparent
                                                                                  : Colors.black)),
                                                                      child: Text(
                                                                        controller.times?[index] ??
                                                                            "",
                                                                        style: TextStyle(
                                                                            color: controller.getAppointmentDetailsByDate.any((element) {
                                                                          return TimeCalculationUtils()
                                                                              .startTimeCalCulation(element.startTime, element.updateTimeInMin)
                                                                              .contains(controller.times?[index].toString() ?? "");
                                                                        })
                                                                                ? Colors.white
                                                                                : Colors.black),
                                                                      ));
                                                                })),
                                                          )),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                            'Booked Slots'),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          height: 15,
                                                          width: 15,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Colors
                                                                      .blue,
                                                                  shape: BoxShape
                                                                      .circle),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Obx(() => Text(controller
                                                            .getAppointmentDetailsByDate
                                                            .length
                                                            .toString())),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        const Text(
                                                            'Remaning Slots'),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          height: 15,
                                                          width: 15,
                                                          decoration: BoxDecoration(
                                                              color: Colors.grey
                                                                  .shade100,
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 1)),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Obx(() => Text(((controller
                                                                        .times
                                                                        ?.length ??
                                                                    0) -
                                                                controller
                                                                    .getAppointmentDetailsByDate
                                                                    .length)
                                                            .toString())),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(width: kSpacing),
                            Obx(
                              () => SizedBox(
                                width: 250,
                                child: Card(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
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
                                                SharedPrefUtils.readPrefStr(
                                                            "role") ==
                                                        'PATIENT'
                                                    ? (controller
                                                                .patientTodaysData
                                                                .value
                                                                .indexOf(controller
                                                                    .currentPatientAppointmentData
                                                                    .value) +
                                                            1)
                                                        .toString()
                                                    : (controller
                                                                .staffTodaysData
                                                                .value
                                                                .indexOf(controller
                                                                    .currentStaffAppointmentData
                                                                    .value) +
                                                            1)
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
                                          SharedPrefUtils.readPrefStr("role") ==
                                                  'PATIENT'
                                              ? '${controller.currentPatientAppointmentData.value.patient?.firstName ?? ''} ${controller.currentPatientAppointmentData.value.patient?.lastName ?? ''}'
                                              : '${controller.currentStaffAppointmentData.value.patient?.firstName ?? ''} ${controller.currentStaffAppointmentData.value.patient?.lastName ?? ''}',
                                          style: TextStyle(
                                              color: Colors.yellow.shade800,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          SharedPrefUtils.readPrefStr("role") ==
                                                  'PATIENT'
                                              ? '${controller.currentPatientAppointmentData.value.patient?.sex ?? ''}'
                                                  '${controller.currentStaffAppointmentData.value.patient?.sex ?? ''}'
                                              : '',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          "Blood group - ${SharedPrefUtils.readPrefStr("role") == 'PATIENT' ? controller.currentPatientAppointmentData.value.patient?.bloodType ?? '' : controller.currentStaffAppointmentData.value.patient?.bloodType ?? ''}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          "Address - ${SharedPrefUtils.readPrefStr("role") == 'PATIENT' ? controller.currentPatientAppointmentData.value.patient?.address ?? '' : controller.currentStaffAppointmentData.value.patient?.address ?? ''}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          "Contact - ${SharedPrefUtils.readPrefStr("role") == 'PATIENT' ? controller.currentPatientAppointmentData.value.patient?.mobile ?? '' : controller.currentStaffAppointmentData.value.patient?.mobile ?? ''}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ),
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
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CustomTextFormField(
              labelText: "Patient name",
              controller: controller.nameController,
              isRequired: true,
              padding: TextFormFieldPadding.PaddingT14,
              validator: (value) {
                return controller.firstNameValidator(value ?? "");
              },
              textInputType: TextInputType.emailAddress,
              prefixConstraints:
                  BoxConstraints(maxHeight: getVerticalSize(56))),
          const SizedBox(
            height: 15.0,
          ),
          CustomTextFormField(
            labelText: 'Patient mobile Number',
            controller: controller.mobileController,
            textInputAction: TextInputAction.done,
            isRequired: true,
            maxLength: 10,
            textInputType: TextInputType.phone,
            validator: (value) {
              return controller.numberValidator(value ?? "");
            },
            padding: TextFormFieldPadding.PaddingT14,
            prefixConstraints: BoxConstraints(maxHeight: getVerticalSize(56)),
          ),
          // TextField(
          //   controller: controller.mobileController,
          //   keyboardType: TextInputType.text,
          //   maxLines: 1,
          //   decoration: const InputDecoration(
          //       labelText: 'Patient mobile no.',
          //       label: isForExistingPatient == true
          //           ? Obx(() => Text(
          //               controller.patientData.value.patient?.mobile.toString() ??
          //                   ''))
          //           : null,
          //       hintMaxLines: 1,
          //       border: OutlineInputBorder(
          //           borderSide: BorderSide(color: Colors.green, width: 4.0))),
          // ),
          const SizedBox(
            height: 15.0,
          ),
          CustomTextFormField(
              labelText: "Patient's Email",
              controller: controller.addressController,
              isRequired: true,
              padding: TextFormFieldPadding.PaddingT14,
              textInputType: TextInputType.emailAddress,
              validator: (value) {
                return controller.emailValidator(value ?? "");
              },
              prefixConstraints:
                  BoxConstraints(maxHeight: getVerticalSize(56))),
          const SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: () {
              bool a = controller.trySubmit();
              if (a) {
                isForExistingPatient == true
                    ? onTapBookEmergencyAppointment("existing")
                    : onTapBookEmergencyAppointment("new");
              }

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
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900),
            child: Text(
              isForExistingPatient == true ? 'Submit' : 'Add Patient',
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          )
        ],
      ),
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
      child: PatientsList(
        data: controller.getAllPatientsList,
        doctorsList: controller.doctorsList,
      ),
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

  Widget _buildStaffListPageContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: StaffList(),
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
                    // : controller.getEmergencyPatientsList.value.isEmpty
                    //     ? loadEmptyWidget()
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
      packageImage: PackageImage.Image_3,
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
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/bg-img-01.png',
                ),
                fit: BoxFit.contain,
                alignment: Alignment.centerRight)),
        child: ResponsiveBuilder.isMobile(context)
            // ||
            //         ResponsiveBuilder.isTablet(context)
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
                              ? '' //controller.patientNumber.toString()
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
              child: ResponsiveBuilder.isMobile(Get.context!)
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
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xff013f88)),
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
                            const SizedBox(
                              width: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xff013f88)),
                                  child: const Icon(
                                      Icons.person_outline_outlined,
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
                            const SizedBox(
                              width: 20,
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
                                        size: 40,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Countup(
                                          begin: 0,
                                          end: double.parse(controller
                                              .staffTodaysCompletedData.length
                                              .toString()),
                                          duration: const Duration(seconds: 2),
                                          separator: ',',
                                          style: TextStyle(
                                            fontSize: Responsive.isDesktop(
                                                    Get.context!)
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
                    ),
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
