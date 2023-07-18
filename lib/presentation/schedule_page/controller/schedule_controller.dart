import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/app_export.dart';
import '../../../models/getAllApointments.dart';
//import '../../../models/getallAppointbypoatientidModel.dart';
import '../../../network/api/appointment_api.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../widgets/pdf_viewer.dart';

class ScheduleController extends GetxController {
  bool response = false;

  GetAllAppointments model = GetAllAppointments();
  List<AppointmentContent> listModel = <AppointmentContent>[];
  String precriptionFileName = "";
  String invoiceFileName = "";
  RxBool isloading = false.obs;
  bool value = false;

  RxList<AppointmentContent> today = <AppointmentContent>[].obs;
  RxList<AppointmentContent> upcoming = <AppointmentContent>[].obs;
  RxList<AppointmentContent> completed = <AppointmentContent>[].obs;
  RxList<AppointmentContent> today1 = <AppointmentContent>[].obs;
  RxList<AppointmentContent> upcoming1 = <AppointmentContent>[].obs;
  RxList<AppointmentContent> completed1 = <AppointmentContent>[].obs;

  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  RxBool sortAscending = true.obs;
  RxInt sortColumnIndex = 0.obs;
  //DessertDataSourceAsync? _dessertsDataSource;
  final PaginatorController pageController = PaginatorController();
  //DessertDataSourceAsync? dessertsDataSource;

  RxBool dataSourceLoading = false.obs;
  RxInt initialRow = 0.obs;

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

  @override
  void onReady() {
    super.onReady();
    isloading.value = true;
    if (SharedPrefUtils.readPrefStr('role') != "PATIENT") {
      //SharedPrefUtils.readPrefINt('employee_Id')
      callGetAllAppointments(0, 1);
    } else {
      //callAppointmentsByPatientId(SharedPrefUtils.readPrefINt('patient_Id'));
    }
  }

  Future<void> callGetAllAppointments(int pageNo, int count) async {
    print("count ----- $count");
    try {
      model = (await Get.find<AppointmentApi>().getAllAppointments(pageNo));
      _handleGetAllAppointment(model);
      update();
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloading.value = false;
    }
  }

  Future<void> callAppointmentsByPatientId(int patientId) async {
    try {
      listModel = (await Get.find<AppointmentApi>()
          .getAllAppointmentBYPatientId(patientId, 0));

      isloading.value = false;
      _handleAllAppointmentPatientId(listModel);
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  Future<void> updateAppointment(var data) async {
    try {
      value = (await Get.find<AppointmentApi>().updateAppointment(data));
      if (SharedPrefUtils.readPrefStr('role') != "PATIENT") {
        callGetAllAppointments(0, 0);
      } else {
        callAppointmentsByPatientId(SharedPrefUtils.readPrefINt('patient_Id'));
      }
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  Future<void> callGeneratePrecription(
      int patientId, int appointmentId, int examinationId) async {
    try {
      precriptionFileName = (await Get.find<AppointmentApi>()
          .callGeneratePrecription(patientId, appointmentId, examinationId));
      if (precriptionFileName != "") {
        Navigator.push(
            Get.context!,
            MaterialPageRoute(
                builder: (context) => PDFScreen(path: precriptionFileName)));
      }
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  Future<void> callGenerateInvoice(int patientId, int appointmentId,
      int paymentReferenceId, int staffId) async {
    try {
      invoiceFileName = (await Get.find<AppointmentApi>().callGenerateInvoice(
          patientId, appointmentId, paymentReferenceId, staffId));
      if (invoiceFileName != "") {
        Navigator.push(
            Get.context!,
            MaterialPageRoute(
                builder: (context) => PDFScreen(path: invoiceFileName)));
      }
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  dateFormat(String a) {
    final DateFormat formatter = DateFormat('dd-MMM-yyyy');
    return formatter.format(DateTime.parse(a));
  }

  _handleGetAllAppointment(GetAllAppointments model) {
    List<AppointmentContent> userList = model.content!.map((e) => e).toList();
    for (var i = 0; i < userList.length; i++) {
      if (userList[i].status == "Completed" &&
          userList[i].treatment != null &&
          userList[i].active == true) {
        completed.add(AppointmentContent(
            active: userList[i].active,
            date: userList[i].date,
            startTime: userList[i].startTime,
            endTime: userList[i].endTime,
            dateCreated: userList[i].dateCreated,
            department: userList[i].department,
            examination: userList[i].examination,
            examiner: userList[i].examiner,
            id: userList[i].id,
            labOrder: userList[i].labOrder,
            note: userList[i].note,
            patient: userList[i].patient,
            purpose: userList[i].purpose,
            referenceId: userList[i].referenceId,
            status: userList[i].status,
            treatment: userList[i].treatment,
            visit: userList[i].visit));
      } else if (dateFormat(userList[i].date ?? "") ==
              dateFormat(DateTime.now().toString()) &&
          userList[i].active == true) {
        today.add(AppointmentContent(
            active: userList[i].active,
            date: userList[i].date,
            startTime: userList[i].startTime,
            endTime: userList[i].endTime,
            dateCreated: userList[i].dateCreated,
            department: userList[i].department,
            examination: userList[i].examination,
            examiner: userList[i].examiner,
            id: userList[i].id,
            labOrder: userList[i].labOrder,
            note: userList[i].note,
            patient: userList[i].patient,
            purpose: userList[i].purpose,
            referenceId: userList[i].referenceId,
            status: userList[i].status,
            treatment: userList[i].treatment,
            visit: userList[i].visit));
      } else if (userList[i].active == true) {
        upcoming.add(AppointmentContent(
            active: userList[i].active,
            date: userList[i].date,
            startTime: userList[i].startTime,
            endTime: userList[i].endTime,
            dateCreated: userList[i].dateCreated,
            department: userList[i].department,
            examination: userList[i].examination,
            examiner: userList[i].examiner,
            id: userList[i].id,
            labOrder: userList[i].labOrder,
            note: userList[i].note,
            patient: userList[i].patient,
            purpose: userList[i].purpose,
            referenceId: userList[i].referenceId,
            status: userList[i].status,
            treatment: userList[i].treatment,
            visit: userList[i].visit));
      }
    }
  }

  _handleAllAppointmentPatientId(List<AppointmentContent> userList1) {
    //List<Datum> userList1 = model.data!.map((e) => e).toList();
    for (var i = 0; i < userList1.length; i++) {
      if (userList1[i].status == "Completed" &&
          userList1[i].treatment != null &&
          userList1[i].active == true) {
        completed1.add(AppointmentContent(
            active: userList1[i].active,
            date: userList1[i].date,
            startTime: userList1[i].startTime,
            endTime: userList1[i].endTime,
            dateCreated: userList1[i].dateCreated,
            department: userList1[i].department,
            examination: userList1[i].examination,
            examiner: userList1[i].examiner,
            id: userList1[i].id,
            labOrder: userList1[i].labOrder,
            note: userList1[i].note,
            patient: userList1[i].patient,
            purpose: userList1[i].purpose,
            referenceId: userList1[i].referenceId,
            status: userList1[i].status,
            treatment: userList1[i].treatment,
            visit: userList1[i].visit));
      } else if (dateFormat(userList1[i].date ?? "") ==
              dateFormat(DateTime.now().toString()) &&
          userList1[i].active == true) {
        today1.add(AppointmentContent(
            active: userList1[i].active,
            date: userList1[i].date,
            startTime: userList1[i].startTime,
            endTime: userList1[i].endTime,
            dateCreated: userList1[i].dateCreated,
            department: userList1[i].department,
            examination: userList1[i].examination,
            examiner: userList1[i].examiner,
            id: userList1[i].id,
            labOrder: userList1[i].labOrder,
            note: userList1[i].note,
            patient: userList1[i].patient,
            purpose: userList1[i].purpose,
            referenceId: userList1[i].referenceId,
            status: userList1[i].status,
            treatment: userList1[i].treatment,
            visit: userList1[i].visit));
      } else if (userList1[i].active == true) {
        upcoming1.add(AppointmentContent(
            active: userList1[i].active,
            date: userList1[i].date,
            startTime: userList1[i].startTime,
            endTime: userList1[i].endTime,
            dateCreated: userList1[i].dateCreated,
            department: userList1[i].department,
            examination: userList1[i].examination,
            examiner: userList1[i].examiner,
            id: userList1[i].id,
            labOrder: userList1[i].labOrder,
            note: userList1[i].note,
            patient: userList1[i].patient,
            purpose: userList1[i].purpose,
            referenceId: userList1[i].referenceId,
            status: userList1[i].status,
            treatment: userList1[i].treatment,
            visit: userList1[i].visit));
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  List getList(String tab) {
    String role = SharedPrefUtils.readPrefStr("role");
    switch (tab) {
      case "today":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? today.value
            : today1;
      case "upcoming":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? upcoming
            : upcoming1;
      case "completed":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? completed
            : completed1;
      default:
        return [];
    }
  }

  getDeptName(String tab, int index) {
    switch (tab) {
      case "today":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? today[index].department?.name ?? ""
            : today1[index].department?.name ?? "";
      case "upcoming":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? upcoming[index].department?.name ?? ""
            : upcoming1[index].department?.name ?? "";
      case "completed":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? completed[index].department?.name ?? ""
            : completed1[index].department?.name ?? "";
      default:
        return 0;
    }
  }

  getStatus(String tab, int index) {
    switch (tab) {
      case "today":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? today[index].status ?? ""
            : today1[index].status ?? "";
      case "upcoming":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? upcoming[index].status ?? ""
            : upcoming1[index].status ?? "";
      case "completed":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? completed[index].status ?? ""
            : completed1[index].status ?? "";
      default:
        return 0;
    }
  }

  getName(String tab, int index) {
    switch (tab) {
      case "today":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? "${today[index].patient?.firstName} ${today[index].patient?.lastName}"
            : "${today1[index].examiner?.firstName} ${today1[index].examiner?.lastName}";
      case "upcoming":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? "${upcoming[index].patient?.firstName} ${upcoming[index].patient?.lastName}"
            : "${upcoming1[index].examiner?.firstName} ${upcoming1[index].examiner?.lastName}";
      case "completed":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? "${completed[index].patient?.firstName} ${completed[index].patient?.lastName}"
            : "${completed1[index].examiner?.firstName} ${completed1[index].examiner?.lastName}";
      default:
        return 0;
    }
  }

  getDate(String tab, int index) {
    switch (tab) {
      case "today":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? today[index].date ?? ""
            : today1[index].date ?? "";
      case "upcoming":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? upcoming[index].date ?? ""
            : upcoming1[index].date ?? "";
      case "completed":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? completed[index].date ?? ""
            : completed1[index].date ?? "";
      default:
        return 0;
    }
  }

  getStartTime(String tab, int index) {
    switch (tab) {
      case "today":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? today[index].startTime ?? ""
            : today1[index].startTime ?? "";
      case "upcoming":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? upcoming[index].startTime ?? ""
            : upcoming1[index].startTime ?? "";
      case "completed":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? completed[index].startTime ?? ""
            : completed1[index].startTime ?? "";
      default:
        return 0;
    }
  }

  getEndTime(String tab, int index) {
    switch (tab) {
      case "today":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? today[index].endTime ?? ""
            : today1[index].endTime ?? "";
      case "upcoming":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? upcoming[index].endTime ?? ""
            : upcoming1[index].endTime ?? "";
      case "completed":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? completed[index].endTime ?? ""
            : completed1[index].endTime ?? "";
      default:
        return 0;
    }
  }

  getAppointmentID(String tab, int index) {
    switch (tab) {
      case "today":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? today[index].id ?? ""
            : today1[index].id ?? "";
      case "upcoming":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? upcoming[index].id ?? ""
            : upcoming1[index].id ?? "";
      case "completed":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? completed[index].id ?? ""
            : completed1[index].id ?? "";
      default:
        return 0;
    }
  }

  getPurpose(String tab, int index) {
    switch (tab) {
      case "today":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? today[index].purpose ?? ""
            : today1[index].purpose ?? "";
      case "upcoming":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? upcoming[index].purpose ?? ""
            : upcoming1[index].purpose ?? "";
      case "completed":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? completed[index].purpose ?? ""
            : completed1[index].purpose ?? "";
      default:
        return "";
    }
  }

  getNote(String tab, int index) {
    switch (tab) {
      case "today":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? today[index].note ?? ""
            : today1[index].note ?? "";
      case "upcoming":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? upcoming[index].note ?? ""
            : upcoming1[index].note ?? "";
      case "completed":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? completed[index].note ?? ""
            : completed1[index].note ?? "";
      default:
        return "";
    }
  }

  getExaminerId(String tab, int index) {
    switch (tab) {
      case "today":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? today[index].examiner?.id ?? 0
            : today1[index].examiner?.id ?? 0;
      case "upcoming":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? upcoming[index].examiner?.id ?? 0
            : upcoming1[index].examiner?.id ?? 0;
      case "completed":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? completed[index].examiner?.id ?? 0
            : completed1[index].examiner?.id ?? 0;
      default:
        return 0;
    }
  }

  getPatientId(String tab, int index) {
    switch (tab) {
      case "today":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? today[index].patient?.id ?? 0
            : today1[index].patient?.id ?? 0;
      case "upcoming":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? upcoming[index].patient?.id ?? 0
            : upcoming1[index].patient?.id ?? 0;
      case "completed":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? completed[index].patient?.id ?? 0
            : completed1[index].patient?.id ?? 0;
      default:
        return 0;
    }
  }

  String? getProfilePicture(String tab, int index) {
    switch (tab) {
      case "today":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? today[index].examiner?.profilePicture
            : today1[index].patient?.profilePicture;
      case "upcoming":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? upcoming[index].examiner?.profilePicture
            : upcoming1[index].patient?.profilePicture;
      case "completed":
        return SharedPrefUtils.readPrefStr('role') != "PATIENT"
            ? completed[index].examiner?.profilePicture
            : completed1[index].patient?.profilePicture;
      default:
        return null;
    }
  }

  getData(String tab, int index) {
    switch (tab) {
      case "today":
        return today[index];
      case "upcoming":
        return upcoming[index];
      case "completed":
        return completed[index];
      default:
        return null;
    }
  }

  getData1(String tab, int index) {
    switch (tab) {
      case "today":
        return today1[index];
      case "upcoming":
        return upcoming1[index];
      case "completed":
        return completed1[index];
      default:
        return null;
    }
  }
}
