// To parse this JSON data, do
//
//     final otpModel = otpModelFromJson(jsonString);

import 'dart:convert';

OtpModel otpModelFromJson(String str) => OtpModel.fromJson(json.decode(str));

String otpModelToJson(OtpModel data) => json.encode(data.toJson());

class OtpModel {
  bool? result;
  String? message;

  OtpModel({
    this.result,
    this.message,
  });

  OtpModel copyWith({
    bool? result,
    String? message,
  }) =>
      OtpModel(
        result: result ?? this.result,
        message: message ?? this.message,
      );

  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
        result: json["result"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
      };
}
