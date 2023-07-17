// To parse this JSON data, do
//
//     final staffList = staffListFromJson(jsonString);

import 'dart:convert';

StaffList staffListFromJson(String str) => StaffList.fromJson(json.decode(str));

String staffListToJson(StaffList data) => json.encode(data.toJson());

class StaffList {
  List<Contents>? content;
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
  bool? last;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  StaffList({
    this.content,
    this.pageable,
    this.totalPages,
    this.totalElements,
    this.last,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  StaffList copyWith({
    List<Contents>? content,
    Pageable? pageable,
    int? totalPages,
    int? totalElements,
    bool? last,
    int? size,
    int? number,
    Sort? sort,
    int? numberOfElements,
    bool? first,
    bool? empty,
  }) =>
      StaffList(
        content: content ?? this.content,
        pageable: pageable ?? this.pageable,
        totalPages: totalPages ?? this.totalPages,
        totalElements: totalElements ?? this.totalElements,
        last: last ?? this.last,
        size: size ?? this.size,
        number: number ?? this.number,
        sort: sort ?? this.sort,
        numberOfElements: numberOfElements ?? this.numberOfElements,
        first: first ?? this.first,
        empty: empty ?? this.empty,
      );

  factory StaffList.fromJson(Map<String, dynamic> json) => StaffList(
        content: json["content"] == null
            ? []
            : List<Contents>.from(
                json["content"]!.map((x) => Contents.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
        last: json["last"],
        size: json["size"],
        number: json["number"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x.toJson())),
        "pageable": pageable?.toJson(),
        "totalPages": totalPages,
        "totalElements": totalElements,
        "last": last,
        "size": size,
        "number": number,
        "sort": sort?.toJson(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class Contents {
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

  Contents({
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

  Contents copyWith({
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
      Contents(
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

  factory Contents.fromJson(Map<String, dynamic> json) => Contents(
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

class Pageable {
  Sort? sort;
  int? offset;
  int? pageSize;
  int? pageNumber;
  bool? unpaged;
  bool? paged;

  Pageable({
    this.sort,
    this.offset,
    this.pageSize,
    this.pageNumber,
    this.unpaged,
    this.paged,
  });

  Pageable copyWith({
    Sort? sort,
    int? offset,
    int? pageSize,
    int? pageNumber,
    bool? unpaged,
    bool? paged,
  }) =>
      Pageable(
        sort: sort ?? this.sort,
        offset: offset ?? this.offset,
        pageSize: pageSize ?? this.pageSize,
        pageNumber: pageNumber ?? this.pageNumber,
        unpaged: unpaged ?? this.unpaged,
        paged: paged ?? this.paged,
      );

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        offset: json["offset"],
        pageSize: json["pageSize"],
        pageNumber: json["pageNumber"],
        unpaged: json["unpaged"],
        paged: json["paged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort?.toJson(),
        "offset": offset,
        "pageSize": pageSize,
        "pageNumber": pageNumber,
        "unpaged": unpaged,
        "paged": paged,
      };
}

class Sort {
  bool? sorted;
  bool? unsorted;
  bool? empty;

  Sort({
    this.sorted,
    this.unsorted,
    this.empty,
  });

  Sort copyWith({
    bool? sorted,
    bool? unsorted,
    bool? empty,
  }) =>
      Sort(
        sorted: sorted ?? this.sorted,
        unsorted: unsorted ?? this.unsorted,
        empty: empty ?? this.empty,
      );

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        sorted: json["sorted"],
        unsorted: json["unsorted"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "sorted": sorted,
        "unsorted": unsorted,
        "empty": empty,
      };
}
