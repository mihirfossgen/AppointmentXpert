import '../controller/reset_password_email_tab_container_controller.dart';
import 'package:get/get.dart';

class ResetPasswordEmailTabContainerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPasswordEmailTabContainerController());
  }
}
