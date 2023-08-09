import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

import '../../../core/app_export.dart';
import '../../../core/utils/color_constant.dart';
import '../../../core/utils/size_utils.dart';
import '../../../models/getAllApointments.dart';
//import '../../../models/getallAppointbypoatientidModel.dart';
import '../../../network/api/appointment_api.dart';
import '../../../network/endpoints.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../../theme/app_style.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/responsive.dart';

class ScheduleController extends GetxController {
  bool response = false;

  GetAllAppointments model = GetAllAppointments();
  RxList<AppointmentContent> patientAppointmentlist =
      <AppointmentContent>[].obs;
  String precriptionFileName = "";
  String invoiceFileName = "";
  RxBool isloading = false.obs;
  bool value = false;
  RxBool isLoading = false.obs;
  RxBool isRescheduleLoading = false.obs;
  RxList<AppointmentContent> getAppointmentDetailsByDate =
      <AppointmentContent>[].obs;

  // RxList<AppointmentContent> today = <AppointmentContent>[].obs;
  // RxList<AppointmentContent> upcoming = <AppointmentContent>[].obs;
  // RxList<AppointmentContent> completed = <AppointmentContent>[].obs;
  // RxList<AppointmentContent> today1 = <AppointmentContent>[].obs;
  // RxList<AppointmentContent> upcoming1 = <AppointmentContent>[].obs;
  // RxList<AppointmentContent> completed1 = <AppointmentContent>[].obs;

  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  RxBool sortAscending = true.obs;
  RxInt sortColumnIndex = 0.obs;
//DessertDataSourceAsync? dessertsDataSource;

  RxBool dataSourceLoading = false.obs;
  RxInt initialRow = 0.obs;
  TextEditingController dob = TextEditingController();
  Rx<TextEditingController> from = TextEditingController().obs;
  TextEditingController to = TextEditingController();
  TextEditingController reschduleDate = TextEditingController();

  RxString fromTime = ''.obs;
  RxString toTime = ''.obs;

  List<String>? times;
  RxString selectedStartTime = ''.obs;

  TimeOfDay startTime = const TimeOfDay(hour: 12, minute: 00);
  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 00);
  Duration step = const Duration(minutes: 15);
  int? index;

  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController _timeController = TextEditingController();
  String? _hour, _minute, _time;
  Map<String, dynamic>? a;
  Future<void> selectTime(BuildContext context, int diffInBookingInMin) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      print(picked);
      selectedTime = picked;
    }

    int intervalTime = diffInBookingInMin != 0 ? 15 : 15;
    _hour = selectedTime.hour.toString();
    _minute = selectedTime.minute.toString();
    _time = '$_hour : $_minute';

    from.value.text = formatDate(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
            selectedTime.hour, selectedTime.minute),
        [hh, ':', nn, " ", am]).toString();
    to.text = formatDate(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
            selectedTime.hour, selectedTime.minute + intervalTime),
        [hh, ':', nn, " ", am]).toString();
  }

  getRescheduleDate() {
    DateTime? date = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    return Get.dialog(
        AlertDialog(
          title: const Text('Please select Date'),
          content: SizedBox(
            height: 250,
            width: 100,
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(),
              value: [DateTime.now()],
              onValueChanged: (value) {
                print(value);
                date = value[0];
              },
            ),
          ),
          actions: [
            TextButton(
                child: const Text("Continue"),
                onPressed: () {
                  Get.back(result: date);
                }),
          ],
        ),
        barrierDismissible: false);
  }

  static const _pageSize = 20;
  final formKey = GlobalKey<FormState>();
  // PagingController<int, AppointmentContent> todayPagingController =
  //     PagingController(firstPageKey: 0);
  // PagingController<int, AppointmentContent> upcomingPagingController =
  //     PagingController(firstPageKey: 0);
  // PagingController<int, AppointmentContent> completedPagingController =
  //     PagingController(firstPageKey: 0);
  Rx<PagingController<int, AppointmentContent>> todayPagingController =
      PagingController<int, AppointmentContent>(firstPageKey: 0).obs;
  Rx<PagingController<int, AppointmentContent>> upcomingPagingController =
      PagingController<int, AppointmentContent>(firstPageKey: 0).obs;
  Rx<PagingController<int, AppointmentContent>> completedPagingController =
      PagingController<int, AppointmentContent>(firstPageKey: 0).obs;

  getformattedDate(String date) {
    final DateFormat formatter = DateFormat.yMMMEd();
    return formatter.format(DateTime.parse(date));
  }

  getformattedtime(String date, BuildContext context) {
    DateTime a = DateTime.parse(date);
    final time = TimeOfDay(hour: a.hour, minute: a.minute);
    return time.format(context);
  }

  void didChangeDependencies() {
    // initState is to early to access route options, context is invalid at that stage
    // dessertsDataSource ??= getCurrentRouteOption(Get.context!) == noData
    //     ? DessertDataSourceAsync.empty()
    //     : getCurrentRouteOption(Get.context!) == asyncErrors
    //         ? DessertDataSourceAsync.error()
    //         : DessertDataSourceAsync();

    // if (getCurrentRouteOption(Get.context!) == goToLast) {
    //   dataSourceLoading.value = true;
    //   dessertsDataSource!.getTotalRecords().then((count) {
    //     initialRow.value = count - rowsPerPage;
    //     dataSourceLoading.value = false;
    //   });
    // }
  }

  final GlobalKey _rangeSelectorKey = GlobalKey();

  getTimes() {
    String startTime = "11:45";
    String closeTime = "17:45";
    String space = "00:15";
    Duration spaceDuration = Duration(
        minutes: int.parse(space.split(':')[1]),
        hours: int.parse(space.split(':')[0]));
    TimeOfDay start = TimeOfDay(
        hour: int.parse(startTime.split(':')[0]),
        minute: int.parse(startTime.split(':')[1]));
    TimeOfDay close = TimeOfDay(
        hour: int.parse(closeTime.split(':')[0]),
        minute: int.parse(closeTime.split(':')[1]));
    List<String> timeSlots = [];
    while (start.hour < close.hour ||
        (start.hour == close.hour && start.minute <= close.minute)) {
      final time =
          DateTime(0, 0, 0, start.hour, start.minute).add(spaceDuration);
      String date2 = DateFormat("hh:mm a").format(time);
      timeSlots.add(date2);

      start = TimeOfDay(hour: time.hour, minute: time.minute);
    }

    times = timeSlots;
  }

  @override
  void onInit() {
    isloading.value = true;
    //pagingController.addPageRequestListener((pageKey) {
    if (SharedPrefUtils.readPrefStr('role') != "PATIENT") {
      //SharedPrefUtils.readPrefINt('employee_Id')
      callGetAllAppointments(0, 20);
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      callGetAppointmentDetailsForDate(formatter.format(DateTime.now()));
      final DateFormat format = DateFormat('yyyy-MM-dd');
      reschduleDate.text = format.format(DateTime.now());
      getTimes();
    } else {
      callGetAllAppointmentsForPatient(0);
    }
    //});
    super.onInit;
  }

  @override
  void onReady() {
    // isloading.value = true;
    // pagingController.addPageRequestListener((pageKey) {
    //   if (SharedPrefUtils.readPrefStr('role') != "PATIENT") {
    //     //SharedPrefUtils.readPrefINt('employee_Id')
    //     callGetAllAppointments(pageKey, _pageSize);
    //   } else {
    //     //callAppointmentsByPatientId(SharedPrefUtils.readPrefINt('patient_Id'));
    //   }
    // });
    super.onReady();
  }

  DateTime timeFormat(String value) {
    final now = DateTime.now();
    final dt = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(value.split(':')[0]),
        int.parse(
            value.split(':')[1].replaceAll(" AM", "").replaceAll(" PM", "")));
    return dt;
  }

  String? fromValidator(String value, String startTime, String endTime) {
    if (value.isEmpty) {
      return 'Please select time';
    } else if (timeFormat(value).isAfter(timeFormat(startTime)) ||
        timeFormat(value).isBefore(timeFormat(endTime))) {
      return null;
    } else {
      return "Please select time between 12 to 6 PM";
    }
  }

  String? dobValidator(String value) {
    if (value.isEmpty) {
      return 'Please select date of birth';
    }
    return null;
  }

  bool trySubmit() {
    final isValid = formKey.currentState?.validate();
    Get.focusScope!.unfocus();

    if (isValid == true) {
      formKey.currentState!.save();

      return true;
    }
    return false;
  }

  Future<void> callGetAllAppointments(int pageNo, int count) async {
    print("count ----- $count");
    try {
      model = (await Get.find<AppointmentApi>().getAllAppointments(pageNo));
      final isLastPage = model.numberOfElements! <= _pageSize;
      if (isLastPage) {
        todayPagingController.value.itemList = [];
        upcomingPagingController.value.itemList = [];
        completedPagingController.value.itemList = [];
        List<AppointmentContent> list = model.content ?? [];
        var now = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en-US');
        List<AppointmentContent> appointmentsCompleted =
            list.where((i) => i.status?.toLowerCase() == "completed").toList();
        List<AppointmentContent> appointmentsUpcoming = list
            .where(
              (i) =>
                  i.active == true &&
                  !formatter
                      .parse(i.date!)
                      .isBefore(formatter.parse(now.toString())) &&
                  i.status?.toLowerCase() != "completed",
            )
            .toList();
        List<AppointmentContent> appointmentsToday = list
            .where((i) =>
                dateFormat(i.date!) == dateFormat(DateTime.now().toString()) &&
                i.active == true &&
                i.status?.toLowerCase() != "completed")
            .toList();
        todayPagingController.value.appendLastPage(appointmentsToday);
        upcomingPagingController.value.appendLastPage(appointmentsUpcoming);
        completedPagingController.value.appendLastPage(appointmentsCompleted);
        isloading.value = false;
        update();
      } else {
        List<AppointmentContent> list = model.content ?? [];
        var now = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en-US');
        List<AppointmentContent> appointmentsCompleted =
            list.where((i) => i.status?.toLowerCase() == "completed").toList();
        List<AppointmentContent> appointmentsUpcoming = list
            .where(
              (i) =>
                  i.active == true &&
                  !formatter
                      .parse(i.date!)
                      .isBefore(formatter.parse(now.toString())) &&
                  i.status?.toLowerCase() != "completed",
            )
            .toList();
        List<AppointmentContent> appointmentsToday = list
            .where((i) =>
                dateFormat(i.date!) == dateFormat(DateTime.now().toString()) &&
                i.active == true &&
                i.status?.toLowerCase() != "completed")
            .toList();
        final nextPageKey = pageNo + appointmentsToday.length;
        todayPagingController.value.appendPage(appointmentsToday, nextPageKey);
        upcomingPagingController.value
            .appendPage(appointmentsUpcoming, nextPageKey);
        completedPagingController.value
            .appendPage(appointmentsCompleted, nextPageKey);
        isloading.value = false;
        update();
      }
      // todayPagingController.refresh();
      // upcomingPagingController.refresh();
      // completedPagingController.refresh();
    } on Map {
      //postLoginResp = e;
      todayPagingController.value.error = 'No data found.';
      rethrow;
    } finally {
      isloading.value = false;
    }
  }

  Future<void> callTodayAppointmentsByPatient() async {
    try {
      isloading.value = true;
      var response = (await Get.find<AppointmentApi>().getTodaysAppointments(
          SharedPrefUtils.readPrefINt('patient_Id'), true));
      List<AppointmentContent> list = response;
      var now = DateTime.now();
      List<AppointmentContent> appointments = list
          .where((i) =>
              i.status?.toLowerCase() != 'completed' &&
              now.isAfter(DateFormat('yyyy-MM-dd').parse(i.date!)))
          .toList();
      patientAppointmentlist.value = appointments;
      // _handleCreateLoginSuccess(loginModelObj);
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloading.value = false;
    }
  }

  Future<List<AppointmentContent>> callGetAppointmentDetailsForDate(
      String date) async {
    try {
      isLoading.value = true;
      var response =
          (await Get.find<AppointmentApi>().getAppointmentDetailsViaDate(date));
      List<dynamic> data = response.data;
      List<AppointmentContent> list =
          data.map((e) => AppointmentContent.fromJson(e)).toList();
      getAppointmentDetailsByDate.value = list;
      return list;
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> callGetAllAppointmentsForPatient(int pageIndex) async {
    try {
      isloading.value = true;
      var patientId = SharedPrefUtils.readPrefINt('patient_Id');
      var response = (await Get.find<AppointmentApi>()
          .getAllAppointmentBYPatientId(patientId, pageIndex));
      List<AppointmentContent> list = response;
      var now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en-US');
      todayPagingController.value.itemList = [];
      upcomingPagingController.value.itemList = [];
      completedPagingController.value.itemList = [];
      List<AppointmentContent> appointmentsCompleted =
          list.where((i) => i.status?.toLowerCase() == "completed").toList();
      List<AppointmentContent> appointmentsUpcoming = list
          .where(
            (i) =>
                i.active == true &&
                !formatter
                    .parse(i.date!)
                    .isBefore(formatter.parse(now.toString())) &&
                i.status?.toLowerCase() != "completed",
          )
          .toList();
      List<AppointmentContent> appointmentsToday = list
          .where((i) =>
              dateFormat(i.date!) == dateFormat(DateTime.now().toString()) &&
              i.active == true &&
              i.status?.toLowerCase() != "completed")
          .toList();
      todayPagingController.value.appendLastPage(appointmentsToday);
      upcomingPagingController.value.appendLastPage(appointmentsUpcoming);
      completedPagingController.value.appendLastPage(appointmentsCompleted);
      //patientAppointmentlist.value = appointmentsUpcoming;
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloading.value = false;
    }
  }

  Future<void> updateAppointment(var data) async {
    try {
      value = (await Get.find<AppointmentApi>().updateAppointment(data));
      // if (SharedPrefUtils.readPrefStr('role') != "PATIENT") {
      if (value) {
        isloading.value = true;
        //pagingController.addPageRequestListener((pageKey) {
        if (SharedPrefUtils.readPrefStr('role') != "PATIENT") {
          //SharedPrefUtils.readPrefINt('employee_Id')
          callGetAllAppointments(0, 20);
        } else {
          callGetAllAppointmentsForPatient(0);
        }
        isRescheduleLoading.value = false;
        selectedStartTime.value = '';
        Get.back();
      }
      //   callGetAllAppointments(0, 1);
      // } else {
      //   callAppointmentsByPatientId(SharedPrefUtils.readPrefINt('patient_Id'));
      // }
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  dateFormat(String a) {
    final DateFormat formatter = DateFormat('dd-MMM-yyyy');
    return formatter.format(DateTime.parse(a));
  }

  dateFormatUTC(String a) {
    final DateFormat formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
    return formatter.format(DateTime.parse(a));
  }

  @override
  void onClose() {
    todayPagingController.value.dispose();
    upcomingPagingController.value.dispose();
    completedPagingController.value.dispose();
    super.onClose();
    update();
  }
}

class MyData extends DataTableSource {
  final ScheduleController scheduleController = Get.put(ScheduleController());

  List<AppointmentContent> data = [];
  bool _type = false;

  MyData(List<AppointmentContent> appointments, bool type) {
    data = appointments;
    _type = type;
  }
  final DateFormat formatter = DateFormat('dd-MMM-yyyy');

  @override
  DataRow getRow(int index) {
    AppointmentContent? appointment = data[index];
    return _type == true
        ? loadPatientDataRow(appointment)
        : loadStaffDataRow(appointment);
  }

  loadPatientDataRow(AppointmentContent appointment) {
    return DataRow(cells: [
      DataCell(
          Row(
            children: [
              appointment.examiner?.uploadedProfilePath != null
                  ? CachedNetworkImage(
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                      imageUrl: Uri.encodeFull(Endpoints.baseURL +
                          Endpoints.downLoadEmployePhoto +
                          appointment.examiner!.uploadedProfilePath.toString()),
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
              Flexible(
                  child: Text(
                '${appointment.examiner?.firstName.toString()} ${appointment.examiner?.lastName.toString()}',
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ))
            ],
          ),
          onTap: () {}),

      DataCell(Text(appointment.examiner?.mobile.toString() ?? ''),
          onTap: () {}),
      DataCell(Text(appointment.status.toString()), onTap: () {}),
      DataCell(Text(appointment.note.toString())),
      DataCell(
          Text(formatter.format(DateTime.parse(appointment.date.toString()))),
          onTap: () {}),
      DataCell(
          Text('${appointment.startTime.toString()} - '
              '${appointment.endTime.toString()}'),
          onTap: () {}),
      //DataCell(Text(appointment.endTime.toString()), onTap: () {}),
      // const DataCell(Row(
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     //loadActionButtons(),
      //   ],
      // )),
      DataCell(Row(
        children: [
          // IconButton(
          //   icon: const Icon(Icons.edit),
          //   color: Colors.indigo,
          //   onPressed: () {},
          // ),
          IconButton(
            icon: const Icon(Icons.cancel),
            color: Colors.redAccent,
            onPressed: () {},
          ),
        ],
      )),
    ]);
  }

  loadStaffDataRow(AppointmentContent appointment) {
    return DataRow(cells: [
      DataCell(
          Row(
            children: [
              appointment.patient?.profilePicture != null
                  ? CachedNetworkImage(
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                      imageUrl: Uri.encodeFull(Endpoints.baseURL +
                          Endpoints.downLoadPatientPhoto +
                          appointment.patient!.profilePicture.toString()),
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
              Flexible(
                  child: Text(
                '${appointment.patient?.firstName.toString()} ${appointment.patient?.lastName.toString()}',
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ))
            ],
          ),
          onTap: () {}),
      DataCell(Flexible(
          child: Text(
        '${appointment.examiner?.firstName.toString()} ${appointment.examiner?.lastName.toString()}',
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ))),
      DataCell(Text(appointment.patient?.mobile.toString() ?? ''),
          onTap: () {}),
      DataCell(Text(appointment.note.toString()), onTap: () {}),
      //DataCell(Text('${data[index].visit}')),
      DataCell(
          Text(formatter.format(DateTime.parse(appointment.date.toString()))),
          onTap: () {}),
      DataCell(
          Text('${appointment.startTime.toString()} - '
              '${appointment.endTime.toString()}'),
          onTap: () {}),
      // const DataCell(Row(
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     //loadActionButtons(),
      //   ],
      // )),
      appointment.status?.toLowerCase() != 'completed'
          ? DataCell(Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  color: Colors.indigo,
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      showDialog(
                        context: Get.context!,
                        builder: (context) => AlertDialog(
                          title: const Text('Reschdule Appointment'),
                          actions: [
                            Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 0, 15, 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          child: InkWell(
                                            onTap: () async {
                                              DateTime a =
                                                  await scheduleController
                                                      .getRescheduleDate();

                                              final DateFormat formatter =
                                                  DateFormat('yyyy-MM-dd');
                                              scheduleController.dob.text =
                                                  formatter.format(a);
                                            },
                                            child: AbsorbPointer(
                                              child: CustomTextFormField(
                                                  controller: scheduleController
                                                      .dob,
                                                  labelText: "Date",
                                                  size: size,
                                                  validator: (value) {
                                                    return scheduleController
                                                        .dobValidator(
                                                            value ?? "");
                                                  },
                                                  padding: TextFormFieldPadding
                                                      .PaddingT14,
                                                  textInputType: TextInputType
                                                      .emailAddress,
                                                  suffix: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: const Icon(Icons
                                                          .calendar_month)),
                                                  suffixConstraints:
                                                      BoxConstraints(
                                                          maxHeight:
                                                              getVerticalSize(
                                                                  56))),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            scheduleController.selectTime(
                                                Get.context!,
                                                appointment.examiner
                                                        ?.timeSlotForBookingInMin ??
                                                    0);
                                          },
                                          child: AbsorbPointer(
                                            child: CustomTextFormField(
                                                labelText: "From",
                                                controller: scheduleController
                                                    .from.value,
                                                padding: TextFormFieldPadding
                                                    .PaddingT14,
                                                textInputType: TextInputType
                                                    .emailAddress,
                                                validator: (value) {
                                                  return scheduleController
                                                      .fromValidator(
                                                          value ?? "",
                                                          scheduleController.a?[
                                                                  'startTime'] ??
                                                              "12:00 PM",
                                                          scheduleController.a?[
                                                                  'endTime'] ??
                                                              "06:00 PM");
                                                },
                                                suffix: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child:
                                                      const Icon(Icons.alarm),
                                                ),
                                                suffixConstraints:
                                                    BoxConstraints(
                                                        maxHeight:
                                                            getVerticalSize(
                                                                56))),
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                        AbsorbPointer(
                                          child: CustomTextFormField(
                                              controller: scheduleController.to,
                                              labelText: "To",
                                              padding: TextFormFieldPadding
                                                  .PaddingT14,
                                              textInputType:
                                                  TextInputType.datetime,
                                              suffix: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                child: const Icon(Icons.alarm),
                                              ),
                                              suffixConstraints: BoxConstraints(
                                                  maxHeight:
                                                      getVerticalSize(56))),
                                        ),
                                      ],
                                    )),
                                Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                      //height: getVerticalSize(56),
                                      //width: getHorizontalSize(110),
                                      child:
                                          const Text("Rechsdule Appointment"),
                                      // shape: ButtonShape.RoundedBorder8,
                                      // padding: ButtonPadding.PaddingAll16,
                                      // fontStyle: ButtonFontStyle
                                      //     .RalewayRomanSemiBold14WhiteA700,
                                      onPressed: () async {
                                        var requestData = {
                                          "active": true,
                                          "date": DateTime.parse(
                                                  "${scheduleController.dob.text} ${scheduleController.from.value.text.replaceAll(" PM", "").replaceAll(" AM", "")}")
                                              .toIso8601String(),
                                          "startTime": scheduleController
                                              .from.value.text,
                                          "endTime":
                                              scheduleController.to.value.text,
                                          "examinerId":
                                              appointment.examiner!.id,
                                          "note": appointment.note,
                                          "id": appointment.id,
                                          "patientId": appointment.patient?.id,
                                          "purpose": "CHECKUP",
                                          "status": "Reschduled",
                                          "update_time_in_min": 0
                                        };
                                        print(jsonEncode(requestData));
                                        scheduleController
                                            .updateAppointment(requestData);
                                      }),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    });
                  },
                ),
                IconButton(
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      showDialog(
                        context: Get.context!,
                        builder: (context) => AlertDialog(
                          title: const Text(
                              'Are you sure appointment is completed?'),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    var data = {
                                      "active": false,
                                      "id": appointment.id,
                                      "date": appointment.date,
                                      "examinerId": appointment.examiner!.id,
                                      "note": appointment.note,
                                      "patientId": appointment.patient?.id,
                                      "purpose": appointment.purpose,
                                      "status": "Completed"
                                    };
                                    scheduleController.updateAppointment(data);
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: ColorConstant.blue700,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Yes',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: AppStyle
                                          .txtRalewayRomanRegular14WhiteA700,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: ColorConstant.blue700,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'No',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: AppStyle
                                          .txtRalewayRomanRegular14WhiteA700,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.check),
                  color: Colors.green,
                ),
                IconButton(
                  icon: const Icon(Icons.cancel),
                  color: Colors.redAccent,
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      showDialog(
                        context: Get.context!,
                        builder: (context) => AlertDialog(
                          title:
                              const Text('Are you sure to cancel appointment?'),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // call cancel appointment
                                    var data = {
                                      "active": false,
                                      "id": appointment.id,
                                      "date": appointment.date,
                                      "examinerId": appointment.examiner!.id,
                                      "note": appointment.note,
                                      "patientId": appointment.patient?.id,
                                      "purpose": appointment.purpose,
                                      "status": "Canceled"
                                    };
                                    scheduleController.updateAppointment(data);
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: ColorConstant.blue700,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Yes',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: AppStyle
                                          .txtRalewayRomanRegular14WhiteA700,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: ColorConstant.blue700,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'No',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: AppStyle
                                          .txtRalewayRomanRegular14WhiteA700,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    });
                  },
                ),
              ],
            ))
          : DataCell(Row(
              children: [
                // IconButton(
                //     onPressed: () {}, icon: const Icon(Icons.remove_red_eye),)
                TextButton(onPressed: () {}, child: const Text('View'))
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
