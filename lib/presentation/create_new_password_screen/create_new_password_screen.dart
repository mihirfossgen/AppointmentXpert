import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/color_constant.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_style.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/responsive.dart';
import '../create_new_password_success_dialog/controller/create_new_password_success_controller.dart';
import '../create_new_password_success_dialog/create_new_password_success_dialog.dart';
import 'controller/create_new_password_controller.dart';

class CreateNewPasswordScreen extends GetWidget<CreateNewPasswordController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: ColorConstant.whiteA700,
            appBar: Responsive.isDesktop(context)
                ? null
                : AppbarImage(
                    backgroundColor: ColorConstant.whiteA70001,
                    height: 70,
                    width: width,
                    imagePath: 'assets/images/login-logo.png',
                    leading: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 24, right: 24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: getPadding(top: 40),
                          child: Text("msg_create_new_pass".tr,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtRalewayRomanBold24)),
                      Padding(
                          padding: getPadding(top: 14),
                          child: Text("msg_create_your_new".tr,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtRalewayRomanRegular16)),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      CustomTextFormField(
                        labelText: "msg_enter_new_passw".tr,
                        controller: controller.inputController,
                        textInputAction: TextInputAction.done,
                        isRequired: true,
                        textInputType: TextInputType.emailAddress,
                        validator: (value) {},
                        padding: TextFormFieldPadding.PaddingT14,
                        prefixConstraints:
                            BoxConstraints(maxHeight: getVerticalSize(56)),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Obx(() => CustomTextFormField(
                          labelText: "msg_confirm_passwor".tr,
                          controller: controller.inputOneController,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.visiblePassword,
                          isRequired: true,
                          validator: (value) {},
                          padding: TextFormFieldPadding.PaddingT14,
                          prefixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56)),
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
                          isObscureText: controller.isShowPassword.value)),
                      CustomButton(
                          height: getVerticalSize(56),
                          text: "lbl_create_password".tr,
                          margin: getMargin(top: 24, bottom: 5),
                          onTap: () async {
                            bool value = await controller.callForgotPassword(
                                controller.inputController.text,
                                controller.inputOneController.text,
                                "8550978815");

                            if (value) onTapCreatepasswordOne();
                          })
                    ]))));
  }

  onTapImgArrowleft() {
    Get.back();
  }

  onTapCreatepasswordOne() {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.only(left: 0),
      content: CreateNewPasswordSuccessDialog(
        Get.put(
          CreateNewPasswordSuccessController(),
        ),
      ),
    ));
  }
}
