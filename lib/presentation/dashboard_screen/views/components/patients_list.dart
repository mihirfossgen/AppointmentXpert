import 'package:appointmentxpert/core/utils/size_utils.dart';
import 'package:appointmentxpert/models/patient_model.dart';
import 'package:appointmentxpert/presentation/add_patient_screens/add_patient_screen.dart';
import 'package:appointmentxpert/presentation/patient_details_page/patient_details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/color_constant.dart';
import '../../../../models/patient_list_model.dart';
import '../../../../network/endpoints.dart';
import '../../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../../../theme/app_style.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/responsive.dart';
import '../../../appointment_booking_screen/appointment_booking.dart';
import '../../controller/dashboard_controller.dart';
import '../../shared_components/list_recent_patient.dart';
import '../../shared_components/search_field.dart';
import '../screens/dashboard_screen.dart';

class PatientsList extends GetView<DashboardController> {
  List<Content>? data;

  DashboardController dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => AddPatientScreen());
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textView(),
                            InkWell(
                              onTap: () async {
                                controller.onClose();
                                await controller.callRecentPatientList(0);
                                data = controller.getAllPatientsList;
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
                                    style: AppStyle
                                        .txtRalewayRomanMedium14WhiteA700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SearchField(
                          onSearch: (value) {
                            print(value);
                          },
                        ),
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
                          ? RefreshIndicator(
                              onRefresh: () async {
                                Future.sync(() => dashboardController
                                    .patientPagingController
                                    .refresh());
                                dashboardController.isloading.value = true;
                                dashboardController.callRecentPatientList(0);
                              },
                              child: PagedListView<int, Content>.separated(
                                shrinkWrap: true,
                                pagingController:
                                    dashboardController.patientPagingController,
                                builderDelegate:
                                    PagedChildBuilderDelegate<Content>(
                                  animateTransitions: true,
                                  itemBuilder: (context, item, index) =>
                                      Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: GFListTile(
                                      icon: const Icon(Icons.arrow_right),
                                      avatar: item.profilePicture != null
                                          ? CachedNetworkImage(
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.contain,
                                              imageUrl: Uri.encodeFull(
                                                Endpoints.baseURL +
                                                    Endpoints
                                                        .downLoadPatientPhoto +
                                                    item.profilePicture
                                                        .toString(),
                                              ),
                                              httpHeaders: {
                                                "Authorization":
                                                    "Bearer ${SharedPrefUtils.readPrefStr("auth_token")}"
                                              },
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                              errorWidget:
                                                  (context, url, error) {
                                                print(error);
                                                return CustomImageView(
                                                  imagePath: !Responsive
                                                          .isDesktop(
                                                              Get.context!)
                                                      ? 'assets' +
                                                          '/images/default_profile.png'
                                                      : '/images/default_profile.png',
                                                );
                                              },
                                            )
                                          : CustomImageView(
                                              width: 80,
                                              height: 80,
                                              imagePath: !Responsive.isDesktop(
                                                      Get.context!)
                                                  ? 'assets' +
                                                      '/images/default_profile.png'
                                                  : '/images/default_profile.png',
                                            ),
                                      //autofocus: true,
                                      color: Colors.white,
                                      description: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Email: ${item.email.toString()}',
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Address: ${item.address}',
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Age: ${item.age}',
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      enabled: true,
                                      firstButtonTextStyle: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                      firstButtonTitle: 'View Details',
                                      secondButtonTitle: 'Book Appointment',
                                      secondButtonTextStyle: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                      onSecondButtonTap: () {
                                        Get.to(AppointmentBookingScreen(
                                            patientDetailsArguments:
                                                PatientDetailsArguments(
                                                    [], item)));
                                      },
                                      onFirstButtonTap: () {
                                        Get.to(PatientDetailsPage(item));
                                      },
                                      //focusColor: ,
                                      focusNode: FocusNode(),
                                      //hoverColor: Colors.blue,
                                      //icon: ,
                                      listItemTextColor: GFColors.DARK,
                                      //margin: getMarginOrPadding(all: 8.0),
                                      //onFirstButtonTap: ,
                                      //onLongPress: ,
                                      //onSecondButtonTap: ,
                                      onTap: () {},
                                      //padding: ,
                                      radius: 8,
                                      //secondButtonTextStyle: ,
                                      //secondButtonTitle: 'Delete',
                                      selected: false,
                                      //shadow: BoxShadow,
                                      //subTitleText: 'Address: ${data.address}',
                                      title: Text(
                                        '${item.firstName} ' +
                                            '${item.lastName}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      //titleText: '${data.firstName} ' + '${data.lastName}',
                                    ),
                                  ),
                                ),
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                              ),
                            )
                          //loadList()
                          : Container()
                      //loadDataTable(),
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
  /*
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
                            const SizedBox(
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
              (e) => ListRecentPatients(
                data: e.value,
                onPressed: () => onPressed(e.key, e.value),
                // onPressedAssign: () => onPressedAssign(e.key, e.value),
                // onPressedMember: () => onPressedMember(e.key, e.value),
              ),
            )
            .toList());
  }
  */
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

Widget textView() => const Text(
      "Patients",
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w600, fontSize: 17.0),
    );
