import 'package:appointmentxpert/presentation/dashboard_screen/shared_components/emergency_patient_list.dart';
import 'package:data_table_2/data_table_2.dart';
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
                        top: 8.0, left: 15.0, right: 12.0),
                    child: textView(),
                  ),

                  //SearchField(),
                ],
              ),
            if (!Responsive.isMobile(context))
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 3, child: textView()),
                  //Expanded(flex: 5, child: SearchField())
                ],
              ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 700,
              child:
                  Responsive.isMobile(context) ? loadList() : loadDataTable(),
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
          //dataRowHeight: 70,
          empty: const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No patient\'s found.',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
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
              label: Text(
                'patientName',
                style: AppStyle.txtInterSemiBold14,
              ),
              size: ColumnSize.L,
            ),
            DataColumn(
              label: Text(
                'mobileNumber.',
                style: AppStyle.txtInterSemiBold14,
              ),
            ),
            DataColumn(
              label: Text(
                'emailId',
                style: AppStyle.txtInterSemiBold14,
              ),
            ),
            DataColumn(
              label: Text(
                'date',
                style: AppStyle.txtInterSemiBold14,
              ),
            ),
            DataColumn(
              label: Text(
                'patientType',
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
                    DataCell(Text('${data[index].mobileNumber}'), onTap: () {}),
                    DataCell(
                        Text(formatter
                            .format(DateTime.parse('${data[index].date}'))),
                        onTap: () {}),
                    DataCell(Text('${data[index].emailId}'), onTap: () {}),
                    DataCell(Text('${data[index].patientType}'), onTap: () {}),
                    //DataCell(Text(
                    //    formatter.format(DateTime.parse('${data[index].date}')))),
                    const DataCell(Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.remove_red_eye),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Icon(Icons.close)
                      ],
                    )),
                  ]))),
    );
  }

  Widget loadList() {
    return ResponsiveGridList(
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
