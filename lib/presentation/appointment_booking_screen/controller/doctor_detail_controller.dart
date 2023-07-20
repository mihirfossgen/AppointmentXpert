import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../../models/getallEmplyesList.dart';
import '../../../network/api/appointment_api.dart';
import '../models/doctor_detail_model.dart';

class DoctorDetailController extends GetxController {
  Rx<DoctorDetailModel> doctorDetailModelObj = DoctorDetailModel().obs;
  DateTime selectedDate = DateTime.now();
  String? finalDate;
  RxString finalTime = "".obs;
  bool value = false;

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController gender = TextEditingController();
  Rx<TextEditingController> from = TextEditingController().obs;
  TextEditingController to = TextEditingController();
  TextEditingController consultingDoctor = TextEditingController();
  int? examinerId;
  TextEditingController treatment = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController address = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Rx<DateTime> dateTime = DateTime.now().obs;
  List<DoctorList>? list;
  int? deptId;
  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  List<String>? times;

  getdeptId(int id) {
    deptId = list?.firstWhere((element) => element.id == id).departmentId;
    print(deptId);
    return deptId;
  }

  getDate(List<DateTime?> value) {
    selectedDate = value[0]!;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    finalDate = formatter.format(selectedDate);
  }

  bool trySubmit() {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();

    if (isValid) {
      formKey.currentState!.save();

      return true;
    }
    return false;
  }

  String? emailValidator(String value) {
    if (value.isEmpty || !value.contains('@')) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  String? firstNameValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'First name must be at least 4 characters long.';
    }
    return null;
  }

  String? lastNameValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Last name must be at least 4 characters long.';
    }
    return null;
  }

  String? userNameValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Username must be at least 4 characters long.';
    }
    return null;
  }

  String? dobValidator(String value) {
    if (value.isEmpty) {
      return 'Please select date of birth';
    }
    return null;
  }

  String? numberValidator(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  String? addressValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Please enter address';
    }
    return null;
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

  String? fromValidator(String value, String startTime) {
    print(startTime);
    print(timeFormat(value).isBefore(timeFormat(startTime)));
    if (value.isEmpty) {
      return 'Please select time';
    } else if (timeFormat(value).isBefore(timeFormat(startTime))) {
      return "Please select time between 12 to 6 PM";
    }
    return null;
  }

  String? toValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Please select time.';
    }
    return null;
  }

  String? consultingDoctorValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'First name must be at least 4 characters long.';
    }
    return null;
  }

  String? treatmentValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Treatment must be at least 4 characters long.';
    }
    return null;
  }

  String? notesValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Notes must be at least 4 characters long.';
    }
    return null;
  }

  String? genderValidator(String value) {
    if (value.isEmpty) {
      return 'Please select gender';
    }
    return null;
  }

  String? consultingdoctorValidator(String value) {
    if (value.isEmpty) {
      return 'Please select doctor';
    }
    return null;
  }

  Rx<List<SelectionPopupModel>> genderList = Rx([
    SelectionPopupModel(
      id: 1,
      title: "MALE",
    ),
    SelectionPopupModel(
      id: 2,
      title: "FEMALE",
    ),
  ]);
  SelectionPopupModel? selectedgender;

  onSelectedGender(dynamic value) {
    selectedgender = value as SelectionPopupModel;
    genderList.value.forEach((element) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    });
    genderList.refresh();
  }

  Rx<List<SelectionPopupModel>> counsultingDoctor = Rx(<SelectionPopupModel>[]);

  onConsultingDoctorSelect(dynamic value) {
    counsultingDoctor.value.forEach((element) {
      element.isSelected = false;
      if (element.id == value.id) {
        examinerId = element.id;
        element.isSelected = true;
      }
    });
    counsultingDoctor.refresh();
  }

  bool valueS = false;

  Future<void> callCreateLogin(Map<String, dynamic> req) async {
    try {
      valueS = (await Get.find<AppointmentApi>().createAppointment(
        req,
        {
          'Content-type': 'application/json',
        },
      ));
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  @override
  void onReady() {
    super.onReady();
    // gettomeSlots();
  }

  @override
  void onClose() {
    super.onClose();
    firstname.dispose();
    lastname.dispose();
    email.dispose();
    mobile.dispose();
    gender.dispose();
    from.value.dispose();
    to.dispose();
    consultingDoctor.dispose();
    treatment.dispose();
    notes.dispose();
  }
}
