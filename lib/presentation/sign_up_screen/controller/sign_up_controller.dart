import 'package:appointmentxpert/models/sign_up_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/color_constant.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../../models/verify_otp_model.dart';
import '../../../network/api/user_api.dart';
import '../../sign_up_success_dialog/controller/sign_up_success_controller.dart';
import '../../sign_up_success_dialog/sign_up_success_dialog.dart';

class SignUpController extends GetxController {
  TextEditingController enternameController = TextEditingController();
  TextEditingController enteremailController = TextEditingController();
  TextEditingController enternumberController = TextEditingController();
  TextEditingController enterpasswordController = TextEditingController();
  TextEditingController selectedDropDownvalue = TextEditingController();
  SelectionPopupModel? selectedDropDownValue;
  final formKey = GlobalKey<FormState>();
  String userEmail = '';
  String userName = '';
  String userPassword = '';
  String userNumber = '';

  OtpModel? getOtp;

  Map postRegisterResp = {};

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
  void onClose() {
    super.onClose();
    enternameController.clear();
    enteremailController.clear();
    enterpasswordController.clear();
    enternumberController.clear();
    selectedDropDownvalue.clear();
  }

  String? emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (!(regex.hasMatch(value))) return "Invalid Email";

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
    String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
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

  bool trySubmit() {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();

    if (isValid) {
      formKey.currentState!.save();

      return true;
    }
    return false;
  }

  onSelected(dynamic value) {
    selectedDropDownValue = value as SelectionPopupModel;
    for (var element in dropdownItemList.value) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
    dropdownItemList.refresh();
  }

  Future<void> callRegister(Map<String, dynamic> req) async {
    try {
      SignUpModel model = await Get.find<UserApi>().callRegister(
        headers: {
          'Content-type': 'application/json',
        },
        data: req,
      );
      _handleCreateRegisterSuccess(model);
    } on Map catch (e) {
      postRegisterResp = e;
      rethrow;
    }
  }

  void _handleCreateRegisterSuccess(SignUpModel model) {
    if (model.result == "false") {
      Get.back();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => Get.snackbar(
            "Uh oh!!",
            model.message ?? "",
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
      Get.dialog(AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.only(left: 0),
        content: SignUpSuccessDialog(
          Get.put(
            SignUpSuccessController(),
          ),
        ),
      ));
    }
  }
}
