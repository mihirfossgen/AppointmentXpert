import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/utils/color_constant.dart';
import '../core/utils/image_constant.dart';
import '../core/utils/size_utils.dart';
import 'custom_image_view.dart';

class CustomBottomBar extends StatelessWidget {
  CustomBottomBar(
      {super.key, this.onChangedStaffMenu, this.onChangedPatientMenu, required this.user});

  String user;
  Function(StaffBottomBarEnum)? onChangedStaffMenu;
  Function(PatientBottomBarEnum)? onChangedPatientMenu;

  RxInt selectedIndex = 0.obs;

  List<PatientBottomMenuModel> patientBottomMenuList = [
    PatientBottomMenuModel(
      icon: ImageConstant.imgHome,
      type: PatientBottomBarEnum.Home,
    ),
    PatientBottomMenuModel(
      icon: ImageConstant.imgBookmark,
      type: PatientBottomBarEnum.Appointments,
    ),
    PatientBottomMenuModel(
      icon: ImageConstant.imgCall,
      type: PatientBottomBarEnum.Chat,
    ),
    PatientBottomMenuModel(
      icon: ImageConstant.imgUser,
      type: PatientBottomBarEnum.Profile,
    ),
    // PatientBottomMenuModel(
    //   icon: ImageConstant.imgSettings,
    //   type: PatientBottomBarEnum.Setting,
    // )
  ];

  List<StaffBottomMenuModel> staffBottomMenuList = [
    StaffBottomMenuModel(
      icon: ImageConstant.imgHome,
      type: StaffBottomBarEnum.Home,
    ),
    StaffBottomMenuModel(
      icon: ImageConstant.imgBookmark,
      type: StaffBottomBarEnum.Appointments,
    ),
    StaffBottomMenuModel(
      icon: ImageConstant.imgUser1,
      type: StaffBottomBarEnum.Patients,
    ),
    StaffBottomMenuModel(
      icon: ImageConstant.imgCall,
      type: StaffBottomBarEnum.Chat,
    ),
    StaffBottomMenuModel(
      icon: ImageConstant.imgUser,
      type: StaffBottomBarEnum.Profile,
    ),
    // StaffBottomMenuModel(
    //   icon: ImageConstant.imgSettings,
    //   type: StaffBottomBarEnum.Setting,
    // )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstant.whiteA700,
      ),
      child: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.transparent,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          currentIndex: selectedIndex.value,
          type: BottomNavigationBarType.fixed,
          items: List.generate(
              user == 'PATIENT'
                  ? patientBottomMenuList.length
                  : staffBottomMenuList.length, (index) {
            return BottomNavigationBarItem(
              icon: CustomImageView(
                svgPath: user == 'PATIENT'
                    ? patientBottomMenuList[index].icon
                    : staffBottomMenuList[index].icon,
                height: getSize(
                  32,
                ),
                width: getSize(
                  32,
                ),
                color: ColorConstant.gray500,
              ),
              activeIcon: CustomImageView(
                svgPath: user == 'PATIENT'
                    ? patientBottomMenuList[index].icon
                    : staffBottomMenuList[index].icon,
                height: getSize(
                  32,
                ),
                width: getSize(
                  32,
                ),
                color: ColorConstant.blue600,
              ),
              label: user == 'PATIENT'
                  ? patientBottomMenuList[index].type.name.toString()
                  : staffBottomMenuList[index].type.name.toString(),
            );
          }),
          onTap: (index) {
            selectedIndex.value = index;
            (user == 'PATIENT')
                ? onChangedPatientMenu?.call(patientBottomMenuList[index].type)
                : onChangedStaffMenu?.call(staffBottomMenuList[index].type);
          },
        ),
      ),
    );
  }
}

enum PatientBottomBarEnum {
  Home,
  Appointments,
  Chat,
  Profile,
  //Setting,
}

enum StaffBottomBarEnum {
  Home,
  Appointments,
  Patients,
  Chat,
  Profile,
  //Setting,
}

class PatientBottomMenuModel {
  PatientBottomMenuModel({required this.icon, required this.type});

  String icon;

  PatientBottomBarEnum type;
}

class StaffBottomMenuModel {
  StaffBottomMenuModel({required this.icon, required this.type});

  String icon;

  StaffBottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
  const DefaultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
