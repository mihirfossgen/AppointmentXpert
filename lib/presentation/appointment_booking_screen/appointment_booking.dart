import 'dart:convert';

import 'package:appointmentxpert/models/temp_hold.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/errors/exceptions.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../models/getallEmplyesList.dart';
import '../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_form_field.dart';
import '../booking_doctor_success_dialog/booking_doctor_success_dialog.dart';
import '../booking_doctor_success_dialog/controller/booking_doctor_success_controller.dart';
import '../dashboard_screen/shared_components/responsive_builder.dart';
import '../dashboard_screen/views/screens/dashboard_screen.dart';
import 'controller/doctor_detail_controller.dart';

// ignore: must_be_immutable
class AppointmentBookingScreen extends GetWidget<DoctorDetailController> {
  AppointmentBookingScreen(
      {super.key, this.doctorDetailsArguments, this.patientDetailsArguments});
  DoctorDetailsArguments? doctorDetailsArguments;
  PatientDetailsArguments? patientDetailsArguments;
  DoctorDetailController controller = Get.put(DoctorDetailController());
  @override
  Widget build(BuildContext context) {
    // final args =
    //     ModalRoute.of(context)!.settings.arguments as DoctorDetailsArguments;

    TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 30);
    TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 30);
    Duration step = const Duration(minutes: 30);
    TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
    TextEditingController _timeController = TextEditingController();
    String _hour, _minute, _time;
    controller.times = controller
        .getTimes(startTime, endTime, step)
        .map((tod) => tod.format(context))
        .toList();

    if (SharedPrefUtils.readPrefStr('doctor_name') != '') {
      controller.consultingDoctor.text =
          SharedPrefUtils.readPrefStr('doctor_name');
    }
    if (patientDetailsArguments?.details != null &&
        controller.firstname.text == "") {
      controller.firstname.text =
          patientDetailsArguments?.details?.firstName ?? "";
      controller.lastname.text =
          patientDetailsArguments?.details?.lastName ?? "";
      controller.email.text = patientDetailsArguments?.details?.email ?? "";

      controller.mobile.text = patientDetailsArguments?.details?.mobile ?? "";
      controller.address.text = patientDetailsArguments?.details?.address ?? "";
      controller.list = patientDetailsArguments?.list;

      controller.genderList.value.any((element) {
        if (element.title.toLowerCase() ==
            patientDetailsArguments?.details?.sex?.toLowerCase()) {
          element.isSelected = true;
          controller.genderList.refresh();
          return true;
        } else {
          return false;
        }
      });
    }

    if (doctorDetailsArguments?.appointmentData != null &&
        controller.firstname.text == "") {
      controller.firstname.text =
          doctorDetailsArguments?.appointmentData.patient?.firstName ?? "";
      controller.lastname.text =
          doctorDetailsArguments?.appointmentData.patient?.lastName ?? "";
      controller.email.text =
          doctorDetailsArguments?.appointmentData.patient?.email ?? "";

      controller.mobile.text =
          doctorDetailsArguments?.appointmentData.patient?.mobile ?? "";
      controller.address.text =
          doctorDetailsArguments?.appointmentData.patient?.address ?? "";
      controller.list = patientDetailsArguments?.list;

      controller.genderList.value.any((element) {
        if (element.title.toLowerCase() ==
            doctorDetailsArguments?.appointmentData.patient?.sex
                ?.toLowerCase()) {
          element.isSelected = true;
          controller.genderList.refresh();
          return true;
        } else {
          return false;
        }
      });
    }

    getDate() {
      DateTime? date = DateTime.now();
      WidgetsBinding.instance.addPostFrameCallback((_) {});
      return Get.dialog(
          AlertDialog(
            title: const Text('Please select'),
            content: SizedBox(
              height: 250,
              width: 100,
              child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(),
                initialValue: [DateTime.now()],
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

    Future<Null> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (picked != null) selectedTime = picked;
      _hour = selectedTime.hour.toString();
      _minute = selectedTime.minute.toString();
      _time = '$_hour : $_minute';
      _timeController.text = _time;
      controller.from.value.text = formatDate(
          DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
          [hh, ':', nn, " ", am]).toString();
      controller.to.text = formatDate(
          DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute + 30),
          [hh, ':', nn, " ", am]).toString();
      _timeController.text = formatDate(
          DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
          [hh, ':', nn, " ", am]).toString();
    }

    Widget mobileUi(BuildContext cxt) {
      return SizedBox(
          width: double.maxFinite,
          child: Card(
              //elevation: 4,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Form(
                key: controller.formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                        child: Text("Patient Details",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: ColorConstant.blue700)),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                          child: Column(
                            children: [
                              CustomTextFormField(
                                  controller: controller.firstname,
                                  labelText: "First name",
                                  padding: TextFormFieldPadding.PaddingT14,
                                  validator: (value) {
                                    return controller
                                        .firstNameValidator(value ?? "");
                                  },
                                  textInputType: TextInputType.emailAddress,
                                  prefixConstraints: BoxConstraints(
                                      maxHeight: getVerticalSize(56))),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              CustomTextFormField(
                                  controller: controller.lastname,
                                  labelText: "Last name",
                                  padding: TextFormFieldPadding.PaddingT14,
                                  validator: (value) {
                                    return controller
                                        .lastNameValidator(value ?? "");
                                  },
                                  textInputType: TextInputType.emailAddress,
                                  prefixConstraints: BoxConstraints(
                                      maxHeight: getVerticalSize(56))),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              CustomDropDown(
                                  labelText: "Gender",
                                  variant: DropDownVariant.OutlineBluegray400,
                                  fontStyle: DropDownFontStyle
                                      .ManropeMedium14Bluegray500,
                                  validator: (value) {
                                    return controller
                                        .genderValidator(value?.title ?? "");
                                  },
                                  icon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.arrow_drop_down),
                                  ),
                                  items: controller.genderList.value,
                                  onChanged: (value) {
                                    controller.gender.text = value.title;
                                    controller.onSelectedGender(value);
                                  }),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              CustomTextFormField(
                                  controller: controller.email,
                                  labelText: "Email",
                                  validator: (value) {
                                    return controller
                                        .emailValidator(value ?? "");
                                  },
                                  padding: TextFormFieldPadding.PaddingT14,
                                  textInputType: TextInputType.emailAddress,
                                  prefixConstraints: BoxConstraints(
                                      maxHeight: getVerticalSize(56))),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              CustomTextFormField(
                                  controller: controller.mobile,
                                  labelText: "Number",
                                  validator: (value) {
                                    return controller
                                        .numberValidator(value ?? "");
                                  },
                                  padding: TextFormFieldPadding.PaddingT14,
                                  textInputType: TextInputType.number,
                                  prefixConstraints: BoxConstraints(
                                      maxHeight: getVerticalSize(56))),
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
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 15, 0, 15),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Appointment Details",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: ColorConstant.blue700)),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              SizedBox(
                                child: InkWell(
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    DateTime a = await getDate();

                                    final DateFormat formatter =
                                        DateFormat('yyyy-MM-dd');
                                    controller.dob.text = formatter.format(a);
                                  },
                                  child: AbsorbPointer(
                                    child: CustomTextFormField(
                                        controller: controller.dob,
                                        labelText: "Date",
                                        padding:
                                            TextFormFieldPadding.PaddingT14,
                                        textInputType:
                                            TextInputType.emailAddress,
                                        suffix: Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Icon(Icons.calendar_month)),
                                        suffixConstraints: BoxConstraints(
                                            maxHeight: getVerticalSize(56))),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              InkWell(
                                onTap: () {
                                  _selectTime(context);
                                },
                                child: AbsorbPointer(
                                  child: CustomTextFormField(
                                      controller: controller.from.value,
                                      labelText: "From",
                                      padding: TextFormFieldPadding.PaddingT14,
                                      validator: (value) {
                                        return controller
                                            .fromValidator(value ?? "");
                                      },
                                      textInputType: TextInputType.emailAddress,
                                      suffix: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: Icon(Icons.alarm),
                                      ),
                                      suffixConstraints: BoxConstraints(
                                          maxHeight: getVerticalSize(56))),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              AbsorbPointer(
                                child: CustomTextFormField(
                                    controller: controller.to,
                                    labelText: "To",
                                    padding: TextFormFieldPadding.PaddingT14,
                                    // validator: (value) {
                                    //   return controller
                                    //       .lastNameValidator(
                                    //           value ?? "");
                                    // },
                                    textInputType: TextInputType.emailAddress,
                                    suffix: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Icon(Icons.alarm),
                                    ),
                                    suffixConstraints: BoxConstraints(
                                        maxHeight: getVerticalSize(56))),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              CustomTextFormField(
                                  controller: controller.consultingDoctor,
                                  labelText: "Consulting Doctor",
                                  readonly: true,
                                  isRequired: true,
                                  validator: (value) {
                                    return controller
                                        .consultingdoctorValidator(value ?? "");
                                  },
                                  padding: TextFormFieldPadding.PaddingT14,
                                  textInputType: TextInputType.emailAddress,
                                  prefixConstraints: BoxConstraints(
                                      maxHeight: getVerticalSize(56))),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              CustomTextFormField(
                                  controller: controller.treatment,
                                  labelText: "Treatment",
                                  validator: (value) {
                                    return controller
                                        .treatmentValidator(value ?? "");
                                  },
                                  padding: TextFormFieldPadding.PaddingT14,
                                  textInputType: TextInputType.emailAddress,
                                  prefixConstraints: BoxConstraints(
                                      maxHeight: getVerticalSize(56))),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              CustomTextFormField(
                                  labelText: "Notes",
                                  controller: controller.notes,
                                  padding: TextFormFieldPadding.PaddingT14,
                                  validator: (value) {
                                    return controller
                                        .notesValidator(value ?? "");
                                  },
                                  textInputType: TextInputType.emailAddress,
                                  prefixConstraints: BoxConstraints(
                                      maxHeight: getVerticalSize(56))),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Padding(
                                  padding: getPadding(bottom: 28),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: CustomButton(
                                                height: getVerticalSize(52),
                                                text: "lbl_book_apointment".tr,
                                                margin: getMargin(left: 11),
                                                fontStyle: ButtonFontStyle
                                                    .RalewayRomanSemiBold14WhiteA700,
                                                onTap: () async {
                                                  bool a = await controller
                                                      .trySubmit();
                                                  if (a) {
                                                    onTapBookapointmentOne(
                                                      controller.examinerId ??
                                                          0,
                                                    );
                                                  }
                                                }))
                                      ]))
                            ],
                          )),
                    ]),
              )));
    }

    Widget webUi(BuildContext context, PatientDetailsArguments args) {
      return Form(
        key: controller.formKey,
        child: Container(
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
                              controller: controller.firstname,
                              labelText: "First name",
                              isRequired: true,
                              padding: TextFormFieldPadding.PaddingT14,
                              validator: (value) {
                                return controller
                                    .firstNameValidator(value ?? "");
                              },
                              textInputType: TextInputType.emailAddress,
                              prefixConstraints: BoxConstraints(
                                  maxHeight: getVerticalSize(56))),
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: CustomTextFormField(
                              controller: controller.lastname,
                              labelText: "Last name",
                              isRequired: true,
                              padding: TextFormFieldPadding.PaddingT14,
                              validator: (value) {
                                return controller
                                    .lastNameValidator(value ?? "");
                              },
                              textInputType: TextInputType.emailAddress,
                              prefixConstraints: BoxConstraints(
                                  maxHeight: getVerticalSize(56))),
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
                                icon: Padding(
                                  padding: const EdgeInsets.only(right: 10),
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
                  child: Row(
                    children: [
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
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Expanded(
                        flex: 1,
                        child: CustomTextFormField(
                            controller: controller.mobile,
                            isRequired: true,
                            labelText: "Number",
                            validator: (value) {
                              return controller.numberValidator(value ?? "");
                            },
                            padding: TextFormFieldPadding.PaddingT14,
                            textInputType: TextInputType.emailAddress,
                            prefixConstraints:
                                BoxConstraints(maxHeight: getVerticalSize(56))),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                  child: CustomTextFormField(
                      labelText: "Address",
                      controller: controller.address,
                      isRequired: true,
                      padding: TextFormFieldPadding.PaddingT14,
                      validator: (value) {
                        return controller.addressValidator(value ?? "");
                      },
                      // textInputType: TextInputType.emailAddress,
                      prefixConstraints:
                          BoxConstraints(maxHeight: getVerticalSize(56))),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 15),
                  child: Text("Appointment Details",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: size.height * 0.03,
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
                                FocusScope.of(context).unfocus();
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
                                      return controller
                                          .dobValidator(value ?? "");
                                    },
                                    padding: TextFormFieldPadding.PaddingT14,
                                    textInputType: TextInputType.emailAddress,
                                    suffix: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: Icon(Icons.calendar_month)),
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
                          child: InkWell(
                            onTap: () {
                              _selectTime(context);
                            },
                            child: AbsorbPointer(
                              child: CustomTextFormField(
                                  labelText: "From",
                                  isRequired: true,
                                  controller: controller.from.value,
                                  padding: TextFormFieldPadding.PaddingT14,
                                  validator: (value) {
                                    return controller
                                        .fromValidator(value ?? "");
                                  },
                                  textInputType: TextInputType.emailAddress,
                                  suffix: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.alarm),
                                  ),
                                  suffixConstraints: BoxConstraints(
                                      maxHeight: getVerticalSize(56))),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: AbsorbPointer(
                            child: CustomTextFormField(
                                controller: controller.to,
                                isRequired: true,
                                labelText: "To",
                                padding: TextFormFieldPadding.PaddingT14,
                                validator: (value) {
                                  return controller.toValidator(value ?? "");
                                },
                                textInputType: TextInputType.datetime,
                                suffix: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.alarm),
                                ),
                                suffixConstraints: BoxConstraints(
                                    maxHeight: getVerticalSize(56))),
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                  child: Row(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: CustomTextFormField(
                            controller: controller.consultingDoctor,
                            labelText: "Consulting Doctor",
                            isRequired: true,
                            readonly: true,
                            validator: (value) {
                              return controller
                                  .consultingdoctorValidator(value ?? "");
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
                            controller: controller.treatment,
                            isRequired: true,
                            labelText: "Treatment",
                            validator: (value) {
                              return controller.treatmentValidator(value ?? "");
                            },
                            padding: TextFormFieldPadding.PaddingT14,
                            textInputType: TextInputType.text,
                            prefixConstraints:
                                BoxConstraints(maxHeight: getVerticalSize(56))),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                  child: CustomTextFormField(
                      labelText: "Notes",
                      controller: controller.notes,
                      isRequired: true,
                      padding: TextFormFieldPadding.PaddingT14,
                      validator: (value) {
                        return controller.notesValidator(value ?? "");
                      },
                      textInputType: TextInputType.text,
                      prefixConstraints:
                          BoxConstraints(maxHeight: getVerticalSize(56))),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                      height: getVerticalSize(60),
                      width: getHorizontalSize(80),
                      text: "lbl_book_apointment".tr,
                      margin: getMargin(left: 0, right: 10),
                      fontStyle:
                          ButtonFontStyle.RalewayRomanSemiBold14WhiteA700,
                      onTap: () async {
                        bool a = await controller.trySubmit();
                        if (a)
                          onTapBookapointmentOne(controller.examinerId ?? 0);
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

    Widget getBody(
        Size size, BuildContext context, PatientDetailsArguments args) {
      return SingleChildScrollView(
        child: Container(
            width: double.maxFinite,
            padding: getPadding(left: 8, top: 15, right: 8, bottom: 32),
            child: ResponsiveBuilder.isMobile(Get.context!)
                ? mobileUi(context)
                : webUi(context, args)),
      );
    }

    Widget _buildLargeScreen(
        Size size, BuildContext context, PatientDetailsArguments args) {
      return Row(
        children: [
          // Expanded(
          //   flex: 1,
          //   child: RotatedBox(
          //     quarterTurns: 0,
          //     child: Lottie.asset(
          //       '/lottie/need_doctor.json',
          //       //height: size.height * 0.3,
          //       width: double.infinity,
          //       fit: BoxFit.fill,
          //     ),
          //   ),
          // ),
          // SizedBox(width: size.width * 0.06),
          Expanded(
            flex: 7,
            child: getBody(size, context, args),
          ),
        ],
      );
    }

    /// For Small screens
    Widget _buildSmallScreen(
        Size size, BuildContext context, PatientDetailsArguments args) {
      return Center(
        child: getBody(size, context, args),
      );
    }

    return ResponsiveBuilder.isMobile(Get.context!)
        ? _buildSmallScreen(size, context, patientDetailsArguments!)
        : _buildLargeScreen(size, context, patientDetailsArguments!);
  }

  onTapBookapointmentOne(int id) async {
    var requestData = {
      "active": true,
      "date": DateTime.parse(
              "${controller.dob.text} ${controller.from.value.text.replaceAll(" PM", "").replaceAll(" AM", "")}")
          .toIso8601String(),
      // "departmentId": controller.getdeptId(id),
      "startTime": controller.from.value.text,
      "endTime": controller.to.value.text,
      "examinerId": SharedPrefUtils.readPrefINt('staff_id'),
      "note": controller.treatment.text,

      "purpose": "OTHER",
      //"referenceId": 0,
      "status": "Pending",
      "updateTimeInMin": 0
    };

    print(jsonEncode(requestData));

    try {
      await controller.callCreateLogin(requestData);
      onTapBooknow();
    } on Map {
      //  _onOnTapSignInError();
    } on NoInternetException catch (e) {
      Get.rawSnackbar(message: e.toString());
    } catch (e) {
      Get.rawSnackbar(message: e.toString());
    }
  }
}

onTapArrowleft4() {
  Get.back();
}

onTapBooknow() {
  Get.dialog(AlertDialog(
    backgroundColor: Colors.transparent,
    contentPadding: EdgeInsets.zero,
    insetPadding: const EdgeInsets.only(left: 0),
    content: BookingDoctorSuccessDialog(
      Get.put(
        BookingDoctorSuccessController(),
      ),
    ),
  ));
}

class AppointmentDetails {
  String time;
  String date;
  int examinerId;
  DoctorList itemData;
  AppointmentDetails(this.date, this.time, this.itemData, this.examinerId);
}
