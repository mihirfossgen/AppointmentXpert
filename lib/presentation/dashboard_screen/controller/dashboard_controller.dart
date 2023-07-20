import 'dart:convert';

import 'package:appointmentxpert/models/staff_list_model.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
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
  RxList<AppointmentContent> patientTodaysData = <AppointmentContent>[].obs;
  RxList<AppointmentContent> upComingAppointments = <AppointmentContent>[].obs;

  static const _pageSize = 20;
  PagingController<int, Content> patientPagingController =
      PagingController(firstPageKey: 0);

  var isloadingPatientData = false.obs;
  var isloadingPatientTodaysAppointments = false.obs;
  var isloadingPatientUpcomingAppointments = false.obs;
  var isloadingStaffData = false.obs;
  var isloadingStaffTodayAppointments = false.obs;
  var isloadingStaffUpcomingAppointments = false.obs;
  var isloadingStaffList = false.obs;
  var isloadingRecentPatients = false.obs;
  var isloadingEmergancyPatients = false.obs;

  getformattedDate(String date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(DateTime.parse(date));
  }

  getformattedtime(String date) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(DateTime.parse(date));
  }

  @override
  void onReady() {
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
    }
  }

  Future<void> callRecentPatientList(int pageNo) async {
    try {
      isloadingRecentPatients.value = true;
      var response = (await Get.find<PatientApi>().getAllPatientsList(pageNo));
      //getAllPatientsList.value = response.content ?? [];
      PatientList patientListData = response;
      //patientPagingController.itemList = [];
      final isLastPage = patientListData.totalElements! < _pageSize;
      if (isLastPage) {
        List<Content> list = patientListData.content ?? [];
        patientPagingController.appendLastPage(list);
      } else {
        List<Content> list = patientListData.content ?? [];
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
      getEmergencyPatientsList.value = response;
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

  Future<void> callStaffList(int pageNumber) async {
    try {
      isloadingStaffList.value = true;
      StaffList response = (await Get.find<StaffApi>().staffList(pageNumber));
      print(response);
      for (var i = 0; i < (response.content?.length ?? 0); i++) {
        if (response.content?[i].profession == "DOCTOR") {
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
      patientTodaysData.value = appointments;
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
                i.status?.toLowerCase() != "completed",
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
        List<AppointmentContent> list = response.content ?? [];
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
      packageImage: PackageImage.Image_1,
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
  }

  void _handleCreateRegisterSuccess() {}
}
