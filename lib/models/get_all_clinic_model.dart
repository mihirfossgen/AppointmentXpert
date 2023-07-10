// To parse this JSON data, do
//
//     final getAllClinic = getAllClinicFromJson(jsonString);

import 'dart:convert';

GetAllClinic getAllClinicFromJson(String str) =>
    GetAllClinic.fromJson(json.decode(str));

String getAllClinicToJson(GetAllClinic data) => json.encode(data.toJson());

class GetAllClinic {
  List<Datum>? data;

  GetAllClinic({
    this.data,
  });

  GetAllClinic copyWith({
    List<Datum>? data,
  }) =>
      GetAllClinic(
        data: data ?? this.data,
      );

  factory GetAllClinic.fromJson(Map<String, dynamic> json) => GetAllClinic(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  String? name;
  List<Department>? departments;

  Datum({
    this.id,
    this.name,
    this.departments,
  });

  Datum copyWith({
    int? id,
    String? name,
    List<Department>? departments,
  }) =>
      Datum(
        id: id ?? this.id,
        name: name ?? this.name,
        departments: departments ?? this.departments,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        departments: json["departments"] == null
            ? []
            : List<Department>.from(
                json["departments"]!.map((x) => Department.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "departments": departments == null
            ? []
            : List<dynamic>.from(departments!.map((x) => x.toJson())),
      };
}

class Department {
  int? id;
  int? version;
  dynamic dateUpdated;
  String? dateCreated;
  dynamic createdBy;
  dynamic modifiedBy;
  String? name;

  Department({
    this.id,
    this.version,
    this.dateUpdated,
    this.dateCreated,
    this.createdBy,
    this.modifiedBy,
    this.name,
  });

  Department copyWith({
    int? id,
    int? version,
    dynamic dateUpdated,
    String? dateCreated,
    dynamic createdBy,
    dynamic modifiedBy,
    String? name,
  }) =>
      Department(
        id: id ?? this.id,
        version: version ?? this.version,
        dateUpdated: dateUpdated ?? this.dateUpdated,
        dateCreated: dateCreated ?? this.dateCreated,
        createdBy: createdBy ?? this.createdBy,
        modifiedBy: modifiedBy ?? this.modifiedBy,
        name: name ?? this.name,
      );

  factory Department.fromJson(Map<String, dynamic> json) => Department(
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
