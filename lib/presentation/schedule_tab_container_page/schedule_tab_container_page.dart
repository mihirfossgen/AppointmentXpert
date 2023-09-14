import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../core/app_export.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../network/api/appointment_api.dart';
import '../../shared_prefrences_page/shared_prefrence_page.dart';
import '../dashboard_screen/controller/dashboard_controller.dart';
import '../schedule_page/controller/schedule_controller.dart';
import '../schedule_page/schedule_page.dart';
import 'controller/schedule_tab_container_controller.dart';

class ScheduleTabContainerPage extends StatelessWidget {
  ScheduleTabContainerController controller =
      Get.put(ScheduleTabContainerController());

  AppointmentApi api = Get.put(AppointmentApi());
  ScheduleController scheduleController = Get.put(ScheduleController());
  DashboardController dashboardController = Get.put(DashboardController());

  ScheduleTabContainerPage({super.key});
  @override
  Widget build(BuildContext context) {
    //DashboardController dashboardController = Get.find();
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Get.to(AppointmentBookingScreen(
        //         patientDetailsArguments: PatientDetailsArguments(
        //             [], dashboardController.patientData.value.patient)));
        //   },
        //   child: const Icon(Icons.add),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        backgroundColor: ColorConstant.whiteA700,
        body: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          child: LiquidPullToRefresh(
            showChildOpacityTransition: false,
            onRefresh: () async {
              String a = SharedPrefUtils.readPrefStr('role');
              // scheduleController.onClose();
              // scheduleController.onReady();

              //pagingController.addPageRequestListener((pageKey) {
              if (a == "PATIENT") {
                //SharedPrefUtils.readPrefINt('employee_Id')
                scheduleController.isloading.value = true;
                scheduleController.callGetAllAppointmentsForPatient(0);
              } else if (a == "DOCTOR") {
                scheduleController.isloading.value = true;
                scheduleController.callGetAllAppointmentsByStaffId(0, 20);
              } else {
                scheduleController.isloading.value = true;
                scheduleController.callGetAllAppointments(0, 20);
              }
            },
            child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Container(
                        height: getVerticalSize(
                          46,
                        ),
                        // width: getHorizontalSize(
                        //   100,
                        // ),
                        margin: getMargin(
                          top: 2,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.gray10002,
                          borderRadius: BorderRadius.circular(
                            getHorizontalSize(
                              8,
                            ),
                          ),
                        ),
                        child: SharedPrefUtils.readPrefStr('role') == "PATIENT"
                            ? TabBar(
                                controller: controller.group126Controller,
                                labelColor: ColorConstant.whiteA700,
                                labelStyle: TextStyle(
                                  fontSize: getFontSize(
                                    14,
                                  ),
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                ),
                                unselectedLabelColor: ColorConstant.gray90001,
                                unselectedLabelStyle: TextStyle(
                                  fontSize: getFontSize(
                                    14,
                                  ),
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w400,
                                ),
                                indicator: BoxDecoration(
                                  color: ColorConstant.blue600,
                                  borderRadius: BorderRadius.circular(
                                    getHorizontalSize(
                                      8,
                                    ),
                                  ),
                                ),
                                onTap: (value) {},
                                tabs: [
                                  const Tab(
                                    child: Text(
                                      "Today",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      "lbl_upcoming".tr,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            : TabBar(
                                controller: controller.group125Controller,
                                labelColor: ColorConstant.whiteA700,
                                labelStyle: TextStyle(
                                  fontSize: getFontSize(
                                    14,
                                  ),
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                ),
                                unselectedLabelColor: ColorConstant.gray90001,
                                unselectedLabelStyle: TextStyle(
                                  fontSize: getFontSize(
                                    14,
                                  ),
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w400,
                                ),
                                indicator: BoxDecoration(
                                  color: ColorConstant.blue600,
                                  borderRadius: BorderRadius.circular(
                                    getHorizontalSize(
                                      8,
                                    ),
                                  ),
                                ),
                                onTap: (value) {},
                                tabs: [
                                  const Tab(
                                    child: Text(
                                      "Today",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      "lbl_upcoming".tr,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      "lbl_completed".tr,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      SizedBox(
                          height: getVerticalSize(
                              MediaQuery.of(context).size.height),
                          //height: 600,
                          child:
                              SharedPrefUtils.readPrefStr('role') == "PATIENT"
                                  ? TabBarView(
                                      //dragStartBehavior: DragStartBehavior.down,
                                      controller: controller.group126Controller,
                                      children: [
                                        SchedulePage("today"),
                                        SchedulePage("upcoming"),
                                      ],
                                    )
                                  : TabBarView(
                                      //dragStartBehavior: DragStartBehavior.down,
                                      controller: controller.group125Controller,
                                      children: [
                                        SchedulePage("today"),
                                        SchedulePage("upcoming"),
                                        SchedulePage("completed"),
                                      ],
                                    )),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
