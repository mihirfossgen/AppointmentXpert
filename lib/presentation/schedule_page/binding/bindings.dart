import '../../../core/app_export.dart';
import '../../../network/api/appointment_api.dart';
import '../controller/schedule_controller.dart';

class SchedulePage extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScheduleController());
    Get.lazyPut(() => AppointmentApi());
  }
}
