import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/color_constant.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_decoration.dart';
import '../../theme/app_style.dart';
import '../../widgets/custom_image_view.dart';
import 'controller/booking_doctor_success_controller.dart';

// ignore_for_file: must_be_immutable
class BookingDoctorSuccessDialog extends StatelessWidget {
  BookingDoctorSuccessDialog(this.controller, {super.key});

  BookingDoctorSuccessController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: getHorizontalSize(250),
        padding: getPadding(left: 25, top: 49, right: 25, bottom: 49),
        decoration: AppDecoration.white
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder24),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0,
                  color: ColorConstant.gray50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusStyle.circleBorder51),
                  child: Container(
                      height: getSize(102),
                      width: getSize(102),
                      decoration: AppDecoration.fillGray50.copyWith(
                          borderRadius: BorderRadiusStyle.circleBorder51),
                      child: Stack(children: [
                        CustomImageView(
                            svgPath: ImageConstant.imgCheckmark31x41,
                            height: getVerticalSize(31),
                            width: getHorizontalSize(41),
                            radius: BorderRadius.circular(getHorizontalSize(3)),
                            alignment: Alignment.center)
                      ]))),
              const SizedBox(
                height: 10,
              ),
              Text('Appointment booked',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtRalewayRomanBold20),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  child: Text('See all appointments to know status.',
                      maxLines: null,
                      textAlign: TextAlign.center,
                      style: AppStyle.txtRalewayRomanRegular16)),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    onTapGoBack();
                  },
                  child: const Text('Go Back'))
              // CustomButton(
              //     height: getVerticalSize(56),
              //     text: 'Go Back',
              //     onTap: () {
              //       onTapGoBack();
              //     })
            ]));
  }

  onTapGoBack() {
    Get.offAllNamed(AppRoutes.dashboardScreen);
  }
}
