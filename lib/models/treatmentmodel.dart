// To parse this JSON data, do
//
//     final treatmentModel = treatmentModelFromJson(jsonString);

import 'dart:convert';

TreatmentModel treatmentModelFromJson(String str) =>
    TreatmentModel.fromJson(json.decode(str));

String treatmentModelToJson(TreatmentModel data) => json.encode(data.toJson());

class TreatmentModel {
  String? amount;
  String? category;
  String? description;
  int? examinationId;
  int? howManyWeeks;
  int? id;
  String? name;
  String? time;
  String? type;

  TreatmentModel({
    this.amount,
    this.category,
    this.description,
    this.examinationId,
    this.howManyWeeks,
    this.id,
    this.name,
    this.time,
    this.type,
  });

  TreatmentModel copyWith({
    String? amount,
    String? category,
    String? description,
    int? examinationId,
    int? howManyWeeks,
    int? id,
    String? name,
    String? time,
    String? type,
  }) =>
      TreatmentModel(
        amount: amount ?? this.amount,
        category: category ?? this.category,
        description: description ?? this.description,
        examinationId: examinationId ?? this.examinationId,
        howManyWeeks: howManyWeeks ?? this.howManyWeeks,
        id: id ?? this.id,
        name: name ?? this.name,
        time: time ?? this.time,
        type: type ?? this.type,
      );

  factory TreatmentModel.fromJson(Map<String, dynamic> json) => TreatmentModel(
        amount: json["amount"],
        category: json["category"],
        description: json["description"],
        examinationId: json["examinationId"],
        howManyWeeks: json["howManyWeeks"],
        id: json["id"],
        name: json["name"],
        time: json["time"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "category": category,
        "description": description,
        "examinationId": examinationId,
        "howManyWeeks": howManyWeeks,
        "id": id,
        "name": name,
        "time": time,
        "type": type,
      };
}
