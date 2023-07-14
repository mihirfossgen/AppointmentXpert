import 'package:appointmentxpert/core/app_export.dart';
import '../controller/add_patient_controller.dart';

class AddPatientBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddPatientController());
  }
}
