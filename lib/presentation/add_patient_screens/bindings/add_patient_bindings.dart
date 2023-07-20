import 'package:appointmentxpert/core/app_export.dart';
import 'package:appointmentxpert/network/api/patient_api.dart';
import 'package:appointmentxpert/network/api/user_api.dart';
import '../controller/add_patient_controller.dart';

class AddPatientBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddPatientController());
    Get.lazyPut(() => UserApi());
    Get.lazyPut(() => PatientApi());
  }
}
