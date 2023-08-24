// To parse this JSON data, do
//
//     final staffData = staffDataFromJson(jsonString);

import 'dart:convert';

StaffData staffDataFromJson(String str) => StaffData.fromJson(json.decode(str));

String staffDataToJson(StaffData data) => json.encode(data.toJson());

class StaffData {
  int? id;
  String? prefix;
  String? staffId;
  String? firstName;
  int? userId;
  String? fatherName;
  String? lastName;
  String? sex;
  String? dob;
  String? clinicName;
  int? clinicId;
  String? departmentName;
  int? departmentId;
  String? email;
  String? mobile;
  String? address;
  String? profession;
  String? employment;
  String? qualification;
  String? status;
  String? joinedDate;
  String? terminatedDate;
  String? profilePicture;
  String? startTime;
  String? endTime;
  bool? notificationFlag;

  StaffData({
    this.id,
    this.prefix,
    this.staffId,
    this.firstName,
    this.userId,
    this.fatherName,
    this.lastName,
    this.sex,
    this.dob,
    this.clinicName,
    this.clinicId,
    this.departmentName,
    this.departmentId,
    this.email,
    this.mobile,
    this.address,
    this.profession,
    this.employment,
    this.qualification,
    this.status,
    this.joinedDate,
    this.terminatedDate,
    this.profilePicture,
    this.startTime,
    this.endTime,
    this.notificationFlag,
  });

  StaffData copyWith(
          {int? id,
          String? prefix,
          String? staffId,
          String? firstName,
          int? userId,
          String? fatherName,
          String? lastName,
          String? sex,
          String? dob,
          String? clinicName,
          int? clinicId,
          String? departmentName,
          int? departmentId,
          String? email,
          String? mobile,
          String? address,
          String? profession,
          String? employment,
          String? qualification,
          String? status,
          String? joinedDate,
          String? terminatedDate,
          String? profilePicture,
          String? startTime,
          String? endTime,
          bool? notificationFlag}) =>
      StaffData(
          id: id ?? this.id,
          prefix: prefix ?? this.prefix,
          staffId: staffId ?? this.staffId,
          firstName: firstName ?? this.firstName,
          userId: userId ?? this.userId,
          fatherName: fatherName ?? this.fatherName,
          lastName: lastName ?? this.lastName,
          sex: sex ?? this.sex,
          dob: dob ?? this.dob,
          clinicName: clinicName ?? this.clinicName,
          clinicId: clinicId ?? this.clinicId,
          departmentName: departmentName ?? this.departmentName,
          departmentId: departmentId ?? this.departmentId,
          email: email ?? this.email,
          mobile: mobile ?? this.mobile,
          address: address ?? this.address,
          profession: profession ?? this.profession,
          employment: employment ?? this.employment,
          qualification: qualification ?? this.qualification,
          status: status ?? this.status,
          joinedDate: joinedDate ?? this.joinedDate,
          terminatedDate: terminatedDate ?? this.terminatedDate,
          profilePicture: profilePicture ?? this.profilePicture,
          startTime: startTime ?? this.startTime,
          endTime: endTime ?? this.endTime,
          notificationFlag: notificationFlag ?? this.notificationFlag);

  factory StaffData.fromJson(Map<String, dynamic> json) => StaffData(
      id: json["id"],
      prefix: json["prefix"],
      staffId: json["staffId"],
      firstName: json["firstName"],
      userId: json["userId"],
      fatherName: json["fatherName"],
      lastName: json["lastName"],
      sex: json["sex"],
      dob: json["dob"],
      clinicName: json["clinicName"],
      clinicId: json["clinicId"],
      departmentName: json["departmentName"],
      departmentId: json["departmentId"],
      email: json["email"],
      mobile: json["mobile"],
      address: json["address"],
      profession: json["profession"],
      employment: json["employment"],
      qualification: json["qualification"],
      status: json["status"],
      joinedDate: json["joinedDate"],
      terminatedDate: json["terminatedDate"],
      profilePicture: json["uploadedProfilePath"],
      startTime: json['startTime'],
      endTime: json['endTime'],
      notificationFlag: json['notificationFlag']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "prefix": prefix,
        "staffId": staffId,
        "firstName": firstName,
        "userId": userId,
        "fatherName": fatherName,
        "lastName": lastName,
        "sex": sex,
        "dob": dob,
        "clinicName": clinicName,
        "clinicId": clinicId,
        "departmentName": departmentName,
        "departmentId": departmentId,
        "email": email,
        "mobile": mobile,
        "address": address,
        "profession": profession,
        "employment": employment,
        "qualification": qualification,
        "status": status,
        "joinedDate": joinedDate,
        "terminatedDate": terminatedDate,
        "uploadedProfilePath": profilePicture,
        "startTime": startTime,
        "endTime": endTime,
        "notificationFlag": notificationFlag
      };
}
