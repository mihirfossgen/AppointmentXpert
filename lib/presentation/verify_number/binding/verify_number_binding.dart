import 'package:get/get.dart';
import '../../../network/api/verify_otp.dart';
import '../controller/verify_number_controller.dart';

class VerifyNumberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerifyNumberController());
    Get.lazyPut(() => VerifyOtpApi());
  }
}
