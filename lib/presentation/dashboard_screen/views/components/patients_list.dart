import 'package:appointmentxpert/models/staff_list_model.dart';
import 'package:appointmentxpert/presentation/patient_details_page/patient_details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../../core/constants/constants.dart';
import '../../../../models/patient_list_model.dart';
import '../../../../network/endpoints.dart';
import '../../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../../../theme/app_style.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/responsive.dart';
import '../../../add_patient_screens/add_patient_screen.dart';
import '../../../appointment_booking_screen/appointment_booking.dart';
import '../../controller/dashboard_controller.dart';
import '../../shared_components/search_field.dart';
import '../screens/dashboard_screen.dart';

class PatientsList extends GetView<DashboardController> {
  List<Content>? data;
  List<Contents>? doctorsList;
  PatientsList({super.key, this.data, this.doctorsList});

  DashboardController dashboardController = Get.put(DashboardController());

  final DateFormat formatter = DateFormat.yMMMMd('en_US');
  final DateFormat formatters = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddPatientScreen());
        },
        tooltip: 'Add New Patient',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: loadBody(),
    );
  }

  Widget loadBody() {
    return SizedBox(
      height: MediaQuery.of(Get.context!).size.height + 100,
      child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: LiquidPullToRefresh(
            showChildOpacityTransition: false,
            onRefresh: () async {
              controller.isloadingRecentPatients.value = true;
              // controller.patientPagingController =
              //     PagingController(firstPageKey: 0);
              controller.callRecentPatientList(0);
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (Responsive.isMobile(Get.context!))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     textView(),
                        //     InkWell(
                        //       onTap: () async {
                        //         controller.onClose();
                        //         await controller.callRecentPatientList(0);
                        //         data = controller.getAllPatientsList;
                        //       },
                        //       child: Card(
                        //         color: ColorConstant.blue700,
                        //         elevation: 4,
                        //         shadowColor: ColorConstant.gray400,
                        //         child: Container(
                        //           alignment: Alignment.center,
                        //           height: 50,
                        //           width: 150,
                        //           child: Text(
                        //             'Refresh',
                        //             overflow: TextOverflow.ellipsis,
                        //             textAlign: TextAlign.center,
                        //             style: AppStyle
                        //                 .txtRalewayRomanMedium14WhiteA700,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SearchField(
                          controller: dashboardController.searchedText.value,
                          onSearch: (value) {
                            if (value.length > 2) {
                              List<Content> a = [];
                              data?.forEach((element) {
                                if (element.firstName!
                                    .toLowerCase()
                                    .contains(value.toLowerCase())) {
                                  print(true);

                                  a.add(element);
                                }
                              });
                              dashboardController
                                  .patientPagingController.itemList = a;
                            } else {
                              dashboardController
                                  .patientPagingController.itemList = data;
                            }
                          },
                        ),
                      ],
                    ),
                  if (!Responsive.isMobile(Get.context!))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 1, child: textView()),
                        Expanded(
                          flex: 1,
                          child: SearchField(
                            controller: dashboardController.searchedText.value,
                            onSearch: (value) {
                              if (value.length > 2) {
                                data?.forEach((element) {
                                  if (element.firstName!
                                      .toLowerCase()
                                      .contains(value.toLowerCase())) {
                                    print(true);
                                    List<Content> a = [];
                                    a.add(element);
                                    dashboardController
                                        .patientPagingController.itemList = a;
                                  }
                                });
                              } else {
                                dashboardController
                                    .patientPagingController.itemList = data;
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: Responsive.isMobile(Get.context!)
                        ? null
                        : Responsive.isTablet(Get.context!)
                            ? MediaQuery.of(Get.context!).size.height * 0.80
                            : MediaQuery.of(Get.context!).size.height,
                    child: Responsive.isMobile(Get.context!) ||
                            Responsive.isTablet(Get.context!)
                        ? RefreshIndicator(
                            onRefresh: () async {
                              Future.sync(() => dashboardController
                                  .patientPagingController
                                  .refresh());
                              dashboardController
                                  .isloadingRecentPatients.value = true;
                              dashboardController.callRecentPatientList(0);
                            },
                            child: PagedListView<int, Content>.separated(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              pagingController:
                                  dashboardController.patientPagingController,
                              builderDelegate:
                                  PagedChildBuilderDelegate<Content>(
                                animateTransitions: true,
                                itemBuilder: (context, item, index) => Padding(
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
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress),
                                            errorWidget: (context, url, error) {
                                              print(error);
                                              return CustomImageView(
                                                imagePath: !Responsive
                                                        .isDesktop(Get.context!)
                                                    ? 'assets'
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
                                                ? 'assets'
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
                                          'Email: ${item.email == '' ? "N/A" : item.email}',
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
                                          'Date of Birth: ${formatters.format(DateTime.parse(item.dob ?? ""))}',
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
                                      Get.to(() => AppointmentBookingScreen(
                                          doctorsList: doctorsList,
                                          patientDetailsArguments:
                                              PatientDetailsArguments(
                                                  [], item)));
                                    },
                                    onFirstButtonTap: () {
                                      Get.to(() => (PatientDetailsPage(item)));
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
                                      '${item.prefix.toString()}'
                                      '${item.firstName} '
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
              ),
            ),
          )),
    );
  }

  Widget loadDataTable() {
    return Card(
      child: PaginatedDataTable2(
        columnSpacing: 10,
        horizontalMargin: 10,
        minWidth: 500,
        //showBottomBorder: true,
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
          subTitle: 'No patients found.',
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
          DataColumn2(
            label: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Name',
                style: AppStyle.txtInterSemiBold14,
              ),
            ),
            size: ColumnSize.L,
          ),
          DataColumn(
            label: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Address',
                style: AppStyle.txtInterSemiBold14,
              ),
            ),
          ),
          DataColumn(
            label: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Date of birth',
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
                'Mobile',
                style: AppStyle.txtInterSemiBold14,
              ),
            ),
          ),
          DataColumn(
            label: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Actions',
                style: AppStyle.txtInterSemiBold14,
              ),
            ),
            numeric: false,
          ),
        ],
        source: PatientListDataSource(
            dashboardController.patientPagingController.itemList ?? [],
            doctorsList ?? []),
      ),
    );
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
                child: Text('${fileInfo.firstName.toString()} ',
                    semanticsLabel: fileInfo.lastName.toString()),
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

class PatientListDataSource extends DataTableSource {
  final DashboardController dashboardController =
      Get.put(DashboardController());

  List<Content> data = [];
  List<Contents> doctorsData = [];

  PatientListDataSource(List<Content> patients, List<Contents> doctors) {
    data = patients;
    doctorsData = doctors;
  }

  final DateFormat formatter = DateFormat.yMMMMd('en_US');

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                data[index].profilePicture != null
                    ? CachedNetworkImage(
                        width: 60,
                        height: 60,
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
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) {
                          print(error);
                          return CustomImageView(
                            width: 60,
                            height: 60,
                            imagePath: !Responsive.isDesktop(Get.context!)
                                ? 'assets' + '/images/default_profile.png'
                                : '/images/default_profile.png',
                          );
                        },
                      )
                    : CustomImageView(
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                        imagePath: !Responsive.isDesktop(Get.context!)
                            ? 'assets' + '/images/default_profile.png'
                            : '/images/default_profile.png',
                      ),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    '${data[index].firstName} ' + '${data[index].lastName}',
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          onTap: () {}),
      DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${data[index].address}',
              maxLines: 2,
            ),
          ),
          onTap: () {}),
      DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(formatter.format(DateTime.parse('${data[index].dob}'))),
          ),
          onTap: () {}),
      DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${data[index].email}'),
          ),
          onTap: () {}),
      DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${data[index].mobile}'),
          ),
          onTap: () {}),
      //DataCell(Text(
      //    formatter.format(DateTime.parse('${data[index].date}')))),
      DataCell(Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
              onPressed: () {
                Get.to(() => (PatientDetailsPage(data[index])));
              },
              child: const Icon(Icons.remove_red_eye)),
          const SizedBox(
            width: 10,
          ),
          TextButton(
              onPressed: () {
                Get.to(() => AppointmentBookingScreen(
                    doctorsList: doctorsData,
                    patientDetailsArguments:
                        PatientDetailsArguments([], data[index])));
              },
              child: const Text('Book New')),
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
