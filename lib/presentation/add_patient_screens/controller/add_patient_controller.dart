import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/color_constant.dart';
import '../../../core/utils/image_constant.dart';
import '../../../core/utils/size_utils.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../../models/createpatient_model.dart';
import '../../../models/sign_up_model.dart';
import '../../../network/api/user_api.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/app_style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_image_view.dart';

class AddPatientController extends GetxController {
  final formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController stateOrProvince = TextEditingController();
  TextEditingController postalCode = TextEditingController();
  TextEditingController prefixController = TextEditingController();
  RxBool isShowPassword = true.obs;
  CreatepatientModel createpatientModel = CreatepatientModel();
  isObscureActive() {
    isShowPassword.value = !isShowPassword.value;
  }

  String? prefixControllerValidator(String value) {
    if (value.isEmpty || value.length <= 1) {
      return 'Prefix must be at least 2 characters long.';
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

  String? validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  String? validateConfirmPassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else if (password.text.toLowerCase() !=
          confirmPassword.text.toLowerCase()) {
        return 'Password must be similar';
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

  String? emailValidator(String value) {
    if (value.isEmpty || !value.contains('@')) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  String? addressValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter address';
    }
    return null;
  }

  String? genderValidator(String value) {
    if (value.isEmpty) {
      return 'Please select gender';
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

  String? cityValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter city';
    }
    return null;
  }

  String? countryValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Plese enter country';
    }
    return null;
  }

  String? stateValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Please enter state';
    }
    return null;
  }

  String? postalCodeValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Please enter postal code';
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

  Map postRegisterResp = {};
  Future<void> callRegister(Map<String, dynamic> req) async {
    try {
      SignUpModel model = await Get.find<UserApi>().callRegister(
        headers: {
          'Content-type': 'application/json',
        },
        data: req,
      );
      callCreatePatient(model.userDetail?.id ?? 0);
    } on Map catch (e) {
      postRegisterResp = e;
      rethrow;
    }
  }

  calculateAge(String birthDate) {
    DateTime a = DateTime.parse(birthDate);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - a.year;
    int month1 = currentDate.month;
    int month2 = a.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = a.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Future<void> callCreatePatient(int roleID) async {
    var data = {
      "address": address.text,
      "age": calculateAge(dob.text),
      "country": country.text,
      "countryOfBirth": country.text,
      "dateCreated": DateTime.now().toIso8601String(),
      "dob": dob.text,
      "email": email.text,
      "firstName": firstName.text,
      "lastName": lastName.text,
      "mobile": mobile.text,
      "prefix": "",
      "sex": gender.text,
      "userId": roleID,
      "visits": []
    };
    try {
      createpatientModel = (await Get.find<UserApi>().callCreatePatient(
        headers: {
          'Content-type': 'application/json',
        },
        data: data,
      ));
      print("create api called for patient");
      Get.dialog(Padding(
          padding: const EdgeInsets.all(20),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            insetPadding: const EdgeInsets.only(left: 0),
            content: Container(
                //width: getHorizontalSize(327),
                padding: getPadding(left: 24, top: 36, right: 24, bottom: 36),
                decoration: AppDecoration.white
                    .copyWith(borderRadius: BorderRadiusStyle.roundedBorder24),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 0,
                          margin: getMargin(top: 26),
                          color: ColorConstant.gray50,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusStyle.circleBorder51),
                          child: Container(
                              height: getSize(102),
                              width: getSize(102),
                              padding: getPadding(
                                  left: 29, top: 34, right: 29, bottom: 34),
                              decoration: AppDecoration.fillGray50.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.circleBorder51),
                              child: Stack(children: [
                                CustomImageView(
                                    svgPath: ImageConstant.imgCheckmark31x41,
                                    height: getVerticalSize(31),
                                    width: getHorizontalSize(41),
                                    radius: BorderRadius.circular(
                                        getHorizontalSize(3)),
                                    alignment: Alignment.center)
                              ]))),
                      Padding(
                          padding: getPadding(top: 42),
                          child: Text("Patient Added Successfully!!",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtRalewayRomanBold20)),
                      CustomButton(
                          height: getVerticalSize(56),
                          text: "lbl_go_to_home".tr,
                          margin: getMargin(top: 22),
                          onTap: () {
                            Get.offAllNamed(AppRoutes.dashboardScreen);
                          })
                    ])),
          )));
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }
}
