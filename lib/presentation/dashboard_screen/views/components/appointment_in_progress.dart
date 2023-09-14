part of dashboard;

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:data_table_2/data_table_2.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import '../../../../core/constants/app_constants.dart';
// //import '../../../../models/getAllApointments.dart';
// import '../../../../models/getTodaysAppointment.dart';
// import '../../../../network/endpoints.dart';
// import '../../../../shared_prefrences_page/shared_prefrence_page.dart';
// import '../../../../theme/app_style.dart';
// import '../../../../widgets/custom_image_view.dart';
// import '../../../../widgets/responsive.dart';
// import '../../shared_components/card_appointment.dart';

class _AppointmentInProgress extends StatelessWidget {
  _AppointmentInProgress({
    required this.data,
    Key? key,
  }) : super(key: key);

  final List<AppointmentContent> data;
  DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder.isMobile(context) ||
            ResponsiveBuilder.isTablet(context)
        ? loadDataTableMobile()
        : loadDataTable();
    // ClipRRect(
    //   borderRadius: BorderRadius.circular(kBorderRadius * 2),
    //   child: loadDataTable(),
    // );
  }

  Widget loadDataTableMobile() {
    return SizedBox(
        //width: 400,
        height: 250,
        child: Card(
          child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: MediaQuery.of(Get.context!).size.width,
              showBottomBorder: true,
              columns: [
                DataColumn2(
                  fixedWidth: Responsive.isMobile(Get.context!) ? 30 : 50,
                  label: Text(
                    'No',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                ),
                DataColumn2(
                    label: Text(
                      'Name',
                      style: AppStyle.txtInterSemiBold14,
                    ),
                    fixedWidth: 110),
                DataColumn2(
                  label: Text(
                    'Time',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Status',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Action',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                ),
              ],
              rows: List<DataRow>.generate(
                  data.length,
                  (index) => DataRow(cells: [
                        DataCell(
                            Text(
                              "${index + 1}",
                              overflow: TextOverflow.clip,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {}),
                        SharedPrefUtils.readPrefStr('role') == "PATIENT"
                            ? DataCell(
                                Text(
                                  '${data[index].examiner?.prefix}'
                                  '${data[index].examiner?.firstName} '
                                  '${data[index].examiner?.lastName}',
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                                onTap: () {})
                            : DataCell(
                                Text(
                                  '${data[index].patient?.prefix}'
                                  '${data[index].patient?.firstName} '
                                  '${data[index].patient?.lastName}',
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                                onTap: () {}),
                        DataCell(
                            data[index].updateTimeInMin == 0
                                ? Text(
                                    '${data[index].startTime?.replaceAll(' AM', '').replaceAll(' PM', '')}-${data[index].endTime}')
                                : Text(TimeCalculationUtils().timeCalCulated(
                                    data[index].startTime,
                                    data[index].endTime,
                                    data[index].updateTimeInMin)),
                            onTap: () {}),
                        DataCell(Text(
                          '${data[index].status}',
                          overflow: TextOverflow.ellipsis,
                        )),
                        DataCell(InkWell(
                          onTap: () {
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              showDialog(
                                context: Get.context!,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                      'Do you want to cancel appointment?'),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                            // height: getVerticalSize(60),
                                            // width: getHorizontalSize(80),
                                            child: Text('Yes'),
                                            // margin:
                                            //     getMargin(left: 10, right: 00),
                                            // fontStyle: ButtonFontStyle
                                            //     .RalewayRomanSemiBold14WhiteA700,
                                            onPressed: () async {
                                              if (data[index].examiner !=
                                                  null) {
                                                var req = {
                                                  "active": false,
                                                  "id": data[index].id,
                                                  "date": data[index].date,
                                                  "examinerId":
                                                      data[index].examiner!.id,
                                                  "note": data[index].note,
                                                  "updateBy": SharedPrefUtils
                                                              .readPrefStr(
                                                                  'role') !=
                                                          "PATIENT"
                                                      ? data[index]
                                                          .examiner!
                                                          .id
                                                          .toString()
                                                      : data[index]
                                                          .patient
                                                          ?.id
                                                          .toString(),
                                                  "patientId":
                                                      data[index].patient?.id,
                                                  "purpose":
                                                      data[index].purpose,
                                                  "status": "Canceled"
                                                };

                                                controller
                                                    .updateAppointment(req);
                                              } else {
                                                Get.back();
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback(
                                                        (timeStamp) =>
                                                            Get.snackbar(
                                                              "Doctor assigned to this appointment is not active",
                                                              '',
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .BOTTOM,
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          5),
                                                              borderRadius: 15,
                                                              icon: Icon(
                                                                Icons
                                                                    .error_outline,
                                                                color: ColorConstant
                                                                    .whiteA700,
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(40),
                                                              colorText:
                                                                  ColorConstant
                                                                      .whiteA700,
                                                              backgroundColor:
                                                                  ColorConstant
                                                                      .blue700,
                                                            ));
                                              }
                                            }),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                            // height: getVerticalSize(60),
                                            // width: getHorizontalSize(80),
                                            child: const Text('No'),
                                            // margin:
                                            //     getMargin(left: 0, right: 10),
                                            // fontStyle: ButtonFontStyle
                                            //     .RalewayRomanSemiBold14WhiteA700,
                                            onPressed: () async {
                                              Get.back();
                                            })
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )),
                      ]))),
        ));
  }

  Widget loadDataTable() {
    //DateTime a = DateTime.parse(txt);
    final DateFormat formatter = DateFormat.yMMMEd();
    return SizedBox(
      //width: MediaQuery.of(Get.context!).size.width,
      height: 380,
      child: PaginatedDataTable2(
          columnSpacing: 6,
          horizontalMargin: 6,
          rowsPerPage: 5,
          //wrapInCard: true,
          // onRowsPerPageChanged: (value) {

          // },
          // minWidth: 600,
          // showBottomBorder: true,
          columns: [
            DataColumn2(
              fixedWidth: 30,
              label: Text(
                'No',
                style: AppStyle.txtInterSemiBold14,
              ),
              //size: ColumnSize.L,
            ),
            DataColumn2(
              fixedWidth: 300,
              label: Text(
                'Name',
                style: AppStyle.txtInterSemiBold14,
              ),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text(
                'Mobile',
                style: AppStyle.txtInterSemiBold14,
              ),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Text(
                'Status',
                style: AppStyle.txtInterSemiBold14,
              ),
              size: ColumnSize.M,
            ),
            // DataColumn(
            //   label: Text(
            //     'Note',
            //     style: AppStyle.txtInterSemiBold14,
            //   ),
            // ),
            // DataColumn(
            //   label: Text(
            //     'Date ',
            //     style: AppStyle.txtInterSemiBold14,
            //   ),
            // ),
            DataColumn2(
              label: Text(
                'Time',
                style: AppStyle.txtInterSemiBold14,
              ),
              size: ColumnSize.M,
            ),

            DataColumn(
              label: Text(
                'Actions',
                style: AppStyle.txtInterSemiBold14,
              ),
              numeric: true,
            ),
          ],
          source: AppointmentsDataSource(data)),
    );
  }

  Widget loadList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSpacing / 2),
          child: CardAppointment(
            appointment: data[index],
            primary: _getSequenceColor(index),
            onPrimary: Colors.white,
          ),
        ),
      ),
    );
  }

  Color _getSequenceColor(int index) {
    int val = index % 4;
    if (val == 3) {
      return Colors.indigo;
    } else if (val == 2) {
      return Colors.grey;
    } else if (val == 1) {
      return Colors.redAccent;
    } else {
      return Colors.lightBlue;
    }
  }
}

class AppointmentsDataSource extends DataTableSource {
  final DashboardController dashboardController =
      Get.put(DashboardController());

  List<AppointmentContent> data = [];

  AppointmentsDataSource(List<AppointmentContent> appointments) {
    data = appointments;
  }

  @override
  DataRow getRow(int index) {
    AppointmentContent? appointment = data[index];
    return DataRow(cells: [
      DataCell(
          Text(
            "${index + 1}",
            overflow: TextOverflow.clip,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {}),
      DataCell(
          Row(
            children: [
              SharedPrefUtils.readPrefStr("role") != 'PATIENT'
                  ? appointment.patient?.profilePicture != null
                      ? CachedNetworkImage(
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          imageUrl: Uri.encodeFull(
                            Endpoints.baseURL +
                                Endpoints.downLoadPatientPhoto +
                                appointment.patient!.profilePicture.toString(),
                          ),
                          httpHeaders: {
                            "Authorization":
                                "Bearer ${SharedPrefUtils.readPrefStr("auth_token")}"
                          },
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) {
                            return CustomImageView(
                              imagePath: !Responsive.isDesktop(Get.context!)
                                  ? 'assets'
                                      '/images/default_profile.png'
                                  : '/images/default_profile.png',
                            );
                          },
                        )
                      : CustomImageView(
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          imagePath: !Responsive.isDesktop(Get.context!)
                              ? 'assets'
                                  '/images/default_profile.png'
                              : '/images/default_profile.png',
                        )
                  : appointment.examiner?.uploadedProfilePath != null
                      ? CachedNetworkImage(
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          imageUrl: Uri.encodeFull(
                            Endpoints.baseURL +
                                Endpoints.downLoadEmployePhoto +
                                appointment.examiner!.uploadedProfilePath
                                    .toString(),
                          ),
                          httpHeaders: {
                            "Authorization":
                                "Bearer ${SharedPrefUtils.readPrefStr("auth_token")}"
                          },
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) {
                            return CustomImageView(
                              imagePath: !Responsive.isDesktop(Get.context!)
                                  ? 'assets'
                                      '/images/default_profile.png'
                                  : '/images/default_profile.png',
                            );
                          },
                        )
                      : CustomImageView(
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          imagePath: !Responsive.isDesktop(Get.context!)
                              ? 'assets'
                                  '/images/default_profile.png'
                              : '/images/default_profile.png',
                        ),
              const SizedBox(
                width: 10,
              ),
              Text(
                // appointment.patient?.prefix != null
                //     ? appointment.patient?.prefix.toString() ?? ''
                //     : ''
                SharedPrefUtils.readPrefStr("role") != 'PATIENT'
                    ? '${appointment.patient?.firstName} '
                        '${appointment.patient?.lastName}'
                    : '${((appointment.examiner?.firstName == null || appointment.examiner?.firstName == '') || ((appointment.examiner?.lastName == null || appointment.examiner?.lastName == ''))) ? 'N/A' : '${appointment.examiner?.firstName}' '${appointment.examiner?.lastName}'} ',
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          onTap: () {}),
      DataCell(
          Text(SharedPrefUtils.readPrefStr("role") != 'PATIENT'
              ? "${appointment.patient?.mobile}"
              : "${appointment.patient?.mobile}"),
          onTap: () {}),
      DataCell(Text('${appointment.status}')),
      // DataCell(
      //     Text(formatter.format(
      //         DateTime.parse(data[index].date ?? ""))),
      //     onTap: () {}),
      DataCell(
          appointment.updateTimeInMin == 0
              ? Text(
                  '${appointment.startTime?.replaceAll(' AM', '').replaceAll(' PM', '')}-${appointment.endTime}')
              : Text(TimeCalculationUtils().timeCalCulated(
                  appointment.startTime,
                  appointment.endTime,
                  appointment.updateTimeInMin)),
          onTap: () {}),
      DataCell(Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                showDialog(
                  context: Get.context!,
                  builder: (context) => AlertDialog(
                    title: const Text('Do you want to cancel appointment?'),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              // height: getVerticalSize(60),
                              // width: getHorizontalSize(80),
                              child: Text('Yes'),
                              // margin:
                              //     getMargin(left: 10, right: 00),
                              // fontStyle: ButtonFontStyle
                              //     .RalewayRomanSemiBold14WhiteA700,
                              onPressed: () async {
                                var req = {
                                  "active": false,
                                  "id": data[index].id,
                                  "date": data[index].date,
                                  "examinerId": data[index].examiner!.id,
                                  "note": data[index].note,
                                  "updateBy":
                                      SharedPrefUtils.readPrefStr('role') !=
                                              "PATIENT"
                                          ? data[index].examiner!.id.toString()
                                          : data[index].patient?.id.toString(),
                                  "patientId": data[index].patient?.id,
                                  "purpose": data[index].purpose,
                                  "status": "Canceled"
                                };
                                dashboardController.updateAppointment(req);
                              }),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              // height: getVerticalSize(60),
                              // width: getHorizontalSize(80),
                              child: const Text('No'),
                              // margin:
                              //     getMargin(left: 0, right: 10),
                              // fontStyle: ButtonFontStyle
                              //     .RalewayRomanSemiBold14WhiteA700,
                              onPressed: () async {
                                Get.back();
                              })
                        ],
                      )
                    ],
                  ),
                );
              });
            },
            child: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          // SizedBox(
          //   width: 10,
          // ),
          // Icon(Icons.close)
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
