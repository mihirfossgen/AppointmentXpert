import 'package:appointmentxpert/models/emergency_patient_list.dart';
import 'package:appointmentxpert/models/staff_list_model.dart';
import 'package:appointmentxpert/models/temp_hold.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

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

  Map postAppointmentResp = Map();

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
  final PagingController<int, Content> patientPagingController =
      PagingController(firstPageKey: 0);

  var isloading = false.obs;

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
    print(role);
    isloading.value = true;
    if (role == "PATIENT") {
      getPatientDetails(SharedPrefUtils.readPrefINt('patient_Id'));
    } else {
      callDoctorsData(SharedPrefUtils.readPrefINt('employee_Id'));
      callStaffList(0);
      callEmergencyPatientList();
    }
  }

  Future<void> callRecentPatientList(int pageNo) async {
    try {
      var response = (await Get.find<PatientApi>().getAllPatientsList(pageNo));
      print(response.content);
      //getAllPatientsList.value = response.content ?? [];
      PatientList patientListData = response;
      patientPagingController.itemList = [];
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
      //getUpcomingAppointments(0, true);
      isloading(false);
      //getPatientDetails(SharedPrefUtils.readPrefINt('patient_Id'));
      // _handleCreateLoginSuccess(loginModelObj);
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloading(false);
    }
  }

  Future<void> callEmergencyPatientList() async {
    try {
      var response =
          (await Get.find<AppointmentApi>().getEmergencyPatientsList());
      //print(response.content);
      getEmergencyPatientsList.value = response;
      //getUpcomingAppointments(0, true);
      isloading(false);
      //getPatientDetails(SharedPrefUtils.readPrefINt('patient_Id'));
      // _handleCreateLoginSuccess(loginModelObj);
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloading(false);
    }
  }

  Future<void> callDoctorsData(int staffId) async {
    try {
      var response = (await Get.find<StaffApi>().getstaffbyid(staffId));
      print(response);
      staffData.value = response;
      //callAppointmentsByStaffId(
      //    SharedPrefUtils.readPrefINt('employee_Id'), true);
      callReceiptionTodayAppointments();
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  Future<void> callStaffList(int pageNumber) async {
    try {
      StaffList response = (await Get.find<StaffApi>().staffList(pageNumber));
      print(response);
      for (var i = 0; i < (response.content?.length ?? 0); i++) {
        if (response.content?[i].profession == "DOCTOR") {
          TempHold().DoctorName =
              "${response.content![i].firstName} ${response.content![i].lastName}";
          SharedPrefUtils.saveStr('doctor_name',
              "${response.content![i].firstName} ${response.content![i].lastName}");
          SharedPrefUtils.saveInt('staff_id', response.content![i].id ?? 0);
        }
      }
      callReceiptionTodayAppointments();
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  Future<void> callAppointmentsByStaffId(int staffId, bool active) async {
    try {
      //isloading(true);
      var response = (await Get.find<AppointmentApi>()
          .getTodaysAppointmentsByExaminerId(staffId, active));
      print(response);
      staffTodaysData.value = response;
      callRecentPatientList(0);
      //isloading(false);
      // _handleCreateLoginSuccess(loginModelObj);
    } on Map {
      //postLoginResp = e;
      isloading(false);
      rethrow;
    }
  }

  Future<void> callAppointmentstodaybypatientid() async {
    try {
      //isloading(true);
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
      getUpcomingAppointments(0, true);
      // _handleCreateLoginSuccess(loginModelObj);
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  Future<void> callReceiptionTodayAppointments() async {
    try {
      var response = (await Get.find<AppointmentApi>()
          .getAllReceiptionstTodayAppointment());
      List<AppointmentContent> list = response;
      //List<AppointmentContent> match = [];
      var now = DateTime.now();
      List<AppointmentContent> appointments = list
          .where((i) =>
              i.status?.toLowerCase() != 'completed' ||
              now.isAfter(DateTime.parse(i.date!)))
          .toList();

      // list.any((element) {
      //   if (element.status?.toLowerCase() != 'completed') {
      //     print('Matched obj: ${element}');
      //     match.add(element);
      //     return true;
      //   }
      //   return false;
      // });
      staffTodaysData.value = appointments;
      callReceiptionUpcomingAppointments();
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  Future<void> callReceiptionUpcomingAppointments() async {
    try {
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
      callRecentPatientList(0);
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  Future<void> getUpcomingAppointments(int pageIndex, bool isForPatient) async {
    try {
      //isloading(true);
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

      isloading(false);
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloading(false);
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
      patientData.value =
          (await Get.find<PatientApi>().getPatientDetails(headers: {
        'Content-type': 'application/json',
      }, id: id));
      callAppointmentstodaybypatientid();
      // _handleCreateLoginSuccess(loginModelObj);
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  Future<void> getEmergencyPatientDetails() async {
    try {
      getEmergencyPatientsList.value = (await Get.find<AppointmentApi>()
          .getEmergencyPatientsList()) as List<EmergencyContent>;
      callEmergencyPatientList();
      // _handleCreateLoginSuccess(loginModelObj);
    } on Map {
      //postLoginResp = e;
      rethrow;
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
  }

  void _handleCreateRegisterSuccess() {}
}
