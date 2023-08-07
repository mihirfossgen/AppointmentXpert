import 'dart:convert';
import 'dart:io';

import 'package:appointmentxpert/core/utils/country_list.dart';
import 'package:appointmentxpert/presentation/create_profile/listing_page.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../core/errors/exceptions.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../core/utils/state_list.dart';
import '../../models/create_staff_model.dart';
import '../../models/createpatient_model.dart';
import '../../widgets/app_bar/appbar_subtitle_2.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/loader.dart';
import '../../widgets/responsive.dart';
import '../create_profile_success_dialog/controller/create_profile_success_controller.dart';
import '../create_profile_success_dialog/create_profile_success_dialog.dart';
import '../dashboard_screen/shared_components/responsive_builder.dart';
import 'controller/create_profile_controller.dart';

class CreateProfileScreen extends GetWidget<CreateProfileController> {
  final CreateStaff _staffModel = CreateStaff();
  final CreatepatientModel _model = CreatepatientModel();

  CreateProfileController controller = Get.put(CreateProfileController());
  List<String>? deptname;
  late ImageSource sourcee;
  //late GetAllClinic _getAllClinic;
  String? finalDob;
  String fileName = "";

  CreateProfileScreen({super.key});

  // storingPatientOrEmployeeId(int id) async {
  //   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //   final SharedPreferences prefs = await _prefs;
  //   if (args.type == "PATIENT") {
  //     prefs.setInt('patient_Id', id);
  //     // AppointmentDetails.patientId = id;
  //   } else {
  //     prefs.setInt('employee_Id', id);
  //     // AppointmentDetails.staffId = id;
  //   }
  // }

  showSnackbar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.showSnackbar(const GetSnackBar(
        title: 'Failed to Upload Image',
        duration: Duration(seconds: 5),
      ));
    });
  }

  getDate() {
    DateTime? date = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    return Get.dialog(
        AlertDialog(
          title: const Text('Please select DOB'),
          content: SizedBox(
            height: 250,
            width: 100,
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(),
              value: [DateTime.now()],
              onValueChanged: (value) {
                print(value);
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

  // int getClinicID(String t) {
  //   var a = clinic.firstWhere((element) => element.name == t).id;
  //   return a ?? 0;
  // }

  // int getDeptID(String t) {
  //   var a = dept.firstWhere((element) => element.name == t).id;
  //   return a ?? 0;
  // }

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

  Widget patientUI(Size size, BuildContext context) {
    return Form(
        key: controller.formKey,
        child: Responsive.isDesktop(context)
            ? SizedBox(
                width: size.width,
                child: Column(
                  children: [
                    Card(
                      elevation: 4,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: Text("Basic Information",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();
                                            showModalBottomSheet<dynamic>(
                                                isScrollControlled: true,
                                                context: context,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (BuildContext bc) {
                                                  return Bottomsheet(
                                                    onchanged: ((value) {
                                                      print(value);
                                                      if (value == "Gallery") {
                                                        controller.pickImage(
                                                            ImageSource
                                                                .gallery);
                                                      } else {
                                                        controller.pickImage(
                                                            ImageSource.camera);
                                                      }
                                                    }),
                                                    values: [],
                                                  );
                                                });
                                          },
                                          child: AbsorbPointer(
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 100,
                                                  width: 100,
                                                  color: Colors.grey,
                                                  child: Obx(
                                                    () => controller
                                                                .selectedImage ==
                                                            ""
                                                        ? Icon(Icons.person)
                                                        : Responsive.isDesktop(
                                                                context)
                                                            ? Image.network(
                                                                controller
                                                                    .imageFileList![
                                                                        0]
                                                                    .path,
                                                                fit:
                                                                    BoxFit.fill,
                                                              )
                                                            : Image.file(
                                                                File(controller
                                                                    .imageFileList![
                                                                        0]
                                                                    .path),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            right: -15,
                                            bottom: -10,
                                            child: Container(
                                                height: 40,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    shape: BoxShape.circle),
                                                child: const Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: Colors.white,
                                                )))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: size.width * 0.04,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: size.width * 0.40,
                                      child: Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: CustomTextFormField(
                                                controller: controller
                                                    .firstname,
                                                labelText: "First name",
                                                padding: TextFormFieldPadding
                                                    .PaddingT14,
                                                validator: (value) {
                                                  return controller
                                                      .lastNameValidator(
                                                          value ?? "");
                                                },
                                                textInputType: TextInputType
                                                    .name,
                                                prefixConstraints:
                                                    BoxConstraints(
                                                        maxHeight:
                                                            getVerticalSize(
                                                                56))),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: CustomTextFormField(
                                                controller: controller.lastname,
                                                labelText: "Last name",
                                                padding: TextFormFieldPadding
                                                    .PaddingT14,
                                                validator: (value) {
                                                  return controller
                                                      .lastNameValidator(
                                                          value ?? "");
                                                },
                                                textInputType: TextInputType
                                                    .name,
                                                prefixConstraints:
                                                    BoxConstraints(
                                                        maxHeight:
                                                            getVerticalSize(
                                                                56))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    Container(
                                      width: size.width * 0.40,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: SizedBox(
                                              child: InkWell(
                                                onTap: () async {
                                                  DateTime a = await getDate();
                                                  finalDob =
                                                      a.toIso8601String();

                                                  final DateFormat formatter =
                                                      DateFormat('yyyy-MM-dd');
                                                  controller.dob.text =
                                                      formatter.format(a);
                                                },
                                                child: AbsorbPointer(
                                                  child: CustomTextFormField(
                                                      labelText:
                                                          "Date of Birth",
                                                      controller:
                                                          controller.dob,
                                                      validator: (value) {
                                                        return controller
                                                            .dobValidator(
                                                                value ?? "");
                                                      },
                                                      padding:
                                                          TextFormFieldPadding
                                                              .PaddingT14,
                                                      textInputType:
                                                          TextInputType
                                                              .emailAddress,
                                                      suffix: Icon(
                                                          Icons.calendar_month),
                                                      prefixConstraints:
                                                          BoxConstraints(
                                                              maxHeight:
                                                                  getVerticalSize(
                                                                      56))),
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
                                                  validator: (value) {
                                                    return controller
                                                        .genderValidator(
                                                            value?.title ?? "");
                                                  },
                                                  icon: Container(
                                                      margin: getMargin(
                                                          left: 15, right: 5),
                                                      child: const Icon(Icons
                                                          .arrow_drop_down)),
                                                  items: controller
                                                      .genderList.value,
                                                  onChanged: (value) {
                                                    controller.gender =
                                                        value.title;
                                                    controller.onSelectedGender(
                                                        value);
                                                  })),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Card(
                      elevation: 4,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: Text("Contact Information",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            CustomTextFormField(
                                labelText: "Address",
                                controller: controller.address,
                                padding: TextFormFieldPadding.PaddingT14,
                                validator: (value) {
                                  return controller
                                      .addressValidator(value ?? "");
                                },
                                textInputType: TextInputType.emailAddress,
                                prefixConstraints: BoxConstraints(
                                    maxHeight: getVerticalSize(56))),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: size.width * 0.72,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(ListingPage(
                                            listOfCountryOrList: countryList,
                                          ));
                                        },
                                        child: AbsorbPointer(
                                          child: CustomTextFormField(
                                              labelText: "State",
                                              controller: controller.state,
                                              validator: (value) {
                                                return controller
                                                    .stateValidator(
                                                        value ?? "");
                                              },
                                              padding: TextFormFieldPadding
                                                  .PaddingT14,
                                              textInputType: TextInputType.name,
                                              prefixConstraints: BoxConstraints(
                                                  maxHeight:
                                                      getVerticalSize(56))),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: InkWell(
                                            onTap: () {
                                              Get.to(ListingPage(
                                                listOfCountryOrList:
                                                    countryList,
                                              ));
                                            },
                                            child: AbsorbPointer(
                                              child: CustomTextFormField(
                                                  labelText: "Country",
                                                  controller: controller
                                                      .country,
                                                  validator: (value) {
                                                    return controller
                                                        .countryValidator(
                                                            value ?? "");
                                                  },
                                                  padding: TextFormFieldPadding
                                                      .PaddingT14,
                                                  textInputType: TextInputType
                                                      .name,
                                                  prefixConstraints:
                                                      BoxConstraints(
                                                          maxHeight:
                                                              getVerticalSize(
                                                                  56))),
                                            ))),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: size.width * 0.72,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: CustomTextFormField(
                                          labelText: "Pin Code",
                                          controller: controller.pincode,
                                          padding:
                                              TextFormFieldPadding.PaddingT14,
                                          validator: (value) {
                                            return controller
                                                .pincodeValidator(value ?? "");
                                          },
                                          textInputType: TextInputType.number,
                                          prefixConstraints: BoxConstraints(
                                              maxHeight: getVerticalSize(56))),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: CustomTextFormField(
                                          labelText: "Phone Number",
                                          controller: controller.mobile,
                                          maxLength: 10,
                                          padding:
                                              TextFormFieldPadding.PaddingT14,
                                          textInputType: TextInputType.phone,
                                          validator: (value) {
                                            return controller
                                                .numberValidator(value ?? "");
                                          },
                                          prefixConstraints: BoxConstraints(
                                              maxHeight: getVerticalSize(56))),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    //width: size.width,
                    child: Card(
                      elevation: 4,
                      shadowColor: ColorConstant.gray400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                              child: Text("Basic Information",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      showModalBottomSheet<dynamic>(
                                          isScrollControlled: true,
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder: (BuildContext bc) {
                                            return Bottomsheet(
                                              onchanged: ((value) {
                                                print(value);
                                                if (value == "Gallery") {
                                                  controller.pickImage(
                                                      ImageSource.gallery);
                                                } else {
                                                  controller.pickImage(
                                                      ImageSource.camera);
                                                }
                                              }),
                                              values: [],
                                            );
                                          });
                                    },
                                    child: AbsorbPointer(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 120,
                                            color: Colors.grey,
                                            child: Obx(
                                              () =>
                                                  controller.selectedImage == ""
                                                      ? Icon(Icons.person)
                                                      : Image.file(
                                                          File(controller
                                                              .imageFileList![0]
                                                              .path),
                                                          fit: BoxFit.fill,
                                                        ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      right: -15,
                                      bottom: -10,
                                      child: Container(
                                          height: 40,
                                          width: 60,
                                          decoration: const BoxDecoration(
                                              color: Colors.grey,
                                              shape: BoxShape.circle),
                                          child: const Icon(
                                            Icons.camera_alt_outlined,
                                            color: Colors.white,
                                          )))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 12),
                                      child: CustomDropDown(
                                          labelText: "Prefix",
                                          isRequired: true,
                                          validator: (value) {
                                            return controller
                                                .prefixControllerValidator(
                                                    value?.title ?? "");
                                          },
                                          icon: Container(
                                              margin: getMargin(
                                                  left: 10, right: 16),
                                              child: const Icon(
                                                  Icons.arrow_drop_down)),
                                          variant: DropDownVariant.GreyOutline,
                                          fontStyle: DropDownFontStyle
                                              .ManropeMedium14Bluegray500,
                                          items: controller.prefixesList.value,
                                          onChanged: (value) {
                                            controller.prefix = value.title;
                                            controller.onSelectedPrefix(value);
                                          }),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    flex: 2,
                                    child: CustomTextFormField(
                                        labelText: "First name",
                                        controller: controller.firstname,
                                        isRequired: true,
                                        padding:
                                            TextFormFieldPadding.PaddingT14,
                                        validator: (value) {
                                          return controller
                                              .firstNameValidator(value ?? "");
                                        },
                                        textInputType:
                                            TextInputType.emailAddress,
                                        prefixConstraints: BoxConstraints(
                                            maxHeight: getVerticalSize(56))),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: CustomTextFormField(
                                        controller: controller.lastname,
                                        labelText: "Last name",
                                        isRequired: true,
                                        padding:
                                            TextFormFieldPadding.PaddingT14,
                                        validator: (value) {
                                          return controller
                                              .lastNameValidator(value ?? "");
                                        },
                                        textInputType:
                                            TextInputType.emailAddress,
                                        prefixConstraints: BoxConstraints(
                                            maxHeight: getVerticalSize(56))),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                child: InkWell(
                                  onTap: () async {
                                    DateTime a = await getDate();
                                    finalDob = a.toIso8601String();

                                    final DateFormat formatter =
                                        DateFormat('yyyy-MM-dd');
                                    controller.dob.text = formatter.format(a);
                                  },
                                  child: AbsorbPointer(
                                    child: CustomTextFormField(
                                        labelText: "Date of Birth",
                                        controller: controller.dob,
                                        validator: (value) {
                                          return controller
                                              .dobValidator(value ?? "");
                                        },
                                        padding:
                                            TextFormFieldPadding.PaddingT14,
                                        textInputType:
                                            TextInputType.emailAddress,
                                        prefixConstraints: BoxConstraints(
                                            maxHeight: getVerticalSize(56))),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: CustomDropDown(
                                  labelText: "Gender",
                                  validator: (value) {
                                    return controller
                                        .genderValidator(value?.title ?? "");
                                  },
                                  variant: DropDownVariant.OutlineBluegray400,
                                  fontStyle: DropDownFontStyle
                                      .ManropeMedium14Bluegray500,
                                  icon: Container(
                                      margin: getMargin(left: 30, right: 16),
                                      child: Icon(Icons.arrow_drop_down)),
                                  items: controller.genderList.value,
                                  onChanged: (value) {
                                    controller.gender = value.title;
                                    controller.onSelectedGender(value);
                                  }),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shadowColor: ColorConstant.gray400,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                          child: Text("Contact Information",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                              labelText: "Address",
                              controller: controller.address,
                              padding: TextFormFieldPadding.PaddingT14,
                              validator: (value) {
                                return controller.addressValidator(value ?? "");
                              },
                              textInputType: TextInputType.emailAddress,
                              prefixConstraints: BoxConstraints(
                                  maxHeight: getVerticalSize(56))),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () {
                              Get.to(ListingPage(
                                listOfCountryOrList: stateList,
                              ))?.then((value) {
                                if (value != null) {
                                  controller.state.text =
                                      value['name'].toString();
                                }
                              });
                            },
                            child: AbsorbPointer(
                              child: CustomTextFormField(
                                  labelText: "State",
                                  controller: controller.state,
                                  validator: (value) {
                                    return controller
                                        .stateValidator(value ?? "");
                                  },
                                  padding: TextFormFieldPadding.PaddingT14,
                                  textInputType: TextInputType.name,
                                  prefixConstraints: BoxConstraints(
                                      maxHeight: getVerticalSize(56))),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
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
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                              labelText: "Pin Code",
                              controller: controller.pincode,
                              padding: TextFormFieldPadding.PaddingT14,
                              validator: (value) {
                                return controller.pincodeValidator(value ?? "");
                              },
                              textInputType: TextInputType.number,
                              prefixConstraints: BoxConstraints(
                                  maxHeight: getVerticalSize(56))),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                              labelText: "Phone Number",
                              controller: controller.mobile,
                              maxLength: 10,
                              isRequired: true,
                              padding: TextFormFieldPadding.PaddingT14,
                              textInputType: TextInputType.phone,
                              validator: (value) {
                                return controller.numberValidator(value ?? "");
                              },
                              prefixConstraints: BoxConstraints(
                                  maxHeight: getVerticalSize(56))),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                              labelText: "Email",
                              controller: controller.email,
                              isRequired: true,
                              padding: TextFormFieldPadding.PaddingT14,
                              textInputType: TextInputType.emailAddress,
                              validator: (value) {
                                return controller.emailValidator(value ?? "");
                              },
                              prefixConstraints: BoxConstraints(
                                  maxHeight: getVerticalSize(56))),
                        ),
                      ],
                    ),
                  )
                ],
              ));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    ScreenArguments? args =
        ModalRoute.of(context)?.settings.arguments as ScreenArguments?;
    if (args != null) {
      controller.mobile.text = args.username;
    }
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            appBar: !Responsive.isDesktop(context)
                ? CustomAppBar(
                    backgroundColor: ColorConstant.blue700,
                    height: getVerticalSize(60),
                    leadingWidth: 64,
                    elevation: 0,
                    leading: !Responsive.isDesktop(context)
                        ? IconButton(
                            onPressed: () {
                              onTapArrowleft();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ))
                        // AppbarImage(
                        //     height: getSize(40),
                        //     width: getSize(40),
                        //     backgroundColor: ColorConstant.blue50,
                        //     svgPath: ImageConstant.imgArrowleft,
                        //     margin: getMargin(left: 24),
                        //     onTap: () {
                        //       onTapArrowleft();
                        //     })
                        : null,
                    centerTitle: true,
                    title: AppbarSubtitle2(text: "Profile"))
                : null,
            body: ResponsiveBuilder(
              mobileBuilder: (context, constraints) {
                return _buildSmallScreen(size, controller, context, args);
              },
              desktopBuilder: (context, constraints) {
                return _buildLargeScreen(size, controller, context, args);
              },
              tabletBuilder: (context, constraints) {
                return _buildSmallScreen(size, controller, context, args);
              },
            )));
  }

  Widget _buildLargeScreen(Size size, CreateProfileController loginController,
      BuildContext context, ScreenArguments? args) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: RotatedBox(
            quarterTurns: 0,
            child: Image.asset(
              !Responsive.isDesktop(Get.context!)
                  ? 'assets' '/images/bannerbg.png'
                  : '/images/bannerbg.png',
              fit: BoxFit.contain,
              // height: size.height * 0.2,
              // width: size.width * 0.8,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.02),
        Expanded(
          flex: 7,
          child: Center(child: getBody(size, loginController, context, args)),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(Size size, CreateProfileController loginController,
      BuildContext context, ScreenArguments? args) {
    return Center(
      child: getBody(size, loginController, context, args),
    );
  }

  Widget getBody(Size size, CreateProfileController simpleUIController,
      BuildContext context, ScreenArguments? args) {
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        padding: getPadding(left: 15, top: 20, right: 15, bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            patientUI(size, context),
            Obx(() => controller.isloading.value
                ? SizedBox(height: 50, child: ThreeDotLoader())
                : CustomButton(
                    height: getVerticalSize(56),
                    text: "Confirm and Save",
                    margin: getMargin(top: 12),
                    onTap: () {
                      bool a = controller.trySubmit();
                      if (a) OnTapConfirmAndSave(args);
                    })),
          ],
        ),
      ),
    );
  }

  onTapArrowleft() {
    Get.back();
  }

  OnTapConfirmAndSave(ScreenArguments? args) async {
    controller.isloading.value = true;
    Map<String, dynamic> credentials;
    if (args != null) {
      if (args.type == "PATIENT") {
        credentials = {
          "address": controller.address.text,
          "age": calculateAge(finalDob ?? ""),
          "bloodType": controller.bloodGroup.text,
          "country": controller.country.text,
          "countryOfBirth": controller.countryOfBirth.text,
          "dateCreated": DateTime.now().toIso8601String(),
          "dob": finalDob,
          "email": controller.email.text,
          "fatherName": controller.fathername.text,
          "firstName": controller.firstname.text,
          //"id": 0,
          "lastName": controller.lastname.text,
          "mobile": controller.mobile.text,
          "motherName": controller.motherName.text,
          "nationality": controller.nationality.text,
          // "placeOfBirth": controller.placeOfBirth.text,
          "prefix": controller.prefix,
          // "regions": controller.regions.text,
          "sex": controller.gender,
          "userId": args.roleId,
          "visits": []
        };
        print(jsonEncode(credentials));
      } else {
        // staff creation api
        credentials = {
          "address": controller.address.text,
          "clinicId": 1,
          "departmentId": 6,
          "dob": finalDob,
          "email": controller.email.text,
          "employment": controller.jobtype,
          "fatherName": controller.fathername.text,
          "firstName": controller.firstname.text,
          "joinedDate": "2023-05-04T05:25:51.534Z",
          "lastName": controller.lastname.text,
          "mobile": controller.mobile.text,
          "prefix": controller.prefix,
          "profession": args.type == "PATIENT" ? "PATIENT" : "DOCTOR",
          "qualification": "DEGREE",
          "sex": controller.gender,
          "staffId": controller.staffId.text,
          "terminatedDate": "",
          "userId": args.roleId
        };
        print(jsonEncode(credentials));
      }

      try {
        if (args.type == "PATIENT") {
          await controller.callCreatePatient(credentials, args.type);
        } else {
          await controller.callCreateEmployee(credentials, args.type);
        }
        onTapCreateprofile();
      } on Map {
        print("errrororrrr");
        // _onOnTapSignInError();
      } on NoInternetException catch (e) {
        Get.rawSnackbar(message: e.toString());
      } catch (e) {
        Get.rawSnackbar(message: e.toString());
      }
    }
  }

  onTapCreateprofile() {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.only(left: 0),
      content: CreateProfileSuccessDialog(
        Get.put(
          CreateProfileSuccessContoller(),
        ),
      ),
    ));
  }
}

class Bottomsheet extends StatefulWidget {
  final List<String> values;
  final selectedvalue;
  final widgetName;
  final Function(String) onchanged;
  const Bottomsheet(
      {Key? key,
      this.widgetName,
      required this.values,
      this.selectedvalue,
      required this.onchanged})
      : super(key: key);

  @override
  State<Bottomsheet> createState() => _BottomsheetState();
}

class _BottomsheetState extends State<Bottomsheet> {
  @override
  void initState() {
    super.initState();
  }

  String? selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: const Icon(
                      Icons.clear,
                      size: 25,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Select...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      selected = "Gallery";
                      widget.onchanged(selected ?? "");
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade300))),
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 5),
                        child: const Text("Select Gallery")),
                  ),
                  InkWell(
                    onTap: () {
                      selected = "Camera";
                      widget.onchanged(selected ?? "");
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 5),
                        child: const Text("Select Camera")),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
