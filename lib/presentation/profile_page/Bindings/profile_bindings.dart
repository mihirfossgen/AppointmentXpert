import 'package:appointmentxpert/core/app_export.dart';
import 'package:appointmentxpert/network/api/patient_api.dart';
import 'package:appointmentxpert/network/api/staff_api.dart';
import 'package:appointmentxpert/presentation/profile_page/controller/profile_controller.dart';

class ProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => StaffApi());
    Get.lazyPut(() => PatientApi());
  }
}
