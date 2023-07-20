import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../core/app_export.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../domain/facebookauth/facebook_auth_helper.dart';
import '../../domain/googleauth/google_auth_helper.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_decoration.dart';
import '../../theme/app_style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_checkbox.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/responsive.dart';
import '../login_success_dialog/controller/login_success_controller.dart';
import '../login_success_dialog/login_success_dialog.dart';
import '../verify_number/controller/verify_number_controller.dart';
import '../verify_number/verify_number_screen.dart';
import 'controller/login_controller.dart';

class LoginScreen extends GetWidget<LoginController> {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        top: false,
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: ColorConstant.whiteA700,
              // appBar: CustomAppBar(
              //     //backgroundColor: ColorConstant.blue700,
              //     height: getVerticalSize(60),
              //     leadingWidth: 64,
              //     elevation: 0,
              //     leading: AppbarImage(
              //         height: getSize(40),
              //         width: getSize(40),
              //         backgroundColor: Colors.transparent,
              //         svgPath: ImageConstant.imgArrowleft,
              //         margin: getMargin(left: 24),
              //         onTap: () {
              //           onTapArrowleft();
              //         }),
              //     centerTitle: true,
              //     title: AppbarSubtitle2(text: '')),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  if (Responsive.isDesktop(context)) {
                    return _buildLargeScreen(size, controller);
                  } else {
                    return _buildSmallScreen(size, controller);
                  }
                },
              )),
        ));
  }

  /// For large screens
  Widget _buildLargeScreen(
    Size size,
    LoginController loginController,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Image.asset(
              'assets/images/bannerbg.png',
              fit: BoxFit.fill,
              // height: size.height * 0.2,
              // width: size.width / 2,
            ),
          ),
          SizedBox(width: size.width * 0.06),
          Expanded(
            flex: 5,
            child: _buildMainBody(
              size,
              loginController,
            ),
          ),
        ],
      ),
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
    Size size,
    LoginController loginController,
  ) {
    return Center(
      child: _buildMainBody(
        size,
        loginController,
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
    Size size,
    LoginController simpleUIController,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              !Responsive.isDesktop(Get.context!)
                  ? 'assets' '/images/logo-opdxpert.png'
                  : '/images/logo-opdxpert.png',
              fit: BoxFit.contain,
              height: size.height * 0.2,
              width: size.width * 0.8,
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  /// username or Gmail
                  CustomTextFormField(
                    labelText: 'Mobile Number',
                    controller: controller.emailController,
                    textInputAction: TextInputAction.done,
                    isRequired: true,
                    textInputType: TextInputType.number,
                    validator: (value) {
                      return controller.numberValidator(value ?? "");
                    },
                    padding: TextFormFieldPadding.PaddingT14,
                    prefixConstraints:
                        BoxConstraints(maxHeight: getVerticalSize(56)),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Obx(() => CustomCheckbox(
                        text: "Remember me",
                        fontStyle:
                            CheckboxFontStyle.SFProDisplayRegular14Bluegray800,
                        value: controller.isRememberMe.value,
                        onChange: (p0) {
                          controller.isRememberMe.value = p0;
                        },
                      )),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                          onTap: () {
                            onTapTxtForgotPassword();
                          },
                          child: Padding(
                              padding: getPadding(top: 10),
                              child: Text("msg_forgot_password".tr,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtRalewayRomanMedium14)))),
                  SizedBox(
                    height: size.height * 0.02,
                  ),

                  /// Login Button
                  loginButton(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: getPadding(bottom: 1),
                            child: Text("msg_don_t_have_an_a2".tr,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtRalewayRomanRegular15
                                    .copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.5)))),
                        GestureDetector(
                            onTap: () {
                              onTapTxtSignUp();
                            },
                            child: Padding(
                                padding: getPadding(left: 4, top: 1),
                                child: Text("lbl_sign_up".tr,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtInterRegular14Gray700)))
                      ]),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Padding(
                      padding: getPadding(top: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: getPadding(top: 8, bottom: 9),
                                child: SizedBox(
                                    width: getHorizontalSize(30),
                                    child: Divider(
                                        height: getVerticalSize(1),
                                        thickness: getVerticalSize(1),
                                        color: ColorConstant.gray200))),
                            Text("lbl_or".tr,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtRalewayRomanRegular16),
                            Padding(
                                padding: getPadding(top: 8, bottom: 9),
                                child: SizedBox(
                                    width: getHorizontalSize(30),
                                    child: Divider(
                                        height: getVerticalSize(1),
                                        thickness: getVerticalSize(1),
                                        color: ColorConstant.gray200)))
                          ])),
                  GestureDetector(
                      onTap: () {
                        onTapRowgoogle();
                      },
                      child: Center(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: getMargin(
                                    top: 20,
                                  ),
                                  padding: getPadding(
                                      left: 16, top: 16, right: 16, bottom: 16),
                                  decoration: AppDecoration.outlineGray200
                                      .copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.roundedBorder8),
                                  child: CustomImageView(
                                      svgPath: ImageConstant.imgGoogle,
                                      height: getVerticalSize(20),
                                      width: getHorizontalSize(19),
                                      margin: getMargin(top: 1, bottom: 1))),
                              // Container(
                              //     margin: getMargin(top: 20, left: 5),
                              //     padding: getPadding(
                              //         left: 16, top: 16, right: 16, bottom: 16),
                              //     decoration: AppDecoration.outlineGray200
                              //         .copyWith(
                              //             borderRadius:
                              //                 BorderRadiusStyle.roundedBorder8),
                              //     child: CustomImageView(
                              //         svgPath: ImageConstant.imgCamera,
                              //         height: getVerticalSize(20),
                              //         width: getHorizontalSize(16),
                              //         margin: getMargin(top: 1, bottom: 1),
                              //         onTap: () {
                              //           onTapImgCamera();
                              //         })),
                              Container(
                                  margin: getMargin(top: 20, left: 5),
                                  padding: getPadding(
                                      left: 16, top: 16, right: 16, bottom: 16),
                                  decoration: AppDecoration.outlineGray200
                                      .copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.roundedBorder8),
                                  child: CustomImageView(
                                      svgPath: ImageConstant.imgFacebook,
                                      height: getVerticalSize(20),
                                      color: Colors.blue,
                                      width: getHorizontalSize(16),
                                      margin: getMargin(top: 1, bottom: 1),
                                      onTap: () {
                                        //onTapImgCamera();
                                      })),
                            ]),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: SignInWithAppleButton(
                        onPressed: () async {
                          final credential =
                              await SignInWithApple.getAppleIDCredential(
                            scopes: [
                              AppleIDAuthorizationScopes.email,
                              AppleIDAuthorizationScopes.fullName,
                            ],
                          );

                          print(credential);

                          // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                          // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Login Button
  Widget loginButton() {
    return CustomButton(
        height: getVerticalSize(65),
        text: "lbl_login".tr,
        margin: getMargin(top: 12, bottom: 10),
        onTap: () async {
          if (controller.trySubmit()) {
            bool resp = await controller.callOtp(
                controller.emailController.text, "login");
            if (resp) {
              VerifyNumberController verifyNumberController =
                  Get.put(VerifyNumberController());

              Responsive.isMobile(Get.context!)
                  ? await showModalBottomSheet<dynamic>(
                      context: Get.context!,
                      isDismissible: true,
                      isScrollControlled: false,
                      enableDrag: false,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      builder: (context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: VerifyPhoneNumberScreen(
                              phoneNumber: controller.emailController.text),
                        );
                      },
                    ).then((value) {
                      print(value);
                      if (value) onTapSignin(controller);
                    })
                  : WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                          context: Get.context!,
                          builder: (context) => AlertDialog(
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('Close'))
                                ],
                                title: const Text('Verify Phone Number'),
                                content: SizedBox(
                                    height: 300,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: VerifyPhoneNumberScreen(
                                        phoneNumber:
                                            controller.emailController.text)),
                              )).then((value) {
                        bool value = controller.trySubmit();
                        if (value) onTapSignin(controller);
                      });
                    });
            }
          }
        });
  }
}

onTapTxtForgotPassword() {
  Get.toNamed(
    AppRoutes.resetPasswordEmailTabContainerScreen,
  );
}

Future<void> onTapSignin(LoginController controller) async {
  Map<String, dynamic> requestData = {
    'userName': controller.emailController.text,
    'password': "qwerty"
  };
  try {
    await controller.callCreateLogin(requestData);
    // onTapLoginOne();
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
    msg: "Invalid username or password!",
  );
}

onTapLoginOne() {
  Get.dialog(AlertDialog(
    backgroundColor: Colors.transparent,
    contentPadding: EdgeInsets.zero,
    insetPadding: const EdgeInsets.only(left: 0),
    content: LoginSuccessDialog(
      Get.put(
        LoginSuccessController(),
      ),
    ),
  ));
}

onTapTxtSignUp() {
  Get.toNamed(
    AppRoutes.signUpScreen,
  );
}

onTapRowgoogle() async {
  await GoogleAuthHelper().googleSignInProcess().then((googleUser) {
    if (googleUser != null) {
      //TODO Actions to be performed after signin
    } else {
      Get.snackbar('Error', 'user data is empty');
    }
  }).catchError((onError) {
    Get.snackbar('Error', onError.toString());
  });
}

onTapImgCamera() async {
  // await PermissionManager.askForPermission(Permission.camera);
  // await PermissionManager.askForPermission(Permission.storage);
  // List<String?>? imageList = [];
  // await FileManager().showModelSheetForImage(getImages: (value) async {
  //   imageList = value;
  // });
}

onTapRowfacebook() async {
  await FacebookAuthHelper().facebookSignInProcess().then((facebookUser) {
    //TODO Actions to be performed after signin
  }).catchError((onError) {
    Get.snackbar('Error', onError.toString());
  });
}

onTapArrowleft() {
  Get.back();
}
