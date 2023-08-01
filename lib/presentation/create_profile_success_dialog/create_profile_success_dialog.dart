import 'package:appointmentxpert/core/app_export.dart';
import 'package:flutter/material.dart';

import '../../core/utils/color_constant.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_decoration.dart';
import '../../theme/app_style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';
import 'controller/create_profile_success_controller.dart';

// ignore_for_file: must_be_immutable
class CreateProfileSuccessDialog extends StatelessWidget {
  CreateProfileSuccessDialog(this.controller, {super.key});

  CreateProfileSuccessContoller controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: getHorizontalSize(327),
        padding: getPadding(left: 24, top: 36, right: 24, bottom: 36),
        decoration: AppDecoration.white
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder24),
        child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 0,
                    margin: getMargin(top: 26),
                    color: ColorConstant.gray50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusStyle.circleBorder51),
                    child: Container(
                        height: getSize(102),
                        width: getSize(102),
                        padding: getPadding(
                            left: 29, top: 34, right: 29, bottom: 34),
                        decoration: AppDecoration.fillGray50.copyWith(
                            borderRadius: BorderRadiusStyle.circleBorder51),
                        child: Stack(children: [
                          CustomImageView(
                              svgPath: ImageConstant.imgCheckmark31x41,
                              height: getVerticalSize(31),
                              width: getHorizontalSize(41),
                              radius:
                                  BorderRadius.circular(getHorizontalSize(3)),
                              alignment: Alignment.center)
                        ]))),
                Padding(
                    padding: getPadding(top: 42),
                    child: Text("Profile Created SuccessFully",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtRalewayRomanBold20)),
                CustomButton(
                    height: getVerticalSize(62),
                    text: "lbl_go_to_home".tr,
                    margin: getMargin(top: 22),
                    onTap: () {
                      onTapGotohome();
                    })
              ]),
        ));
  }

  onTapGotohome() {
    Get.offAllNamed(AppRoutes.dashboardScreen);
    // Get.offNamed(AppRoutes.homeContainerScreen, arguments: {
    //   // NavigationArgs.id: controller.postLoginResp.data!.id!,
    //   // NavigationArgs.token: controller.postLoginResp.data!.token!
    // });
  }
}
