import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/selectionPopupModel/selection_popup_model.dart';

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
  RxBool isShowPassword = true.obs;
  isObscureActive() {
    isShowPassword.value = !isShowPassword.value;
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
      } else if (password != confirmPassword) {
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
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
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
    if (value.isEmpty || value.length < 4) {
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
    genderList.value.forEach((element) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    });
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
}
