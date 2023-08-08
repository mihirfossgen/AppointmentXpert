import 'package:appointmentxpert/presentation/dashboard_screen/shared_components/responsive_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
    return SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SharedPrefUtils.readPrefStr('role') != "PATIENT"
                ? Obx(() => Padding(
                      padding: getPadding(left: 0, top: 12, right: 0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Responsive.isMobile(context) ||
                                Responsive.isTablet(context)
                            ? controller.isloading.value
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : RefreshIndicator(
                                    onRefresh: () async {
                                      controller.todayPagingController.value
                                          .itemList = [];
                                      controller.upcomingPagingController.value
                                          .itemList = [];
                                      controller.completedPagingController.value
                                          .itemList = [];
                                      controller.isloading.value = true;
                                      controller.callGetAllAppointments(0, 20);
                                      /*Future.sync(
                                      () => tab.toLowerCase() == 'today'
                                          ? controller.todayPagingController
                                              .refresh()
                                          : tab.toLowerCase() == 'upcoming'
                                              ? controller
                                                  .upcomingPagingController
                                                  .refresh()
                                              : controller
                                                  .completedPagingController
                                                  .refresh(),
                                    );*/
                                    },
                                    child: SizedBox(
                                      height: Responsive.isMobile(context)
                                          ? MediaQuery.of(context).size.height *
                                              0.65
                                          : MediaQuery.of(context).size.height *
                                              0.75,
                                      child: PagedGridView<int,
                                          AppointmentContent>(
                                        shrinkWrap: true,
                                        showNewPageProgressIndicatorAsGridChild:
                                            false,
                                        showNewPageErrorIndicatorAsGridChild:
                                            false,
                                        showNoMoreItemsIndicatorAsGridChild:
                                            false,
                                        pagingController: tab.toLowerCase() ==
                                                'today'
                                            ? controller
                                                .todayPagingController.value
                                            : tab.toLowerCase() == 'upcoming'
                                                ? controller
                                                    .upcomingPagingController
                                                    .value
                                                : controller
                                                    .completedPagingController
                                                    .value,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 100 / 60,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          crossAxisCount:
                                              ResponsiveBuilder.isMobile(
                                                      context)
                                                  ? 1
                                                  : ResponsiveBuilder.isTablet(
                                                          context)
                                                      ? 2
                                                      : 3,
                                        ),
                                        builderDelegate:
                                            PagedChildBuilderDelegate<
                                                AppointmentContent>(
                                          animateTransitions: true,
                                          itemBuilder: (context, item, index) =>
                                              ScheduleItemWidget(
                                                  item,
                                                  item.patient?.id ?? 0,
                                                  item.examiner?.id ?? 0,
                                                  tab),
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
                                          noItemsFoundIndicatorBuilder: (_) =>
                                              loadEmptyWidget(),
                                          //     const Text(
                                          //   'No appointments found.',
                                          //   textAlign: TextAlign.center,
                                          // ),
                                          noMoreItemsIndicatorBuilder: (_) =>
                                              const Padding(
                                            padding: EdgeInsets.all(28.0),
                                            child: Text(
                                              'No more appointments.',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
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
                              : RefreshIndicator(
                                  onRefresh: () => Future.sync(
                                    () => tab.toLowerCase() == 'today'
                                        ? controller.todayPagingController
                                            .refresh()
                                        : tab.toLowerCase() == 'upcoming'
                                            ? controller
                                                .upcomingPagingController
                                                .refresh()
                                            : controller
                                                .completedPagingController
                                                .refresh(),
                                  ),
                                  child: PagedGridView<int, AppointmentContent>(
                                    shrinkWrap: true,
                                    showNewPageProgressIndicatorAsGridChild:
                                        false,
                                    showNewPageErrorIndicatorAsGridChild: false,
                                    showNoMoreItemsIndicatorAsGridChild: false,
                                    pagingController: tab.toLowerCase() ==
                                            'today'
                                        ? controller.todayPagingController.value
                                        : tab.toLowerCase() == 'upcoming'
                                            ? controller
                                                .upcomingPagingController.value
                                            : controller
                                                .completedPagingController
                                                .value,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 100 / 100,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: ResponsiveBuilder
                                              .isMobile(context)
                                          ? 1
                                          : ResponsiveBuilder.isTablet(context)
                                              ? 2
                                              : 3,
                                    ),
                                    builderDelegate: PagedChildBuilderDelegate<
                                        AppointmentContent>(
                                      animateTransitions: true,
                                      // noMoreItemsIndicatorBuilder: (context) {
                                      //   return loadEmptyWidget();
                                      // },
                                      // noItemsFoundIndicatorBuilder: (context) {
                                      //   return loadEmptyWidget();
                                      // },
                                      itemBuilder: (context, item, index) =>
                                          ScheduleItemWidget(
                                              item,
                                              item.patient?.id ?? 0,
                                              item.examiner?.id ?? 0,
                                              tab),
                                    ),
                                  ),
                                )
                          //loadPatientAppointmentsList()
                          : loadPatientAppointmentsDataTable(),
                    )))
          ],
        ));
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
        ? controller.todayPagingController.value.itemList
        : tab.toLowerCase() == 'upcoming'
            ? controller.upcomingPagingController.value.itemList
            : controller.completedPagingController.value.itemList;
    return SizedBox(
        height: 600,
        child: Card(
          child: SizedBox(
            height: 600,
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
                      DataColumn(
                        label: Text(
                          'Note',
                          style: AppStyle.txtInterSemiBold14,
                        ),
                      ),
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
        ? controller.todayPagingController.value.itemList
        : tab.toLowerCase() == 'upcoming'
            ? controller.upcomingPagingController.value.itemList
            : controller.completedPagingController.value.itemList;
    return Card(
      child: SizedBox(
        height: 600,
        child: appointments == null || appointments.isEmpty
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
