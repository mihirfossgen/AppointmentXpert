import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/utils/color_constant.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_decoration.dart';
import '../../theme/app_style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';
import 'controller/onboarding_two_controller.dart';

class OnboardingTwoScreen extends GetWidget<OnboardingTwoController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: SingleChildScrollView(
              child: Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment(0.5, 0),
                          end: Alignment(0.5, 1),
                          colors: [
                        ColorConstant.blue60001,
                        ColorConstant.blue700
                      ])),
                  child: Container(
                      height: size.height,
                      width: double.maxFinite,
                      child:
                          Stack(alignment: Alignment.bottomCenter, children: [
                        CustomImageView(
                            fit: BoxFit.contain,
                            imagePath: ImageConstant.img7xm2,
                            height: getVerticalSize(467),
                            width: getHorizontalSize(317),
                            alignment: Alignment.topCenter,
                            margin: getMargin(top: 52)),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                padding: getPadding(
                                    left: 12, top: 33, right: 12, bottom: 33),
                                decoration: AppDecoration.white.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.customBorderTL64),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: getHorizontalSize(280),
                                          margin: getMargin(
                                              left: 22, right: 18, top: 20),
                                          child: Text("msg_find_a_lot_of_s".tr,
                                              maxLines: null,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtRalewayRomanBold22)),
                                      Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                              height: getVerticalSize(8),
                                              margin: getMargin(top: 23),
                                              child: SmoothIndicator(
                                                  offset: 0,
                                                  count: 3,
                                                  size: Size.zero,
                                                  effect: ScrollingDotsEffect(
                                                      spacing: 4,
                                                      activeDotColor:
                                                          ColorConstant.blue600,
                                                      dotColor:
                                                          ColorConstant.blue100,
                                                      dotHeight:
                                                          getVerticalSize(8),
                                                      dotWidth:
                                                          getHorizontalSize(
                                                              8))))),
                                      Padding(
                                          padding:
                                              getPadding(top: 54, bottom: 2),
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      onTapTxtSkip();
                                                    },
                                                    child: Padding(
                                                        padding: getPadding(
                                                            top: 20,
                                                            bottom: 18),
                                                        child: Text(
                                                            "lbl_skip".tr,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtInterRegular14))),
                                                CustomButton(
                                                    height: getVerticalSize(60),
                                                    width:
                                                        getHorizontalSize(85),
                                                    text: "lbl_next".tr,
                                                    fontStyle: ButtonFontStyle
                                                        .InterSemiBold16WhiteA700,
                                                    onTap: () {
                                                      onTapNext();
                                                    })
                                              ]))
                                    ])))
                      ]))),
            )));
  }

  onTapTxtSkip() {
    Get.toNamed(
      AppRoutes.onboardingFourScreen,
    );
  }

  onTapNext() {
    Get.toNamed(
      AppRoutes.onboardingThreeScreen,
    );
  }
}
