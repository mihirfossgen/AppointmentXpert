import '../../../core/app_export.dart';
import '../../../network/api/appointment_api.dart';
import '../controller/schedule_tab_container_controller.dart';

class ScheduleTabBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScheduleTabContainerController());
    Get.lazyPut(() => AppointmentApi());
  }
}
