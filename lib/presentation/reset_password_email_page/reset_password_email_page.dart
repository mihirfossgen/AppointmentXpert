import 'package:get/get.dart';

import '../../core/utils/size_utils.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'controller/reset_password_email_controller.dart';
import 'models/reset_password_email_model.dart';
import 'package:flutter/material.dart';

class ResetPasswordEmailPage extends StatelessWidget {
  ResetPasswordEmailController controller =
      Get.put(ResetPasswordEmailController(ResetPasswordEmailModel().obs));

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
                  padding: getPadding(
                    left: 24,
                    top: 24,
                    right: 24,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        labelText: 'Email',
                        controller: controller.emailController,
                        textInputAction: TextInputAction.done,
                        isRequired: true,
                        textInputType: TextInputType.emailAddress,
                        validator: (value) {},
                        padding: TextFormFieldPadding.PaddingT14,
                        prefixConstraints:
                            BoxConstraints(maxHeight: getVerticalSize(56)),
                      ),
                      CustomButton(
                        height: getVerticalSize(
                          56,
                        ),
                        text: "lbl_send_otp".tr,
                        margin: getMargin(
                          top: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
