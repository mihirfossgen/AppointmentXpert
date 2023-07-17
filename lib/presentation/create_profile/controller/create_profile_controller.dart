import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../../models/create_staff_model.dart';
import '../../../models/createpatient_model.dart';
import '../../../models/get_all_clinic_model.dart';
import '../../../network/api/user_api.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';

class CreateProfileController extends GetxController {
  GetAllClinic getAllClinic = GetAllClinic();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController staffId = TextEditingController();
  TextEditingController bloodGroup = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController fathername = TextEditingController();
  TextEditingController motherName = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController countryOfBirth = TextEditingController();
  TextEditingController country = TextEditingController();
  SelectionPopupModel? selectedjobtype;
  SelectionPopupModel? selectedprefix;
  SelectionPopupModel? selectedgender;
  String? jobtype;
  String? department;
  String? clinics;
  String? prefix;
  String? gender;
  String? fileName;
  CreateStaff createStaffObj = CreateStaff();
  CreatepatientModel createpatientModel = CreatepatientModel();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? imageFileList = [];
  var selectedImage = ''.obs;
  final formKey = GlobalKey<FormState>();
  void _setImageFileListFromFile(XFile? value) {
    imageFileList = value == null ? null : <XFile>[value];
    selectedImage.value = imageFileList![0].path;
    print(selectedImage);
  }

  pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        _setImageFileListFromFile(pickedFile);
        fileName = imageFileList![0].path.split('/').last;
      }
    } catch (e) {
      print(e);
    }
  }

  TextEditingController? _controller;

  Rx<List<SelectionPopupModel>> jobType = Rx([
    SelectionPopupModel(
      id: 1,
      title: "PERMANENT",
    ),
    SelectionPopupModel(
      id: 2,
      title: "PER_TIME",
    ),
    SelectionPopupModel(
      id: 3,
      title: "WEEKEND",
    ),
  ]);

  onSelectedJobType(dynamic value) {
    selectedjobtype = value as SelectionPopupModel;
    jobType.value.forEach((element) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    });
    jobType.refresh();
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

  String? fatherNamrValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Father name must be at least 4 characters long.';
    }
    return null;
  }

  String? addressValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Please enter address';
    }
    return null;
  }

  String? motherNameValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Mother name must be at least 4 characters long.';
    }
    return null;
  }

  String? userNameValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Username must be at least 4 characters long.';
    }
    return null;
  }

  String? countryValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Please enter country';
    }
    return null;
  }

  String? stateValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Please enter state';
    }
    return null;
  }

  String? genderValidator(String value) {
    if (value.isEmpty) {
      return 'Please select gender';
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

  String? pincodeValidator(String value) {
    String pattern = r"^[1-9]{1}[0-9]{2}\\s{0, 1}[0-9]{3}$";
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter pincode';
    }
    // else if (!regExp.hasMatch(value)) {
    //   return 'Please enter valid pincode';
    // }
    return null;
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

  Rx<List<SelectionPopupModel>> prefixesList = Rx([
    SelectionPopupModel(
      id: 1,
      title: "MR.",
    ),
    SelectionPopupModel(
      id: 2,
      title: "Mrs.",
    ),
    SelectionPopupModel(
      id: 3,
      title: "Ms.",
    ),
  ]);

  onSelectedPrefix(dynamic value) {
    selectedprefix = value as SelectionPopupModel;
    prefixesList.value.forEach((element) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    });
    prefixesList.refresh();
  }

  List<Map<String, Object>> clinic = [
    {
      "id": 1,
      "name": "Apollo Hospitals",
      "departments": [
        {
          "id": 6,
          "version": 0,
          "dateUpdated": null,
          "dateCreated": "2023-05-10T10:42:09.812+00:00",
          "createdBy": null,
          "modifiedBy": null,
          "name": "OPD"
        }
      ]
    },
    {"id": 2, "name": "Sanjeevan Hospital", "departments": []}
  ];
  List<Map<String, Object>> dept = [];

  Future<void> callCreateEmployee(var data, String role) async {
    try {
      createStaffObj = (await Get.find<UserApi>().callCreateEmployee(
        headers: {
          'Content-type': 'application/json',
        },
        data: data,
      ));
      print("create api called for employee");
      _handleCreateEmployeeSuccess(createStaffObj, role, createpatientModel);
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  Future<void> callCreatePatient(var data, String role) async {
    try {
      createpatientModel = (await Get.find<UserApi>().callCreatePatient(
        headers: {
          'Content-type': 'application/json',
        },
        data: data,
      ));
      print("create api called for employee");
      _handleCreateEmployeeSuccess(createStaffObj, role, createpatientModel);
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  _handleCreateEmployeeSuccess(
      CreateStaff model, String role, CreatepatientModel _model) {
    storingPatientOrEmployeeID(
        role,
        ((role.toLowerCase() == "examiner" ||
                    role.toLowerCase() == "receptionist" ||
                    role.toLowerCase() == "admin" ||
                    role.toLowerCase() == "doctor")
                ? model.t?.id
                : _model.t?.id) ??
            0);
    if (imageFileList!.isNotEmpty) {
      if (role.toLowerCase() == "examiner" ||
          role.toLowerCase() == "receptionist" ||
          role.toLowerCase() == "admin" ||
          role.toLowerCase() == "doctor") {
        UserApi().upLoadEmplyeePhoto(model.t?.id.toString() ?? "0",
            imageFileList![0].path, fileName ?? "");
      } else {
        UserApi().upLoadPatientPhoto(_model.t?.id.toString() ?? "0",
            imageFileList![0].path, fileName ?? "");
      }
    }
  }

  void storingPatientOrEmployeeID(String role, int id) {
    SharedPrefUtils.saveBool("complete_profile_flag", true);
    if (role.toLowerCase() == "examiner" ||
        role.toLowerCase() == "receptionist" ||
        role.toLowerCase() == "admin" ||
        role.toLowerCase() == "doctor") {
      SharedPrefUtils.saveInt("employee_Id", id);
    } else {
      SharedPrefUtils.saveInt("patient_Id", id);
    }
  }

  @override
  void onReady() {
    super.onReady();
    //callClinicsList();
    // _controller = TextEditingController(
    //   patternMatchMap: {RegExp('*'): TextStyle(color: Colors.red)},
    //   onMatch: (match) {},
    // );
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> callClinicsList() async {
    try {
      getAllClinic = (await Get.find<UserApi>().callGetAllClinics(
        headers: {
          'Content-type': 'application/json',
        },
      ));
      //clinic = getAllClinic.data ?? [];
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }
}

class ScreenArguments {
  final String type;
  final int roleId;
  final String username;
  ScreenArguments(this.type, this.roleId, this.username);
}
