class PatientList {
  List<Content>? content;
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

  PatientList(
      {this.content,
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

  PatientList.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(new Content.fromJson(v));
      });
    }
    pageable = json['pageable'] != null
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
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    if (this.pageable != null) {
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
    data['empty'] = this.empty;
    return data;
  }
}

class Content {
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
  String? placeOfBirth;
  String? countryOfBirth;
  String? address;
  String? mobile;
  String? email;
  String? regions;
  String? country;
  String? nationality;
  String? dateCreated;
  String? visits;
  int? age;
  String? profilePicture;

  Content(
      {this.id,
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
      this.profilePicture});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prefix = json['prefix'];
    userId = json['userId'];
    firstName = json['firstName'];
    fatherName = json['fatherName'];
    lastName = json['lastName'];
    motherName = json['motherName'];
    emergencyContactName = json['emergencyContactName'];
    emergencyContactMobile = json['emergencyContactMobile'];
    emergencyContactEmail = json['emergencyContactEmail'];
    sex = json['sex'];
    dob = json['dob'];
    bloodType = json['bloodType'];
    placeOfBirth = json['placeOfBirth'];
    countryOfBirth = json['countryOfBirth'];
    address = json['address'];
    mobile = json['mobile'];
    email = json['email'];
    regions = json['regions'];
    country = json['country'];
    nationality = json['nationality'];
    dateCreated = json['dateCreated'];
    visits = json['visits'];
    age = json['age'];
    profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prefix'] = this.prefix;
    data['userId'] = this.userId;
    data['firstName'] = this.firstName;
    data['fatherName'] = this.fatherName;
    data['lastName'] = this.lastName;
    data['motherName'] = this.motherName;
    data['emergencyContactName'] = this.emergencyContactName;
    data['emergencyContactMobile'] = this.emergencyContactMobile;
    data['emergencyContactEmail'] = this.emergencyContactEmail;
    data['sex'] = this.sex;
    data['dob'] = this.dob;
    data['bloodType'] = this.bloodType;
    data['placeOfBirth'] = this.placeOfBirth;
    data['countryOfBirth'] = this.countryOfBirth;
    data['address'] = this.address;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['regions'] = this.regions;
    data['country'] = this.country;
    data['nationality'] = this.nationality;
    data['dateCreated'] = this.dateCreated;
    data['visits'] = this.visits;
    data['age'] = this.age;
    data['profilePicture'] = this.profilePicture;
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
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    offset = json['offset'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['offset'] = this.offset;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['paged'] = this.paged;
    data['unpaged'] = this.unpaged;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sorted'] = this.sorted;
    data['unsorted'] = this.unsorted;
    data['empty'] = this.empty;
    return data;
  }
}
