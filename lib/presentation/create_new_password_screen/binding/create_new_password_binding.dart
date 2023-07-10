import '../../../network/api/user_api.dart';
import '../controller/create_new_password_controller.dart';
import 'package:get/get.dart';

class CreateNewPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateNewPasswordController());
    Get.lazyPut(() => UserApi());
  }
}
