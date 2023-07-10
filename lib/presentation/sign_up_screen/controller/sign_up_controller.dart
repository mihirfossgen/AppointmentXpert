import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../../models/verify_otp_model.dart';
import '../../../network/api/user_api.dart';
import '../models/sign_up_model.dart';

class SignUpController extends GetxController {
  TextEditingController enternameController = TextEditingController();
  TextEditingController enteremailController = TextEditingController();
  TextEditingController enternumberController = TextEditingController();
  TextEditingController enterpasswordController = TextEditingController();
  TextEditingController selectedDropDownvalue = TextEditingController();
  SelectionPopupModel? selectedDropDownValue;

  Rx<SignUpModel> signUpModelObj = SignUpModel().obs;
  OtpModel? getOtp;

  Map postRegisterResp = Map();

  Rx<bool> isShowPassword = true.obs;

  Rx<bool> isCheckbox = false.obs;

  isObscureActive() {
    isShowPassword.value = !isShowPassword.value;
  }

  Rx<List<SelectionPopupModel>> dropdownItemList = Rx([
    SelectionPopupModel(
      id: 1,
      title: "ADMIN",
    ),
    SelectionPopupModel(
      id: 2,
      title: "DOCTOR",
    ),
    SelectionPopupModel(
      id: 3,
      title: "EXAMINER",
    ),
    SelectionPopupModel(
      id: 4,
      title: "RECEIPTIONIST",
    ),
    SelectionPopupModel(
      id: 5,
      title: "PATIENT",
    ),
    SelectionPopupModel(
      id: 5,
      title: "NURSE",
    )
  ]);

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    formKey.currentState?.dispose();
    enternameController.dispose();
    enteremailController.dispose();
    enterpasswordController.dispose();
    enternumberController.dispose();
    selectedDropDownvalue.dispose();
  }

  final formKey = GlobalKey<FormState>();
  String userEmail = '';
  String userName = '';
  String userPassword = '';
  String userNumber = '';

  String? emailValidator(String value) {
    if (value.isEmpty || !value.contains('@')) {
      return 'Please enter a valid email address.';
    } else {
      userEmail = value;
    }

    return null;
  }

  String? userNameValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Username must be at least 4 characters long.';
    } else {
      userName = value;
    }
    return null;
  }

  String? passwordValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Password must be at least 4 characters long.';
    } else {
      userPassword = value;
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
    } else {
      userNumber = value;
    }
    return null;
  }

  bool trySubmit() {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();

    if (isValid) {
      formKey.currentState!.save();
      print(userEmail);
      print(userName);
      print(userPassword);
      print(userNumber);
      return true;
    }
    return false;
  }

  onSelected(dynamic value) {
    selectedDropDownValue = value as SelectionPopupModel;
    dropdownItemList.value.forEach((element) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    });
    dropdownItemList.refresh();
  }

  Future<void> callRegister(Map<String, dynamic> req) async {
    try {
      postRegisterResp = await Get.find<UserApi>().callRegister(
        headers: {
          'Content-type': 'application/json',
        },
        data: req,
      );
      _handleCreateRegisterSuccess();
    } on Map catch (e) {
      postRegisterResp = e;
      rethrow;
    }
  }

  void _handleCreateRegisterSuccess() {
    //Get.find<PrefUtils>().setId(postRegisterResp.data!.id!.toString());
  }
}
