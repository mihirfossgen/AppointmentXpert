import 'package:appointmentxpert/presentation/verify_number/widgets/pin_input_field.dart';
import 'package:appointmentxpert/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/errors/exceptions.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../widgets/app_bar/appbar_subtitle_2.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/responsive.dart';
import 'controller/verify_number_controller.dart';

class VerifyPhoneNumberScreen extends GetWidget<VerifyNumberController> {
  final String? phoneNumber;

  const VerifyPhoneNumberScreen({super.key, this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.enteredOtpp.value = '';
        controller.isSendingCode.value = false;
        controller.showResendText.value = false;
        Get.back();
        return true;
      },
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
                            controller.enteredOtpp.value = '';
                            controller.isSendingCode.value = false;
                            controller.showResendText.value = false;
                            Get.back();
                          },
                          child: const Icon(
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
                  title: AppbarSubtitle2(text: 'Verify'))
              : null,
          key: VerifyNumberController.scaffoldMessengerKey,
          body: ListView(
              padding: const EdgeInsets.all(20),
              controller: controller.scrollController,
              children: [
                Text(
                  "We've sent an SMS with a verification code to $phoneNumber",
                  style: const TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 10),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Enter OTP',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Obx(() => controller.showResendText.value
                        ? InkWell(
                            child: const Text(
                              'Resend OTP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              controller.callOtp(phoneNumber ?? "", "reSent");
                            },
                          )
                        : Container())
                  ],
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 300, maxHeight: 100),
                    child: PinInputField(
                        length: 4,
                        onFocusChange: (hasFocus) async {
                          if (hasFocus) {
                            await controller.scrollToBottomOnKeyboardOpen();
                          }
                        },
                        onChanged: (value) {
                          controller.enteredOtpp.value = value;
                          controller.otpValue = value;
                        },
                        onSubmit: (enteredOtp) async {
                          controller.enteredOtpp.value = enteredOtp;
                          controller.otpValue = enteredOtp;
                        })),
                const SizedBox(height: 10),
                Obx(() => controller.enteredOtpp.value.length < 4
                    ? CustomButton(
                        height: getVerticalSize(60),
                        text: "Verify",
                        variant: ButtonVariant.FillGrey,
                        fontStyle:
                            ButtonFontStyle.RalewayRomanSemiBold14WhiteA700,
                      )
                    : controller.isloading.value
                        ? SizedBox(height: 50, child: ThreeDotLoader())
                        : SizedBox(
                            height: 60,
                            child: ElevatedButton(
                                // fontStyle:
                                //     ButtonFontStyle.RalewayRomanSemiBold14WhiteA700,
                                onPressed: () async {
                                  try {
                                    controller.isloading.value = true;
                                    await controller.verifyOtp(
                                        controller.enteredOtpp.value,
                                        phoneNumber ?? "");
                                  } on Map {
                                    //  _onOnTapSignInError();
                                  } on NoInternetException catch (e) {
                                    controller.isloading.value = false;
                                    Get.rawSnackbar(message: e.toString());
                                  } catch (e) {
                                    controller.isloading.value = false;
                                    Get.rawSnackbar(message: e.toString());
                                  }
                                },
                                child: const Text('Verify')),
                          ))
              ])),
    );
  }
}
