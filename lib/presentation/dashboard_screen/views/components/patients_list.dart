import 'package:appointmentxpert/presentation/add_patient_screens/add_patient_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../../../../core/constants/constants.dart';
import '../../../../models/patient_list_model.dart';
import '../../../../network/endpoints.dart';
import '../../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../../../theme/app_style.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/responsive.dart';
import '../../shared_components/list_recent_patient.dart';

class PatientsList extends StatelessWidget {
  const PatientsList({Key? key, required this.data, required this.onPressed})
      : super(key: key);

  final List<Content> data;
  final Function(int index, Content data) onPressed;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(AddPatientScreen());
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Responsive.isMobile(context))
                    Column(
                      children: [
                        textView(),
                        const SizedBox(
                          height: 10.0,
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
                    child: Responsive.isMobile(context)
                        ? loadList()
                        : loadDataTable(),
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
              )),
        ),
      ),
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
          empty: Center(
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
                'Name',
                style: AppStyle.txtInterSemiBold14,
              ),
              size: ColumnSize.L,
            ),
            DataColumn(
              label: Text(
                'Age',
                style: AppStyle.txtInterSemiBold14,
              ),
            ),
            DataColumn(
              label: Text(
                'Date of birth',
                style: AppStyle.txtInterSemiBold14,
              ),
            ),
            DataColumn(
              label: Text(
                'Email',
                style: AppStyle.txtInterSemiBold14,
              ),
            ),
            DataColumn(
              label: Text(
                'Blood Group',
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
                            data[index].profilePicture != null
                                ? CachedNetworkImage(
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    imageUrl: Uri.encodeFull(
                                      Endpoints.baseURL +
                                          Endpoints.downLoadPatientPhoto +
                                          data[index].id.toString(),
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
                            SizedBox(
                              width: 10,
                            ),
                            Text('${data[index].firstName} ' +
                                '${data[index].lastName}')
                          ],
                        ),
                        onTap: () {}),
                    DataCell(Text('${data[index].age}'), onTap: () {}),
                    DataCell(
                        Text(formatter
                            .format(DateTime.parse('${data[index].dob}'))),
                        onTap: () {}),
                    DataCell(Text('${data[index].email}'), onTap: () {}),
                    DataCell(Text('${data[index].bloodType}'), onTap: () {}),
                    //DataCell(Text(
                    //    formatter.format(DateTime.parse('${data[index].date}')))),
                    DataCell(Row(
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
        horizontalGridMargin: 10,
        maxItemsPerRow: 2,
        minItemsPerRow: 1,
        shrinkWrap: true,
        verticalGridMargin: 10,
        minItemWidth: 380,
        children: data
            .asMap()
            .entries
            .map(
              (e) => ListRecentPatients(
                data: e.value,
                onPressed: () => onPressed(e.key, e.value),
                // onPressedAssign: () => onPressedAssign(e.key, e.value),
                // onPressedMember: () => onPressedMember(e.key, e.value),
              ),
            )
            .toList());
  }
}

DataRow patientDataRow(Content fileInfo, BuildContext context, Size size) {
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
                child: Text('${fileInfo.firstName.toString()} ' +
                    '${fileInfo.lastName.toString()}'),
              ),
            ],
          ), onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (_) => SurveyChart()));
      }),
      DataCell(Text(fileInfo.age.toString())),
      DataCell(Text(fileInfo.dob.toString())),
      DataCell(Text(fileInfo.bloodType.toString())),
      DataCell(Text(fileInfo.sex.toString())),
    ],
  );
}

Widget textView() => Text(
      "Patients",
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w600, fontSize: 17.0),
    );
