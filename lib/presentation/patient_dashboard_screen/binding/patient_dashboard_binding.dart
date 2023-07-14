import 'package:get/get.dart';

import '../../../network/api/appointment_api.dart';
import '../../../network/api/patient_api.dart';
import '../../../network/api/staff_api.dart';
import '../controller/patient_dashboard_controller.dart';

class PatientDashboardMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => StaffApi());
    Get.lazyPut(() => AppointmentApi());
    Get.lazyPut(() => PatientApi());
  }
}
