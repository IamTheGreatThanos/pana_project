class User {
  int? id;
  String? surname;
  String? name;
  String? avatar;
  String? phone;
  int? phoneCode;
  int? status;
  int? cityId;
  int? roleId;
  String? birthDate;
  String? email;
  String? emailVerifiedAt;
  String? gender;
  String? organizationName;
  String? jobPosition;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.surname,
      this.name,
      this.avatar,
      this.phone,
      this.phoneCode,
      this.status,
      this.cityId,
      this.roleId,
      this.birthDate,
      this.email,
      this.emailVerifiedAt,
      this.gender,
      this.organizationName,
      this.jobPosition,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    surname = json['surname'];
    name = json['name'];
    avatar = json['avatar'];
    phone = json['phone'];
    phoneCode = json['phone_code'];
    status = json['status'];
    cityId = json['city_id'];
    roleId = json['role_id'];
    birthDate = json['birth_date'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    gender = json['gender'];
    organizationName = json['organization_name'];
    jobPosition = json['job_position'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['surname'] = surname;
    data['name'] = name;
    data['avatar'] = avatar;
    data['phone'] = phone;
    data['phone_code'] = phoneCode;
    data['status'] = status;
    data['city_id'] = cityId;
    data['role_id'] = roleId;
    data['birth_date'] = birthDate;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['gender'] = gender;
    data['organization_name'] = organizationName;
    data['job_position'] = jobPosition;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
