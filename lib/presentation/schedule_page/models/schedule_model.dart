import 'package:get/get.dart';

import 'schedule_item_model.dart';

class ScheduleModel {
  Rx<List<ScheduleItemModel>> scheduleItemList =
      Rx(List.generate(8, (index) => ScheduleItemModel()));
}
