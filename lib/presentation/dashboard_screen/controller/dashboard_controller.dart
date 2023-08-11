import 'dart:convert';

import 'package:appointmentxpert/models/staff_list_model.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

import '../../../models/emergency_patient_list.dart';
import '../../../models/getAllApointments.dart';
import '../../../models/getallEmplyesList.dart';
import '../../../models/patient_list_model.dart';
import '../../../models/patient_model.dart';
import '../../../models/staff_model.dart';
import '../../../network/api/appointment_api.dart';
import '../../../network/api/patient_api.dart';
import '../../../network/api/staff_api.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../shared_components/list_recent_patient.dart';
import '../shared_components/selection_button.dart';
import '../shared_components/task_progress.dart';
import '../shared_components/user_profile.dart';

enum pats { Existing, New }

class DashboardController extends GetxController {
  final scafoldKey = GlobalKey<ScaffoldState>();

  final dataProfil = const UserProfileData(
    image: AssetImage('assets/images/img_7xm2.png'),
    name: "Ashish Ranade",
    subTitle: "Project Manager",
  );

  RxInt selectedPageIndex = 0.obs;
  RxInt radioButtonIndex = 0.obs;
  RxString radioButtonVal = "".obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  Map postAppointmentResp = {};

  //final member = ["Avril Kimberly", "Michael Greg"];

  final dataTask = const TodaysAppointmentsProgressData(
      totalAppointments: 5, totalCompleted: 1);

  void onPressedProfil() {}

  void onSelectedMainMenu(int index, SelectionButtonData value) {
    selectedPageIndex.value = index;
  }

  void onSelectedTabBarMainMenu(int index) {
    selectedPageIndex.value = index;
  }

  void onSelectedTaskMenu(int index, String label) {}

  void searchTask(String value) {}

  void onPressedPatient(int index, Content data) {}
  //void onPressedAssignTask(int index, ListRecentPatientData data) {}
  //void onPressedMemberTask(int index, ListRecentPatientData data) {}
  void onPressedCalendar() {}
  void onPressedGroup(int index, ListRecentPatientData data) {}

  void openDrawer() {
    if (scafoldKey.currentState != null) {
      scafoldKey.currentState!.openDrawer();
    }
  }

  String role = SharedPrefUtils.readPrefStr("role");
  RxList<Content> getAllPatientsList = <Content>[].obs;
  RxList<EmergencyContent> getEmergencyPatientsList = <EmergencyContent>[].obs;

  Rx<GetAllEmployesList> getAllEmployesList = GetAllEmployesList().obs;

  Rx<StaffData> staffData = StaffData().obs;
  Rx<PatientData> patientData = PatientData().obs;
  RxList<AppointmentContent> staffTodaysData = <AppointmentContent>[].obs;
  RxList<AppointmentContent> staffTodaysCompletedData =
      <AppointmentContent>[].obs;
  RxList<AppointmentContent> staffTodaysTotalData = <AppointmentContent>[].obs;
  RxList<AppointmentContent> patientTodaysData = <AppointmentContent>[].obs;
  RxList<AppointmentContent> upComingAppointments = <AppointmentContent>[].obs;
  var patientNumber;
  Rx<TextEditingController> searchedText = TextEditingController().obs;

  Rx<AppointmentContent> currentStaffAppointmentData = AppointmentContent().obs;
  Rx<AppointmentContent> currentPatientAppointmentData =
      AppointmentContent().obs;
  final calendarControllerToday = AdvancedCalendarController.today();
  // AdvancedCalendarController calendarControllerCustom =
  //     AdvancedCalendarController(DateTime(2022, 10, 23));
  final events = <DateTime>[];
  PatientApi patientAPi = Get.put(PatientApi());
  static const _pageSize = 20;
  PagingController<int, Content> patientPagingController =
      PagingController(firstPageKey: 0);
  PagingController<int, Contents> staffPagingController =
      PagingController(firstPageKey: 0);
  Contents? staffDataa;

  var isloadingPatientData = false.obs;
  var isloadingPatientTodaysAppointments = false.obs;
  var isloadingPatientUpcomingAppointments = false.obs;
  var isloadingStaffData = false.obs;
  var isloadingStaffTodayAppointments = false.obs;
  var isloadingStaffUpcomingAppointments = false.obs;
  var isloadingStaffList = false.obs;
  var isloadingRecentPatients = false.obs;
  var isloadingEmergancyPatients = false.obs;
  RxBool isLoadingAppointmentsByDate = false.obs;
  List<Contents> doctorsList = [];

  RxList<AppointmentContent> getAppointmentDetailsByDate =
      <AppointmentContent>[].obs;

  getformattedDate(String date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(DateTime.parse(date));
  }

  getformattedtime(String date) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(DateTime.parse(date));
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );

  @override
  void onReady() async {
    super.onReady();
    if (role == "PATIENT") {
      getPatientDetails(SharedPrefUtils.readPrefINt('patient_Id'));
      callTodayAppointmentsByPatient();
      getUpcomingAppointments(0, true);
    } else {
      patientPagingController = PagingController(firstPageKey: 0);
      patientPagingController.itemList = [];
      callStaffData(SharedPrefUtils.readPrefINt('employee_Id'));
      callStaffTodayAppointments();
      callStaffUpcomingAppointments();
      callStaffList(0);
      callRecentPatientList(0);
      callEmergencyPatientList();
      getTimes();
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      callGetAppointmentDetailsForDate(formatter.format(DateTime.now()));
    }
  }

  String userNumber = '';
  String? numberValidator(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    } else {
      userNumber = value;
    }
    return null;
  }

  final RegExp nameRegExp = RegExp('[a-zA-Z]');
  String? firstNameValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter first name';
    } else if (value == " ") {
      return 'Enter valid name';
    } else if (!nameRegExp.hasMatch(value)) {
      return 'Enter valid name';
    } else {
      return null;
    }
  }

  String? emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (!(regex.hasMatch(value))) return "Invalid Email";

    return null;
  }

  final formKey = GlobalKey<FormState>();

  bool trySubmit() {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();

    if (isValid) {
      formKey.currentState!.save();

      return true;
    }
    return false;
  }

  Future<void> callRecentPatientList(int pageNo) async {
    try {
      isloadingRecentPatients.value = true;
      var response = (await Get.find<PatientApi>().getAllPatientsList(pageNo));
      getAllPatientsList.value = response.content ?? [];
      PatientList patientListData = response;
      isloadingRecentPatients.value = false;
      //patientPagingController.itemList = [];
      final isLastPage = patientListData.totalElements! < _pageSize;
      if (isLastPage) {
        isloadingRecentPatients.value = false;
        List<Content> list = patientListData.content ?? [];
        patientPagingController.appendLastPage(list);
      } else {
        isloadingRecentPatients.value = false;
        List<Content> list = patientListData.content ?? [];
        getAllPatientsList.value = response.content ?? [];
        final nextPageKey = pageNo + list.length;
        patientPagingController.appendPage(list, nextPageKey);
      }

      update();
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloadingRecentPatients.value = false;
    }
  }

  Future<void> callEmergencyPatientList() async {
    try {
      isloadingEmergancyPatients.value = true;
      var response =
          (await Get.find<AppointmentApi>().getEmergencyPatientsList());
      //print(response.content);
      List<EmergencyContent> requests = response
          .where((i) =>
              dateFormat(i.date!) == dateFormat(DateTime.now().toString()))
          .toList();
      getEmergencyPatientsList.value = requests;
      //getUpcomingAppointments(0, true);
      //getPatientDetails(SharedPrefUtils.readPrefINt('patient_Id'));
      // _handleCreateLoginSuccess(loginModelObj);
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloadingEmergancyPatients.value = false;
    }
  }

  Future<void> updateAppointment(var data) async {
    try {
      bool value = (await Get.find<AppointmentApi>().updateAppointment(data));
      // if (SharedPrefUtils.readPrefStr('role') != "PATIENT") {
      if (value) {
        Get.back();
      }
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  Future<void> callStaffData(int staffId) async {
    try {
      isloadingStaffData.value = true;
      var response = (await Get.find<StaffApi>().getstaffbyid(staffId));
      staffData.value = response;
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloadingStaffData.value = false;
    }
  }

  Future<List<AppointmentContent>> callGetAppointmentDetailsForDate(
      String date) async {
    try {
      isloadingStaffData.value = true;
      var response =
          (await Get.find<AppointmentApi>().getAppointmentDetailsViaDate(date));
      List<dynamic> data = response.data;
      List<AppointmentContent> list =
          data.map((e) => AppointmentContent.fromJson(e)).toList();
      for (var i = 0; i < list.length; i++) {
        print(list[i].startTime);
      }
      getAppointmentDetailsByDate.value = list;
      return list;
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloadingStaffData.value = false;
    }
  }

  Future<void> callStaffList(int pageNumber) async {
    try {
      isloadingStaffList.value = true;
      StaffList response = (await Get.find<StaffApi>().staffList(pageNumber));
      print(response);
      staffPagingController.itemList = [];
      staffPagingController.appendLastPage(response.content ?? []);
      doctorsList.clear();
      for (var i = 0; i < (response.content?.length ?? 0); i++) {
        print(response.content?[i].profession);
        if (response.content?[i].profession?.toLowerCase() == "doctor") {
          print(response.content?[i].profession);
          staffDataa = response.content![i];
          doctorsList.add(response.content![i]);
          print({"doctors list length ----- ${doctorsList.length}"});
          SharedPrefUtils.saveStr(
              'doctor_details', jsonEncode(response.content![i]));
        }
      }
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloadingStaffList.value = false;
    }
  }

  Future<void> updateStaff(var data) async {
    try {
      bool value = (await Get.find<StaffApi>().staffUpdate(data));
      // if (SharedPrefUtils.readPrefStr('role') != "PATIENT") {
      if (value) {
        callStaffList(0);
        Get.back();
      }
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

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

  getTimeSlots() {
    getTimes();
  }

  int? _getTimeInMinutesSinceMidnight(String time) {
    final parts = time.split(":");

    if (parts.length != 2) {
      return null;
    }

    final a = int.tryParse(parts[0]);
    final b = int.tryParse(parts[1]);
    if (a == null || b == null) {
      return null;
    }

    return a * 60 + b;
  }

  String _getTimeInStringForMinutesSinceMidnight(int time) {
    final hours = time ~/ 60;
    final minutes = time % 60;

    formatTime(int val) {
      if (val < 10) {
        return "0$val";
      } else {
        return "$val";
      }
    }

    String a = "${formatTime(hours)}:${formatTime(minutes)}";

    String b = utcTo12HourFormat(a);

    return b;
  }

  String utcTo12HourFormat(String bigTime) {
    DateTime tempDate = DateFormat("hh:mm").parse(bigTime);
    var dateFormat = DateFormat("hh:mm a"); // you can change the format here
    var utcDate = dateFormat.format(tempDate); // pass the UTC time here
    var localDate = dateFormat.parse(utcDate, true).toLocal().toString();
    String createdDate = dateFormat.format(DateTime.parse(localDate));
    print("------------$createdDate");
    return createdDate;
  }

  final startTime = const TimeOfDay(hour: 12, minute: 0);
  final endTime = const TimeOfDay(hour: 18, minute: 0);
  final step = const Duration(minutes: 15);
  List<String>? times;
  String? finalTime;

  // Future<void> callAppointmentsByStaffId(int staffId, bool active) async {
  //   try {
  //     //isloading(true);
  //     var response = (await Get.find<AppointmentApi>()
  //         .getTodaysAppointmentsByExaminerId(staffId, active));
  //     print(response);
  //     staffTodaysData.value = response;

  //     //isloading(false);
  //     // _handleCreateLoginSuccess(loginModelObj);
  //   } on Map {
  //     //postLoginResp = e;
  //     isloading(false);
  //     rethrow;
  //   }
  // }

  Future<void> callTodayAppointmentsByPatient() async {
    try {
      isloadingPatientTodaysAppointments.value = true;
      var response = (await Get.find<AppointmentApi>().getTodaysAppointments(
          SharedPrefUtils.readPrefINt('patient_Id'), true));
      List<AppointmentContent> list = response;
      var now = DateTime.now();
      List<AppointmentContent> appointments = list
          .where((i) =>
              i.status?.toLowerCase() != 'completed' &&
              now.isAfter(DateFormat('yyyy-MM-dd').parse(i.date!)))
          .toList();
      if (appointments.isNotEmpty) {
        currentPatientAppointmentData.value = appointments[0];
      }
      patientTodaysData.value = appointments;

      List<AppointmentContent> timeList = list
          .where((i) =>
              i.status?.toLowerCase() == 'completed' &&
              now.isAfter(DateFormat('yyyy-MM-dd').parse(i.date!)))
          .toList();

      int number = timeList.length;

      patientNumber = number;

      // _handleCreateLoginSuccess(loginModelObj);
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloadingPatientTodaysAppointments.value = false;
    }
  }

  Future<void> callStaffTodayAppointments() async {
    try {
      isloadingStaffTodayAppointments.value = true;
      var response = (await Get.find<AppointmentApi>()
          .getAllReceiptionstTodayAppointment());
      List<AppointmentContent> list = response;
      //List<AppointmentContent> match = [];
      List<AppointmentContent> appointments = list
          .where((i) =>
              i.status?.toLowerCase() != 'completed' &&
              dateFormat(i.date!) == dateFormat(DateTime.now().toString()))
          .toList();
      staffTodaysData.value = appointments;
      if (appointments.isNotEmpty) {
        currentStaffAppointmentData.value = appointments[0];
      }
      List<AppointmentContent> totalTodayList = list
          .where((i) =>
              dateFormat(i.date!) == dateFormat(DateTime.now().toString()))
          .toList();
      staffTodaysTotalData.value = totalTodayList;

      List<AppointmentContent> completedList = list
          .where((i) =>
              i.status?.toLowerCase() == 'completed' &&
              dateFormat(i.date!) == dateFormat(DateTime.now().toString()))
          .toList();
      staffTodaysCompletedData.value = completedList;
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloadingStaffTodayAppointments.value = false;
    }
  }

  dateFormat(String a) {
    final DateFormat formatter = DateFormat('dd-MMM-yyyy');
    return formatter.format(DateTime.parse(a));
  }

  Future<void> callStaffUpcomingAppointments() async {
    try {
      isloadingStaffUpcomingAppointments.value = true;
      var response =
          (await Get.find<AppointmentApi>().getAllReceiptionstAppointment(0));
      List<AppointmentContent> list = response;
      var now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en-US');
      List<AppointmentContent> appointmentsUpcoming = list
          .where(
            (i) =>
                i.active == true &&
                !formatter
                    .parse(i.date!)
                    .isBefore(formatter.parse(now.toString())) &&
                i.status?.toLowerCase() != "completed" &&
                formatter.parse(i.date!) != formatter.parse(now.toString()),
          )
          .toList();
      upComingAppointments.value = appointmentsUpcoming;
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloadingStaffUpcomingAppointments.value = false;
    }
  }

  Future<void> getUpcomingAppointments(int pageIndex, bool isForPatient) async {
    try {
      isloadingPatientUpcomingAppointments.value = true;
      if (isForPatient == true) {
        var patientId = SharedPrefUtils.readPrefINt('patient_Id');
        var response = (await Get.find<AppointmentApi>()
            .getAllAppointmentBYPatientId(patientId, pageIndex));
        List<AppointmentContent> list = response;
        var now = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en-US');
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
        upComingAppointments.value = appointmentsUpcoming;
      } else {
        var response =
            (await Get.find<AppointmentApi>().getAllAppointments(pageIndex));
        //List<AppointmentContent> list = response.content ?? [];
        List<AppointmentContent> list = response;
        var now = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en-US');
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
        upComingAppointments.value = appointmentsUpcoming;
      }
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloadingPatientUpcomingAppointments.value = false;
    }
  }

  Future<void> callDoctorsList(Map<String, dynamic> req) async {
    try {
      var response = (await Get.find<StaffApi>().callDoctorsList(
        headers: {
          'Content-type': 'application/json',
        },
        data: req,
      ));
      print(response.doctorList);
      getAllEmployesList.value = response;
      getPatientDetails(SharedPrefUtils.readPrefINt('patient_Id'));
      // _handleCreateLoginSuccess(loginModelObj);
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  Future<void> getPatientDetails(int id) async {
    try {
      isloadingPatientData.value = true;
      patientData.value =
          (await Get.find<PatientApi>().getPatientDetails(headers: {
        'Content-type': 'application/json',
      }, id: id));
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloadingPatientData.value = false;
    }
  }

  Future<void> addEmergencyAppointment(Map<String, dynamic> req) async {
    try {
      postAppointmentResp =
          (await Get.find<AppointmentApi>().addEmergencyAppointment(
        headers: {
          'Content-type': 'application/json',
        },
        data: req,
      ));
      _handleCreateRegisterSuccess();
    } on Map catch (e) {
      postAppointmentResp = e;
      rethrow;
    }
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning, ';
    }
    if (hour < 17) {
      return 'Good Afternoon, ';
    }
    return 'Good Evening, ';
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

  @override
  void onClose() {
    super.onClose();
    getAllPatientsList.clear();
    searchedText.value.clear();
  }

  void _handleCreateRegisterSuccess() {}
}
