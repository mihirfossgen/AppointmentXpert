import 'package:appointmentxpert/core/scaffolds/public_master_layout/public_master_layout.dart';
import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import 'controller/splash_controller.dart';

class SplashScreen extends GetWidget<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: PublicMasterLayout(
            //backgroundColor: ColorConstant.blue700,
            body: SizedBox(
                width: double.maxFinite,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: CustomImageView(
                            imagePath: 'assets/images/logo-opdxpert.png',
                            fit: BoxFit.contain,
                            //svgPath: ImageConstant.imgVector,
                            // height: getVerticalSize(130),
                            // width: getHorizontalSize(117)
                          ),
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Padding(
                      //       padding: getPadding(top: 15, bottom: 5),
                      //       child: Text("lbl_helthio".tr,
                      //           overflow: TextOverflow.ellipsis,
                      //           textAlign: TextAlign.left,
                      //           style: AppStyle.txtRalewayRomanBold50)),
                      // )
                    ]))));
  }
}
