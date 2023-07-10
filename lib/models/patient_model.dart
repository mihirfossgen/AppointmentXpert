// To parse this JSON data, do
//
//     final patientData = patientDataFromJson(jsonString);

import 'dart:convert';

PatientData patientDataFromJson(String str) =>
    PatientData.fromJson(json.decode(str));

String patientDataToJson(PatientData data) => json.encode(data.toJson());

class PatientData {
  Patients? patient;
  dynamic examinations;
  List<dynamic>? paymentReferences;

  PatientData({
    this.patient,
    this.examinations,
    this.paymentReferences,
  });

  PatientData copyWith({
    Patients? patient,
    dynamic examinations,
    List<dynamic>? paymentReferences,
  }) =>
      PatientData(
        patient: patient ?? this.patient,
        examinations: examinations ?? this.examinations,
        paymentReferences: paymentReferences ?? this.paymentReferences,
      );

  factory PatientData.fromJson(Map<String, dynamic> json) => PatientData(
        patient:
            json["patient"] == null ? null : Patients.fromJson(json["patient"]),
        examinations: json["examinations"],
        paymentReferences: json["paymentReferences"] == null
            ? []
            : List<dynamic>.from(json["paymentReferences"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "patient": patient?.toJson(),
        "examinations": examinations,
        "paymentReferences": paymentReferences == null
            ? []
            : List<dynamic>.from(paymentReferences!.map((x) => x)),
      };
}

class Patients {
  int? id;
  String? prefix;
  int? userId;
  String? firstName;
  String? fatherName;
  String? lastName;
  String? motherName;
  String? emergencyContactName;
  String? emergencyContactMobile;
  String? emergencyContactEmail;
  String? sex;
  String? dob;
  String? bloodType;
  dynamic placeOfBirth;
  String? countryOfBirth;
  String? address;
  String? mobile;
  String? email;
  String? regions;
  String? country;
  String? nationality;
  String? dateCreated;
  dynamic visits;
  int? age;
  String? profilePicture;

  Patients({
    this.id,
    this.prefix,
    this.userId,
    this.firstName,
    this.fatherName,
    this.lastName,
    this.motherName,
    this.emergencyContactName,
    this.emergencyContactMobile,
    this.emergencyContactEmail,
    this.sex,
    this.dob,
    this.bloodType,
    this.placeOfBirth,
    this.countryOfBirth,
    this.address,
    this.mobile,
    this.email,
    this.regions,
    this.country,
    this.nationality,
    this.dateCreated,
    this.visits,
    this.age,
    this.profilePicture,
  });

  Patients copyWith({
    int? id,
    String? prefix,
    int? userId,
    String? firstName,
    String? fatherName,
    String? lastName,
    String? motherName,
    String? emergencyContactName,
    String? emergencyContactMobile,
    String? emergencyContactEmail,
    String? sex,
    String? dob,
    String? bloodType,
    dynamic placeOfBirth,
    String? countryOfBirth,
    String? address,
    String? mobile,
    String? email,
    String? regions,
    String? country,
    String? nationality,
    String? dateCreated,
    dynamic visits,
    int? age,
    String? profilePicture,
  }) =>
      Patients(
        id: id ?? this.id,
        prefix: prefix ?? this.prefix,
        userId: userId ?? this.userId,
        firstName: firstName ?? this.firstName,
        fatherName: fatherName ?? this.fatherName,
        lastName: lastName ?? this.lastName,
        motherName: motherName ?? this.motherName,
        emergencyContactName: emergencyContactName ?? this.emergencyContactName,
        emergencyContactMobile:
            emergencyContactMobile ?? this.emergencyContactMobile,
        emergencyContactEmail:
            emergencyContactEmail ?? this.emergencyContactEmail,
        sex: sex ?? this.sex,
        dob: dob ?? this.dob,
        bloodType: bloodType ?? this.bloodType,
        placeOfBirth: placeOfBirth ?? this.placeOfBirth,
        countryOfBirth: countryOfBirth ?? this.countryOfBirth,
        address: address ?? this.address,
        mobile: mobile ?? this.mobile,
        email: email ?? this.email,
        regions: regions ?? this.regions,
        country: country ?? this.country,
        nationality: nationality ?? this.nationality,
        dateCreated: dateCreated ?? this.dateCreated,
        visits: visits ?? this.visits,
        age: age ?? this.age,
        profilePicture: profilePicture ?? this.profilePicture,
      );

  factory Patients.fromJson(Map<String, dynamic> json) => Patients(
        id: json["id"],
        prefix: json["prefix"],
        userId: json["userId"],
        firstName: json["firstName"],
        fatherName: json["fatherName"],
        lastName: json["lastName"],
        motherName: json["motherName"],
        emergencyContactName: json["emergencyContactName"],
        emergencyContactMobile: json["emergencyContactMobile"],
        emergencyContactEmail: json["emergencyContactEmail"],
        sex: json["sex"],
        dob: json["dob"],
        bloodType: json["bloodType"],
        placeOfBirth: json["placeOfBirth"],
        countryOfBirth: json["countryOfBirth"],
        address: json["address"],
        mobile: json["mobile"],
        email: json["email"],
        regions: json["regions"],
        country: json["country"],
        nationality: json["nationality"],
        dateCreated: json["dateCreated"],
        visits: json["visits"],
        age: json["age"],
        profilePicture: json["profilePicture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "prefix": prefix,
        "userId": userId,
        "firstName": firstName,
        "fatherName": fatherName,
        "lastName": lastName,
        "motherName": motherName,
        "emergencyContactName": emergencyContactName,
        "emergencyContactMobile": emergencyContactMobile,
        "emergencyContactEmail": emergencyContactEmail,
        "sex": sex,
        "dob": dob,
        "bloodType": bloodType,
        "placeOfBirth": placeOfBirth,
        "countryOfBirth": countryOfBirth,
        "address": address,
        "mobile": mobile,
        "email": email,
        "regions": regions,
        "country": country,
        "nationality": nationality,
        "dateCreated": dateCreated,
        "visits": visits,
        "age": age,
        "profilePicture": profilePicture,
      };
}
