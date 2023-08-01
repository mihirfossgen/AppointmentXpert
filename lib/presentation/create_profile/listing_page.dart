import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/country_list.dart';
import '../../core/utils/size_utils.dart';
import '../../widgets/app_bar/appbar_subtitle_2.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_checkbox.dart';
import '../../widgets/responsive.dart';
import '../dashboard_screen/shared_components/search_field.dart';
import 'controller/create_profile_controller.dart';

class ListingPage extends GetWidget<CreateProfileController> {
  CreateProfileController controller = Get.put(CreateProfileController());
  List<Map<dynamic, String>>? listOfCountryOrList;
  ListingPage({super.key, this.listOfCountryOrList});

  List<Map<dynamic, String>>? searchedLists;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: !Responsive.isDesktop(context)
                ? CustomAppBar(
                    backgroundColor: ColorConstant.blue700,
                    height: getVerticalSize(60),
                    leadingWidth: 64,
                    elevation: 0,
                    leading: !Responsive.isDesktop(context)
                        ? IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ))
                        : null,
                    centerTitle: true,
                    title: AppbarSubtitle2(text: "Search"))
                : null,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    child: SearchField(
                      onSearch: (value) {
                        if (value.length > 3) {
                          searchedLists = listOfCountryOrList!.where((element) {
                            return element['name']!
                                .toLowerCase()
                                .contains(value.toLowerCase());
                          }).toList();
                          if (searchedLists != []) {
                            controller.isSearched.value = true;
                          }
                        } else {
                          controller.isSearched.value = false;
                        }
                      },
                    ),
                  ),
                  Obx(() => Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                        child: controller.isSearched.value
                            ? Column(
                                children: searchedList(),
                              )
                            : Column(
                                children: list(),
                              ),
                      ))
                ],
              ),
            )));
  }

  List<Widget> searchedList() {
    List<Widget> a = [];
    for (var i = 0; i < (searchedLists?.length ?? 0); i++) {
      a.add(InkWell(
        onTap: () {
          controller.selectedIndex.value = i;
          controller.isSearched.value = false;
          Get.back(result: searchedLists?[i]);
        },
        child: AbsorbPointer(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(searchedLists?[i]['name'] ?? ""),
                Obx(() => controller.selectedIndex.value == 0
                    ? Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1)),
                      )
                    : Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: controller.selectedIndex.value == i
                                ? Colors.blue
                                : Colors.white,
                            border: Border.all(color: Colors.black, width: 1)),
                      ))
              ],
            ),
          ),
        ),
      ));
    }
    return a;
  }

  List<Widget> list() {
    List<Widget> a = [];
    for (var i = 0; i < (listOfCountryOrList?.length ?? 0); i++) {
      a.add(InkWell(
        onTap: () {
          controller.selectedIndex.value = i;
          controller.isSearched.value = false;
          Get.back(result: listOfCountryOrList?[i]);
        },
        child: AbsorbPointer(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(listOfCountryOrList?[i]['name'] ?? ""),
                Obx(() => controller.selectedIndex.value == 0
                    ? Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1)),
                      )
                    : Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: controller.selectedIndex.value == i
                                ? Colors.blue
                                : Colors.white,
                            border: Border.all(color: Colors.black, width: 1)),
                      ))
              ],
            ),
          ),
        ),
      ));
    }
    return a;
  }
}
