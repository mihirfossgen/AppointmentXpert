class EmergencyPatientList {
  List<EmergencyContent>? content;
  Pageable? pageable;
  bool? last;
  int? totalPages;
  int? totalElements;
  bool? first;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? empty;

  EmergencyPatientList(
      {
        this.content,
        this.pageable,
        this.last,
        this.totalPages,
        this.totalElements,
        this.first,
        this.size,
        this.number,
        this.sort,
        this.numberOfElements,
        this.empty});

  EmergencyPatientList.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <EmergencyContent>[];
      json['content'].forEach((v) {
        content!.add(EmergencyContent.fromJson(v));
      });
    }
  /*  pageable = json['pageable'] != null
        ? new Pageable.fromJson(json['pageable'])
        : null;
    last = json['last'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    first = json['first'];
    size = json['size'];
    number = json['number'];
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    numberOfElements = json['numberOfElements'];
    empty = json['empty'];*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    /*if (this.pageable != null) {
      data['pageable'] = this.pageable!.toJson();
    }
    data['last'] = this.last;
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    data['first'] = this.first;
    data['size'] = this.size;
    data['number'] = this.number;
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['numberOfElements'] = this.numberOfElements;
    data['empty'] = this.empty;*/
    return data;
  }
}

class EmergencyContent {

  String? patientName;
  String? mobileNumber;
  String? emailId;
  String? date;
  String? patientType;
  int? id;
  int? userId;

  EmergencyContent(
      {
        this.patientName,
        this.mobileNumber,
        this.emailId,
        this.date,
        this.patientType,
        this.id,
        this.userId,
      });

  EmergencyContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    userId = json['userId'];
    patientName = json['patientName'];
    mobileNumber = json['mobileNumber'];
    emailId = json['emailId'];
    date = json['date'];
    patientType = json['patientType'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['patientName'] = patientName;
    data['mobileNumber'] = mobileNumber;
    data['emailId'] = emailId;
    data['date'] = date;
    data['patientType'] = patientType;
    return data;
  }
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable(
      {this.sort,
        this.offset,
        this.pageNumber,
        this.pageSize,
        this.paged,
        this.unpaged});

  Pageable.fromJson(Map<String, dynamic> json) {
    sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    offset = json['offset'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sort != null) {
      data['sort'] = sort!.toJson();
    }
    data['offset'] = offset;
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    data['paged'] = paged;
    data['unpaged'] = unpaged;
    return data;
  }
}

class Sort {
  bool? sorted;
  bool? unsorted;
  bool? empty;

  Sort({this.sorted, this.unsorted, this.empty});

  Sort.fromJson(Map<String, dynamic> json) {
    sorted = json['sorted'];
    unsorted = json['unsorted'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sorted'] = sorted;
    data['unsorted'] = unsorted;
    data['empty'] = empty;
    return data;
  }
}
