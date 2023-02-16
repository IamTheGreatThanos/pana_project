import 'package:pana_project/models/user.dart';

class Answers {
  int? id;
  int? reviewId;
  User? user;
  String? description;
  String? createdAt;
  String? updatedAt;

  Answers(
      {this.id,
      this.reviewId,
      this.user,
      this.description,
      this.createdAt,
      this.updatedAt});

  Answers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reviewId = json['review_id'];
    user = User.fromJson(json['user']);
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['review_id'] = this.reviewId;
    data['user'] = this.user;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
