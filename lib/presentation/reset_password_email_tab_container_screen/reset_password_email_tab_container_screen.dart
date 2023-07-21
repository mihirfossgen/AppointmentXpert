import 'package:adaptive_layout/adaptive_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_style.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/responsive.dart';
import '../reset_password_email_page/reset_password_email_page.dart';
import '../reset_password_phone_page/reset_password_phone_page.dart';
import 'controller/reset_password_email_tab_container_controller.dart';

class ResetPasswordEmailTabContainerScreen
    extends GetWidget<ResetPasswordEmailTabContainerController> {
  const ResetPasswordEmailTabContainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
            body: AdaptiveLayout(
              smallLayout: getBody(width),
              mediumLayout: getBody(width),
              largeLayout: Center(child: getBody(width / 2)),
            )));
  }

  Widget getBody(double width) {
    return SizedBox(
        width: width,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: getPadding(left: 24, top: 43),
                  child: Text("msg_forgot_your_pas".tr,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtRalewayRomanBold24))),
          Container(
              width: getHorizontalSize(319),
              margin: getMargin(left: 24, top: 10, right: 32),
              child: Text("msg_enter_your_emai2".tr,
                  maxLines: null,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtRalewayRomanMedium16Bluegray300)),
          Container(
              height: getVerticalSize(51),
              width: getHorizontalSize(327),
              margin: getMargin(top: 23),
              decoration: BoxDecoration(
                  color: ColorConstant.gray100,
                  borderRadius: BorderRadius.circular(getHorizontalSize(12))),
              child: TabBar(
                  controller: controller.tabController,
                  labelColor: ColorConstant.blue600,
                  labelStyle: TextStyle(
                      fontSize: getFontSize(14),
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600),
                  unselectedLabelColor: ColorConstant.blueGray400,
                  unselectedLabelStyle: TextStyle(
                      fontSize: getFontSize(14),
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500),
                  indicatorPadding: getPadding(all: 4.0),
                  indicator: BoxDecoration(
                      color: ColorConstant.whiteA700,
                      borderRadius: BorderRadius.circular(getHorizontalSize(8)),
                      boxShadow: [
                        BoxShadow(
                            color: ColorConstant.black9000c,
                            spreadRadius: getHorizontalSize(2),
                            blurRadius: getHorizontalSize(2),
                            offset: const Offset(0, 0))
                      ]),
                  tabs: [
                    Tab(
                        child: Text("lbl_email".tr,
                            overflow: TextOverflow.ellipsis)),
                    Tab(
                        child: Text("lbl_phone".tr,
                            overflow: TextOverflow.ellipsis))
                  ])),
          SizedBox(
              height: 280,// getVerticalSize(525),
              child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    ResetPasswordEmailPage(),
                    ResetPasswordPhonePage()
                  ]))
        ]));
  }

  onTapImgArrowleft() {
    Get.back();
  }
}
