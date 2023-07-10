// To parse this JSON data, do
//
//     final getallAppointbypatientidModel = getallAppointbypatientidModelFromJson(jsonString);

import 'dart:convert';

GetallAppointbypatientidModel getallAppointbypatientidModelFromJson(
        String str) =>
    GetallAppointbypatientidModel.fromJson(json.decode(str));

String getallAppointbypatientidModelToJson(
        GetallAppointbypatientidModel data) =>
    json.encode(data.toJson());

class GetallAppointbypatientidModel {
  List<Datum>? data;

  GetallAppointbypatientidModel({
    this.data,
  });

  GetallAppointbypatientidModel copyWith({
    List<Datum>? data,
  }) =>
      GetallAppointbypatientidModel(
        data: data ?? this.data,
      );

  factory GetallAppointbypatientidModel.fromJson(Map<String, dynamic> json) =>
      GetallAppointbypatientidModel(
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
  var id;
  String? dateCreated;
  Patient? patient;
  Examiner? examiner;
  Department? department;
  var referenceId;
  String? note;
  String? status;
  String? date;
  bool? active;
  String? purpose;
  dynamic examination;
  Treatment? treatment;
  dynamic visit;
  dynamic labOrder;

  Datum({
    this.id,
    this.dateCreated,
    this.patient,
    this.examiner,
    this.department,
    this.referenceId,
    this.note,
    this.status,
    this.date,
    this.active,
    this.purpose,
    this.examination,
    this.treatment,
    this.visit,
    this.labOrder,
  });

  Datum copyWith({
    var id,
    String? dateCreated,
    Patient? patient,
    Examiner? examiner,
    Department? department,
    var referenceId,
    String? note,
    String? status,
    String? date,
    bool? active,
    String? purpose,
    dynamic examination,
    Treatment? treatment,
    dynamic visit,
    dynamic labOrder,
  }) =>
      Datum(
        id: id ?? this.id,
        dateCreated: dateCreated ?? this.dateCreated,
        patient: patient ?? this.patient,
        examiner: examiner ?? this.examiner,
        department: department ?? this.department,
        referenceId: referenceId ?? this.referenceId,
        note: note ?? this.note,
        status: status ?? this.status,
        date: date ?? this.date,
        active: active ?? this.active,
        purpose: purpose ?? this.purpose,
        examination: examination ?? this.examination,
        treatment: treatment ?? this.treatment,
        visit: visit ?? this.visit,
        labOrder: labOrder ?? this.labOrder,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        dateCreated: json["dateCreated"],
        patient:
            json["patient"] == null ? null : Patient.fromJson(json["patient"]),
        examiner: json["examiner"] == null
            ? null
            : Examiner.fromJson(json["examiner"]),
        department: json["department"] == null
            ? null
            : Department.fromJson(json["department"]),
        referenceId: json["referenceId"],
        note: json["note"],
        status: json["status"],
        date: json["date"],
        active: json["active"],
        purpose: json["purpose"],
        examination: json["examination"],
        treatment: json["treatment"] == null
            ? null
            : Treatment.fromJson(json["treatment"]),
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
        "status": status,
        "date": date,
        "active": active,
        "purpose": purpose,
        "examination": examination,
        "treatment": treatment?.toJson(),
        "visit": visit,
        "labOrder": labOrder,
      };
}

class Department {
  var id;
  String? name;

  Department({
    this.id,
    this.name,
  });

  Department copyWith({
    var id,
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

class Examiner {
  var id;
  String? prefix;
  String? staffId;
  String? firstName;
  var userId;
  String? fatherName;
  String? lastName;
  String? sex;
  String? dob;
  String? clinicName;
  var clinicId;
  String? departmentName;
  var departmentId;
  String? email;
  String? mobile;
  String? address;
  String? profession;
  String? employment;
  String? qualification;
  String? status;
  String? joinedDate;
  String? terminatedDate;

  Examiner({
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

  Examiner copyWith({
    var id,
    String? prefix,
    String? staffId,
    String? firstName,
    var userId,
    String? fatherName,
    String? lastName,
    String? sex,
    String? dob,
    String? clinicName,
    var clinicId,
    String? departmentName,
    var departmentId,
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
      Examiner(
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

  factory Examiner.fromJson(Map<String, dynamic> json) => Examiner(
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
  var id;
  String? prefix;
  var userId;
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
  var age;
  String? profilePicture;

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
    var id,
    String? prefix,
    var userId,
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
    var age,
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

class Treatment {
  var id;
  Examination? examination;
  List<TreatmentElement>? treatments;
  String? type;
  dynamic started;
  dynamic startedDate;
  String? result;
  bool? active;
  dynamic completedDate;
  String? goals;
  String? note;
  dynamic progresses;

  Treatment({
    this.id,
    this.examination,
    this.treatments,
    this.type,
    this.started,
    this.startedDate,
    this.result,
    this.active,
    this.completedDate,
    this.goals,
    this.note,
    this.progresses,
  });

  Treatment copyWith({
    var id,
    Examination? examination,
    List<TreatmentElement>? treatments,
    String? type,
    dynamic started,
    dynamic startedDate,
    String? result,
    bool? active,
    dynamic completedDate,
    String? goals,
    String? note,
    dynamic progresses,
  }) =>
      Treatment(
        id: id ?? this.id,
        examination: examination ?? this.examination,
        treatments: treatments ?? this.treatments,
        type: type ?? this.type,
        started: started ?? this.started,
        startedDate: startedDate ?? this.startedDate,
        result: result ?? this.result,
        active: active ?? this.active,
        completedDate: completedDate ?? this.completedDate,
        goals: goals ?? this.goals,
        note: note ?? this.note,
        progresses: progresses ?? this.progresses,
      );

  factory Treatment.fromJson(Map<String, dynamic> json) => Treatment(
        id: json["id"],
        examination: json["examination"] == null
            ? null
            : Examination.fromJson(json["examination"]),
        treatments: json["treatments"] == null
            ? []
            : List<TreatmentElement>.from(
                json["treatments"]!.map((x) => TreatmentElement.fromJson(x))),
        type: json["type"],
        started: json["started"],
        startedDate: json["startedDate"],
        result: json["result"],
        active: json["active"],
        completedDate: json["completedDate"],
        goals: json["goals"],
        note: json["note"],
        progresses: json["progresses"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "examination": examination?.toJson(),
        "treatments": treatments == null
            ? []
            : List<dynamic>.from(treatments!.map((x) => x.toJson())),
        "type": type,
        "started": started,
        "startedDate": startedDate,
        "result": result,
        "active": active,
        "completedDate": completedDate,
        "goals": goals,
        "note": note,
        "progresses": progresses,
      };
}

class Examination {
  var id;
  Examiner? examiner;
  Visit? visit;
  dynamic patientVisitId;
  String? disease;
  String? diseaseStatement;
  dynamic findings;
  dynamic labOrders;
  dynamic treatments;
  String? dateCreated;
  String? chiefComplaint;
  String? historyOfPresentIllness;
  String? physicalExamination;
  String? assessmentAndPlan;
  String? ordersAndPrescriptions;
  String? progressNote;
  String? diagnosisProcess;
  String? diagnosticCategory;
  bool? active;
  String? functionalLimitationActive;
  String? functionalLimitationPassive;
  String? functionalLimitationMotor;
  dynamic functionalLimitationSensation;
  String? functionalLimitationReflex;
  String? functionalLimitationOverPressure;

  Examination({
    this.id,
    this.examiner,
    this.visit,
    this.patientVisitId,
    this.disease,
    this.diseaseStatement,
    this.findings,
    this.labOrders,
    this.treatments,
    this.dateCreated,
    this.chiefComplaint,
    this.historyOfPresentIllness,
    this.physicalExamination,
    this.assessmentAndPlan,
    this.ordersAndPrescriptions,
    this.progressNote,
    this.diagnosisProcess,
    this.diagnosticCategory,
    this.active,
    this.functionalLimitationActive,
    this.functionalLimitationPassive,
    this.functionalLimitationMotor,
    this.functionalLimitationSensation,
    this.functionalLimitationReflex,
    this.functionalLimitationOverPressure,
  });

  Examination copyWith({
    var id,
    Examiner? examiner,
    Visit? visit,
    dynamic patientVisitId,
    String? disease,
    String? diseaseStatement,
    dynamic findings,
    dynamic labOrders,
    dynamic treatments,
    String? dateCreated,
    String? chiefComplaint,
    String? historyOfPresentIllness,
    String? physicalExamination,
    String? assessmentAndPlan,
    String? ordersAndPrescriptions,
    String? progressNote,
    String? diagnosisProcess,
    String? diagnosticCategory,
    bool? active,
    String? functionalLimitationActive,
    String? functionalLimitationPassive,
    String? functionalLimitationMotor,
    dynamic functionalLimitationSensation,
    String? functionalLimitationReflex,
    String? functionalLimitationOverPressure,
  }) =>
      Examination(
        id: id ?? this.id,
        examiner: examiner ?? this.examiner,
        visit: visit ?? this.visit,
        patientVisitId: patientVisitId ?? this.patientVisitId,
        disease: disease ?? this.disease,
        diseaseStatement: diseaseStatement ?? this.diseaseStatement,
        findings: findings ?? this.findings,
        labOrders: labOrders ?? this.labOrders,
        treatments: treatments ?? this.treatments,
        dateCreated: dateCreated ?? this.dateCreated,
        chiefComplaint: chiefComplaint ?? this.chiefComplaint,
        historyOfPresentIllness:
            historyOfPresentIllness ?? this.historyOfPresentIllness,
        physicalExamination: physicalExamination ?? this.physicalExamination,
        assessmentAndPlan: assessmentAndPlan ?? this.assessmentAndPlan,
        ordersAndPrescriptions:
            ordersAndPrescriptions ?? this.ordersAndPrescriptions,
        progressNote: progressNote ?? this.progressNote,
        diagnosisProcess: diagnosisProcess ?? this.diagnosisProcess,
        diagnosticCategory: diagnosticCategory ?? this.diagnosticCategory,
        active: active ?? this.active,
        functionalLimitationActive:
            functionalLimitationActive ?? this.functionalLimitationActive,
        functionalLimitationPassive:
            functionalLimitationPassive ?? this.functionalLimitationPassive,
        functionalLimitationMotor:
            functionalLimitationMotor ?? this.functionalLimitationMotor,
        functionalLimitationSensation:
            functionalLimitationSensation ?? this.functionalLimitationSensation,
        functionalLimitationReflex:
            functionalLimitationReflex ?? this.functionalLimitationReflex,
        functionalLimitationOverPressure: functionalLimitationOverPressure ??
            this.functionalLimitationOverPressure,
      );

  factory Examination.fromJson(Map<String, dynamic> json) => Examination(
        id: json["id"],
        examiner: json["examiner"] == null
            ? null
            : Examiner.fromJson(json["examiner"]),
        visit: json["visit"] == null ? null : Visit.fromJson(json["visit"]),
        patientVisitId: json["patientVisitId"],
        disease: json["disease"],
        diseaseStatement: json["diseaseStatement"],
        findings: json["findings"],
        labOrders: json["labOrders"],
        treatments: json["treatments"],
        dateCreated: json["dateCreated"],
        chiefComplaint: json["chiefComplaint"],
        historyOfPresentIllness: json["historyOfPresentIllness"],
        physicalExamination: json["physicalExamination"],
        assessmentAndPlan: json["assessmentAndPlan"],
        ordersAndPrescriptions: json["ordersAndPrescriptions"],
        progressNote: json["progressNote"],
        diagnosisProcess: json["diagnosisProcess"],
        diagnosticCategory: json["diagnosticCategory"],
        active: json["active"],
        functionalLimitationActive: json["functionalLimitationActive"],
        functionalLimitationPassive: json["functionalLimitationPassive"],
        functionalLimitationMotor: json["functionalLimitationMotor"],
        functionalLimitationSensation: json["functionalLimitationSensation"],
        functionalLimitationReflex: json["functionalLimitationReflex"],
        functionalLimitationOverPressure:
            json["functionalLimitationOverPressure"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "examiner": examiner?.toJson(),
        "visit": visit?.toJson(),
        "patientVisitId": patientVisitId,
        "disease": disease,
        "diseaseStatement": diseaseStatement,
        "findings": findings,
        "labOrders": labOrders,
        "treatments": treatments,
        "dateCreated": dateCreated,
        "chiefComplaint": chiefComplaint,
        "historyOfPresentIllness": historyOfPresentIllness,
        "physicalExamination": physicalExamination,
        "assessmentAndPlan": assessmentAndPlan,
        "ordersAndPrescriptions": ordersAndPrescriptions,
        "progressNote": progressNote,
        "diagnosisProcess": diagnosisProcess,
        "diagnosticCategory": diagnosticCategory,
        "active": active,
        "functionalLimitationActive": functionalLimitationActive,
        "functionalLimitationPassive": functionalLimitationPassive,
        "functionalLimitationMotor": functionalLimitationMotor,
        "functionalLimitationSensation": functionalLimitationSensation,
        "functionalLimitationReflex": functionalLimitationReflex,
        "functionalLimitationOverPressure": functionalLimitationOverPressure,
      };
}

class Visit {
  var id;
  var patientId;
  String? patientFullName;
  String? dob;
  String? sex;
  var staffId;
  String? staffFullName;
  String? healthProblem;
  dynamic problemStartDate;
  dynamic takingDrug;
  String? visitDate;
  String? visitCause;
  String? otherVisitCause;
  String? disease;
  dynamic pregnancyStatus;
  dynamic surgicalStatus;
  dynamic surgicalType;
  dynamic failStatus;
  dynamic failType;
  dynamic fractureStatus;
  dynamic fractureType;
  String? orthopedicMetalStatus;
  String? orthopedicMetalType;
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
  dynamic examinerId;
  dynamic examinerName;
  bool? examined;
  dynamic assignedDepartment;
  String? spo2;
  String? bmi;
  dynamic examination;

  Visit({
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

  Visit copyWith({
    var id,
    var patientId,
    String? patientFullName,
    String? dob,
    String? sex,
    var staffId,
    String? staffFullName,
    String? healthProblem,
    dynamic problemStartDate,
    dynamic takingDrug,
    String? visitDate,
    String? visitCause,
    String? otherVisitCause,
    String? disease,
    dynamic pregnancyStatus,
    dynamic surgicalStatus,
    dynamic surgicalType,
    dynamic failStatus,
    dynamic failType,
    dynamic fractureStatus,
    dynamic fractureType,
    String? orthopedicMetalStatus,
    String? orthopedicMetalType,
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
    dynamic examinerId,
    dynamic examinerName,
    bool? examined,
    dynamic assignedDepartment,
    String? spo2,
    String? bmi,
    dynamic examination,
  }) =>
      Visit(
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

  factory Visit.fromJson(Map<String, dynamic> json) => Visit(
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

class TreatmentElement {
  var id;
  var version;
  dynamic dateUpdated;
  String? dateCreated;
  dynamic createdBy;
  dynamic modifiedBy;
  String? name;
  String? description;
  String? amount;
  String? type;
  var howManyWeeks;
  String? time;
  String? category;
  var examinationId;

  TreatmentElement({
    this.id,
    this.version,
    this.dateUpdated,
    this.dateCreated,
    this.createdBy,
    this.modifiedBy,
    this.name,
    this.description,
    this.amount,
    this.type,
    this.howManyWeeks,
    this.time,
    this.category,
    this.examinationId,
  });

  TreatmentElement copyWith({
    var id,
    var version,
    dynamic dateUpdated,
    String? dateCreated,
    dynamic createdBy,
    dynamic modifiedBy,
    String? name,
    String? description,
    String? amount,
    String? type,
    var howManyWeeks,
    String? time,
    String? category,
    var examinationId,
  }) =>
      TreatmentElement(
        id: id ?? this.id,
        version: version ?? this.version,
        dateUpdated: dateUpdated ?? this.dateUpdated,
        dateCreated: dateCreated ?? this.dateCreated,
        createdBy: createdBy ?? this.createdBy,
        modifiedBy: modifiedBy ?? this.modifiedBy,
        name: name ?? this.name,
        description: description ?? this.description,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        howManyWeeks: howManyWeeks ?? this.howManyWeeks,
        time: time ?? this.time,
        category: category ?? this.category,
        examinationId: examinationId ?? this.examinationId,
      );

  factory TreatmentElement.fromJson(Map<String, dynamic> json) =>
      TreatmentElement(
        id: json["id"],
        version: json["version"],
        dateUpdated: json["dateUpdated"],
        dateCreated: json["dateCreated"],
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        name: json["name"],
        description: json["description"],
        amount: json["amount"],
        type: json["type"],
        howManyWeeks: json["howManyWeeks"],
        time: json["time"],
        category: json["category"],
        examinationId: json["examinationId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "version": version,
        "dateUpdated": dateUpdated,
        "dateCreated": dateCreated,
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "name": name,
        "description": description,
        "amount": amount,
        "type": type,
        "howManyWeeks": howManyWeeks,
        "time": time,
        "category": category,
        "examinationId": examinationId,
      };
}
