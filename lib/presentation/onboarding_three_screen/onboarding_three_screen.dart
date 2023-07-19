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
import 'controller/onboarding_three_controller.dart';

// ignore_for_file: must_be_immutable
class OnboardingThreeScreen extends GetWidget<OnboardingThreeController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                0.5,
                0,
              ),
              end: Alignment(
                0.5,
                1,
              ),
              colors: [
                ColorConstant.blue60001,
                ColorConstant.blue700,
              ],
            ),
          ),
          child: Container(
            height: size.height,
            width: double.maxFinite,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomImageView(
                  fit: BoxFit.contain,
                  imagePath: ImageConstant.img7xm5,
                  height: getVerticalSize(
                    465,
                  ),
                  width: getHorizontalSize(
                    321,
                  ),
                  alignment: Alignment.topCenter,
                  margin: getMargin(
                    top: 47,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: getPadding(
                      left: 12,
                      top: 33,
                      right: 12,
                      bottom: 33,
                    ),
                    decoration: AppDecoration.white.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderTL64,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: getHorizontalSize(
                            294,
                          ),
                          margin: getMargin(
                            left: 22,
                            right: 14,
                          ),
                          child: Text(
                            "msg_get_connect_our".tr,
                            maxLines: null,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtRalewayRomanBold22,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: getVerticalSize(
                              8,
                            ),
                            margin: getMargin(
                              top: 17,
                            ),
                            child: SmoothIndicator(
                              offset: 0,
                              count: 3,
                              size: Size.zero,
                              effect: ScrollingDotsEffect(
                                spacing: 4,
                                activeDotColor: ColorConstant.blue600,
                                dotColor: ColorConstant.blue100,
                                dotHeight: getVerticalSize(
                                  8,
                                ),
                                dotWidth: getHorizontalSize(
                                  8,
                                ),
                              ),
                            ),
                          ),
                        ),
                        CustomButton(
                          height: getVerticalSize(
                            56,
                          ),
                          text: "lbl_get_started".tr,
                          margin: getMargin(
                            top: 54,
                            bottom: 2,
                          ),
                          fontStyle: ButtonFontStyle.InterSemiBold16WhiteA700,
                          onTap: () {
                            Get.toNamed(AppRoutes.onboardingFourScreen);
                          },
                        ),
                      ],
                    ),
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
