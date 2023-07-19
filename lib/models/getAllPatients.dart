// To parse this JSON data, do
//
//     final getAllPatientslist = getAllPatientslistFromJson(jsonString);

import 'dart:convert';

GetAllPatientslist getAllPatientslistFromJson(String str) =>
    GetAllPatientslist.fromJson(json.decode(str));

String getAllPatientslistToJson(GetAllPatientslist data) =>
    json.encode(data.toJson());

class GetAllPatientslist {
  GetAllPatientslist({
    this.data,
    this.message,
    this.responseCode,
    this.status,
  });

  final List<Datum>? data;
  final String? message;
  final int? responseCode;
  final bool? status;

  GetAllPatientslist copyWith({
    List<Datum>? data,
    String? message,
    int? responseCode,
    bool? status,
  }) =>
      GetAllPatientslist(
        data: data ?? this.data,
        message: message ?? this.message,
        responseCode: responseCode ?? this.responseCode,
        status: status ?? this.status,
      );

  factory GetAllPatientslist.fromJson(Map<String, dynamic> json) =>
      GetAllPatientslist(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        message: json["message"],
        responseCode: json["responseCode"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
        "responseCode": responseCode,
        "status": status,
      };
}

class Datum {
  Datum({
    this.patientId,
    this.userId,
    this.firstName,
    this.lastName,
    this.gender,
    this.birthday,
    this.address,
    this.email,
    this.bloodGroup,
    this.profilePicture,
    this.patientCases,
    this.documents,
  });

  final String? patientId;
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? birthday;
  final String? address;
  final String? email;
  final String? bloodGroup;
  final String? profilePicture;
  final List<dynamic>? patientCases;
  final List<dynamic>? documents;

  Datum copyWith({
    String? patientId,
    int? userId,
    String? firstName,
    String? lastName,
    String? gender,
    String? birthday,
    String? address,
    String? email,
    String? bloodGroup,
    String? profilePicture,
    List<dynamic>? patientCases,
    List<dynamic>? documents,
  }) =>
      Datum(
        patientId: patientId ?? this.patientId,
        userId: userId ?? this.userId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        gender: gender ?? this.gender,
        birthday: birthday ?? this.birthday,
        address: address ?? this.address,
        email: email ?? this.email,
        bloodGroup: bloodGroup ?? this.bloodGroup,
        profilePicture: profilePicture ?? this.profilePicture,
        patientCases: patientCases ?? this.patientCases,
        documents: documents ?? this.documents,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        patientId: json["patientId"],
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        gender: json["gender"],
        birthday: json["birthday"],
        address: json["address"],
        email: json["email"],
        bloodGroup: json["bloodGroup"],
        profilePicture: json["uploadedProfilePath"],
        patientCases: json["patientCases"] == null
            ? []
            : List<dynamic>.from(json["patientCases"]!.map((x) => x)),
        documents: json["documents"] == null
            ? []
            : List<dynamic>.from(json["documents"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "patientId": patientId,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
        "birthday": birthday,
        "address": address,
        "email": email,
        "bloodGroup": bloodGroup,
        "uploadedProfilePath": profilePicture,
        "patientCases": patientCases == null
            ? []
            : List<dynamic>.from(patientCases!.map((x) => x)),
        "documents": documents == null
            ? []
            : List<dynamic>.from(documents!.map((x) => x)),
      };
}
