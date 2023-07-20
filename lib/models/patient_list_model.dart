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
        content!.add(Content.fromJson(v));
      });
    }
    pageable = json['pageable'] != null
        ? Pageable.fromJson(json['pageable'])
        : null;
    last = json['last'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    first = json['first'];
    size = json['size'];
    number = json['number'];
    sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    numberOfElements = json['numberOfElements'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    if (pageable != null) {
      data['pageable'] = pageable!.toJson();
    }
    data['last'] = last;
    data['totalPages'] = totalPages;
    data['totalElements'] = totalElements;
    data['first'] = first;
    data['size'] = size;
    data['number'] = number;
    if (sort != null) {
      data['sort'] = sort!.toJson();
    }
    data['numberOfElements'] = numberOfElements;
    data['empty'] = empty;
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
    profilePicture = json['uploadedProfilePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['prefix'] = prefix;
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['fatherName'] = fatherName;
    data['lastName'] = lastName;
    data['motherName'] = motherName;
    data['emergencyContactName'] = emergencyContactName;
    data['emergencyContactMobile'] = emergencyContactMobile;
    data['emergencyContactEmail'] = emergencyContactEmail;
    data['sex'] = sex;
    data['dob'] = dob;
    data['bloodType'] = bloodType;
    data['placeOfBirth'] = placeOfBirth;
    data['countryOfBirth'] = countryOfBirth;
    data['address'] = address;
    data['mobile'] = mobile;
    data['email'] = email;
    data['regions'] = regions;
    data['country'] = country;
    data['nationality'] = nationality;
    data['dateCreated'] = dateCreated;
    data['visits'] = visits;
    data['age'] = age;
    data['uploadedProfilePath'] = profilePicture;
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
