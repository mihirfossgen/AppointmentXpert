import 'package:adaptive_layout/adaptive_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/color_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';
import 'controller/onboarding_four_controller.dart';

class OnboardingFourScreen extends GetWidget<OnboardingFourController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            body: AdaptiveLayout(
              smallLayout: getBody(width),
              mediumLayout: getBody(width),
              largeLayout: Center(child: getBody(width / 2)),
            )));
  }

  Widget getBody(double width) {
    return Container(
        width: width,
        padding: getPadding(left: 24, top: 16, right: 24, bottom: 16),
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          CustomImageView(
              imagePath: 'assets/images/logo-opdxpert.png',
              //svgPath: ImageConstant.imgVideocamera,
              // height: getVerticalSize(80),
              // width: getHorizontalSize(80),
              margin: getMargin(top: 163)),
          // Padding(
          //     padding: getPadding(top: 5),
          //     child: Text("lbl_helthio".tr,
          //         overflow: TextOverflow.ellipsis,
          //         textAlign: TextAlign.left,
          //         style: AppStyle.txtRalewayRomanBold25)),
          Padding(
              padding: getPadding(top: 40),
              child: Text("msg_let_s_get_start".tr,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtRalewayRomanBold22)),
          Container(
              width: getHorizontalSize(260),
              margin: getMargin(left: 33, top: 9, right: 32),
              child: Text("msg_login_to_enjoy".tr,
                  maxLines: null,
                  textAlign: TextAlign.center,
                  style: AppStyle.txtRalewayRomanMedium16
                      .copyWith(letterSpacing: getHorizontalSize(0.5)))),
          Spacer(),
          CustomButton(
              height: getVerticalSize(65),
              margin: getMargin(left: 24, right: 23, bottom: 15),
              text: "lbl_login".tr,
              onTap: () {
                onTapLogin();
              }),
          //Spacer(),
          CustomButton(
              height: getVerticalSize(65),
              text: "lbl_sign_up".tr,
              margin: getMargin(left: 24, right: 23, bottom: 80),
              variant: ButtonVariant.OutlineBlue600_1,
              fontStyle: ButtonFontStyle.RalewayRomanSemiBold16Blue600_1,
              onTap: () {
                onTapSignup();
              }),
          SizedBox(
            height: 30,
          )
        ]));
  }

  onTapLogin() {
    Get.toNamed(
      AppRoutes.loginScreen,
    );
  }

  onTapSignup() {
    Get.toNamed(
      AppRoutes.signUpScreen,
    );
  }
}
