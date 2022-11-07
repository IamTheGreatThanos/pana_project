class Videos {
  int? id;
  int? housingId;
  String? path;
  int? position;

  Videos({this.id, this.housingId, this.path, this.position});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    housingId = json['housing_id'];
    path = json['path'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['housing_id'] = housingId;
    data['path'] = path;
    data['position'] = position;
    return data;
  }
}
