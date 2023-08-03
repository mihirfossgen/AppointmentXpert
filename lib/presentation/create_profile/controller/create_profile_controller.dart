import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/color_constant.dart';
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
  TextEditingController prefixController = TextEditingController();
  RxBool isloading = false.obs;
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
  RxInt selectedIndex = 0.obs;
  RxBool isSearched = false.obs;

  get isCheckbox => null;

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
    for (var element in jobType.value) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
    jobType.refresh();
  }

  String? emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (!(regex.hasMatch(value))) return "Invalid Email";

    return null;
  }

  String? prefixControllerValidator(String value) {
    if (value.isEmpty || value.length <= 1) {
      return 'Prefix must be at least 2 characters long.';
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

  String? lastNameValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter last name';
    } else if (value == " ") {
      return 'Enter valid name';
    } else if (!nameRegExp.hasMatch(value)) {
      return 'Enter valid name';
    } else {
      return null;
    }
  }

  String? fatherNamrValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Father name must be at least 4 characters long.';
    }
    return null;
  }

  final RegExp addressReg = RegExp("^[#.0-9a-zA-Z\s,/-]+");
  String? addressValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter address';
    } else if (value == " ") {
      return 'Please enter valid address';
    } else if (!addressReg.hasMatch(value)) {
      return 'Please enter valid address';
    }
    return null;
  }

  String? countryValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter country';
    } else {
      return null;
    }
  }

  String? stateValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter state';
    } else {
      return null;
    }
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
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  String? pincodeValidator(String value) {
    String pattern = r"^[1-9]{1}[0-9]{2}\\s{0, 1}[0-9]{3}$";
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
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
    for (var element in genderList.value) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
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
    for (var element in prefixesList.value) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
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
      CreateStaff sModel, String role, CreatepatientModel pModel) {
    if (pModel.result == false) {
      isloading.value = false;
      Get.back();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => Get.snackbar(
            "Uh oh!!",
            pModel.message ?? "",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
            borderRadius: 15,
            icon: Icon(
              Icons.error_outline,
              color: ColorConstant.whiteA700,
            ),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(40),
            colorText: ColorConstant.whiteA700,
            backgroundColor: ColorConstant.blue700,
          ));
    } else {
      isloading.value = false;
      storingPatientOrEmployeeID(
          role,
          ((role.toLowerCase() == "examiner" ||
                      role.toLowerCase() == "receptionist" ||
                      role.toLowerCase() == "admin" ||
                      role.toLowerCase() == "doctor")
                  ? sModel.t?.id
                  : pModel.t?.id) ??
              0);
      if (imageFileList!.isNotEmpty) {
        if (role.toLowerCase() == "examiner" ||
            role.toLowerCase() == "receptionist" ||
            role.toLowerCase() == "admin" ||
            role.toLowerCase() == "doctor") {
          UserApi().upLoadEmplyeePhoto(sModel.t?.id.toString() ?? "0",
              imageFileList![0].path, fileName ?? "");
        } else {
          UserApi().upLoadPatientPhoto(pModel.t?.id.toString() ?? "0",
              imageFileList![0].path, fileName ?? "");
        }
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
