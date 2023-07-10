import 'package:get/get.dart';

import '../../../network/api/user_api.dart';
import '../../../network/api/verify_otp.dart';
import '../controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => UserApi());
    Get.lazyPut(() => VerifyOtpApi());
  }
}
