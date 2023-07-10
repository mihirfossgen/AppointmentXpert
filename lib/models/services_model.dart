class ServicesModel {
  int? id;
  String? name;
  String? description;
  String? category;
  List<Packages>? packages;

  ServicesModel(
      {this.id, this.name, this.description, this.category, this.packages});

  ServicesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
    if (json['packages'] != null) {
      packages = <Packages>[];
      json['packages'].forEach((v) {
        packages!.add(new Packages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['category'] = this.category;
    if (this.packages != null) {
      data['packages'] = this.packages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Packages {
  int? id;
  String? packageName;
  int? serviceId;
  String? serviceName;
  int? price;
  bool? active;

  Packages(
      {this.id,
      this.packageName,
      this.serviceId,
      this.serviceName,
      this.price,
      this.active});

  Packages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageName = json['packageName'];
    serviceId = json['serviceId'];
    serviceName = json['serviceName'];
    price = json['price'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['packageName'] = this.packageName;
    data['serviceId'] = this.serviceId;
    data['serviceName'] = this.serviceName;
    data['price'] = this.price;
    data['active'] = this.active;
    return data;
  }
}
