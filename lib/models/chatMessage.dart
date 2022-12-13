import 'package:pana_project/models/user.dart';

class ChatMessageModel {
  int? messageId;
  int? chatId;
  User? user;
  String? isRead;
  String? text;
  String? createdAt;

  ChatMessageModel(
      {this.messageId,
      this.chatId,
      this.user,
      this.isRead,
      this.text,
      this.createdAt});

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    messageId = json['message_id'];
    chatId = json['chat_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    isRead = json['is_read'];
    text = json['text'];
    createdAt = json['created_at'];
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
    return data;
  }
}
