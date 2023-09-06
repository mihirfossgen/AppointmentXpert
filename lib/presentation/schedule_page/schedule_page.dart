import 'package:appointmentxpert/presentation/dashboard_screen/shared_components/responsive_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/app_export.dart';
import '../../core/utils/size_utils.dart';
import '../../models/getAllApointments.dart';
import '../../models/getallAppointbypoatientidModel.dart';
import '../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../theme/app_style.dart';
import '../../widgets/responsive.dart';
import 'controller/schedule_controller.dart';
import 'widgets/schedule_item_widget.dart';

class SchedulePage extends GetWidget<ScheduleController> {
  final String tab;
  SchedulePage(this.tab, {super.key});

  @override
  ScheduleController controller = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return ListView(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? Obx(() => Padding(
                  padding: getPadding(left: 0, top: 12, right: 0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 1.4,
                    child: Responsive.isMobile(context) ||
                            Responsive.isTablet(context)
                        ? controller.isloading.value
                            ? const Center(child: CircularProgressIndicator())
                            : GridView.builder(
                                shrinkWrap: true,
                                // showNewPageProgressIndicatorAsGridChild:
                                //     false,
                                // showNewPageErrorIndicatorAsGridChild:
                                //     false,
                                // showNoMoreItemsIndicatorAsGridChild:
                                //     false,
                                itemCount: tab.toLowerCase() == 'today'
                                    ? controller.todayAppointments.value.length
                                    : tab.toLowerCase() == 'upcoming'
                                        ? controller
                                            .upcomingAppointments.value.length
                                        : controller
                                            .completedAppointments.value.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: tab.toLowerCase() ==
                                          'completed'
                                      ? ResponsiveBuilder.isMobile(context)
                                          ? MediaQuery.of(context).size.width /
                                              (MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5.7)
                                          : 1.9
                                      : ResponsiveBuilder.isMobile(context)
                                          ? MediaQuery.of(context).size.width /
                                              (MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4.0)
                                          : 1.5,
                                  // tab.toLowerCase() == 'completed'
                                  //     ? ResponsiveBuilder.isMobile(
                                  //             context)
                                  //         ? 100 / 45
                                  //         : 100 / 50
                                  //     : ResponsiveBuilder.isMobile(
                                  //             context)
                                  //         ? 100 / 55
                                  //         : 100 / 70,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount:
                                      ResponsiveBuilder.isMobile(context)
                                          ? 1
                                          : ResponsiveBuilder.isTablet(context)
                                              ? 2
                                              : 3,
                                ),
                                itemBuilder: (context, index) {
                                  AppointmentContent item;
                                  if (tab.toLowerCase() == 'today') {
                                    item = controller
                                        .todayAppointments.value[index];
                                  } else if (tab.toLowerCase() == 'upcoming') {
                                    item = controller
                                        .upcomingAppointments.value[index];
                                  } else {
                                    item = controller
                                        .completedAppointments.value[index];
                                  }
                                  return ScheduleItemWidget(
                                      item,
                                      item.patient?.id ?? 0,
                                      item.examiner?.id ?? 0,
                                      tab);
                                },
                                // firstPageErrorIndicatorBuilder: (_) =>
                                //     FirstPageErrorIndicator(
                                //   error: _pagingController.error,
                                //   onTryAgain: () =>
                                //       _pagingController.refresh(),
                                // ),
                                // newPageErrorIndicatorBuilder: (_) =>
                                //     NewPageErrorIndicator(
                                //   error: _pagingController.error,
                                //   onTryAgain: () => _pagingController
                                //       .retryLastFailedRequest(),
                                // ),
                                // firstPageProgressIndicatorBuilder: (_) =>
                                //     FirstPageProgressIndicator(),
                                // newPageProgressIndicatorBuilder: (_) =>
                                //     NewPageProgressIndicator(),
                                // noItemsFoundIndicatorBuilder: (_) =>
                                //     loadEmptyWidget(),
                                //     const Text(
                                //   'No appointments found.',
                                //   textAlign: TextAlign.center,
                                // ),
                                // noMoreItemsIndicatorBuilder: (_) =>
                                //     const Padding(
                                //   padding: EdgeInsets.all(28.0),
                                //   child: Text(
                                //     'No more appointments.',
                                //     textAlign: TextAlign.center,
                                //   ),
                                // ),
                              )
                        //loadStaffAppointmentList()
                        : loadStaffAppointmentsDataTable(),
                  ),
                ))
            : Obx(() => Padding(
                padding: getPadding(left: 0, top: 12, right: 0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Responsive.isMobile(context) ||
                          Responsive.isTablet(context)
                      ? controller.isloading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              // showNewPageProgressIndicatorAsGridChild:
                              //     false,
                              // showNewPageErrorIndicatorAsGridChild: false,
                              // showNoMoreItemsIndicatorAsGridChild: false,
                              itemCount: tab.toLowerCase() == 'today'
                                  ? controller.todayAppointments.value.length
                                  : tab.toLowerCase() == 'upcoming'
                                      ? controller
                                          .upcomingAppointments.value.length
                                      : controller
                                          .completedAppointments.value.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: tab.toLowerCase() ==
                                        'completed'
                                    ? ResponsiveBuilder.isMobile(context)
                                        ? MediaQuery.of(context).size.width /
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                5.7)
                                        : 1.9
                                    : ResponsiveBuilder.isMobile(context)
                                        ? MediaQuery.of(context).size.width /
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4.0)
                                        : 1.5,
                                // tab.toLowerCase() == 'completed'
                                //     ? 100 / 50
                                //     : 100 / 70,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount:
                                    ResponsiveBuilder.isMobile(context)
                                        ? 1
                                        : ResponsiveBuilder.isTablet(context)
                                            ? 2
                                            : 3,
                              ),
                              itemBuilder: (context, index) {
                                AppointmentContent item;
                                if (tab.toLowerCase() == 'today') {
                                  item =
                                      controller.todayAppointments.value[index];
                                } else if (tab.toLowerCase() == 'upcoming') {
                                  item = controller
                                      .upcomingAppointments.value[index];
                                } else {
                                  item = controller
                                      .completedAppointments.value[index];
                                }
                                return ScheduleItemWidget(
                                    item,
                                    item.patient?.id ?? 0,
                                    item.examiner?.id ?? 0,
                                    tab);
                              },
                            )
                      //loadPatientAppointmentsList()
                      : loadPatientAppointmentsDataTable(),
                )))
      ],
    );
  }

  Widget loadEmptyWidget() {
    return EmptyWidget(
      image: null,
      hideBackgroundAnimation: true,
      packageImage: PackageImage.Image_3,
      title: 'No data',
      subTitle: 'No $tab appointments found.',
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

  Widget loadPatientAppointmentsDataTable() {
    final DateFormat formatter = DateFormat.yMMMEd();
    List<AppointmentContent>? appointments = tab.toLowerCase() == 'today'
        ? controller.todayAppointments.value
        : tab.toLowerCase() == 'upcoming'
            ? controller.upcomingAppointments.value
            : controller.completedAppointments.value;
    return SizedBox(
        height: 400,
        child: Card(
          child: SizedBox(
            height: 400,
            width: MediaQuery.of(Get.context!).size.width,
            child: appointments == null && appointments!.isEmpty
                ? loadEmptyWidget()
                : PaginatedDataTable2(
                    columnSpacing: 56,
                    horizontalMargin: 30,
                    source: MyData(appointments, true),
                    sortAscending: false,
                    header: const Text('Appointments'),
                    columns: [
                      DataColumn2(
                        label: Text(
                          'Doctor Name',
                          style: AppStyle.txtInterSemiBold14,
                        ),
                        size: ColumnSize.L,
                      ),
                      DataColumn(
                        label: Text(
                          'Mobile',
                          textAlign: TextAlign.center,
                          style: AppStyle.txtInterSemiBold14,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Status',
                          style: AppStyle.txtInterSemiBold14,
                        ),
                      ),
                      DataColumn2(
                          label: Text(
                            'Note',
                            style: AppStyle.txtInterSemiBold14,
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          fixedWidth: 150),
                      DataColumn(
                        label: Text(
                          'Date',
                          style: AppStyle.txtInterSemiBold14,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Time',
                          style: AppStyle.txtInterSemiBold14,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Action',
                          style: AppStyle.txtInterSemiBold14,
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }

  Widget loadStaffAppointmentsDataTable() {
    final DateFormat formatter = DateFormat.yMMMEd();
    List<AppointmentContent>? appointments = tab.toLowerCase() == 'today'
        ? controller.todayAppointments.value
        : tab.toLowerCase() == 'upcoming'
            ? controller.upcomingAppointments.value
            : controller.completedAppointments.value;
    return Card(
      child: SizedBox(
        height: 500,
        child: appointments.isEmpty
            ? loadEmptyWidget()
            : PaginatedDataTable2(
                sortAscending: false,
                columnSpacing: 50,
                horizontalMargin: 30,
                //header: HeaderText('${tab.toUpperCase()} Appointments'),
                rowsPerPage: 10,
                columns: [
                  DataColumn2(
                    label: Text(
                      'Patient Name',
                      textAlign: TextAlign.center,
                      style: AppStyle.txtInterSemiBold14,
                    ),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text(
                      'Doctor Name',
                      textAlign: TextAlign.center,
                      style: AppStyle.txtInterSemiBold14,
                    ),
                    size: ColumnSize.L,
                  ),
                  DataColumn(
                    label: Text(
                      'Mobile',
                      textAlign: TextAlign.center,
                      style: AppStyle.txtInterSemiBold14,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Purpose',
                      textAlign: TextAlign.center,
                      style: AppStyle.txtInterSemiBold14,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Date ',
                      textAlign: TextAlign.center,
                      style: AppStyle.txtInterSemiBold14,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Time',
                      textAlign: TextAlign.center,
                      style: AppStyle.txtInterSemiBold14,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Actions',
                      textAlign: TextAlign.center,
                      style: AppStyle.txtInterSemiBold14,
                    ),
                    //numeric: true,
                    size: ColumnSize.L,
                  ),
                ],
                source: MyData(appointments, false),
              ),
      ),
    );
  }
}

class AppointmentDetailsArguments {
  AppointmentContent? model1;
  Datum? model2;
  int appointmentid;
  AppointmentDetailsArguments(this.model1, this.model2, this.appointmentid);
}

class _ErrorAndRetry extends StatelessWidget {
  const _ErrorAndRetry(this.errorMessage, this.retry);

  final String errorMessage;
  final void Function() retry;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
            padding: const EdgeInsets.all(10),
            height: 70,
            color: Colors.red,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Oops! $errorMessage',
                      style: const TextStyle(color: Colors.white)),
                  TextButton(
                      onPressed: retry,
                      child:
                          const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        Text('Retry', style: TextStyle(color: Colors.white))
                      ]))
                ])),
      );
}
