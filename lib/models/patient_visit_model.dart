// To parse this JSON data, do
//
//     final patientVisitModel = patientVisitModelFromJson(jsonString);

import 'dart:convert';

PatientVisitModel patientVisitModelFromJson(String str) =>
    PatientVisitModel.fromJson(json.decode(str));

String patientVisitModelToJson(PatientVisitModel data) =>
    json.encode(data.toJson());

class PatientVisitModel {
  bool? result;
  dynamic message;
  T? t;

  PatientVisitModel({
    this.result,
    this.message,
    this.t,
  });

  PatientVisitModel copyWith({
    bool? result,
    dynamic message,
    T? t,
  }) =>
      PatientVisitModel(
        result: result ?? this.result,
        message: message ?? this.message,
        t: t ?? this.t,
      );

  factory PatientVisitModel.fromJson(Map<String, dynamic> json) =>
      PatientVisitModel(
        result: json["result"],
        message: json["message"],
        t: json["t"] == null ? null : T.fromJson(json["t"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "t": t?.toJson(),
      };
}

class T {
  var id;
  var patientId;
  String? patientFullName;
  String? dob;
  String? sex;
  var staffId;
  String? staffFullName;
  dynamic healthProblem;
  dynamic problemStartDate;
  dynamic takingDrug;
  String? visitDate;
  String? visitCause;
  dynamic otherVisitCause;
  String? disease;
  dynamic pregnancyStatus;
  dynamic surgicalStatus;
  dynamic surgicalType;
  dynamic failStatus;
  dynamic failType;
  dynamic fractureStatus;
  dynamic fractureType;
  String? orthopedicMetalStatus;
  dynamic orthopedicMetalType;
  String? diarrhea;
  String? headAche;
  dynamic bodyTemperature;
  dynamic pulseRate;
  dynamic pr;
  dynamic bloodPressure;
  var weight;
  var height;
  String? vitalSignNote;
  String? visitNote;
  String? visitMethod;
  dynamic emergencyContactName;
  dynamic emergencyContactAddress;
  dynamic emergencyContactMobile;
  dynamic emergencyContactEmail;
  bool? assigned;
  var examinerId;
  String? examinerName;
  bool? examined;
  dynamic assignedDepartment;
  String? spo2;
  String? bmi;
  dynamic examination;

  T({
    this.id,
    this.patientId,
    this.patientFullName,
    this.dob,
    this.sex,
    this.staffId,
    this.staffFullName,
    this.healthProblem,
    this.problemStartDate,
    this.takingDrug,
    this.visitDate,
    this.visitCause,
    this.otherVisitCause,
    this.disease,
    this.pregnancyStatus,
    this.surgicalStatus,
    this.surgicalType,
    this.failStatus,
    this.failType,
    this.fractureStatus,
    this.fractureType,
    this.orthopedicMetalStatus,
    this.orthopedicMetalType,
    this.diarrhea,
    this.headAche,
    this.bodyTemperature,
    this.pulseRate,
    this.pr,
    this.bloodPressure,
    this.weight,
    this.height,
    this.vitalSignNote,
    this.visitNote,
    this.visitMethod,
    this.emergencyContactName,
    this.emergencyContactAddress,
    this.emergencyContactMobile,
    this.emergencyContactEmail,
    this.assigned,
    this.examinerId,
    this.examinerName,
    this.examined,
    this.assignedDepartment,
    this.spo2,
    this.bmi,
    this.examination,
  });

  T copyWith({
    var id,
    var patientId,
    String? patientFullName,
    String? dob,
    String? sex,
    var staffId,
    String? staffFullName,
    dynamic healthProblem,
    dynamic problemStartDate,
    dynamic takingDrug,
    String? visitDate,
    String? visitCause,
    dynamic otherVisitCause,
    String? disease,
    dynamic pregnancyStatus,
    dynamic surgicalStatus,
    dynamic surgicalType,
    dynamic failStatus,
    dynamic failType,
    dynamic fractureStatus,
    dynamic fractureType,
    String? orthopedicMetalStatus,
    dynamic orthopedicMetalType,
    String? diarrhea,
    String? headAche,
    dynamic bodyTemperature,
    dynamic pulseRate,
    dynamic pr,
    dynamic bloodPressure,
    var weight,
    var height,
    String? vitalSignNote,
    String? visitNote,
    String? visitMethod,
    dynamic emergencyContactName,
    dynamic emergencyContactAddress,
    dynamic emergencyContactMobile,
    dynamic emergencyContactEmail,
    bool? assigned,
    var examinerId,
    String? examinerName,
    bool? examined,
    dynamic assignedDepartment,
    String? spo2,
    String? bmi,
    dynamic examination,
  }) =>
      T(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        patientFullName: patientFullName ?? this.patientFullName,
        dob: dob ?? this.dob,
        sex: sex ?? this.sex,
        staffId: staffId ?? this.staffId,
        staffFullName: staffFullName ?? this.staffFullName,
        healthProblem: healthProblem ?? this.healthProblem,
        problemStartDate: problemStartDate ?? this.problemStartDate,
        takingDrug: takingDrug ?? this.takingDrug,
        visitDate: visitDate ?? this.visitDate,
        visitCause: visitCause ?? this.visitCause,
        otherVisitCause: otherVisitCause ?? this.otherVisitCause,
        disease: disease ?? this.disease,
        pregnancyStatus: pregnancyStatus ?? this.pregnancyStatus,
        surgicalStatus: surgicalStatus ?? this.surgicalStatus,
        surgicalType: surgicalType ?? this.surgicalType,
        failStatus: failStatus ?? this.failStatus,
        failType: failType ?? this.failType,
        fractureStatus: fractureStatus ?? this.fractureStatus,
        fractureType: fractureType ?? this.fractureType,
        orthopedicMetalStatus:
            orthopedicMetalStatus ?? this.orthopedicMetalStatus,
        orthopedicMetalType: orthopedicMetalType ?? this.orthopedicMetalType,
        diarrhea: diarrhea ?? this.diarrhea,
        headAche: headAche ?? this.headAche,
        bodyTemperature: bodyTemperature ?? this.bodyTemperature,
        pulseRate: pulseRate ?? this.pulseRate,
        pr: pr ?? this.pr,
        bloodPressure: bloodPressure ?? this.bloodPressure,
        weight: weight ?? this.weight,
        height: height ?? this.height,
        vitalSignNote: vitalSignNote ?? this.vitalSignNote,
        visitNote: visitNote ?? this.visitNote,
        visitMethod: visitMethod ?? this.visitMethod,
        emergencyContactName: emergencyContactName ?? this.emergencyContactName,
        emergencyContactAddress:
            emergencyContactAddress ?? this.emergencyContactAddress,
        emergencyContactMobile:
            emergencyContactMobile ?? this.emergencyContactMobile,
        emergencyContactEmail:
            emergencyContactEmail ?? this.emergencyContactEmail,
        assigned: assigned ?? this.assigned,
        examinerId: examinerId ?? this.examinerId,
        examinerName: examinerName ?? this.examinerName,
        examined: examined ?? this.examined,
        assignedDepartment: assignedDepartment ?? this.assignedDepartment,
        spo2: spo2 ?? this.spo2,
        bmi: bmi ?? this.bmi,
        examination: examination ?? this.examination,
      );

  factory T.fromJson(Map<String, dynamic> json) => T(
        id: json["id"],
        patientId: json["patientId"],
        patientFullName: json["patientFullName"],
        dob: json["dob"],
        sex: json["sex"],
        staffId: json["staffId"],
        staffFullName: json["staffFullName"],
        healthProblem: json["healthProblem"],
        problemStartDate: json["problemStartDate"],
        takingDrug: json["takingDrug"],
        visitDate: json["visitDate"],
        visitCause: json["visitCause"],
        otherVisitCause: json["otherVisitCause"],
        disease: json["disease"],
        pregnancyStatus: json["pregnancyStatus"],
        surgicalStatus: json["surgicalStatus"],
        surgicalType: json["surgicalType"],
        failStatus: json["failStatus"],
        failType: json["failType"],
        fractureStatus: json["fractureStatus"],
        fractureType: json["fractureType"],
        orthopedicMetalStatus: json["orthopedicMetalStatus"],
        orthopedicMetalType: json["orthopedicMetalType"],
        diarrhea: json["diarrhea"],
        headAche: json["headAche"],
        bodyTemperature: json["bodyTemperature"],
        pulseRate: json["pulseRate"],
        pr: json["pr"],
        bloodPressure: json["bloodPressure"],
        weight: json["weight"],
        height: json["height"],
        vitalSignNote: json["vitalSignNote"],
        visitNote: json["visitNote"],
        visitMethod: json["visitMethod"],
        emergencyContactName: json["emergencyContactName"],
        emergencyContactAddress: json["emergencyContactAddress"],
        emergencyContactMobile: json["emergencyContactMobile"],
        emergencyContactEmail: json["emergencyContactEmail"],
        assigned: json["assigned"],
        examinerId: json["examinerId"],
        examinerName: json["examinerName"],
        examined: json["examined"],
        assignedDepartment: json["assignedDepartment"],
        spo2: json["spo2"],
        bmi: json["bmi"],
        examination: json["examination"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patientId": patientId,
        "patientFullName": patientFullName,
        "dob": dob,
        "sex": sex,
        "staffId": staffId,
        "staffFullName": staffFullName,
        "healthProblem": healthProblem,
        "problemStartDate": problemStartDate,
        "takingDrug": takingDrug,
        "visitDate": visitDate,
        "visitCause": visitCause,
        "otherVisitCause": otherVisitCause,
        "disease": disease,
        "pregnancyStatus": pregnancyStatus,
        "surgicalStatus": surgicalStatus,
        "surgicalType": surgicalType,
        "failStatus": failStatus,
        "failType": failType,
        "fractureStatus": fractureStatus,
        "fractureType": fractureType,
        "orthopedicMetalStatus": orthopedicMetalStatus,
        "orthopedicMetalType": orthopedicMetalType,
        "diarrhea": diarrhea,
        "headAche": headAche,
        "bodyTemperature": bodyTemperature,
        "pulseRate": pulseRate,
        "pr": pr,
        "bloodPressure": bloodPressure,
        "weight": weight,
        "height": height,
        "vitalSignNote": vitalSignNote,
        "visitNote": visitNote,
        "visitMethod": visitMethod,
        "emergencyContactName": emergencyContactName,
        "emergencyContactAddress": emergencyContactAddress,
        "emergencyContactMobile": emergencyContactMobile,
        "emergencyContactEmail": emergencyContactEmail,
        "assigned": assigned,
        "examinerId": examinerId,
        "examinerName": examinerName,
        "examined": examined,
        "assignedDepartment": assignedDepartment,
        "spo2": spo2,
        "bmi": bmi,
        "examination": examination,
      };
}
