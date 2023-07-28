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
  Rx<TextEditingController> consultingDoctor = TextEditingController().obs;
  int? examinerId;
  RxBool showDateAndTime = false.obs;
  TextEditingController treatment = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController address = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Rx<DateTime> dateTime = DateTime.now().obs;
  RxBool pleasefillAllFields = false.obs;
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
      pleasefillAllFields.value = false;
      return true;
    }
    pleasefillAllFields.value = true;
    return false;
  }

  String? emailValidator(String value) {
    if (value.isEmpty || !value.contains('@')) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  final RegExp nameRegExp = RegExp('[a-zA-Z]');
  String? firstNameValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter first name';
    } else {
      if (!nameRegExp.hasMatch(value)) {
        return 'Enter valid name';
      } else {
        return null;
      }
    }
  }

  String? lastNameValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter last name';
    } else {
      if (!nameRegExp.hasMatch(value)) {
        return 'Enter valid name';
      } else {
        return null;
      }
    }
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
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  String? addressValidator(String? value) {
    if (value == null) {
      return 'Please enter address';
    } else if (value == "") {
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

  String? toValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Please select time.';
    }
    return null;
  }

  String? consultingDoctorValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Please select doctor';
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
    for (var element in genderList.value) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
    genderList.refresh();
  }

  Rx<List<SelectionPopupModel>> counsultingDoctor = Rx(<SelectionPopupModel>[]);

  onConsultingDoctorSelect(dynamic value) {
    for (var element in counsultingDoctor.value) {
      element.isSelected = false;
      if (element.id == value.id) {
        examinerId = element.id;
        element.isSelected = true;
      }
    }
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
  void onClose() {
    super.onClose();
    firstname.clear();
    lastname.clear();
    email.clear();
    mobile.clear();
    gender.clear();
    from.value.clear();
    to.clear();
    consultingDoctor.value.clear();
    treatment.clear();
    notes.clear();
  }
}
