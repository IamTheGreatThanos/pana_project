import 'package:pana_project/models/user.dart';

class ChatMessageModel {
  int? messageId;
  int? chatId;
  User? user;
  String? isRead;
  String? text;
  String? createdAt;
  List<Files>? files;

  ChatMessageModel({
    this.messageId,
    this.chatId,
    this.user,
    this.isRead,
    this.text,
    this.createdAt,
    this.files,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    messageId = json['message_id'];
    chatId = json['chat_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    isRead = json['is_read'];
    text = json['text'];
    createdAt = json['created_at'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message_id'] = messageId;
    data['chat_id'] = chatId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['is_read'] = isRead;
    data['text'] = text;
    data['created_at'] = createdAt;
    if (this.files != null) {
      data['files'] = this.files!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Files {
  int? id;
  int? chatMessageId;
  String? path;
  String? createdAt;
  String? updatedAt;

  Files(
      {this.id, this.chatMessageId, this.path, this.createdAt, this.updatedAt});

  Files.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatMessageId = json['chat_message_id'];
    path = json['path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chat_message_id'] = this.chatMessageId;
    data['path'] = this.path;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
