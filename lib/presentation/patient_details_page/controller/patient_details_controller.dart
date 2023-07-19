import 'package:appointmentxpert/presentation/patient_details_page/models/patient_details_model.dart';
import 'package:get/get.dart';
import '../../../models/getAllPatients.dart';

class PatientDetailsController extends GetxController {

  PatientDetailsController(this.patientDetailsObj);

  Rx<PatientDetailsModel> patientDetailsObj;

  //Datum? patientData;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
