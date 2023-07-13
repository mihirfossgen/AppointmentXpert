import 'package:get/get.dart';

class ProfileItemModel {
  Rx<String> heartrateTxt = Rx("Heart rate");

  Rx<String> k215bpmTxt = Rx("215bpm");

  Rx<String>? id = Rx("");
}
