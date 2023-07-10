import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../core/constants/constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_style.dart';
import '../../widgets/app_bar/appbar_subtitle_2.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_checkbox.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/responsive.dart';
import '../dashboard_screen/shared_components/responsive_builder.dart';
import '../sign_up_success_dialog/controller/sign_up_success_controller.dart';
import '../sign_up_success_dialog/sign_up_success_dialog.dart';
import 'controller/sign_up_controller.dart';

class SignUpScreen extends GetWidget<SignUpController> {
  List<Map> types = [
    {"id": 5, "name": "Admin"},
    {"id": 6, "name": "Reception"},
    {"id": 7, "name": "Finance"},
    {"id": 8, "name": "Patient"},
    {"id": 9, "name": "Examiner"},
    {"id": 10, "name": "Nurse"}
  ];

  getStringValue(String text) {
    switch (text.toLowerCase()) {
      case "admin":
        return "ADMIN";
      case "reception":
        return "RECEPTION";
      case "finance":
        return "FINANCE";
      case "nurse":
        return "NURSE";
      case "examiner":
        return "EXAMINER";
      case "patient":
        return "PATIENT";
      default:
        return "";
    }
  }

  // Widget _title(String value) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
  //     child: Row(
  //       children: [
  //         Text(
  //           value,
  //           style: const TextStyle(color: Colors.grey, fontSize: 16),
  //         ),
  //         Text(
  //           "*",
  //           style: TextStyle(color: Colors.red),
  //         )
  //       ],
  //     ),
  //   );
  // }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return SafeArea(
        top: false,
        bottom: false,
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: ColorConstant.whiteA700,
                appBar: !Responsive.isDesktop(context)
                    ? CustomAppBar(
                        height: getVerticalSize(40),
                        leadingWidth: 64,
                        elevation: 0,
                        backgroundColor: ColorConstant.blue700,
                        leading: !Responsive.isDesktop(context)
                            ? InkWell(
                                onTap: () {
                                  onTapArrowleft1();
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                              )
                            // AppbarImage(
                            //     height: getSize(40),
                            //     width: getSize(40),
                            //     backgroundColor: Colors.white,
                            //     svgPath: ImageConstant.imgArrowleft,
                            //     margin: getMargin(left: 24),
                            //     onTap: () {
                            //       onTapArrowleft1();
                            //     })
                            : null,
                        centerTitle: true,
                        title: AppbarSubtitle2(
                            text: !Responsive.isDesktop(context)
                                ? "lbl_sign_up".tr
                                : ''))
                    : null,
                body: ResponsiveBuilder(
                  mobileBuilder: (context, constraints) {
                    return _buildSmallScreen(size, controller, theme);
                  },
                  desktopBuilder: (context, constraints) {
                    return _buildLargeScreen(size, controller, theme);
                  },
                  tabletBuilder: (context, constraints) {
                    return _buildSmallScreen(size, controller, theme);
                  },
                ))));
  }

  /// For large screens
  Widget _buildLargeScreen(
      Size size, SignUpController signUpController, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: RotatedBox(
            quarterTurns: 0,
            child: Image.asset(
              !Responsive.isDesktop(Get.context!)
                  ? 'assets' + '/images/bannerbg.png'
                  : '/images/bannerbg.png',
              fit: BoxFit.contain,
              // height: size.height * 0.2,
              // width: size.width * 0.8,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.04),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, signUpController, theme),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
      Size size, SignUpController simpleUIController, ThemeData theme) {
    return SingleChildScrollView(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  /// Main Body
  Widget _buildMainBody(
      Size size, SignUpController signUpController, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: size.width < 600
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          size.width < 600
              ? Container()
              : Center(
                  child: Image.asset(
                    !Responsive.isDesktop(Get.context!)
                        ? 'assets' + '/images/logo-opdxpert.png'
                        : '/images/logo-opdxpert.png',
                    fit: BoxFit.contain,
                    width: 300,
                    height: 160,
                    // height: size.height * 0.2,
                    // width: size.width * 0.8,
                  ),
                ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Sign Up',
              style: kLoginTitleStyle(size),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Create Account',
              style: kLoginSubtitleStyle(size),
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// username
                  CustomTextFormField(
                      labelText: "lbl_enter_your_name".tr,
                      controller: controller.enternameController,
                      padding: TextFormFieldPadding.PaddingT14,
                      isRequired: true,
                      validator: (value) {
                        return controller.userNameValidator(value ?? "");
                      },
                      prefixConstraints:
                          BoxConstraints(maxHeight: getVerticalSize(56))),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  CustomTextFormField(
                      labelText: "msg_enter_your_emai".tr,
                      controller: controller.enteremailController,
                      isRequired: true,
                      //padding: TextFormFieldPadding.PaddingT16_2,
                      padding: TextFormFieldPadding.PaddingT14,
                      validator: (value) {
                        return controller.emailValidator(value ?? "");
                      },
                      textInputType: TextInputType.emailAddress,
                      prefixConstraints:
                          BoxConstraints(maxHeight: getVerticalSize(56))),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  CustomTextFormField(
                      labelText: "Enter your number",
                      controller: controller.enternumberController,
                      isRequired: true,
                      validator: (value) {
                        return controller.numberValidator(value ?? "");
                      },
                      //padding: TextFormFieldPadding.PaddingT16_2,
                      padding: TextFormFieldPadding.PaddingT14,
                      textInputType: TextInputType.number,
                      prefixConstraints:
                          BoxConstraints(maxHeight: getVerticalSize(56))),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Obx(() => CustomTextFormField(
                      labelText: "msg_enter_your_pass".tr,
                      alignment: Alignment.centerLeft,
                      controller: controller.enterpasswordController,
                      isRequired: true,
                      textInputAction: TextInputAction.done,
                      padding: TextFormFieldPadding.PaddingT14,
                      textInputType: TextInputType.visiblePassword,
                      validator: (value) {
                        return controller.passwordValidator(value ?? "");
                      },
                      prefixConstraints:
                          BoxConstraints(maxHeight: getVerticalSize(56)),
                      suffix: InkWell(
                          onTap: () {
                            controller.isShowPassword.value =
                                !controller.isShowPassword.value;
                          },
                          child: Container(
                              width: 30,
                              margin: getMargin(
                                  left: 15, top: 16, right: 12, bottom: 16),
                              child: CustomImageView(
                                  svgPath: controller.isShowPassword.value
                                      ? ImageConstant.imgCheckmark24x24
                                      : ImageConstant.imgCheckmark24x24))),
                      suffixConstraints:
                          BoxConstraints(maxHeight: getVerticalSize(56)),
                      isObscureText: controller.isShowPassword.value)),
                  Obx(() => SizedBox(
                        height: 80,
                        child: CustomCheckbox(
                            text: "msg_i_agree_to_the2".tr,
                            iconSize: getHorizontalSize(52),
                            width: width,
                            value: controller.isCheckbox.value,
                            margin: getMargin(
                              top: 16,
                            ),
                            fontStyle: CheckboxFontStyle
                                .SFProDisplayRegular14Bluegray800,
                            onChange: (value) {
                              controller.isCheckbox.value = value;
                            }),
                      )),
                  SizedBox(
                    height: size.height * 0.03,
                  ),

                  /// SignUp Button
                  signUpButton(theme),
                  SizedBox(
                    height: size.height * 0.03,
                  ),

                  /// Navigate To Login Screen
                  // GestureDetector(
                  //   onTap: () {
                  //     // Navigator.push(
                  //     //     context,
                  //     //     CupertinoPageRoute(
                  //     //         builder: (ctx) => const LoginView()));
                  //     controller.enteremailController.clear();
                  //     controller.enternameController.clear();
                  //     controller.enternumberController.clear();
                  //     controller.enterpasswordController.clear();
                  //     _formKey.currentState?.reset();

                  //     signUpController.isShowPassword.value = true;
                  //   },
                  //   child: RichText(
                  //     text: TextSpan(
                  //       text: 'Already have an account?',
                  //       style: kHaveAnAccountStyle(size),
                  //       children: [
                  //         TextSpan(
                  //             text: " Login",
                  //             style: kLoginOrSignUpTextStyle(size)),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SignUp Button
  Widget signUpButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(ColorConstant.blue700),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () async {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            // ... Navigate To your Home Page

            onTapSignup();
          }
        },
        child: Text(
          'Sign up',
          style: AppStyle.txtRalewayRomanSemiBold18,
        ),
      ),
    );
  }

  Future<void> onTapSignup() async {
    Map<String, dynamic> requestData = {
      "email": controller.enteremailController.text,
      "mobile": controller.enternumberController.text,
      "password": controller.enterpasswordController.text,
      "role": "PATIENT",
      "username": controller.enteremailController.text
    };
    print(jsonEncode(requestData));
    try {
      await controller.callRegister(requestData);
      onTapSignupOne();
    } on Map {
      _onOnTapSignInError();
    } on NoInternetException catch (e) {
      Get.rawSnackbar(message: e.toString());
    } catch (e) {
      Get.rawSnackbar(message: e.toString());
    }
  }

  void _onOnTapSignInError() {
    Fluttertoast.showToast(
      msg: "Facing technicl Difficulties",
    );
  }

  onTapSignupOne() {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.only(left: 0),
      content: SignUpSuccessDialog(
        Get.put(
          SignUpSuccessController(),
        ),
      ),
    ));
  }

  onTapTxtLogIn() {
    // Get.toNamed(
    //   AppRoutes.loginScreen,
    // );
    onTapArrowleft1();
  }

  onTapArrowleft1() {
    Get.back();
  }
}
