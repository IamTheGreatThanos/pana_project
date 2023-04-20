class Country {
  int? id;
  String? name;
  int? phoneCode;

  Country({this.id, this.name, this.phoneCode});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneCode = json['phone_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone_code'] = phoneCode;
    return data;
  }
}
