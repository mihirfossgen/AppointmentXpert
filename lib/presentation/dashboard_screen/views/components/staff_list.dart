import 'package:appointmentxpert/network/api/user_api.dart';
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
import '../../../../models/staff_list_model.dart';
import '../../../../network/endpoints.dart';
import '../../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../../../theme/app_style.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/responsive.dart';
import '../../controller/dashboard_controller.dart';
import '../../shared_components/search_field.dart';

class StaffList extends GetView<DashboardController> {
  StaffList({super.key});

  DashboardController dashboardController = Get.put(DashboardController());
  UserApi userApi = Get.put(UserApi());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //Get.to(() => AddPatientScreen());
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: LiquidPullToRefresh(
              showChildOpacityTransition: false,
              onRefresh: () async {
                controller.isloadingStaffList.value = true;
                controller.staffPagingController =
                    PagingController(firstPageKey: 0);
                controller.callStaffList(0);
              },
              child: ListView(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (Responsive.isMobile(context))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          SearchField(
                            onSearch: (value) {
                              // if (value.length > 3) {
                              //   data?.forEach((element) {
                              //     if (element.firstName!
                              //         .toLowerCase()
                              //         .contains(value.toLowerCase())) {
                              //       print(true);
                              //       List<Content> a = [];
                              //       a.add(element);
                              //       dashboardController
                              //           .patientPagingController.itemList = a;
                              //     }
                              //   });
                              // } else {
                              //   dashboardController
                              //       .patientPagingController.itemList = data;
                              // }
                            },
                          ),
                        ],
                      ),
                    if (!Responsive.isMobile(context))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 1, child: textView()),
                          Expanded(
                            flex: 1,
                            child: SearchField(
                              onSearch: (value) {
                                // if (value.length > 3) {
                                //   data?.forEach((element) {
                                //     if (element.firstName!
                                //         .toLowerCase()
                                //         .contains(value.toLowerCase())) {
                                //       print(true);
                                //       List<Content> a = [];
                                //       a.add(element);
                                //       dashboardController
                                //           .patientPagingController.itemList = a;
                                //     }
                                //   });
                                // } else {
                                //   dashboardController
                                //       .patientPagingController.itemList = data;
                                // }
                              },
                            ),
                          )
                        ],
                      ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 630,
                      child: Responsive.isMobile(context)
                          ? RefreshIndicator(
                              onRefresh: () async {
                                Future.sync(() => dashboardController
                                    .staffPagingController
                                    .refresh());
                                dashboardController.isloadingStaffList.value =
                                    true;
                                dashboardController.callStaffList(0);
                              },
                              child: PagedListView<int, Contents>.separated(
                                shrinkWrap: true,
                                pagingController:
                                    dashboardController.staffPagingController,
                                builderDelegate:
                                    PagedChildBuilderDelegate<Contents>(
                                  animateTransitions: true,
                                  itemBuilder: (context, item, index) =>
                                      Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: GFListTile(
                                      icon: const Icon(Icons.arrow_right),
                                      avatar: item.uploadedProfilePath != null
                                          ? CachedNetworkImage(
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.contain,
                                              imageUrl: Uri.encodeFull(
                                                Endpoints.baseURL +
                                                    Endpoints
                                                        .downLoadEmployePhoto +
                                                    item.uploadedProfilePath
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
                                            'Profession: ${item.profession}',
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
                                        // Get.to(() => AppointmentBookingScreen(
                                        //     doctorsList: doctorsList,
                                        //     patientDetailsArguments:
                                        //         PatientDetailsArguments(
                                        //             [], item)));
                                      },
                                      onFirstButtonTap: () {
                                        // Get.to(
                                        //     () => (PatientDetailsPage(item)));
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
                  ],
                ),
              ]),
            )),
      ),
    );
  }

  Widget loadDataTable() {
    final DateFormat formatter = DateFormat.yMMMMd('en_US');
    return Card(
      child: DataTable2(
          columnSpacing: 10,
          horizontalMargin: 10,
          minWidth: 500,
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
            subTitle: 'No staffs found.',
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
                  'Profession',
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
            DataColumn2(
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Actions',
                  style: AppStyle.txtInterSemiBold14,
                ),
              ),
              size: ColumnSize.L,
              numeric: false,
            ),
          ],
          rows: List<DataRow>.generate(
              dashboardController.staffPagingController.itemList?.length ?? 0,
              (index) => DataRow(cells: [
                    DataCell(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              dashboardController
                                          .staffPagingController
                                          .itemList?[index]
                                          .uploadedProfilePath !=
                                      null
                                  ? CachedNetworkImage(
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      imageUrl: Uri.encodeFull(
                                        Endpoints.baseURL +
                                            Endpoints.downLoadEmployePhoto +
                                            dashboardController
                                                .staffPagingController
                                                .itemList![index]
                                                .id
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
                                          width: 60,
                                          height: 60,
                                          imagePath: !Responsive.isDesktop(
                                                  Get.context!)
                                              ? 'assets' +
                                                  '/images/default_profile.png'
                                              : '/images/default_profile.png',
                                        );
                                      },
                                    )
                                  : CustomImageView(
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.contain,
                                      imagePath:
                                          !Responsive.isDesktop(Get.context!)
                                              ? 'assets' +
                                                  '/images/default_profile.png'
                                              : '/images/default_profile.png',
                                    ),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  '${dashboardController.staffPagingController.itemList?[index].firstName} ' +
                                      '${dashboardController.staffPagingController.itemList?[index].lastName}',
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
                            '${dashboardController.staffPagingController.itemList?[index].address}',
                            maxLines: 2,
                          ),
                        ),
                        onTap: () {}),
                    DataCell(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '${dashboardController.staffPagingController.itemList?[index].profession}'),
                        ),
                        onTap: () {}),
                    DataCell(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '${dashboardController.staffPagingController.itemList?[index].email}'),
                        ),
                        onTap: () {}),
                    DataCell(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '${dashboardController.staffPagingController.itemList?[index].mobile}'),
                        ),
                        onTap: () {}),
                    //DataCell(Text(
                    //    formatter.format(DateTime.parse('${data[index].date}')))),
                    DataCell(Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // TextButton(
                        //     onPressed: () {
                        //       // Get.to(() => (PatientDetailsPage(
                        //       //     dashboardController.staffPagingController
                        //       //         .itemList![index])));
                        //     },
                        //     child: const Icon(
                        //       Icons.add,
                        //       color: Colors.black,
                        //     )),
                        TextButton(
                            onPressed: () {
                              // Get.to(() => (PatientDetailsPage(
                              //     dashboardController.staffPagingController
                              //         .itemList![index])));
                            },
                            child: const Icon(Icons.edit)),
                        TextButton(
                            onPressed: () {
                              // Get.to(() => AppointmentBookingScreen(
                              //     doctorsList: doctorsList,
                              //     patientDetailsArguments:
                              //         PatientDetailsArguments(
                              //             [],
                              //             dashboardController
                              //                 .patientPagingController
                              //                 .itemList![index])));
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    )),
                  ]))),
    );
  }
}

Widget textView() => const Text(
      "Staff List",
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w600, fontSize: 17.0),
    );
