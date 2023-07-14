import 'package:appointmentxpert/presentation/verify_number/widgets/pin_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/size_utils.dart';
import '../../widgets/custom_button.dart';
import 'controller/verify_number_controller.dart';

class VerifyPhoneNumberScreen extends GetWidget<VerifyNumberController> {
  final String? phoneNumber;

  VerifyPhoneNumberScreen({this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            padding: const EdgeInsets.all(20),
            controller: controller.scrollController,
            children: [
          Text(
            "We've sent an SMS with a verification code to ${phoneNumber}",
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
              constraints: BoxConstraints(maxWidth: 300, maxHeight: 100),
              child: PinInputField(
                  length: 4,
                  onFocusChange: (hasFocus) async {
                    if (hasFocus)
                      await controller.scrollToBottomOnKeyboardOpen();
                  },
                  onSubmit: (enteredOtp) async {
                    controller.enteredOtpp.value = enteredOtp;
                  })),
          const SizedBox(height: 10),
          CustomButton(
              height: getVerticalSize(56),
              width: getHorizontalSize(100),
              text: "Verify",
              shape: ButtonShape.RoundedBorder8,
              padding: ButtonPadding.PaddingAll16,
              fontStyle: ButtonFontStyle.RalewayRomanSemiBold14WhiteA700,
              onTap: () async {
                try {
                  await controller.verifyOtp(
                      controller.enteredOtpp.value, phoneNumber ?? "");

                  // Get.back(result: true);
                } on Map {
                  //  _onOnTapSignInError();
                } on NoInternetException catch (e) {
                  Get.rawSnackbar(message: e.toString());
                } catch (e) {
                  Get.rawSnackbar(message: e.toString());
                }
              })
        ]));
  }
}
