// To parse this JSON data, do
//
//     final getAllAppointments = getAllAppointmentsFromJson(jsonString);

import 'dart:convert';

GetAllAppointments getAllAppointmentsFromJson(String str) =>
    GetAllAppointments.fromJson(json.decode(str));

String getAllAppointmentsToJson(GetAllAppointments data) =>
    json.encode(data.toJson());

class GetAllAppointments {
  List<AppointmentContent>? content;
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
  bool? last;
  int? size;
  int? number;
  Sort? sort;
  bool? first;
  int? numberOfElements;
  bool? empty;

  GetAllAppointments({
    this.content,
    this.pageable,
    this.totalPages,
    this.totalElements,
    this.last,
    this.size,
    this.number,
    this.sort,
    this.first,
    this.numberOfElements,
    this.empty,
  });

  GetAllAppointments copyWith({
    List<AppointmentContent>? content,
    Pageable? pageable,
    int? totalPages,
    int? totalElements,
    bool? last,
    int? size,
    int? number,
    Sort? sort,
    bool? first,
    int? numberOfElements,
    bool? empty,
  }) =>
      GetAllAppointments(
        content: content ?? this.content,
        pageable: pageable ?? this.pageable,
        totalPages: totalPages ?? this.totalPages,
        totalElements: totalElements ?? this.totalElements,
        last: last ?? this.last,
        size: size ?? this.size,
        number: number ?? this.number,
        sort: sort ?? this.sort,
        first: first ?? this.first,
        numberOfElements: numberOfElements ?? this.numberOfElements,
        empty: empty ?? this.empty,
      );

  factory GetAllAppointments.fromJson(Map<String, dynamic> json) =>
      GetAllAppointments(
        content: json["content"] == null
            ? []
            : List<AppointmentContent>.from(
                json["content"]!.map((x) => AppointmentContent.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
        last: json["last"],
        size: json["size"],
        number: json["number"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        first: json["first"],
        numberOfElements: json["numberOfElements"],
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
        "first": first,
        "numberOfElements": numberOfElements,
        "empty": empty,
      };
}

class AppointmentContent {
  int? id;
  String? dateCreated;
  Patient? patient;
  ContentExaminer? examiner;
  Department? department;
  int? referenceId;
  String? note;
  String? status;
  String? date;
  String? startTime;
  String? endTime;
  bool? active;
  String? purpose;
  Examination? examination;
  ContentTreatment? treatment;
  Visit? visit;
  dynamic labOrder;
  bool? selected;

  AppointmentContent({
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
    this.startTime,
    this.endTime,
    this.selected,
  });

  AppointmentContent copyWith({
    int? id,
    String? dateCreated,
    Patient? patient,
    ContentExaminer? examiner,
    Department? department,
    int? referenceId,
    String? note,
    String? status,
    String? date,
    String? startTime,
    String? endTime,
    bool? active,
    String? purpose,
    Examination? examination,
    ContentTreatment? treatment,
    Visit? visit,
    dynamic labOrder,
    bool? selected,
  }) =>
      AppointmentContent(
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
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        selected: selected ?? this.selected,
      );

  factory AppointmentContent.fromJson(Map<String, dynamic> json) =>
      AppointmentContent(
        id: json["id"],
        dateCreated: json["dateCreated"],
        patient:
            json["patient"] == null ? null : Patient.fromJson(json["patient"]),
        examiner: json["examiner"] == null
            ? null
            : ContentExaminer.fromJson(json["examiner"]),
        department: json["department"] == null
            ? null
            : Department.fromJson(json["department"]),
        referenceId: json["referenceId"],
        note: json["note"],
        status: json["status"],
        date: json["date"],
        startTime: json['startTime'],
        endTime: json['endTime'],
        selected: json['selected'],
        active: json["active"],
        purpose: json["purpose"],
        examination: json["examination"] == null
            ? null
            : Examination.fromJson(json["examination"]),
        treatment: json["treatment"] == null
            ? null
            : ContentTreatment.fromJson(json["treatment"]),
        visit: json["visit"] == null ? null : Visit.fromJson(json["visit"]),
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
        "examination": examination?.toJson(),
        "treatment": treatment?.toJson(),
        "visit": visit?.toJson(),
        "labOrder": labOrder,
        "endTime": endTime,
        "startTime": startTime,
        "selected": selected,
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

class ContentExaminer {
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

  ContentExaminer({
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

  ContentExaminer copyWith(
          {int? id,
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
          String? profilePicture}) =>
      ContentExaminer(
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
          profilePicture: profilePicture ?? this.profilePicture);

  factory ContentExaminer.fromJson(Map<String, dynamic> json) =>
      ContentExaminer(
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
          profilePicture: json["uploadedProfilePath"]);

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
        "uploadedProfilePath": profilePicture
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
        profilePicture: json["uploadedProfilePath"],
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
        "uploadedProfilePath": profilePicture,
      };
}

class ContentTreatment {
  int? id;
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

  ContentTreatment({
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

  ContentTreatment copyWith({
    int? id,
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
      ContentTreatment(
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

  factory ContentTreatment.fromJson(Map<String, dynamic> json) =>
      ContentTreatment(
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

class Examinations {
  int? id;
  ExaminationExaminer? examiner;
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
  dynamic functionalLimitationActive;
  dynamic functionalLimitationPassive;
  dynamic functionalLimitationMotor;
  dynamic functionalLimitationSensation;
  dynamic functionalLimitationReflex;
  dynamic functionalLimitationOverPressure;

  Examinations({
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

  Examinations copyWith({
    int? id,
    ExaminationExaminer? examiner,
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
    dynamic functionalLimitationActive,
    dynamic functionalLimitationPassive,
    dynamic functionalLimitationMotor,
    dynamic functionalLimitationSensation,
    dynamic functionalLimitationReflex,
    dynamic functionalLimitationOverPressure,
  }) =>
      Examinations(
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

  factory Examinations.fromJson(Map<String, dynamic> json) => Examinations(
        id: json["id"],
        examiner: json["examiner"] == null
            ? null
            : ExaminationExaminer.fromJson(json["examiner"]),
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

class ExaminationExaminer {
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

  ExaminationExaminer({
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

  ExaminationExaminer copyWith({
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
      ExaminationExaminer(
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

  factory ExaminationExaminer.fromJson(Map<String, dynamic> json) =>
      ExaminationExaminer(
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

class Visit {
  int? id;
  int? patientId;
  String? patientFullName;
  String? dob;
  String? sex;
  int? staffId;
  String? staffFullName;
  dynamic healthProblem;
  String? problemStartDate;
  dynamic takingDrug;
  String? visitDate;
  String? visitCause;
  dynamic otherVisitCause;
  String? disease;
  String? pregnancyStatus;
  String? surgicalStatus;
  dynamic surgicalType;
  String? failStatus;
  dynamic failType;
  String? fractureStatus;
  dynamic fractureType;
  String? orthopedicMetalStatus;
  dynamic orthopedicMetalType;
  String? diarrhea;
  String? headAche;
  var bodyTemperature;
  dynamic pulseRate;
  String? pr;
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
    int? id,
    int? patientId,
    String? patientFullName,
    String? dob,
    String? sex,
    int? staffId,
    String? staffFullName,
    dynamic healthProblem,
    String? problemStartDate,
    dynamic takingDrug,
    String? visitDate,
    String? visitCause,
    dynamic otherVisitCause,
    String? disease,
    String? pregnancyStatus,
    String? surgicalStatus,
    dynamic surgicalType,
    String? failStatus,
    dynamic failType,
    String? fractureStatus,
    dynamic fractureType,
    String? orthopedicMetalStatus,
    dynamic orthopedicMetalType,
    String? diarrhea,
    String? headAche,
    int? bodyTemperature,
    dynamic pulseRate,
    String? pr,
    dynamic bloodPressure,
    double? weight,
    int? height,
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
  int? id;
  int? version;
  dynamic dateUpdated;
  String? dateCreated;
  dynamic createdBy;
  dynamic modifiedBy;
  String? name;
  String? description;
  String? amount;
  String? type;
  int? howManyWeeks;
  String? time;
  String? category;
  int? examinationId;

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
    int? id,
    int? version,
    dynamic dateUpdated,
    String? dateCreated,
    dynamic createdBy,
    dynamic modifiedBy,
    String? name,
    String? description,
    String? amount,
    String? type,
    int? howManyWeeks,
    String? time,
    String? category,
    int? examinationId,
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

class Examination {
  int? id;

  Visit? visit;
  dynamic patientVisitId;
  dynamic disease;
  String? diseaseStatement;
  dynamic findings;
  dynamic labOrders;
  dynamic treatments;
  String? dateCreated;
  String? chiefComplaint;
  dynamic historyOfPresentIllness;
  dynamic physicalExamination;
  String? assessmentAndPlan;
  dynamic ordersAndPrescriptions;
  dynamic progressNote;
  dynamic diagnosisProcess;
  dynamic diagnosticCategory;
  bool? active;
  dynamic functionalLimitationActive;
  dynamic functionalLimitationPassive;
  dynamic functionalLimitationMotor;
  dynamic functionalLimitationSensation;
  dynamic functionalLimitationReflex;
  dynamic functionalLimitationOverPressure;

  Examination({
    this.id,
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
    int? id,
    Visit? visit,
    dynamic patientVisitId,
    dynamic disease,
    String? diseaseStatement,
    dynamic findings,
    dynamic labOrders,
    dynamic treatments,
    String? dateCreated,
    String? chiefComplaint,
    dynamic historyOfPresentIllness,
    dynamic physicalExamination,
    String? assessmentAndPlan,
    dynamic ordersAndPrescriptions,
    dynamic progressNote,
    dynamic diagnosisProcess,
    dynamic diagnosticCategory,
    bool? active,
    dynamic functionalLimitationActive,
    dynamic functionalLimitationPassive,
    dynamic functionalLimitationMotor,
    dynamic functionalLimitationSensation,
    dynamic functionalLimitationReflex,
    dynamic functionalLimitationOverPressure,
  }) =>
      Examination(
        id: id ?? this.id,
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
