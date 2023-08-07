import 'package:appointmentxpert/core/app_export.dart';
import 'package:appointmentxpert/network/api/user_api.dart';
import 'package:appointmentxpert/widgets/loader.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../core/utils/color_constant.dart';
import '../../core/utils/country_list.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_form_field.dart';
import '../create_profile/listing_page.dart';
import '../dashboard_screen/shared_components/responsive_builder.dart';
import 'controller/add_patient_controller.dart';

class AddPatientScreen extends GetWidget<AddPatientController> {
  AddPatientScreen({super.key});

  @override
  AddPatientController controller = Get.put(AddPatientController());
  UserApi userApi = Get.put(UserApi());
  getDate() {
    DateTime? date = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    return Get.dialog(
        AlertDialog(
          title: const Text('Please select date'),
          content: SizedBox(
            height: 250,
            width: 100,
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(),
              value: [DateTime.now()],
              onValueChanged: (value) {
                date = value[0];
              },
            ),
          ),
          actions: [
            TextButton(
                child: const Text("Continue"),
                onPressed: () {
                  Get.back(result: date);
                }),
          ],
        ),
        barrierDismissible: false);
  }

  Widget getBody() {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: ResponsiveBuilder.isDesktop(Get.context!)
            ? null
            : AppbarImage(
                backgroundColor: ColorConstant.whiteA70001,
                height: 70,
                width: width,
                leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    )),
                imagePath: 'assets/images/login-logo.png',
              ),
        body: SingleChildScrollView(
          child: Container(
              width: double.maxFinite,
              padding: getPadding(left: 8, top: 15, right: 8, bottom: 32),
              child: ResponsiveBuilder.isMobile(Get.context!)
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: mobileUi(),
                    )
                  : webOrTabUi()),
        ),
      ),
    );
  }

  Widget mobileUi() {
    return Form(
        key: controller.formKey,
        child: SizedBox(
            width: double.maxFinite,
            child: Card(
              elevation: 4,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Patient Details",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 12),
                        child: CustomDropDown(
                            labelText: "Prefix",
                            isRequired: true,
                            validator: (value) {
                              return controller.prefixControllerValidator(
                                  value?.title ?? "");
                            },
                            icon: Container(
                                margin: getMargin(left: 30, right: 16),
                                child: Icon(Icons.arrow_drop_down)),
                            margin: getMargin(top: 12),
                            variant: DropDownVariant.GreyOutline,
                            fontStyle:
                                DropDownFontStyle.ManropeMedium14Bluegray500,
                            items: controller.prefixesList.value,
                            onChanged: (value) {
                              controller.prefix = value.title;
                              controller.onSelectedPrefix(value);
                            }),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),

                      CustomTextFormField(
                          controller: controller.firstName,
                          labelText: "First name",
                          isRequired: true,
                          padding: TextFormFieldPadding.PaddingT14,
                          validator: (value) {
                            return controller.firstNameValidator(value ?? "");
                          },
                          textInputType: TextInputType.emailAddress,
                          prefixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56))),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      CustomTextFormField(
                          controller: controller.lastName,
                          labelText: "Last name",
                          isRequired: true,
                          padding: TextFormFieldPadding.PaddingT14,
                          validator: (value) {
                            return controller.lastNameValidator(value ?? "");
                          },
                          textInputType: TextInputType.emailAddress,
                          prefixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56))),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      CustomTextFormField(
                          controller: controller.mobile,
                          isRequired: true,
                          labelText: "Mobile",
                          maxLength: 10,
                          validator: (value) {
                            return controller.numberValidator(value ?? "");
                          },
                          padding: TextFormFieldPadding.PaddingT14,
                          textInputType: TextInputType.emailAddress,
                          prefixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56))),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      CustomTextFormField(
                          controller: controller.email,
                          isRequired: true,
                          labelText: "Email",
                          validator: (value) {
                            return controller.emailValidator(value ?? "");
                          },
                          padding: TextFormFieldPadding.PaddingT14,
                          textInputType: TextInputType.emailAddress,
                          prefixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56))),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      /*CustomTextFormField(
                          controller: controller.password,
                          isRequired: true,
                          labelText: "Password",
                          validator: (value) {
                            return controller.validatePassword(value ?? "");
                          },
                          padding: TextFormFieldPadding.PaddingT14,
                          textInputType: TextInputType.emailAddress,
                          prefixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56))),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      CustomTextFormField(
                          controller: controller.confirmPassword,
                          isRequired: true,
                          labelText: "Confirm password",
                          validator: (value) {
                            return controller
                                .validateConfirmPassword(value ?? "");
                          },
                          padding: TextFormFieldPadding.PaddingT14,
                          textInputType: TextInputType.emailAddress,
                          suffix: InkWell(
                              onTap: () {
                                controller.isShowPassword.value =
                                    !controller.isShowPassword.value;
                              },
                              child: Container(
                                  margin: getMargin(
                                      left: 12, top: 16, right: 8, bottom: 16),
                                  child: CustomImageView(
                                      svgPath: controller.isShowPassword.value
                                          ? ImageConstant.imgCheckmark24x24
                                          : ImageConstant.imgCheckmark24x24))),
                          suffixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56)),
                          isObscureText: controller.isShowPassword.value,
                          prefixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56))),
                      SizedBox(
                        height: size.height * 0.03,
                      ),*/
                      SizedBox(
                        child: InkWell(
                          onTap: () async {
                            FocusScope.of(Get.context!).unfocus();
                            DateTime a = await getDate();

                            final DateFormat formatter =
                                DateFormat('yyyy-MM-dd');
                            controller.dob.text = formatter.format(a);
                          },
                          child: AbsorbPointer(
                            child: CustomTextFormField(
                                controller: controller.dob,
                                labelText: "Date of birth",
                                isRequired: true,
                                size: size,
                                validator: (value) {
                                  return controller.dobValidator(value ?? "");
                                },
                                padding: TextFormFieldPadding.PaddingT14,
                                textInputType: TextInputType.emailAddress,
                                suffix: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: const Icon(Icons.calendar_month)),
                                suffixConstraints: BoxConstraints(
                                    maxHeight: getVerticalSize(56))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      CustomDropDown(
                          labelText: "Gender",
                          isRequired: true,
                          validator: (value) {
                            return controller
                                .genderValidator(value?.title ?? "");
                          },
                          variant: DropDownVariant.OutlineBluegray400,
                          fontStyle:
                              DropDownFontStyle.ManropeMedium14Bluegray500,
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.arrow_drop_down),
                          ),
                          items: controller.genderList.value,
                          onChanged: (value) {
                            controller.gender.text = value.title;
                            controller.onSelectedGender(value);
                          }),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      CustomTextFormField(
                          controller: controller.address,
                          labelText: "Address",
                          isRequired: true,
                          padding: TextFormFieldPadding.PaddingT14,
                          validator: (value) {
                            return controller.addressValidator(value ?? '');
                          },
                          textInputType: TextInputType.emailAddress,
                          prefixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56))),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      InkWell(
                          onTap: () {
                            Get.to(() => ListingPage(
                                  listOfCountryOrList: countryList,
                                ))?.then((value) {
                              if (value != null) {
                                controller.country.text =
                                    value['name'].toString();
                              }
                            });
                          },
                          child: AbsorbPointer(
                              child: CustomTextFormField(
                                  labelText: "Country",
                                  controller: controller.country,
                                  isRequired: true,
                                  validator: (value) {
                                    return controller
                                        .countryValidator(value ?? "");
                                  },
                                  padding: TextFormFieldPadding.PaddingT14,
                                  textInputType: TextInputType.name,
                                  prefixConstraints: BoxConstraints(
                                      maxHeight: getVerticalSize(56))))),

                      // SizedBox(
                      //   height: size.height * 0.03,
                      // ),
                      // CustomTextFormField(
                      //     controller: controller.stateOrProvince,
                      //     labelText: "State/Province",
                      //     isRequired: true,
                      //     padding: TextFormFieldPadding.PaddingT14,
                      //     validator: (value) {
                      //       return controller.stateValidator(value ?? "");
                      //     },
                      //     textInputType: TextInputType.emailAddress,
                      //     prefixConstraints:
                      //         BoxConstraints(maxHeight: getVerticalSize(56))),
                      // SizedBox(
                      //   height: size.height * 0.02,
                      // ),
                      // CustomTextFormField(
                      //     controller: controller.postalCode,
                      //     labelText: "Postal Code",
                      //     isRequired: true,
                      //     padding: TextFormFieldPadding.PaddingT14,
                      //     validator: (value) {
                      //       return controller.postalCodeValidator(value ?? "");
                      //     },
                      //     textInputType: TextInputType.emailAddress,
                      //     prefixConstraints:
                      //         BoxConstraints(maxHeight: getVerticalSize(56))),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CustomButton(
                            height: getVerticalSize(60),
                            //width: getHorizontalSize(80),
                            text: "Add patient",
                            margin: getMargin(left: 0, right: 0),
                            fontStyle:
                                ButtonFontStyle.RalewayRomanSemiBold14WhiteA700,
                            onTap: () async {
                              bool a = controller.trySubmit();
                              if (a) {
                                Map<String, dynamic> requestData = {
                                  "email": controller.email.text,
                                  "mobile": controller.mobile.text,
                                  //"password": controller.confirmPassword.text,
                                  "role": "PATIENT",
                                  "username": controller.mobile.text,
                                  "prefix": controller.prefixController.text,
                                };
                                controller.callRegister(requestData);
                              }
                            }),
                      ),
                    ],
                  )),
            )));
  }

  Widget webOrTabUi() {
    return Form(
      key: controller.formKey,
      child: SizedBox(
        width: double.maxFinite,
        child: Card(
          elevation: 4,
          shadowColor: Colors.grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                child: Text("Patient Details",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: CustomTextFormField(
                            controller: controller.firstName,
                            labelText: "First name",
                            isRequired: true,
                            padding: TextFormFieldPadding.PaddingT14,
                            validator: (value) {
                              return controller.firstNameValidator(value ?? "");
                            },
                            textInputType: TextInputType.emailAddress,
                            prefixConstraints:
                                BoxConstraints(maxHeight: getVerticalSize(56))),
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: CustomTextFormField(
                            controller: controller.lastName,
                            labelText: "Last name",
                            isRequired: true,
                            padding: TextFormFieldPadding.PaddingT14,
                            validator: (value) {
                              return controller.lastNameValidator(value ?? "");
                            },
                            textInputType: TextInputType.emailAddress,
                            prefixConstraints:
                                BoxConstraints(maxHeight: getVerticalSize(56))),
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomTextFormField(
                          controller: controller.mobile,
                          isRequired: true,
                          labelText: "Mobile",
                          validator: (value) {
                            return controller.numberValidator(value ?? "");
                          },
                          padding: TextFormFieldPadding.PaddingT14,
                          textInputType: TextInputType.emailAddress,
                          prefixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56))),
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Expanded(
                      flex: 1,
                      child: CustomTextFormField(
                          controller: controller.email,
                          isRequired: true,
                          labelText: "Email",
                          validator: (value) {
                            return controller.emailValidator(value ?? "");
                          },
                          padding: TextFormFieldPadding.PaddingT14,
                          textInputType: TextInputType.emailAddress,
                          prefixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56))),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomTextFormField(
                          controller: controller.password,
                          isRequired: true,
                          labelText: "Password",
                          validator: (value) {
                            return controller.validatePassword(value ?? "");
                          },
                          padding: TextFormFieldPadding.PaddingT14,
                          textInputType: TextInputType.emailAddress,
                          prefixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56))),
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Expanded(
                      flex: 1,
                      child: CustomTextFormField(
                          controller: controller.confirmPassword,
                          isRequired: true,
                          labelText: "Confirm password",
                          validator: (value) {
                            return controller
                                .validateConfirmPassword(value ?? "");
                          },
                          padding: TextFormFieldPadding.PaddingT14,
                          textInputType: TextInputType.emailAddress,
                          suffix: InkWell(
                              onTap: () {
                                controller.isShowPassword.value =
                                    !controller.isShowPassword.value;
                              },
                              child: Container(
                                  margin: getMargin(
                                      left: 12, top: 16, right: 8, bottom: 16),
                                  child: CustomImageView(
                                      svgPath: controller.isShowPassword.value
                                          ? ImageConstant.imgCheckmark24x24
                                          : ImageConstant.imgCheckmark24x24))),
                          suffixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56)),
                          isObscureText: controller.isShowPassword.value,
                          prefixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56))),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: SizedBox(
                          child: InkWell(
                            onTap: () async {
                              FocusScope.of(Get.context!).unfocus();
                              DateTime a = await getDate();

                              final DateFormat formatter =
                                  DateFormat('yyyy-MM-dd');
                              controller.dob.text = formatter.format(a);
                            },
                            child: AbsorbPointer(
                              child: CustomTextFormField(
                                  controller: controller.dob,
                                  labelText: "Date",
                                  isRequired: true,
                                  size: size,
                                  validator: (value) {
                                    return controller.dobValidator(value ?? "");
                                  },
                                  padding: TextFormFieldPadding.PaddingT14,
                                  textInputType: TextInputType.emailAddress,
                                  suffix: Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: const Icon(Icons.calendar_month)),
                                  suffixConstraints: BoxConstraints(
                                      maxHeight: getVerticalSize(56))),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Flexible(
                          fit: FlexFit.tight,
                          child: CustomDropDown(
                              labelText: "Gender",
                              isRequired: true,
                              validator: (value) {
                                return controller
                                    .genderValidator(value?.title ?? "");
                              },
                              icon: const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.arrow_drop_down),
                              ),
                              items: controller.genderList.value,
                              onChanged: (value) {
                                controller.gender.text = value.title;
                                controller.onSelectedGender(value);
                              })),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: CustomTextFormField(
                    labelText: "Address",
                    controller: controller.address,
                    isRequired: true,
                    maxLines: 4,
                    padding: TextFormFieldPadding.PaddingT14,
                    validator: (value) {
                      return controller.addressValidator(value ?? "");
                    },
                    // textInputType: TextInputType.emailAddress,
                    prefixConstraints:
                        BoxConstraints(maxHeight: getVerticalSize(56))),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: CustomTextFormField(
                            controller: controller.address,
                            labelText: "Address",
                            isRequired: true,
                            padding: TextFormFieldPadding.PaddingT14,
                            validator: (value) {
                              return controller.addressValidator(value ?? '');
                            },
                            textInputType: TextInputType.emailAddress,
                            prefixConstraints:
                                BoxConstraints(maxHeight: getVerticalSize(56))),
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: CustomTextFormField(
                            controller: controller.city,
                            labelText: "City",
                            isRequired: true,
                            padding: TextFormFieldPadding.PaddingT14,
                            validator: (value) {
                              return controller.cityValidator(value ?? "");
                            },
                            textInputType: TextInputType.emailAddress,
                            prefixConstraints:
                                BoxConstraints(maxHeight: getVerticalSize(56))),
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: CustomTextFormField(
                            controller: controller.country,
                            labelText: "Country",
                            isRequired: true,
                            padding: TextFormFieldPadding.PaddingT14,
                            validator: (value) {
                              return controller.countryValidator(value ?? "");
                            },
                            textInputType: TextInputType.emailAddress,
                            prefixConstraints:
                                BoxConstraints(maxHeight: getVerticalSize(56))),
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: CustomTextFormField(
                            controller: controller.stateOrProvince,
                            labelText: "State/Province",
                            isRequired: true,
                            padding: TextFormFieldPadding.PaddingT14,
                            validator: (value) {
                              return controller.stateValidator(value ?? "");
                            },
                            textInputType: TextInputType.emailAddress,
                            prefixConstraints:
                                BoxConstraints(maxHeight: getVerticalSize(56))),
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: CustomTextFormField(
                            controller: controller.postalCode,
                            labelText: "Postal Code",
                            isRequired: true,
                            padding: TextFormFieldPadding.PaddingT14,
                            validator: (value) {
                              return controller
                                  .postalCodeValidator(value ?? "");
                            },
                            textInputType: TextInputType.emailAddress,
                            prefixConstraints:
                                BoxConstraints(maxHeight: getVerticalSize(56))),
                      ),
                    ],
                  )),
              SizedBox(
                height: size.height * 0.03,
              ),
              Align(
                alignment: Alignment.center,
                child: CustomButton(
                    height: getVerticalSize(60),
                    width: getHorizontalSize(80),
                    text: 'Add Patient',
                    margin: getMargin(left: 0, right: 10),
                    fontStyle: ButtonFontStyle.RalewayRomanSemiBold14WhiteA700,
                    onTap: () async {
                      bool a = await controller.trySubmit();
                      if (a) {
                        Map<String, dynamic> requestData = {
                          "email": controller.email.text,
                          "mobile": controller.mobile.text,
                          "password": controller.confirmPassword.text,
                          "role": "PATIENT",
                          "username": controller.mobile.text
                        };
                        controller.callRegister(requestData);
                      }
                    }),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }
}
