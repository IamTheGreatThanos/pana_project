import 'package:pana_project/models/answers.dart';
import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/models/images.dart';
import 'package:pana_project/models/user.dart';

class AudioReviewModel {
  int? id;
  User? user;
  int? status;
  HousingDetailModel? housing;
  Null? impression;
  String? audio;
  Null? description;
  int? price;
  int? purity;
  int? staff;
  int? ball;
  List<Answers>? answers;
  List<Images>? images;
  int? likeCount;
  String? createdAt;

  AudioReviewModel(
      {this.id,
      this.user,
      this.status,
      this.housing,
      this.impression,
      this.audio,
      this.description,
      this.price,
      this.purity,
      this.staff,
      this.ball,
      this.answers,
      this.images,
      this.likeCount,
      this.createdAt});

  AudioReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    status = json['status'];
    housing = json['housing'] != null
        ? HousingDetailModel.fromJson(json['housing'])
        : null;
    impression = json['impression'];
    audio = json['audio'];
    description = json['description'];
    price = json['price'];
    purity = json['purity'];
    staff = json['staff'];
    ball = json['ball'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(Answers.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    likeCount = json['like_count'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['status'] = status;
    if (housing != null) {
      data['housing'] = housing!.toJson();
    }
    data['impression'] = impression;
    data['audio'] = audio;
    data['description'] = description;
    data['price'] = price;
    data['purity'] = purity;
    data['staff'] = staff;
    data['ball'] = ball;
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['like_count'] = likeCount;
    data['created_at'] = createdAt;
    return data;
  }
}
