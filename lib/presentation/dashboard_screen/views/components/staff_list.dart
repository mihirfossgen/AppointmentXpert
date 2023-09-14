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
import '../../../../core/utils/size_utils.dart';
import '../../../../models/staff_list_model.dart';
import '../../../../network/api/staff_api.dart';
import '../../../../network/endpoints.dart';
import '../../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../../../theme/app_style.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/responsive.dart';
import '../../controller/dashboard_controller.dart';

class StaffList extends GetView<DashboardController> {
  StaffList({super.key});

  DashboardController dashboardController = Get.put(DashboardController());
  UserApi userApi = Get.put(UserApi());
  StaffApi staffApi = Get.put(StaffApi());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Get.to(() => AddPatientScreen());
        },
        tooltip: 'Add New Staff',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,*/
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
                  // if (Responsive.isMobile(context))
                  //   Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       const SizedBox(
                  //         height: 10.0,
                  //       ),
                  //       // SearchField(
                  //       //   onSearch: (value) {
                  //       //     if (value.length > 3) {
                  //       //       data?.forEach((element) {
                  //       //         if (element.firstName!
                  //       //             .toLowerCase()
                  //       //             .contains(value.toLowerCase())) {
                  //       //           print(true);
                  //       //           List<Content> a = [];
                  //       //           a.add(element);
                  //       //           dashboardController
                  //       //               .patientPagingController.itemList = a;
                  //       //         }
                  //       //       });
                  //       //     } else {
                  //       //       dashboardController
                  //       //           .patientPagingController.itemList = data;
                  //       //     }
                  //       //   },
                  //       // ),
                  //     ],
                  //   ),
                  if (!Responsive.isMobile(context))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 1, child: textView()),
                        const Expanded(flex: 1, child: SizedBox()
                            // SearchField(
                            //   onSearch: (value) {
                            //     if (value.length > 3) {
                            //       data?.forEach((element) {
                            //         if (element.firstName!
                            //             .toLowerCase()
                            //             .contains(value.toLowerCase())) {
                            //           print(true);
                            //           List<Content> a = [];
                            //           a.add(element);
                            //           dashboardController
                            //               .patientPagingController.itemList = a;
                            //         }
                            //       });
                            //     } else {
                            //       dashboardController
                            //           .patientPagingController.itemList = data;
                            //     }
                            //   },
                            // ),
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
                              physics: const ScrollPhysics(),
                              builderDelegate:
                                  PagedChildBuilderDelegate<Contents>(
                                animateTransitions: true,
                                itemBuilder: (context, item, index) => Padding(
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
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress),
                                            errorWidget: (context, url, error) {
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
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                    firstButtonTitle: 'Remove',

                                    onSecondButtonTap: () {},
                                    onFirstButtonTap: () {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((timeStamp) {
                                        showDialog(
                                          context: Get.context!,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                                'Are you sure you want to remove the staff member?'),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomButton(
                                                      height:
                                                          getVerticalSize(60),
                                                      width:
                                                          getHorizontalSize(80),
                                                      text: 'Yes',
                                                      margin: getMargin(
                                                          left: 10, right: 00),
                                                      fontStyle: ButtonFontStyle
                                                          .RalewayRomanSemiBold14WhiteA700,
                                                      onTap: () async {
                                                        var data = {
                                                          "id": item.id,
                                                          "status":
                                                              "NOT_ACTIVE",
                                                          "profession":
                                                              item.profession,
                                                          "userId": item.userId
                                                        };
                                                        controller
                                                            .updateStaff(data);
                                                      }),
                                                  CustomButton(
                                                      height:
                                                          getVerticalSize(60),
                                                      width:
                                                          getHorizontalSize(80),
                                                      text: 'No',
                                                      margin: getMargin(
                                                          left: 0, right: 10),
                                                      fontStyle: ButtonFontStyle
                                                          .RalewayRomanSemiBold14WhiteA700,
                                                      onTap: () async {
                                                        Get.back();
                                                      })
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                    },
                                    //focusColor: ,
                                    focusNode: FocusNode(),
                                    //hoverColor: Colors.blue,
                                    //icon: ,
                                    listItemTextColor: GFColors.DARK,

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
                  )
                ],
              ),
            ]),
          )),
    );
  }

  Widget loadDataTable() {
    final DateFormat formatter = DateFormat.yMMMMd('en_US');
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

        source: StaffDataSource(
            dashboardController.staffPagingController.itemList ?? []),
      ),
    );
  }
}

Widget textView() => const Text(
      "Staff List",
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w600, fontSize: 17.0),
    );

class StaffDataSource extends DataTableSource {
  final DashboardController dashboardController =
      Get.put(DashboardController());

  List<Contents> data = [];

  StaffDataSource(List<Contents> staffs) {
    data = staffs;
  }

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                data[index].uploadedProfilePath != null
                    ? Image.network(
                        width: 40,
                        height: 40,
                        scale: 0.5,
                        fit: BoxFit.contain,
                        Uri.encodeFull(
                          Endpoints.baseURL +
                              Endpoints.downLoadEmployePhoto +
                              data[index].uploadedProfilePath.toString(),
                        ),
                        headers: {
                          "Authorization":
                              "Bearer ${SharedPrefUtils.readPrefStr("auth_token")}"
                        },
                        loadingBuilder: (context, url, downloadProgress) =>
                            const Center(child: CircularProgressIndicator()),
                        errorBuilder: (context, url, error) {
                          return CustomImageView(
                            width: 40,
                            height: 40,
                            imagePath: !Responsive.isDesktop(Get.context!)
                                ? 'assets' + '/images/default_profile.png'
                                : '/images/default_profile.png',
                          );
                        },
                      )
                    : CustomImageView(
                        width: 40,
                        height: 40,
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
            child: Text('${data[index].profession}'),
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
          // TextButton(
          //     onPressed: () {
          //       // Get.to(() => (PatientDetailsPage(
          //       //     dashboardController.staffPagingController
          //       //         .itemList![index])));
          //     },
          //     child: const Icon(Icons.edit)),
          TextButton(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  showDialog(
                    context: Get.context!,
                    builder: (context) => AlertDialog(
                      title: const Text(
                          'Are you sure you want to remove the staff member?'),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                                height: getVerticalSize(60),
                                width: getHorizontalSize(80),
                                text: 'Yes',
                                margin: getMargin(left: 10, right: 00),
                                fontStyle: ButtonFontStyle
                                    .RalewayRomanSemiBold14WhiteA700,
                                onTap: () async {
                                  var rdata = {
                                    "id": data[index].id,
                                    "status": "NOT_ACTIVE",
                                    "profession": data[index].profession,
                                    "userId": data[index].userId
                                  };
                                  dashboardController.updateStaff(rdata);
                                }),
                            CustomButton(
                                height: getVerticalSize(60),
                                width: getHorizontalSize(80),
                                text: 'No',
                                margin: getMargin(left: 0, right: 10),
                                fontStyle: ButtonFontStyle
                                    .RalewayRomanSemiBold14WhiteA700,
                                onTap: () async {
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
              )),
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
