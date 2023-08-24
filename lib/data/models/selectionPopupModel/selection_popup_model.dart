///SelectionPopupModel is common model
///used for setting data into dropdowns
class SelectionPopupModel {
  int? id;
  String title;
  dynamic value;
  bool isSelected;
  String? startTime;
  String? endTime;
  String? interval;

  SelectionPopupModel(
      {this.id,
      required this.title,
      this.value,
      this.isSelected = false,
      this.startTime,
      this.endTime,
      this.interval});
}
