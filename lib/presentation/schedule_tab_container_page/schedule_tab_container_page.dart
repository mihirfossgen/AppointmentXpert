import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../network/api/appointment_api.dart';
import '../../theme/app_style.dart';
import '../dashboard_screen/controller/dashboard_controller.dart';
import '../schedule_page/controller/schedule_controller.dart';
import '../schedule_page/schedule_page.dart';
import 'controller/schedule_tab_container_controller.dart';

class ScheduleTabContainerPage extends StatelessWidget {
  ScheduleTabContainerController controller =
      Get.put(ScheduleTabContainerController());

  AppointmentApi api = Get.put(AppointmentApi());
  ScheduleController scheduleController = Get.put(ScheduleController());
  @override
  Widget build(BuildContext context) {
    DashboardController dashboardController = Get.find();
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      scheduleController.onClose();
                      scheduleController.onReady();
                    },
                    child: Card(
                      color: ColorConstant.blue700,
                      elevation: 4,
                      shadowColor: ColorConstant.gray400,
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 150,
                        child: Text(
                          'Refresh',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppStyle.txtRalewayRomanMedium14WhiteA700,
                        ),
                      ),
                    ),
                  ),
                ),
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
                    onTap: (value) {
                      print(value);
                    },
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
                    height: getVerticalSize(MediaQuery.of(context).size.height),
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
      ),
    );
  }
}
