import '../controller/reset_password_verify_code_controller.dart';
import 'package:get/get.dart';

class ResetPasswordVerifyCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPasswordVerifyCodeController());
  }
}
