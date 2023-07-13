import 'package:get/get.dart';

import 'profile_item_model.dart';

class ProfileModel {
  Rx<List<ProfileItemModel>> profileItemList =
      Rx(List.generate(2, (index) => ProfileItemModel()));
}
