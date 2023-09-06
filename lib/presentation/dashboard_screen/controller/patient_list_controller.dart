import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/patient_list_model.dart';
import '../../../network/api/patient_api.dart';

class PatientListController extends GetxController {
  RxBool isloadingRecentPatients = false.obs;
  RxList<Content> getAllPatientsList = <Content>[].obs;
  RxList<Content> tempList = <Content>[].obs;
  PagingController<int, Content> patientPagingController =
      PagingController(firstPageKey: 0);
  Rx<TextEditingController> searchedText = TextEditingController().obs;
  static const _pageSize = 20;
  ScrollController scrollcontroller = ScrollController();
  int pageno = 0;
  @override
  void onInit() {
    super.onInit();
    scrollcontroller.addListener(pagination);
    //patientPagingController.addPageRequestListener((pageKey) {
    callRecentPatientList(pageno);
    // });
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        (getAllPatientsList.length == _pageSize)) {
      callRecentPatientList(pageno++);
    }
  }

  @override
  void onClose() {
    super.onClose();
    getAllPatientsList.clear();
    searchedText.value.clear();
  }

  Future<void> callRecentPatientList(int pageNo) async {
    try {
      isloadingRecentPatients.value = true;
      var response = (await Get.find<PatientApi>().getAllPatientsList(pageNo));

      PatientList patientListData = response;
      if (patientListData.content != []) {
        getAllPatientsList.addAll(patientListData.content ?? []);
        tempList.addAll(patientListData.content ?? []);
      } else {
        pageNo--;
      }

      isloadingRecentPatients.value = false;
      update();
      //patientPagingController.itemList = [];
      // final isLastPage = patientListData.content!.length < _pageSize;
      // if (isLastPage) {
      //   isloadingRecentPatients.value = false;
      //   List<Content> list = patientListData.content ?? [];
      //   patientPagingController.appendLastPage(list);
      // } else {
      //   isloadingRecentPatients.value = false;
      //   List<Content> list = patientListData.content ?? [];
      //   getAllPatientsList.value = response.content ?? [];
      //   final nextPageKey = pageNo + 1;
      //   patientPagingController.appendPage(list, nextPageKey);
      // }
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloadingRecentPatients.value = false;
    }
  }
}
