library dashboard;

import 'package:cached_network_image/cached_network_image.dart';

import 'package:data_table_2/data_table_2.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
import '../../controller/dashboard_controller.dart';
import '../../shared_components/card_appointment.dart';
import '../../shared_components/header_text.dart';
import '../../shared_components/list_recent_patient.dart';
import '../../shared_components/list_task_date.dart';
import '../../shared_components/responsive_builder.dart';
import '../../shared_components/selection_button.dart';
import '../../shared_components/simple_selection_button.dart';
import '../../shared_components/simple_user_profile.dart';
import '../../shared_components/task_progress.dart';
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

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

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
    } else {
      switch (index) {
        case 0:
          return _buildHomePageContent(context: context);
        case 1:
          return _buildAppointmentPageContent();
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
      floatingActionButton: (SharedPrefUtils.readPrefStr("role") == 'PATIENT')
          ? (ResponsiveBuilder.isMobile(context) ||
                  ResponsiveBuilder.isTablet(context))
              ? Obx(() => controller.selectedPageIndex.value == 0
                  ? FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () {
                        // Get.toNamed(AppRoutes.doctorDetailScreen,
                        //     arguments: DoctorDetailsArguments(
                        //         controller
                        //                 .getAllEmployesList.value.doctorList ??
                        //             [],
                        //         controller.patientData.value.patient));
                      },
                    )
                  : SizedBox())
              : SizedBox()
          : SizedBox(),
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
                  Obx(
                    () => controller.selectedPageIndex.value == 0
                        ? _buildCalendarContent()
                        : Container(),
                  )
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
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const VerticalDivider(),
                ),
                Obx(
                  () => controller.selectedPageIndex.value == 0
                      ? Flexible(
                          flex: 4,
                          child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: _buildCalendarContent(),
                          ),
                        )
                      : Container(),
                ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: constraints.maxWidth > 1350 ? 3 : 4,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: _buildSidebar(context),
                  ),
                ),
                Flexible(
                  flex: constraints.maxWidth > 1350 ? 10 : 9,
                  child: Obx(() =>
                      loadBody(controller.selectedPageIndex.value, context)),
                ),
                Obx(() => controller.selectedPageIndex.value == 0
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const VerticalDivider(),
                      )
                    : Container()),
                Obx(
                  () => controller.selectedPageIndex.value == 0
                      ? Flexible(
                          flex: 4,
                          child: SingleChildScrollView(
                              controller: ScrollController(),
                              child: _buildCalendarContent()),
                        )
                      : Container(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return SizedBox(
      //width: 300,
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
          const SizedBox(height: kSpacing),
          Padding(
            padding: const EdgeInsets.all(kSpacing),
            child: Text(
              "2023 Fossgentechnologies Pvt Ltd.",
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomePageContent(
      {Function()? onPressedMenu, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
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
                                      width: MediaQuery.of(context).size.width,
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
                                style:
                                    TextStyle(color: ColorConstant.whiteA700)),
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
              Get.context!)),
          const SizedBox(height: kSpacing),
          Row(
            children: [
              const Expanded(
                child: HeaderText(
                    //DateTime.now().formatdMMMMY(),
                    "Today's Appointments"),
              ),
              const SizedBox(width: kSpacing / 2),
              SizedBox(
                width: 200,
                child: Obx(() =>
                    (SharedPrefUtils.readPrefStr("role") == 'PATIENT')
                        ? AppointmentProgress(
                            data: TodaysAppointmentsProgressData(
                                totalAppointments:
                                    controller.patientTodaysData.length,
                                totalCompleted: 0))
                        : AppointmentProgress(
                            data: TodaysAppointmentsProgressData(
                                totalAppointments:
                                    controller.staffTodaysData.length,
                                totalCompleted: 0))),
              ),
            ],
          ),
          const SizedBox(height: kSpacing),
          Obx(() => controller.isloading.value
              ? Center(child: CircularProgressIndicator())
              : (SharedPrefUtils.readPrefStr("role") == 'PATIENT')
                  ? controller.patientTodaysData.isNotEmpty
                      ? _AppointmentInProgress(
                          data: controller.patientTodaysData)
                      : Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                      ? _AppointmentInProgress(data: controller.staffTodaysData)
                      : Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(height: kSpacing),
          (SharedPrefUtils.readPrefStr("role") != 'PATIENT')
              //? SharedPrefUtils.readPrefStr("role") == 'RECEPTIONIST'
              ? const _HeaderRecentPatients()
              : Container(),
          //: Container(),
          //const SizedBox(height: kSpacing),
          (SharedPrefUtils.readPrefStr("role") != 'PATIENT')
              //? (SharedPrefUtils.readPrefStr("role") == 'RECEPTIONIST')
              ? Obx(() => controller.isloading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.getAllPatientsList.isNotEmpty
                      ? _RecentPatients(
                          data: controller.getAllPatientsList,
                          onPressed: controller.onPressedPatient,
                          // onPressedAssign: controller.onPressedAssignTask,
                          // onPressedMember: controller.onPressedMemberTask,
                        )
                      : Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
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
          //: Container()
        ],
      ),
    );
  }

  Widget _buildAppointmentPageContent({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Row(
          //   children: [
          //     if (onPressedMenu != null)
          //       Padding(
          //         padding: const EdgeInsets.only(right: kSpacing / 2),
          //         child: IconButton(
          //           onPressed: onPressedMenu,
          //           icon: const Icon(Icons.menu),
          //         ),
          //       ),
          //     // Expanded(
          //     //   child: SearchField(
          //     //     onSearch: controller.searchTask,
          //     //     hintText: "Search.. ",
          //     //   ),
          //     // ),
          //   ],
          // ),
          // const SizedBox(height: kSpacing),
          // Container(
          //   width: MediaQuery.of(Get.context!).size.width,
          //   height: MediaQuery.of(Get.context!).size.height - 10,
          //   //color: Colors.red,
          //   child: ScheduleTabContainerPage(),
          // )
        ],
      ),
    );
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
          // child:
          //  ProfilePage(
          //     controller.staffData.value, controller.patientData.value),
          // child: SharedPrefUtils.readPrefStr("role") == 'PATIENT'
          //     ? CreateProfileScreen()
          //     : ProfilePage(controller.staffData.value),
          height: MediaQuery.of(Get.context!).size.height,
        ));
  }

  Widget _buildPatientsListPageContent({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        children: [
          // const SizedBox(height: kSpacing),
          // Row(
          //   children: [
          //     if (onPressedMenu != null)
          //       Padding(
          //         padding: const EdgeInsets.only(right: kSpacing / 2),
          //         child: IconButton(
          //           onPressed: onPressedMenu,
          //           icon: const Icon(Icons.menu),
          //         ),
          //       ),
          //     // Expanded(
          //     //   child: SearchField(
          //     //     onSearch: controller.searchTask,
          //     //     hintText: "Search.. ",
          //     //   ),
          //     // ),
          //   ],
          // ),
          //const SizedBox(height: kSpacing),
          Container(
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
      String firstName, String lastName, String role, BuildContext context) {
    return Container(
      // width: sizingInformation.screenSize.width,
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadowColor: Colors.grey.shade400,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    controller.greeting(),
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: Responsive.isDesktop(context) ? 30 : 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins"),
                  ),
                  role == "PATIENT"
                      ? Text(
                          "${firstName} ${lastName}",
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: Responsive.isDesktop(context) ? 30 : 18,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          (SharedPrefUtils.readPrefStr('role') == "DOCTOR")
                              ? 'Dr.' + "${firstName} ${lastName}"
                              : "${firstName} ${lastName}",
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: Responsive.isDesktop(context) ? 30 : 18,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Have a nice day at work",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: ColorConstant.gray600),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
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
