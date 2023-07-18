import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../../core/app_export.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../models/getAllApointments.dart';
import '../../models/getallAppointbypoatientidModel.dart';
import '../../network/endpoints.dart';
import '../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../theme/app_style.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/responsive.dart';
import 'controller/schedule_controller.dart';
import 'widgets/schedule_item_widget.dart';

class SchedulePage extends GetWidget<ScheduleController> {
  final String tab;
  SchedulePage(this.tab);

  ScheduleController controller = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: controller.isloading.value
          ? const SizedBox(child: Center(child: CircularProgressIndicator()))
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SharedPrefUtils.readPrefStr('role') != "PATIENT"
                    ? Obx(() => Padding(
                          padding: getPadding(left: 0, top: 12, right: 0),
                          child: SizedBox(
                            //height: 600,
                            child: Responsive.isMobile(context)
                                ? loadStaffAppointmentList()
                                : loadStaffAppointmentsDataTable(),
                          ),
                        ))
                    : Obx(() => Padding(
                        padding: getPadding(left: 0, top: 12, right: 0),
                        child: SizedBox(
                          height: 600,
                          child: Responsive.isMobile(context)
                              ? loadPatientAppointmentsList()
                              : loadPatientAppointmentsDataTable(),
                        )))
              ],
            ),
    );
  }

  Widget loadPatientAppointmentsDataTable() {
    final DateFormat formatter = DateFormat.yMMMEd();
    if (controller.dataSourceLoading.value == true) return const SizedBox();

    return SizedBox(
        height: 500,
        child:
            //   Stack(alignment: Alignment.bottomCenter, children: [
            //     AsyncPaginatedDataTable2(
            //         horizontalMargin: 20,
            //         checkboxHorizontalMargin: 12,
            //         columnSpacing: 0,
            //         wrapInCard: true,
            //         header: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             mainAxisSize: MainAxisSize.max,
            //             children: [
            //               // if (kDebugMode && getCurrentRouteOption(context) == custPager)
            //               //   Row(children: [
            //               //     OutlinedButton(
            //               //         onPressed: () => _controller.goToPageWithRow(25),
            //               //         child: const Text('Go to row 25')),
            //               //     OutlinedButton(
            //               //         onPressed: () => _controller.goToRow(5),
            //               //         child: const Text('Go to row 5'))
            //               //   ]),
            //               // if (getCurrentRouteOption(context) == custPager)
            //               //   PageNumber(controller: _controller)
            //             ]),
            //         rowsPerPage: controller.rowsPerPage,
            //         autoRowsToHeight: getCurrentRouteOption(Get.context!) == autoRows,
            //         // Default - do nothing, autoRows - goToLast, other - goToFirst
            //         pageSyncApproach: getCurrentRouteOption(Get.context!) == dflt
            //             ? PageSyncApproach.doNothing
            //             : getCurrentRouteOption(Get.context!) == autoRows
            //                 ? PageSyncApproach.goToLast
            //                 : PageSyncApproach.goToFirst,
            //         minWidth: 500,
            //         fit: FlexFit.tight,
            //         border: TableBorder(
            //             top: const BorderSide(color: Colors.black),
            //             bottom: BorderSide(color: Colors.grey[300]!),
            //             left: BorderSide(color: Colors.grey[300]!),
            //             right: BorderSide(color: Colors.grey[300]!),
            //             verticalInside: BorderSide(color: Colors.grey[300]!),
            //             horizontalInside:
            //                 const BorderSide(color: Colors.grey, width: 1)),
            //         onRowsPerPageChanged: (value) {
            //           // No need to wrap into setState, it will be called inside the widget
            //           // and trigger rebuild
            //           //setState(() {
            //           print('Row per page changed to $value');
            //           controller.rowsPerPage = value!;
            //           //});
            //         },
            //         initialFirstRowIndex: controller.initialRow.value,
            //         onPageChanged: (rowIndex) {
            //           //print(rowIndex / _rowsPerPage);
            //         },
            //         sortColumnIndex: controller.sortColumnIndex.value,
            //         sortAscending: controller.sortAscending.value,
            //         sortArrowIcon: Icons.keyboard_arrow_up,
            //         sortArrowAnimationDuration: const Duration(milliseconds: 0),
            //         onSelectAll: (select) => select != null && select
            //             ? (getCurrentRouteOption(Get.context!) != selectAllPage
            //                 ? controller.dessertsDataSource!.selectAll()
            //                 : controller.dessertsDataSource!.selectAllOnThePage())
            //             : (getCurrentRouteOption(Get.context!) != selectAllPage
            //                 ? controller.dessertsDataSource!.deselectAll()
            //                 : controller.dessertsDataSource!.deselectAllOnThePage()),
            //         controller: controller.pageController,
            //         hidePaginator: getCurrentRouteOption(Get.context!) == custPager,
            //         columns: controller.columns,
            //         empty: Center(
            //             child: Container(
            //                 padding: const EdgeInsets.all(20),
            //                 color: Colors.grey[200],
            //                 child: const Text('No data'))),
            //         loading: Center(
            //             child: Container(
            //           color: Colors.yellow,
            //           padding: const EdgeInsets.all(7),
            //           width: 150,
            //           height: 50,
            //           child: const Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceAround,
            //               children: [
            //                 CircularProgressIndicator(
            //                   strokeWidth: 2,
            //                   color: Colors.black,
            //                 ),
            //                 Text('Loading..')
            //               ]),
            //         )),
            //         errorBuilder: (e) => _ErrorAndRetry(e.toString(),
            //             () => controller.dessertsDataSource!.refreshDatasource()),
            //         source: controller.dessertsDataSource!),
            //     if (getCurrentRouteOption(Get.context!) == custPager)
            //       Positioned(bottom: 16, child: CustomPager(controller.pageController))
            //   ]),
            // );

            Card(
          child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 600,
              showBottomBorder: true,
              sortAscending: false,
              // wrapInCard: false,
              // renderEmptyRowsInTheEnd: false,
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
              //fit: FlexFit.tight,
              border: TableBorder(
                  top: const BorderSide(color: Colors.black),
                  bottom: BorderSide(color: Colors.grey[300]!),
                  left: BorderSide(color: Colors.grey[300]!),
                  right: BorderSide(color: Colors.grey[300]!),
                  verticalInside: BorderSide(color: Colors.grey[300]!),
                  horizontalInside:
                      const BorderSide(color: Colors.grey, width: 1)),
              //dataRowHeight: 70,
              empty: EmptyWidget(
                image: null,
                hideBackgroundAnimation: true,
                packageImage: PackageImage.Image_1,
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
              ),
              // Center(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         'No $tab appointments found.',
              //         style: const TextStyle(
              //           fontSize: 18,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              columns: [
                // DataColumn2(
                //   label: Text(
                //     'Profile',
                //     style: AppStyle.txtInterSemiBold14,
                //   ),
                //   //size: ColumnSize.L,
                // ),
                DataColumn2(
                  label: Text(
                    'Name',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                  size: ColumnSize.L,
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
                // DataColumn(
                //   label: Text(
                //     'Note',
                //     style: AppStyle.txtInterSemiBold14,
                //   ),
                // ),
                DataColumn(
                  label: Text(
                    'Date & Time',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Start Time',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'End Time',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Actions',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                  numeric: true,
                ),
              ],
              rows: List<DataRow>.generate(
                  controller.getList(tab).length,
                  (index) => DataRow(cells: [
                        DataCell(
                            Row(
                              children: [
                                controller.getProfilePicture(tab, index) != null
                                    ? CachedNetworkImage(
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        imageUrl: Uri.encodeFull(
                                          Endpoints.baseURL +
                                              Endpoints.downLoadPatientPhoto +
                                              controller
                                                  .getPatientId(tab, index)
                                                  .toString(),
                                        ),
                                        httpHeaders: {
                                          "Authorization":
                                              "Bearer ${SharedPrefUtils.readPrefStr("auth_token")}"
                                        },
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) {
                                          print(error);
                                          return CustomImageView(
                                            imagePath: !Responsive.isDesktop(
                                                    Get.context!)
                                                ? 'assets' +
                                                    '/images/default_profile.png'
                                                : '/images/default_profile.png',
                                          );
                                        },
                                      )
                                    : CustomImageView(
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.contain,
                                        imagePath: !Responsive.isDesktop(
                                                Get.context!)
                                            ? 'assets' +
                                                '/images/default_profile.png'
                                            : '/images/default_profile.png',
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                    child: Text(
                                  '${controller.getName(tab, index)}',
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ))
                              ],
                            ),
                            onTap: () {}),
                        DataCell(Text('${controller.getStatus(tab, index)}'),
                            onTap: () {}),
                        DataCell(Text('${controller.getNote(tab, index)}'),
                            onTap: () {}),
                        //DataCell(Text('${data[index].visit}')),
                        DataCell(
                            Text(formatter.format(DateTime.parse(
                                '${controller.getDate(tab, index)}'))),
                            onTap: () {}),
                        DataCell(Text('${controller.getStartTime(tab, index)}'),
                            onTap: () {}),
                        DataCell(Text('${controller.getEndTime(tab, index)}'),
                            onTap: () {}),
                        DataCell(Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                // Navigator.push(
                                //     Get.context!,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             AppointmentDetailsPage(
                                //               appointmentid: controller
                                //                   .getAppointmentID(tab, index),
                                //               appointment: controller.getData1(
                                //                   tab, index),
                                //             )));
                              },
                              child: const Icon(
                                Icons.remove_red_eye,
                                color: Colors.green,
                              ),
                            ),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            // Icon(Icons.close)
                          ],
                        )),
                      ]))),
        ));
  }

  Widget loadStaffAppointmentsDataTable() {
    final DateFormat formatter = DateFormat.yMMMEd();
    return Card(
      child: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 600,
          showBottomBorder: true,
          sortAscending: false,
          // wrapInCard: false,
          // renderEmptyRowsInTheEnd: false,
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
          //fit: FlexFit.tight,
          border: TableBorder(
              top: const BorderSide(color: Colors.black),
              bottom: BorderSide(color: Colors.grey[300]!),
              left: BorderSide(color: Colors.grey[300]!),
              right: BorderSide(color: Colors.grey[300]!),
              verticalInside: BorderSide(color: Colors.grey[300]!),
              horizontalInside: const BorderSide(color: Colors.grey, width: 1)),
          empty: EmptyWidget(
            image: null,
            hideBackgroundAnimation: true,
            packageImage: PackageImage.Image_1,
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
          ),
          // Center(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         'No $tab appointments found.',
          //         style: const TextStyle(
          //           fontSize: 18,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          columns: [
            // DataColumn2(
            //   label: Text(
            //     'Profile',
            //     style: AppStyle.txtInterSemiBold14,
            //   ),
            //   //size: ColumnSize.L,
            // ),
            DataColumn2(
              label: Text(
                'Name',
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
                'Status',
                textAlign: TextAlign.center,
                style: AppStyle.txtInterSemiBold14,
              ),
            ),
            // DataColumn(
            //   label: Text(
            //     'Note',
            //     style: AppStyle.txtInterSemiBold14,
            //   ),
            // ),
            DataColumn(
              label: Text(
                'Date ',
                textAlign: TextAlign.center,
                style: AppStyle.txtInterSemiBold14,
              ),
            ),
            DataColumn(
              label: Text(
                'Start Time',
                textAlign: TextAlign.center,
                style: AppStyle.txtInterSemiBold14,
              ),
            ),
            DataColumn(
              label: Text(
                'End Time',
                textAlign: TextAlign.center,
                style: AppStyle.txtInterSemiBold14,
              ),
            ),
            DataColumn(
              label: Text(
                'Actions',
                textAlign: TextAlign.center,
                style: AppStyle.txtInterSemiBold14,
              ),
              //numeric: true,
            ),
          ],
          rows: List<DataRow>.generate(
              controller.getList(tab).length,
              (index) => DataRow(cells: [
                    DataCell(
                        Row(
                          children: [
                            controller.getProfilePicture(tab, index) != null
                                ? CachedNetworkImage(
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    imageUrl: Uri.encodeFull(
                                      Endpoints.baseURL +
                                          Endpoints.downLoadPatientPhoto +
                                          controller
                                              .getPatientId(tab, index)
                                              .toString(),
                                    ),
                                    httpHeaders: {
                                      "Authorization":
                                          "Bearer ${SharedPrefUtils.readPrefStr("auth_token")}"
                                    },
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) {
                                      print(error);
                                      return CustomImageView(
                                        imagePath: !Responsive.isDesktop(
                                                Get.context!)
                                            ? 'assets' +
                                                '/images/default_profile.png'
                                            : '/images/default_profile.png',
                                      );
                                    },
                                  )
                                : CustomImageView(
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain,
                                    imagePath:
                                        !Responsive.isDesktop(Get.context!)
                                            ? 'assets' +
                                                '/images/default_profile.png'
                                            : '/images/default_profile.png',
                                  ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                                child: Text(
                              '${controller.getName(tab, index)}',
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ))
                          ],
                        ),
                        onTap: () {}),
                    DataCell(Text('${controller.getStatus(tab, index)}'),
                        onTap: () {}),
                    DataCell(Text('${controller.getPurpose(tab, index)}'),
                        onTap: () {}),
                    //DataCell(Text('${data[index].visit}')),
                    DataCell(
                        Text(formatter.format(DateTime.parse(
                            '${controller.getDate(tab, index)}'))),
                        onTap: () {}),
                    DataCell(Text('${controller.getStartTime(tab, index)}'),
                        onTap: () {}),
                    DataCell(Text('${controller.getEndTime(tab, index)}'),
                        onTap: () {}),
                    DataCell(Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        tab.toLowerCase() == 'today'
                            ? InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //     Get.context!,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             AppointmentDetailsPage(
                                  //               appointmentid:
                                  //                   controller.getAppointmentID(
                                  //                       tab, index),
                                  //               appointment: controller.getData(
                                  //                   tab, index),
                                  //             )));
                                },
                                child: const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.green,
                                ),
                              )
                            : tab.toLowerCase() == 'upcoming'
                                ? InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //     Get.context!,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             AppointmentDetailsPage(
                                      //               appointmentid: controller
                                      //                   .getAppointmentID(
                                      //                       tab, index),
                                      //               appointment: controller
                                      //                   .getData(tab, index),
                                      //             )));
                                    },
                                    child: const Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.green,
                                    ),
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Navigator.push(
                                          //     Get.context!,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             AppointmentDetailsPage(
                                          //               appointmentid: controller
                                          //                   .getAppointmentID(
                                          //                       tab, index),
                                          //               appointment:
                                          //                   controller.getData(
                                          //                       tab, index),
                                          //             )));
                                        },
                                        child: const Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.callGeneratePrecription(
                                              controller.getPatientId(
                                                  tab, index),
                                              controller.getAppointmentID(
                                                  tab, index),
                                              1);
                                        },
                                        child: const Icon(
                                          Icons.list_alt,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: const Icon(
                                          Icons.payment,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  )
                      ],
                    )),
                  ]))),
    );
  }

  Widget loadStaffAppointmentList() {
    return controller.getList(tab).isNotEmpty
        ? ResponsiveGridList(
            horizontalGridMargin: 0,
            maxItemsPerRow: 3,
            minItemsPerRow: 1,
            verticalGridMargin: 0,
            minItemWidth: 320,
            listViewBuilderOptions: ListViewBuilderOptions(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics()),
            children: List.generate(
              controller.getList(tab).length,
              (index) => ScheduleItemWidget(
                  controller.getList(tab)[index],
                  controller.getPatientId(tab, index),
                  controller.getExaminerId(tab, index),
                  tab),
              //loadAppointmentCard(index, Get.context!),
              // InkWell(
              //     onTap: () {
              //       // Navigator.push(
              //       //     Get.context!,
              //       //     MaterialPageRoute(
              //       //         builder: (context) => AppointmentDetailsPage(
              //       //               appointmentid:
              //       //                   controller.getAppointmentID(tab, index),
              //       //               model2: null,
              //       //               model1: controller.getData(tab, index),
              //       //             )));
              //     },
              //     child: AbsorbPointer(
              //         child: loadAppointmentCard(index, Get.context!)))
            ),
          )
        : EmptyWidget(
            image: null,
            hideBackgroundAnimation: true,
            packageImage: PackageImage.Image_1,
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

  Widget loadPatientAppointmentsList() {
    return ResponsiveGridList(
      horizontalGridMargin: 0,
      maxItemsPerRow: 1,
      minItemsPerRow: 1,
      verticalGridMargin: 0,
      minItemWidth: 320,
      listViewBuilderOptions: ListViewBuilderOptions(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics()),
      children: List.generate(
          controller.getList(tab).length,
          (index) => InkWell(
              onTap: () {
                // Navigator.push(
                //     Get.context!,
                //     MaterialPageRoute(
                //         builder: (context) => AppointmentDetailsPage(
                //               appointmentid:
                //                   controller.getAppointmentID(tab, index),
                //               appointment: controller.getData1(tab, index),
                //             )));
              },
              child: ScheduleItemWidget(
                  controller.getList(tab)[index],
                  controller.getPatientId(tab, index),
                  controller.getExaminerId(tab, index),
                  tab)
              // loadAppointmentCard(index, Get.context!),
              )),
    );
  }

  Widget loadAppointmentCard(int index, BuildContext context) {
    return GFCard(
      padding: const EdgeInsets.all(2),
      buttonBar: GFButtonBar(children: [
        ElevatedButton(
            onPressed: () {
              controller.callGeneratePrecription(
                  controller.getPatientId(tab, index),
                  controller.getAppointmentID(tab, index),
                  1);
            },
            child: const Text('Generate Precription')),
        ElevatedButton(
            onPressed: () {
              controller.callGenerateInvoice(
                  controller.getPatientId(tab, index),
                  controller.getAppointmentID(tab, index),
                  7,
                  controller.getExaminerId(tab, index));
            },
            child: const Text('Generate Invoice'))
      ]),
      title: GFListTile(
        // firstButtonTitle: 'Generate Precription',
        // //firstButtonTextStyle: AppStyle.txtRalewayRomanRegular14,
        // secondButtonTitle: 'Download',
        // onFirstButtonTap: () {
        //   controller.callGeneratePrecription(
        //       controller.getPatientId(tab, index),
        //       controller.getAppointmentID(tab, index),
        //       1);
        // },
        icon: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.calendar_month,
              color: ColorConstant.blue60001,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${controller.getformattedDate(controller.getDate(tab, index) ?? "")}',
              style: AppStyle.txtManropeBold12,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${controller.getStartTime(tab, index)}-${controller.getEndTime(tab, index)}',
              style: AppStyle.txtManropeBold12,
            )
          ],
        ),
        listItemTextColor: GFColors.DARK,
        avatar: controller.getProfilePicture(tab, index) != null
            ? CachedNetworkImage(
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                imageUrl: Uri.encodeFull(
                  Endpoints.baseURL +
                      Endpoints.downLoadPatientPhoto +
                      controller.getPatientId(tab, index).toString(),
                ),
                httpHeaders: {
                  "Authorization":
                      "Bearer ${SharedPrefUtils.readPrefStr("auth_token")}"
                },
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) {
                  print(error);
                  return CustomImageView(
                    imagePath: !Responsive.isDesktop(Get.context!)
                        ? 'assets' + '/images/default_profile.png'
                        : '/images/default_profile.png',
                  );
                },
              )
            : CustomImageView(
                width: 80,
                height: 80,
                fit: BoxFit.contain,
                imagePath: !Responsive.isDesktop(Get.context!)
                    ? 'assets' + '/images/default_profile.png'
                    : '/images/default_profile.png',
              ),
        //autofocus: true,
        color: Colors.white,
        title: Text(
          controller.getName(tab, index) ?? "",
          style: AppStyle.txtInterSemiBold16,
        ),
        // subTitle: Text(
        //   "Appointment id - ${controller.getAppointmentID(tab, index)}",
        //   style: AppStyle.txtInterRegular12Gray700,
        // ),
        description: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${controller.getPurpose(tab, index)}',
              style: AppStyle.txtInterRegular12Gray700,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Department: ${controller.getDeptName(tab, index) ?? ""}',
              style: AppStyle.txtInterRegular12Gray700,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Status: ${controller.getStatus(tab, index) ?? ""}',
              style: AppStyle.txtInterRegular14,
            ),
          ],
        ),
        enabled: true,
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
