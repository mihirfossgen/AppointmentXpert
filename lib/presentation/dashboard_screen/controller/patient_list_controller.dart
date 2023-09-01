import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/patient_list_model.dart';
import '../../../network/api/patient_api.dart';

class PatientListController extends GetxController {
  var isloadingRecentPatients = false.obs;
  RxList<Content> getAllPatientsList = <Content>[].obs;
  PagingController<int, Content> patientPagingController =
      PagingController(firstPageKey: 0);
  Rx<TextEditingController> searchedText = TextEditingController().obs;
  static const _pageSize = 20;
  @override
  void onInit() {
    super.onInit();
    patientPagingController.addPageRequestListener((pageKey) {
      callRecentPatientList(0);
    });
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
      getAllPatientsList.value = response.content ?? [];
      PatientList patientListData = response;
      isloadingRecentPatients.value = false;
      //patientPagingController.itemList = [];
      final isLastPage = patientListData.content!.length < _pageSize;
      if (isLastPage) {
        isloadingRecentPatients.value = false;
        List<Content> list = patientListData.content ?? [];
        patientPagingController.appendLastPage(list);
      } else {
        isloadingRecentPatients.value = false;
        List<Content> list = patientListData.content ?? [];
        getAllPatientsList.value = response.content ?? [];
        final nextPageKey = pageNo + 1;
        patientPagingController.appendPage(list, nextPageKey);
      }
      update();
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isloadingRecentPatients.value = false;
    }
  }
}
