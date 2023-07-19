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
  const _AppointmentInProgress({
    required this.data,
    Key? key,
  }) : super(key: key);

  final List<AppointmentContent> data;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder.isMobile(context)
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
                DataColumn(
                  label: Text(
                    'Name',
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
                    'Status',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                ),
              ],
              rows: List<DataRow>.generate(
                  data.length,
                  (index) => DataRow(cells: [
                        DataCell(
                            Text(
                              '${data[index].patient?.firstName} '
                              '${data[index].patient?.lastName}',
                              overflow: TextOverflow.clip,
                            ),
                            onTap: () {}),
                        DataCell(
                            Text(
                                '${data[index].startTime?.replaceAll(' AM', '').replaceAll(' PM', '')}-${data[index].endTime}'),
                            onTap: () {}),
                        DataCell(Text('${data[index].status}')),
                      ]))),
        ));
  }

  Widget loadDataTable() {
    //DateTime a = DateTime.parse(txt);
    final DateFormat formatter = DateFormat.yMMMEd();
    return SizedBox(
      //width: 400,
      height: 250,
      child: Card(
        child: DataTable2(
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: 600,
            showBottomBorder: true,
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
                  'Mobile',
                  style: AppStyle.txtInterSemiBold14,
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
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
                  'Actions',
                  style: AppStyle.txtInterSemiBold14,
                ),
                numeric: true,
              ),
            ],
            rows: List<DataRow>.generate(
                data.length,
                (index) => DataRow(cells: [
                      DataCell(
                          Row(
                            children: [
                              data[index].patient?.profilePicture != null
                                  ? CachedNetworkImage(
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      imageUrl: Uri.encodeFull(
                                        Endpoints.baseURL +
                                            Endpoints.downLoadPatientPhoto +
                                            data[index].patient!.id.toString(),
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
                              Text(
                                '${data[index].patient?.firstName} '
                                '${data[index].patient?.lastName}',
                                overflow: TextOverflow.clip,
                              )
                            ],
                          ),
                          onTap: () {}),
                      DataCell(Text("${data[index].patient?.mobile}"),
                          onTap: () {}),
                      DataCell(Text('${data[index].status}')),
                      DataCell(
                          Text(formatter
                              .format(DateTime.parse(data[index].date ?? ""))),
                          onTap: () {}),
                      DataCell(
                          Text(
                              '${data[index].startTime?.replaceAll(' AM', '').replaceAll(' PM', '')}-${data[index].endTime}'),
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
                              //               appointment: data[index],
                              //               appointmentid: data[index].id!,
                              //             )));
                            },
                            child: Icon(
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
      ),
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
