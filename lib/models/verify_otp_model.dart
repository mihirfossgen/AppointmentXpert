// To parse this JSON data, do
//
//     final otpModel = otpModelFromJson(jsonString);

import 'dart:convert';

OtpModel otpModelFromJson(String str) => OtpModel.fromJson(json.decode(str));

String otpModelToJson(OtpModel data) => json.encode(data.toJson());

class OtpModel {
  bool? result;
  String? message;
  Responses? response;

  OtpModel({
    this.result,
    this.message,
    this.response,
  });

  OtpModel copyWith({
    bool? result,
    String? message,
    Responses? response,
  }) =>
      OtpModel(
        result: result ?? this.result,
        message: message ?? this.message,
        response: response ?? this.response,
      );

  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
        result: json["result"],
        message: json["message"],
        response: json["response"] == null
            ? null
            : Responses.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "response": response?.toJson(),
      };
}

class Responses {
  Headers? headers;
  Body? body;
  String? statusCode;
  int? statusCodeValue;

  Responses({
    this.headers,
    this.body,
    this.statusCode,
    this.statusCodeValue,
  });

  Responses copyWith({
    Headers? headers,
    Body? body,
    String? statusCode,
    int? statusCodeValue,
  }) =>
      Responses(
        headers: headers ?? this.headers,
        body: body ?? this.body,
        statusCode: statusCode ?? this.statusCode,
        statusCodeValue: statusCodeValue ?? this.statusCodeValue,
      );

  factory Responses.fromJson(Map<String, dynamic> json) => Responses(
        headers: json["headers"] == null ? null : Headers(),
        body: json["body"] == null ? null : Body.fromJson(json["body"]),
        statusCode: json["statusCode"],
        statusCodeValue: json["statusCodeValue"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers,
        "body": body?.toJson(),
        "statusCode": statusCode,
        "statusCodeValue": statusCodeValue,
      };
}

class Body {
  Patient? patient;
  String? jwt;
  String? mobileNumber;
  List<Role>? roles;
  Staff? staff;
  String? emailId;
  String? userName;
  int? userId;

  Body({
    this.patient,
    this.jwt,
    this.mobileNumber,
    this.roles,
    this.staff,
    this.emailId,
    this.userName,
    this.userId,
  });

  Body copyWith({
    dynamic patient,
    String? jwt,
    String? mobileNumber,
    List<Role>? roles,
    dynamic staff,
    String? emailId,
    String? userName,
    int? userId,
  }) =>
      Body(
        patient: patient ?? this.patient,
        jwt: jwt ?? this.jwt,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        roles: roles ?? this.roles,
        staff: staff ?? this.staff,
        emailId: emailId ?? this.emailId,
        userName: userName ?? this.userName,
        userId: userId ?? this.userId,
      );

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        patient:
            json["patient"] == null ? null : Patient.fromJson(json["patient"]),
        jwt: json["jwt"],
        mobileNumber: json["mobileNumber"],
        roles: json["roles"] == null
            ? []
            : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
        staff: json["staff"] == null ? null : Staff.fromJson(json["staff"]),
        emailId: json["emailId"],
        userName: json["userName"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "patient": patient?.toJson(),
        "jwt": jwt,
        "mobileNumber": mobileNumber,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "staff": staff?.toJson(),
        "emailId": emailId,
        "userName": userName,
        "userId": userId,
      };
}

class Staff {
  int? id;
  String? prefix;
  String? staffId;
  String? firstName;
  int? userId;
  String? fatherName;
  String? lastName;
  String? sex;
  dynamic uploadedProfilePath;
  String? dob;
  String? email;
  String? mobile;
  String? address;
  String? profession;
  String? employment;
  String? qualification;
  String? status;
  String? joinedDate;
  String? terminatedDate;
  int? timeSlotForBookingInMin;
  dynamic startTime;
  dynamic endTime;
  dynamic rescheduleDate;
  int? rescheduleTimeInMin;

  Staff({
    this.id,
    this.prefix,
    this.staffId,
    this.firstName,
    this.userId,
    this.fatherName,
    this.lastName,
    this.sex,
    this.uploadedProfilePath,
    this.dob,
    this.email,
    this.mobile,
    this.address,
    this.profession,
    this.employment,
    this.qualification,
    this.status,
    this.joinedDate,
    this.terminatedDate,
    this.timeSlotForBookingInMin,
    this.startTime,
    this.endTime,
    this.rescheduleDate,
    this.rescheduleTimeInMin,
  });

  Staff copyWith({
    int? id,
    String? prefix,
    String? staffId,
    String? firstName,
    int? userId,
    String? fatherName,
    String? lastName,
    String? sex,
    dynamic uploadedProfilePath,
    String? dob,
    String? email,
    String? mobile,
    String? address,
    String? profession,
    String? employment,
    String? qualification,
    String? status,
    String? joinedDate,
    String? terminatedDate,
    int? timeSlotForBookingInMin,
    dynamic startTime,
    dynamic endTime,
    dynamic rescheduleDate,
    int? rescheduleTimeInMin,
  }) =>
      Staff(
        id: id ?? this.id,
        prefix: prefix ?? this.prefix,
        staffId: staffId ?? this.staffId,
        firstName: firstName ?? this.firstName,
        userId: userId ?? this.userId,
        fatherName: fatherName ?? this.fatherName,
        lastName: lastName ?? this.lastName,
        sex: sex ?? this.sex,
        uploadedProfilePath: uploadedProfilePath ?? this.uploadedProfilePath,
        dob: dob ?? this.dob,
        email: email ?? this.email,
        mobile: mobile ?? this.mobile,
        address: address ?? this.address,
        profession: profession ?? this.profession,
        employment: employment ?? this.employment,
        qualification: qualification ?? this.qualification,
        status: status ?? this.status,
        joinedDate: joinedDate ?? this.joinedDate,
        terminatedDate: terminatedDate ?? this.terminatedDate,
        timeSlotForBookingInMin:
            timeSlotForBookingInMin ?? this.timeSlotForBookingInMin,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        rescheduleDate: rescheduleDate ?? this.rescheduleDate,
        rescheduleTimeInMin: rescheduleTimeInMin ?? this.rescheduleTimeInMin,
      );

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
        id: json["id"],
        prefix: json["prefix"],
        staffId: json["staffId"],
        firstName: json["firstName"],
        userId: json["userId"],
        fatherName: json["fatherName"],
        lastName: json["lastName"],
        sex: json["sex"],
        uploadedProfilePath: json["uploadedProfilePath"],
        dob: json["dob"],
        email: json["email"],
        mobile: json["mobile"],
        address: json["address"],
        profession: json["profession"],
        employment: json["employment"],
        qualification: json["qualification"],
        status: json["status"],
        joinedDate: json["joinedDate"],
        terminatedDate: json["terminatedDate"],
        timeSlotForBookingInMin: json["timeSlotForBookingInMin"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        rescheduleDate: json["rescheduleDate"],
        rescheduleTimeInMin: json["rescheduleTimeInMin"],
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
        "uploadedProfilePath": uploadedProfilePath,
        "dob": dob,
        "email": email,
        "mobile": mobile,
        "address": address,
        "profession": profession,
        "employment": employment,
        "qualification": qualification,
        "status": status,
        "joinedDate": joinedDate,
        "terminatedDate": terminatedDate,
        "timeSlotForBookingInMin": timeSlotForBookingInMin,
        "startTime": startTime,
        "endTime": endTime,
        "rescheduleDate": rescheduleDate,
        "rescheduleTimeInMin": rescheduleTimeInMin,
      };
}

class Patient {
  int? id;
  dynamic prefix;
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
  dynamic regions;
  String? country;
  String? nationality;
  dynamic uploadedProfilePath;
  String? dateCreated;
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
    this.uploadedProfilePath,
    this.dateCreated,
    this.visits,
    this.age,
  });

  Patient copyWith({
    int? id,
    dynamic prefix,
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
    dynamic regions,
    String? country,
    String? nationality,
    dynamic uploadedProfilePath,
    String? dateCreated,
    dynamic visits,
    int? age,
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
        uploadedProfilePath: uploadedProfilePath ?? this.uploadedProfilePath,
        dateCreated: dateCreated ?? this.dateCreated,
        visits: visits ?? this.visits,
        age: age ?? this.age,
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
        uploadedProfilePath: json["uploadedProfilePath"],
        dateCreated: json["dateCreated"],
        visits: json["visits"],
        age: json["age"],
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
        "uploadedProfilePath": uploadedProfilePath,
        "dateCreated": dateCreated,
        "visits": visits,
        "age": age,
      };
}

class Role {
  int? id;
  int? version;
  dynamic dateUpdated;
  String? dateCreated;
  dynamic createdBy;
  dynamic modifiedBy;
  String? name;

  Role({
    this.id,
    this.version,
    this.dateUpdated,
    this.dateCreated,
    this.createdBy,
    this.modifiedBy,
    this.name,
  });

  Role copyWith({
    int? id,
    int? version,
    dynamic dateUpdated,
    String? dateCreated,
    dynamic createdBy,
    dynamic modifiedBy,
    String? name,
  }) =>
      Role(
        id: id ?? this.id,
        version: version ?? this.version,
        dateUpdated: dateUpdated ?? this.dateUpdated,
        dateCreated: dateCreated ?? this.dateCreated,
        createdBy: createdBy ?? this.createdBy,
        modifiedBy: modifiedBy ?? this.modifiedBy,
        name: name ?? this.name,
      );

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        version: json["version"],
        dateUpdated: json["dateUpdated"],
        dateCreated: json["dateCreated"],
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "version": version,
        "dateUpdated": dateUpdated,
        "dateCreated": dateCreated,
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "name": name,
      };
}

class Headers {
  Headers();
}
