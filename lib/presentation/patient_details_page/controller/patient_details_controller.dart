import 'package:appointmentxpert/presentation/patient_details_page/models/patient_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../models/getAllPatients.dart';
import '../../../models/patient_model.dart';
import '../../../network/api/patient_api.dart';


class PatientDetailsController extends GetxController {

  final scafoldKey = GlobalKey<ScaffoldState>();

  PatientDetailsController(this.patientDetailsObj);

  Rx<PatientDetailsModel> patientDetailsObj;

  Rx<PatientData> patientData = PatientData().obs;

  Future<void> getPatientDetails(int id) async {
    try {
      patientData.value =
      (await Get.find<PatientApi>().getPatientDetails(headers: {
        'Content-type': 'application/json',
      }, id: id));
      // _handleCreateLoginSuccess(loginModelObj);
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
