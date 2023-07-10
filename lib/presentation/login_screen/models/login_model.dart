
import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  Patient? patient;
  String? jwt;
  List<Role>? roles;
  Staff? staff;
  String? userName;
  int? userId;

  LoginModel({
    this.patient,
    this.jwt,
    this.roles,
    this.staff,
    this.userName,
    this.userId,
  });

  LoginModel copyWith({
    Patient? patient,
    String? jwt,
    List<Role>? roles,
    Staff? staff,
    String? userName,
    int? userId,
  }) =>
      LoginModel(
        patient: patient ?? this.patient,
        jwt: jwt ?? this.jwt,
        roles: roles ?? this.roles,
        staff: staff ?? this.staff,
        userName: userName ?? this.userName,
        userId: userId ?? this.userId,
      );

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        patient:
            json["patient"] == null ? null : Patient.fromJson(json["patient"]),
        jwt: json["jwt"],
        roles: json["roles"] == null
            ? []
            : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
        staff: json["staff"] == null ? null : Staff.fromJson(json["staff"]),
        userName: json["userName"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "patient": patient?.toJson(),
        "jwt": jwt,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "staff": staff?.toJson(),
        "userName": userName,
        "userId": userId,
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

class Staff {
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

  Staff({
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

  Staff copyWith({
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
      Staff(
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

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
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
      };
}
