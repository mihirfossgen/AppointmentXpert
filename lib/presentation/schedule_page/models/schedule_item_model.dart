import 'package:get/get.dart';

class ScheduleItemModel {
  Rx<String> doctornameTxt = Rx("Dr. Marcus Horizon");

  Rx<String> specialtyTxt = Rx("Chardiologist");

  Rx<String> dateTxt = Rx("26/06/2022");

  Rx<String> timeTxt = Rx("10:30 AM");

  Rx<String>? id = Rx("");
}
