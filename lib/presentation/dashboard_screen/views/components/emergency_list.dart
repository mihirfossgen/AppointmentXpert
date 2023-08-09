import 'package:appointmentxpert/presentation/dashboard_screen/shared_components/emergency_patient_list.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../../../../models/emergency_patient_list.dart';
import '../../../../theme/app_style.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/responsive.dart';

class EmergencyList extends StatelessWidget {
  const EmergencyList({Key? key, required this.data, required this.onPressed})
      : super(key: key);

  final List<EmergencyContent> data;
  final Function(int index, EmergencyContent data) onPressed;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView(shrinkWrap: true, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isMobile(context))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 15.0, right: 12.0),
                    child: textView(),
                  ),

                  //SearchField(),
                ],
              ),
            if (!Responsive.isMobile(context))
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 3, child: textView()),
                    //Expanded(flex: 5, child: SearchField())
                  ],
                ),
              ),
            // const SizedBox(
            //   height: 10.0,
            // ),
            SizedBox(
              height: Responsive.isMobile(Get.context!)
                  ? MediaQuery.of(context).size.height * 0.75
                  : Responsive.isTablet(Get.context!)
                      ? MediaQuery.of(Get.context!).size.height * 0.80
                      : MediaQuery.of(Get.context!).size.height,
              child:
                  !Responsive.isDesktop(context) ? loadList() : loadDataTable(),
            ),

            // Container(
            //   width: double.infinity,
            //   height: 680,
            //   child: DataTable2(
            //     columnSpacing: defaultPadding,
            //     headingRowHeight: defaultPadding * 5,
            //     minWidth: 00,
            //     //decoration: BoxDecoration(color: Color(0xFF2CABB8)),
            //     columns: [
            //       DataColumn(
            //         label: Text(
            //           "Patient Name",
            //           style: AppStyle.txtInterSemiBold14,
            //         ),
            //       ),
            //       DataColumn(
            //         label: Text(
            //           "Age",
            //           style: AppStyle.txtInterSemiBold14,
            //         ),
            //       ),
            //       DataColumn(
            //         label: Text(
            //           "Date of Birth",
            //           style: AppStyle.txtInterSemiBold14,
            //         ),
            //       ),
            //       DataColumn(
            //         label: Text(
            //           "Blood Type",
            //           style: AppStyle.txtInterSemiBold14,
            //         ),
            //       ),
            //       DataColumn(
            //         label: Text(
            //           "Gender",
            //           style: AppStyle.txtInterSemiBold14,
            //         ),
            //       ),
            //     ],
            //     rows: List.generate(data.length,
            //         (index) => patientDataRow(data[index], context, size),
            //         growable: true),
            //   ),
            // ),
          ],
        ),
      ]),
    );
  }

  Widget loadDataTable() {
    final DateFormat formatter = DateFormat.yMMMMd('en_US');
    return Card(
      child: DataTable2(
          columnSpacing: 10,
          horizontalMargin: 10,
          minWidth: 600,
          showBottomBorder: true,
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
          border: TableBorder(
              top: const BorderSide(color: Colors.black),
              bottom: BorderSide(color: Colors.grey[300]!),
              left: BorderSide(color: Colors.grey[300]!),
              right: BorderSide(color: Colors.grey[300]!),
              verticalInside: BorderSide(color: Colors.grey[300]!),
              horizontalInside: const BorderSide(color: Colors.grey, width: 1)),
          //dataRowHeight: 70,
          empty: EmptyWidget(
            image: null,
            hideBackgroundAnimation: true,
            packageImage: PackageImage.Image_3,
            title: 'No data',
            subTitle: 'No emergency requests found.',
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
          columns: [
            // DataColumn2(
            //   label: Text(
            //     'Profile',
            //     style: AppStyle.txtInterSemiBold14,
            //   ),
            //   //size: ColumnSize.L,
            // ),
            DataColumn2(
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Patient Name',
                  style: AppStyle.txtInterSemiBold14,
                ),
              ),
              size: ColumnSize.L,
            ),
            DataColumn(
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Mobile Number',
                  style: AppStyle.txtInterSemiBold14,
                ),
              ),
            ),
            DataColumn(
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Email',
                  style: AppStyle.txtInterSemiBold14,
                ),
              ),
            ),
            DataColumn(
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Date',
                  style: AppStyle.txtInterSemiBold14,
                ),
              ),
            ),
            DataColumn(
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Patient Type',
                  style: AppStyle.txtInterSemiBold14,
                ),
              ),
              numeric: false,
            ),
          ],
          rows: List<DataRow>.generate(
              data.length,
              (index) => DataRow(cells: [
                    DataCell(
                        Row(
                          children: [
                            CustomImageView(
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                              imagePath: !Responsive.isDesktop(Get.context!)
                                  ? 'assets' '/images/default_profile.png'
                                  : '/images/default_profile.png',
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('${data[index].patientName}')
                          ],
                        ),
                        onTap: () {}),
                    DataCell(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${data[index].mobileNumber}'),
                        ),
                        onTap: () {}),
                    DataCell(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(formatter
                              .format(DateTime.parse('${data[index].date}'))),
                        ),
                        onTap: () {}),
                    DataCell(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${data[index].emailId}'),
                          ),
                        ),
                        onTap: () {}),
                    DataCell(Text('${data[index].patientType}'), onTap: () {}),
                    //DataCell(Text(
                    //    formatter.format(DateTime.parse('${data[index].date}')))),
                    // const DataCell(Row(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Icon(Icons.remove_red_eye),
                    //     // SizedBox(
                    //     //   width: 10,
                    //     // ),
                    //     // Icon(Icons.close)
                    //   ],
                    // )),
                  ]))),
    );
  }

  Widget loadList() {
    return data.isEmpty
        ? loadEmptyWidget()
        : ResponsiveGridList(
            horizontalGridMargin: 0,
            maxItemsPerRow: 2,
            minItemsPerRow: 1,
            shrinkWrap: true,
            verticalGridMargin: 10,
            minItemWidth: 380,
            children: data
                .asMap()
                .entries
                .map(
                  (e) => ListEmergencyPatients(
                    data: e.value,
                    onPressed: () => onPressed(e.key, e.value),
                    // onPressedAssign: () => onPressedAssign(e.key, e.value),
                    // onPressedMember: () => onPressedMember(e.key, e.value),
                  ),
                )
                .toList());
  }
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

DataRow patientDataRow(
    EmergencyContent fileInfo, BuildContext context, Size size) {
  return DataRow(
    cells: [
      DataCell(
          Row(
            children: [
              Image.asset(
                //fileInfo.icon!,
                'assets/images/default_profile.png',
                height: !Responsive.isMobile(context) ? 44 : 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(fileInfo.patientName.toString()),
              ),
            ],
          ), onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (_) => SurveyChart()));
      }),
      DataCell(Text(fileInfo.mobileNumber.toString())),
      DataCell(Text(fileInfo.emailId.toString())),
      DataCell(Text(fileInfo.date.toString())),
      DataCell(Text(fileInfo.patientType.toString())),
    ],
  );
}

Widget textView() => Text(
      "Emergency Patients",
      style: TextStyle(
          color: Colors.red.shade900,
          fontWeight: FontWeight.w600,
          fontSize: 18.0),
    );
