import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../network/api/appointment_api.dart';
import '../schedule_page/schedule_page.dart';
import 'controller/schedule_tab_container_controller.dart';

class ScheduleTabContainerPage extends StatelessWidget {
  ScheduleTabContainerController controller =
      Get.put(ScheduleTabContainerController());
  //DashboardController dashboardController = Get.find();
  AppointmentApi api = Get.put(AppointmentApi());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Get.to(AppointmentBookingScreen(
            //     patientDetailsArguments: PatientDetailsArguments(
            //         dashboardController.getAllEmployesList.value.doctorList ??
            //             [],
            //         dashboardController.patientData.value.patient)));
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        backgroundColor: ColorConstant.whiteA700,
        body: SizedBox(
          width: double.maxFinite,
          //height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
                child: TabBar(
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
                  height:
                      getVerticalSize(MediaQuery.of(context).size.height - 150),
                  //height: 600,
                  child: TabBarView(
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
        ),
      ),
    );
  }
}
