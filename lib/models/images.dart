class Images {
  int? id;
  int? housingId;
  String? path;

  Images({this.id, this.housingId, this.path});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    housingId = json['housing_id'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['housing_id'] = housingId;
    data['path'] = path;
    return data;
  }
}
