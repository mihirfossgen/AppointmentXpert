import 'package:get/get.dart';
import '../../../network/api/user_api.dart';
import '../../../network/api/verify_otp.dart';
import '../controller/sign_up_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => UserApi());
    Get.lazyPut(() => VerifyOtpApi());
  }
}
