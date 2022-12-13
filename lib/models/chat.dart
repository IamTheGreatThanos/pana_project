import 'package:pana_project/models/chatMessage.dart';
import 'package:pana_project/models/user.dart';

class ChatModel {
  int? chatId;
  User? user;
  ChatMessageModel? lastMessage;
  int? countNewMessages;

  ChatModel({this.chatId, this.user, this.lastMessage, this.countNewMessages});

  ChatModel.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    lastMessage = json['last_message'] != null
        ? ChatMessageModel.fromJson(json['last_message'])
        : null;
    countNewMessages = json['count_new_messages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_id'] = chatId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (lastMessage != null) {
      data['last_message'] = lastMessage!.toJson();
    }
    data['count_new_messages'] = countNewMessages;
    return data;
  }
}
