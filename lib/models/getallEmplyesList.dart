// To parse this JSON data, do
//
//     final getAllEmployesList = getAllEmployesListFromJson(jsonString);

import 'dart:convert';

GetAllEmployesList getAllEmployesListFromJson(String str) =>
    GetAllEmployesList.fromJson(json.decode(str));

String getAllEmployesListToJson(GetAllEmployesList data) =>
    json.encode(data.toJson());

class GetAllEmployesList {
  List<DoctorList>? doctorList;
  Pageable? pageable;
  bool? last;
  int? totalElements;
  int? totalPages;
  int? size;
  int? number;
  Sort? sort;
  bool? first;
  int? numberOfElements;
  bool? empty;

  GetAllEmployesList({
    this.doctorList,
    this.pageable,
    this.last,
    this.totalElements,
    this.totalPages,
    this.size,
    this.number,
    this.sort,
    this.first,
    this.numberOfElements,
    this.empty,
  });

  GetAllEmployesList copyWith({
    List<DoctorList>? doctorList,
    Pageable? pageable,
    bool? last,
    int? totalElements,
    int? totalPages,
    int? size,
    int? number,
    Sort? sort,
    bool? first,
    int? numberOfElements,
    bool? empty,
  }) =>
      GetAllEmployesList(
        doctorList: doctorList ?? this.doctorList,
        pageable: pageable ?? this.pageable,
        last: last ?? this.last,
        totalElements: totalElements ?? this.totalElements,
        totalPages: totalPages ?? this.totalPages,
        size: size ?? this.size,
        number: number ?? this.number,
        sort: sort ?? this.sort,
        first: first ?? this.first,
        numberOfElements: numberOfElements ?? this.numberOfElements,
        empty: empty ?? this.empty,
      );

  factory GetAllEmployesList.fromJson(Map<String, dynamic> json) =>
      GetAllEmployesList(
        doctorList: json["content"] == null
            ? []
            : List<DoctorList>.from(
                json["content"]!.map((x) => DoctorList.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        last: json["last"],
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        size: json["size"],
        number: json["number"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        first: json["first"],
        numberOfElements: json["numberOfElements"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": doctorList == null
            ? []
            : List<dynamic>.from(doctorList!.map((x) => x.toJson())),
        "pageable": pageable?.toJson(),
        "last": last,
        "totalElements": totalElements,
        "totalPages": totalPages,
        "size": size,
        "number": number,
        "sort": sort?.toJson(),
        "first": first,
        "numberOfElements": numberOfElements,
        "empty": empty,
      };
}

class DoctorList {
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

  DoctorList({
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
  });

  DoctorList copyWith({
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
    String? profilePicture,
  }) =>
      DoctorList(
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
      );

  factory DoctorList.fromJson(Map<String, dynamic> json) => DoctorList(
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
        "uploadedProfilePath": profilePicture,
      };
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.unpaged,
  });

  Pageable copyWith({
    Sort? sort,
    int? offset,
    int? pageNumber,
    int? pageSize,
    bool? paged,
    bool? unpaged,
  }) =>
      Pageable(
        sort: sort ?? this.sort,
        offset: offset ?? this.offset,
        pageNumber: pageNumber ?? this.pageNumber,
        pageSize: pageSize ?? this.pageSize,
        paged: paged ?? this.paged,
        unpaged: unpaged ?? this.unpaged,
      );

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        offset: json["offset"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        paged: json["paged"],
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort?.toJson(),
        "offset": offset,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "paged": paged,
        "unpaged": unpaged,
      };
}

class Sort {
  bool? unsorted;
  bool? sorted;
  bool? empty;

  Sort({
    this.unsorted,
    this.sorted,
    this.empty,
  });

  Sort copyWith({
    bool? unsorted,
    bool? sorted,
    bool? empty,
  }) =>
      Sort(
        unsorted: unsorted ?? this.unsorted,
        sorted: sorted ?? this.sorted,
        empty: empty ?? this.empty,
      );

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        unsorted: json["unsorted"],
        sorted: json["sorted"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "unsorted": unsorted,
        "sorted": sorted,
        "empty": empty,
      };
}
