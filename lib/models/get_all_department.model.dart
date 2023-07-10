// To parse this JSON data, do
//
//     final getAllDepartemnt = getAllDepartemntFromJson(jsonString);

import 'dart:convert';

GetAllDepartemnt getAllDepartemntFromJson(String str) => GetAllDepartemnt.fromJson(json.decode(str));

String getAllDepartemntToJson(GetAllDepartemnt data) => json.encode(data.toJson());

class GetAllDepartemnt {
    List<Datum>? data;

    GetAllDepartemnt({
        this.data,
    });

    GetAllDepartemnt copyWith({
        List<Datum>? data,
    }) => 
        GetAllDepartemnt(
            data: data ?? this.data,
        );

    factory GetAllDepartemnt.fromJson(Map<String, dynamic> json) => GetAllDepartemnt(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? name;

    Datum({
        this.id,
        this.name,
    });

    Datum copyWith({
        int? id,
        String? name,
    }) => 
        Datum(
            id: id ?? this.id,
            name: name ?? this.name,
        );

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
