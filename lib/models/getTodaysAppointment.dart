// To parse this JSON data, do
//
//     final getTodaysAppointment = getTodaysAppointmentFromJson(jsonString);

import 'dart:convert';

List<GetTodaysAppointment> getTodaysAppointmentFromJson(String str) =>
    List<GetTodaysAppointment>.from(
        json.decode(str).map((x) => GetTodaysAppointment.fromJson(x)));

String getTodaysAppointmentToJson(List<GetTodaysAppointment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetTodaysAppointment {
  int? id;
  String? dateCreated;
  Patient? patient;
  Examinerss? examiner;
  Department? department;
  int? referenceId;
  String? note;
  String? date;
  bool? active;
  String? purpose;
  dynamic examination;
  dynamic treatment;
  dynamic visit;
  dynamic labOrder;

  GetTodaysAppointment({
    this.id,
    this.dateCreated,
    this.patient,
    this.examiner,
    this.department,
    this.referenceId,
    this.note,
    this.date,
    this.active,
    this.purpose,
    this.examination,
    this.treatment,
    this.visit,
    this.labOrder,
  });

  GetTodaysAppointment copyWith({
    int? id,
    String? dateCreated,
    Patient? patient,
    Examinerss? examiner,
    Department? department,
    int? referenceId,
    String? note,
    String? date,
    bool? active,
    String? purpose,
    dynamic examination,
    dynamic treatment,
    dynamic visit,
    dynamic labOrder,
  }) =>
      GetTodaysAppointment(
        id: id ?? this.id,
        dateCreated: dateCreated ?? this.dateCreated,
        patient: patient ?? this.patient,
        examiner: examiner ?? this.examiner,
        department: department ?? this.department,
        referenceId: referenceId ?? this.referenceId,
        note: note ?? this.note,
        date: date ?? this.date,
        active: active ?? this.active,
        purpose: purpose ?? this.purpose,
        examination: examination ?? this.examination,
        treatment: treatment ?? this.treatment,
        visit: visit ?? this.visit,
        labOrder: labOrder ?? this.labOrder,
      );

  factory GetTodaysAppointment.fromJson(Map<String, dynamic> json) =>
      GetTodaysAppointment(
        id: json["id"],
        dateCreated: json["dateCreated"],
        patient:
            json["patient"] == null ? null : Patient.fromJson(json["patient"]),
        examiner: json["examiner"] == null
            ? null
            : Examinerss.fromJson(json["examiner"]),
        department: json["department"] == null
            ? null
            : Department.fromJson(json["department"]),
        referenceId: json["referenceId"],
        note: json["note"],
        date: json["date"],
        active: json["active"],
        purpose: json["purpose"],
        examination: json["examination"],
        treatment: json["treatment"],
        visit: json["visit"],
        labOrder: json["labOrder"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dateCreated": dateCreated,
        "patient": patient?.toJson(),
        "examiner": examiner?.toJson(),
        "department": department?.toJson(),
        "referenceId": referenceId,
        "note": note,
        "date": date,
        "active": active,
        "purpose": purpose,
        "examination": examination,
        "treatment": treatment,
        "visit": visit,
        "labOrder": labOrder,
      };
}

class Department {
  int? id;
  String? name;

  Department({
    this.id,
    this.name,
  });

  Department copyWith({
    int? id,
    String? name,
  }) =>
      Department(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Examinerss {
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

  Examinerss({
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
  });

  Examinerss copyWith({
    int? id,
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
  }) =>
      Examinerss(
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
      );

  factory Examinerss.fromJson(Map<String, dynamic> json) => Examinerss(
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
      );

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
      };
}

class Patient {
  int? id;
  String? prefix;
  int? userId;
  String? firstName;
  String? fatherName;
  String? lastName;
  String? motherName;
  dynamic emergencyContactName;
  dynamic emergencyContactMobile;
  dynamic emergencyContactEmail;
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
  String? profilePicture;
  dynamic visits;
  int? age;

  Patient({
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

  Patient copyWith({
    int? id,
    String? prefix,
    int? userId,
    String? firstName,
    String? fatherName,
    String? lastName,
    String? motherName,
    dynamic emergencyContactName,
    dynamic emergencyContactMobile,
    dynamic emergencyContactEmail,
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
      Patient(
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

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
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
