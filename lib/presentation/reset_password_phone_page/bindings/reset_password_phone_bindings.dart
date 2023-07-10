import 'package:get/get.dart';
import '../../../network/api/verify_otp.dart';
import '../controller/reset_password_phone_controller.dart';

class ResetPasswordPhoneBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPasswordPhoneController());
    Get.lazyPut(() => VerifyOtpApi());
  }
}
