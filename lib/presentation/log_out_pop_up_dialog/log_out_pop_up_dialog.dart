import 'package:appointmentxpert/core/app_export.dart';
import 'package:flutter/material.dart';

import '../../core/utils/color_constant.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../routes/app_routes.dart';
import '../../shared_prefrences_page/shared_prefrence_page.dart';
import '../../theme/app_decoration.dart';
import '../../theme/app_style.dart';
import '../../widgets/custom_image_view.dart';
import 'controller/log_out_pop_up_controller.dart';

class LogOutPopUpDialog extends StatelessWidget {
  LogOutPopUpDialog(this.controller, {super.key});

  LogOutPopUpController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getHorizontalSize(
        150,
      ),
      padding: getPadding(
        left: 27,
        top: 49,
        right: 27,
        bottom: 49,
      ),
      decoration: AppDecoration.white.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            margin: getMargin(
              top: 2,
            ),
            color: ColorConstant.red50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusStyle.circleBorder51,
            ),
            child: Container(
              height: getSize(
                83,
              ),
              width: getSize(
                83,
              ),
              padding: getPadding(
                all: 12,
              ),
              decoration: AppDecoration.fillRed50.copyWith(
                borderRadius: BorderRadiusStyle.circleBorder51,
              ),
              child: Stack(
                children: [
                  CustomImageView(
                    svgPath: ImageConstant.imgMinimize,
                    height: getSize(
                      38,
                    ),
                    width: getSize(
                      38,
                    ),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: getHorizontalSize(
              146,
            ),
            margin: getMargin(
              left: 13,
              top: 52,
              right: 13,
            ),
            child: Text(
              "msg_are_you_sure_to".tr,
              maxLines: null,
              textAlign: TextAlign.center,
              style: AppStyle.txtInterBold20,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              SharedPrefUtils().clearAllData();
              Get.offAllNamed(AppRoutes.loginScreen);
            },
            // height: getVerticalSize(
            //   62,
            // ),
            child: Text("lbl_log_out".tr),
            // margin: getMargin(
            //   top: 27,
            // ),
            // variant: ButtonVariant.FillRedA200,
          ),
          Padding(
            padding: getPadding(
              top: 18,
            ),
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Text(
                "lbl_cancel".tr,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppStyle.txtInterSemiBold16Blue600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
