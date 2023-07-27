import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';

import '../../core/errors/exceptions.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../models/getallEmplyesList.dart';
import '../../models/staff_list_model.dart';
import '../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../theme/app_style.dart';
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
      {super.key,
      this.doctorDetailsArguments,
      this.patientDetailsArguments,
      this.doctorsList});
  DoctorDetailsArguments? doctorDetailsArguments;
  PatientDetailsArguments? patientDetailsArguments;
  List<Contents>? doctorsList;
  @override
  DoctorDetailController controller = Get.put(DoctorDetailController());
  Contents? content;
  Map<String, dynamic>? a;

  @override
  Widget build(BuildContext context) {
    // final args =
    //     ModalRoute.of(context)!.settings.arguments as DoctorDetailsArguments;

    TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 30);
    TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 30);
    Duration step = const Duration(minutes: 30);
    TimeOfDay selectedTime = TimeOfDay.now();
    TextEditingController timeController = TextEditingController();
    String hour, minute, time;
    controller.times = controller
        .getTimes(startTime, endTime, step)
        .map((tod) => tod.format(context))
        .toList();

    if (doctorsList != []) {
      print('list value ------- ${controller.counsultingDoctor.value.length}');
      if (controller.counsultingDoctor.value.length == 0) {
        controller.counsultingDoctor.value = doctorsList!
            .map((e) => SelectionPopupModel(
                title: "${e.firstName} ${e.lastName}", id: e.id))
            .toList();
      }
    }

    if (patientDetailsArguments?.details != null) {
      if (controller.firstname.text == '') {
        controller.firstname.text =
            patientDetailsArguments?.details?.firstName ?? "";
      }

      if (controller.lastname.text == '') {
        controller.lastname.text =
            patientDetailsArguments?.details?.lastName ?? "";
      }

      if (controller.email.text == '') {
        controller.email.text = patientDetailsArguments?.details?.email ?? "";
      }
      if (controller.mobile.text == '') {
        controller.mobile.text = patientDetailsArguments?.details?.mobile ?? "";
      }
      if (controller.address.text == '') {
        controller.address.text =
            patientDetailsArguments?.details?.address ?? "";
      }

      controller.list = patientDetailsArguments?.list;
    }

    if (doctorDetailsArguments?.appointmentData != null) {
      if (controller.firstname.text == '') {
        controller.firstname.text =
            doctorDetailsArguments?.appointmentData.patient?.firstName ?? "";
      }

      if (controller.lastname.text == '') {
        controller.lastname.text =
            doctorDetailsArguments?.appointmentData.patient?.lastName ?? "";
      }

      if (controller.email.text == '') {
        controller.email.text =
            doctorDetailsArguments?.appointmentData.patient?.email ?? "";
      }
      if (controller.mobile.text == '') {
        controller.mobile.text =
            doctorDetailsArguments?.appointmentData.patient?.mobile ?? "";
      }
      if (controller.address.text == '') {
        controller.address.text =
            doctorDetailsArguments?.appointmentData.patient?.address ?? "";
      }
      controller.list = patientDetailsArguments?.list;
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

    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (picked != null) {
        print(picked);
        selectedTime = picked;
      }
      int intervalTime = doctorsList
                  ?.firstWhere((element) =>
                      element.id ==
                      controller.counsultingDoctor.value
                          .firstWhere((element) => element.isSelected == true)
                          .id)
                  .timeSlotForBookingInMin ==
              0
          ? 15
          : doctorsList
                  ?.firstWhere((element) =>
                      element.id ==
                      controller.counsultingDoctor.value
                          .firstWhere((element) => element.isSelected == true)
                          .id)
                  .timeSlotForBookingInMin ??
              15;
      hour = selectedTime.hour.toString();
      minute = selectedTime.minute.toString();
      time = '$hour : $minute';
      timeController.text = time;
      controller.from.value.text = formatDate(
          DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, selectedTime.hour, selectedTime.minute),
          [hh, ':', nn, " ", am]).toString();
      controller.to.text = formatDate(
          DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              selectedTime.hour,
              selectedTime.minute + intervalTime),
          [hh, ':', nn, " ", am]).toString();
      timeController.text = formatDate(
          DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, selectedTime.hour, selectedTime.minute),
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
                                  icon: const Padding(
                                    padding: EdgeInsets.all(8.0),
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
                                    return controller.addressValidator(value);
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
                              Obx(() => CustomDropDown(
                                  labelText: "Consulting Doctor ",
                                  variant: DropDownVariant.OutlineBluegray400,
                                  fontStyle: DropDownFontStyle
                                      .ManropeMedium14Bluegray500,
                                  validator: (value) {
                                    return controller.consultingdoctorValidator(
                                        value?.title ?? "");
                                  },
                                  icon: const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.arrow_drop_down),
                                  ),
                                  items: controller.counsultingDoctor.value,
                                  onChanged: (value) {
                                    controller.consultingDoctor.value.text =
                                        value.title;
                                    if (controller
                                            .consultingDoctor.value.text !=
                                        '') {
                                      controller.showDateAndTime.value = true;
                                    }
                                    controller.onConsultingDoctorSelect(value);
                                  })),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Obx(
                                () => controller.showDateAndTime.value == false
                                    ? const SizedBox()
                                    : Column(
                                        children: [
                                          SizedBox(
                                            child: InkWell(
                                              onTap: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                DateTime a = await getDate();

                                                final DateFormat formatter =
                                                    DateFormat('yyyy-MM-dd');
                                                controller.dob.text =
                                                    formatter.format(a);
                                              },
                                              child: AbsorbPointer(
                                                child: CustomTextFormField(
                                                    controller: controller.dob,
                                                    labelText: "Date",
                                                    padding:
                                                        TextFormFieldPadding
                                                            .PaddingT14,
                                                    textInputType: TextInputType
                                                        .emailAddress,
                                                    suffix: Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 10),
                                                        child: const Icon(Icons
                                                            .calendar_month)),
                                                    suffixConstraints:
                                                        BoxConstraints(
                                                            maxHeight:
                                                                getVerticalSize(
                                                                    56))),
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
                                                  controller: controller
                                                      .from.value,
                                                  labelText: "From",
                                                  padding: TextFormFieldPadding
                                                      .PaddingT14,
                                                  validator: (value) {
                                                    return controller
                                                        .fromValidator(
                                                            value ?? "",
                                                            content?.startTime ??
                                                                "12:00 PM",
                                                            content?.endTime ??
                                                                "06:00 PM");
                                                  },
                                                  textInputType: TextInputType
                                                      .emailAddress,
                                                  suffix: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child:
                                                        const Icon(Icons.alarm),
                                                  ),
                                                  suffixConstraints:
                                                      BoxConstraints(
                                                          maxHeight:
                                                              getVerticalSize(
                                                                  56))),
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.02,
                                          ),
                                          AbsorbPointer(
                                            child: CustomTextFormField(
                                                controller: controller.to,
                                                labelText: "To",
                                                padding: TextFormFieldPadding
                                                    .PaddingT14,
                                                // validator: (value) {
                                                //   return controller
                                                //       .lastNameValidator(
                                                //           value ?? "");
                                                // },
                                                textInputType: TextInputType
                                                    .emailAddress,
                                                suffix: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child:
                                                      const Icon(Icons.alarm),
                                                ),
                                                suffixConstraints:
                                                    BoxConstraints(
                                                        maxHeight:
                                                            getVerticalSize(
                                                                56))),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.02,
                                          ),
                                        ],
                                      ),
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
                              Obx(() =>
                                  controller.pleasefillAllFields.value == false
                                      ? const SizedBox()
                                      : Column(
                                          children: [
                                            SizedBox(
                                              height: size.height * 0.04,
                                            ),
                                            Text(
                                              'Please fill all Fields',
                                              style: TextStyle(
                                                  color: Colors.red.shade600,
                                                  fontSize: 16),
                                            )
                                          ],
                                        )),
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
                                                  bool a =
                                                      controller.trySubmit();

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
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child:
                                            const Icon(Icons.calendar_month)),
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
                                    return controller.fromValidator(
                                        value ?? "",
                                        content?.startTime ?? "12:00 PM",
                                        content?.endTime ?? "06:00 PM");
                                  },
                                  textInputType: TextInputType.emailAddress,
                                  suffix: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: const Icon(Icons.alarm),
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
                                  margin: const EdgeInsets.only(right: 10),
                                  child: const Icon(Icons.alarm),
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
                            controller: controller.consultingDoctor.value,
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
                        bool a = controller.trySubmit();
                        if (a) {
                          onTapBookapointmentOne(controller.examinerId ?? 0);
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

    Widget getBody(
        Size size, BuildContext context, PatientDetailsArguments args) {
      return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: ResponsiveBuilder.isDesktop(context)
              ? null
              : AppbarImage(
                  backgroundColor: ColorConstant.whiteA70001,
                  height: 70,
                  width: width,
                  leading: IconButton(
                      onPressed: () {
                        controller.onClose();
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
                    ? mobileUi(context)
                    : webUi(context, args)),
          ),
        ),
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
    TimeOfDay _startTime = TimeOfDay(
        hour: int.parse(controller.from.value.text!.split(":")[0]),
        minute: int.parse(controller.from.value.text
            .split(":")[1]
            .replaceAll(' AM', '')
            .replaceAll(' PM', '')));
    print(_startTime);
    DateTime a = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, _startTime.hour, _startTime.minute);
    TimeOfDay b = TimeOfDay.now();
    String c = DateFormat.jm().format(DateTime.now());
    TimeOfDay _currentTime = TimeOfDay(
        hour: int.parse(c.split(":")[0]),
        minute: int.parse(
            c.split(":")[1].replaceAll(' AM', '').replaceAll(' PM', '')));
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, _currentTime.hour, _currentTime.minute);
    print(a);
    print(now);
    if (a.isAfter(now)) {
      print('yes');
      var requestData = {
        "active": true,
        "date": DateTime.parse(
                "${controller.dob.text} ${controller.from.value.text.replaceAll(" PM", "").replaceAll(" AM", "")}")
            .toIso8601String(),
        // "departmentId": controller.getdeptId(id),
        "startTime": controller.from.value.text,
        "endTime": controller.to.value.text,
        "examinerId": id,
        "note": controller.treatment.text,
        "patientId": patientDetailsArguments?.details?.id,
        "purpose": "OTHER",
        //"referenceId": 0,
        "status": "Booked",
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
    } else {
      print('no');
      Get.dialog(AlertDialog(
        title: const Text('Appointment for the selected time is passed.'),
        actions: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                  color: ColorConstant.blue700,
                  borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: Text(
                'Close',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppStyle.txtRalewayRomanRegular14WhiteA700,
              ),
            ),
          ),
        ],
      ));
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
