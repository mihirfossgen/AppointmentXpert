// To parse this JSON data, do
//
//     final signUpModel = signUpModelFromJson(jsonString);

import 'dart:convert';

SignUpModel signUpModelFromJson(String str) =>
    SignUpModel.fromJson(json.decode(str));

String signUpModelToJson(SignUpModel data) => json.encode(data.toJson());

class SignUpModel {
  UserDetail? userDetail;
  String? message;

  SignUpModel({
    this.userDetail,
    this.message,
  });

  SignUpModel copyWith({
    UserDetail? userDetail,
    String? message,
  }) =>
      SignUpModel(
        userDetail: userDetail ?? this.userDetail,
        message: message ?? this.message,
      );

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
        userDetail: json["userDetail"] == null
            ? null
            : UserDetail.fromJson(json["userDetail"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "userDetail": userDetail?.toJson(),
        "message": message,
      };
}

class UserDetail {
  int? id;
  int? version;
  dynamic dateUpdated;
  String? dateCreated;
  dynamic createdBy;
  dynamic modifiedBy;
  String? userName;
  String? password;
  bool? enabled;
  String? patientName;
  String? emailId;
  String? mobileNumber;

  UserDetail({
    this.id,
    this.version,
    this.dateUpdated,
    this.dateCreated,
    this.createdBy,
    this.modifiedBy,
    this.userName,
    this.password,
    this.enabled,
    this.patientName,
    this.emailId,
    this.mobileNumber,
  });

  UserDetail copyWith({
    int? id,
    int? version,
    dynamic dateUpdated,
    String? dateCreated,
    dynamic createdBy,
    dynamic modifiedBy,
    String? userName,
    String? password,
    bool? enabled,
    String? patientName,
    String? emailId,
    String? mobileNumber,
  }) =>
      UserDetail(
        id: id ?? this.id,
        version: version ?? this.version,
        dateUpdated: dateUpdated ?? this.dateUpdated,
        dateCreated: dateCreated ?? this.dateCreated,
        createdBy: createdBy ?? this.createdBy,
        modifiedBy: modifiedBy ?? this.modifiedBy,
        userName: userName ?? this.userName,
        password: password ?? this.password,
        enabled: enabled ?? this.enabled,
        patientName: patientName ?? this.patientName,
        emailId: emailId ?? this.emailId,
        mobileNumber: mobileNumber ?? this.mobileNumber,
      );

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        id: json["id"],
        version: json["version"],
        dateUpdated: json["dateUpdated"],
        dateCreated: json["dateCreated"],
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        userName: json["userName"],
        password: json["password"],
        enabled: json["enabled"],
        patientName: json["patientName"],
        emailId: json["emailId"],
        mobileNumber: json["mobileNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "version": version,
        "dateUpdated": dateUpdated,
        "dateCreated": dateCreated,
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "userName": userName,
        "password": password,
        "enabled": enabled,
        "patientName": patientName,
        "emailId": emailId,
        "mobileNumber": mobileNumber,
      };
}
