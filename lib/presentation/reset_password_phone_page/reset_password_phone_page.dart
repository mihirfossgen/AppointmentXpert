import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/size_utils.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/responsive.dart';
import '../verify_number/controller/verify_number_controller.dart';
import '../verify_number/verify_number_screen.dart';
import 'controller/reset_password_phone_controller.dart';

// ignore_for_file: must_be_immutable
class ResetPasswordPhonePage extends GetWidget<ResetPasswordPhoneController> {
  ResetPasswordPhoneController controller =
      Get.put(ResetPasswordPhoneController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: SizedBox(
                width: size.width,
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      Padding(
                          padding: getPadding(left: 24, top: 24, right: 24),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomTextFormField(
                                  labelText: 'Number',
                                  controller: controller.mobileNoController,
                                  textInputAction: TextInputAction.done,
                                  isRequired: true,
                                  textInputType: TextInputType.emailAddress,
                                  validator: (value) {},
                                  padding: TextFormFieldPadding.PaddingT14,
                                  prefixConstraints: BoxConstraints(
                                      maxHeight: getVerticalSize(56)),
                                ),
                                CustomButton(
                                    height: getVerticalSize(56),
                                    text: "lbl_send_otp".tr,
                                    margin: getMargin(top: 32),
                                    onTap: () async {
                                      bool resp = await controller.callOtp(
                                          controller.mobileNoController.text,
                                          "login");
                                      if (resp) {
                                        VerifyNumberController
                                            verifyNumberController =
                                            Get.put(VerifyNumberController());

                                        Responsive.isMobile(Get.context!)
                                            ? await showModalBottomSheet<
                                                dynamic>(
                                                context: Get.context!,
                                                isDismissible: true,
                                                isScrollControlled: false,
                                                enableDrag: false,
                                                elevation: 2.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                builder: (context) {
                                                  return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: VerifyPhoneNumberScreen(
                                                        phoneNumber: controller
                                                            .mobileNoController
                                                            .text),
                                                  );
                                                },
                                              ).then((value) {
                                                print(value);
                                                if (value) onTapSendotp;
                                              })
                                            : WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                                showDialog(
                                                    context: Get.context!,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          actions: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                child: Text(
                                                                    'Close'))
                                                          ],
                                                          title: Text(
                                                              'Verify Phone Number'),
                                                          content: SizedBox(
                                                              height: 300,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3,
                                                              child: VerifyPhoneNumberScreen(
                                                                  phoneNumber:
                                                                      controller
                                                                          .mobileNoController
                                                                          .text)),
                                                        )).then((value) {
                                                  if (value) onTapSendotp();
                                                });
                                              });
                                      }
                                    })
                              ]))
                    ])))));
  }

  onTapSendotp() {
    Get.toNamed(
      AppRoutes.createNewPasswordScreen,
    );
  }
}
