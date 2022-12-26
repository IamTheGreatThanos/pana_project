import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/chat_message_card.dart';
import 'package:pana_project/models/chat.dart';
import 'package:pana_project/models/chatMessage.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatMessagesPage extends StatefulWidget {
  ChatMessagesPage(this.chat);
  final ChatModel chat;
  @override
  _ChatMessagesPageState createState() => _ChatMessagesPageState();
}

class _ChatMessagesPageState extends State<ChatMessagesPage> {
  TextEditingController messageController = TextEditingController();
  ScrollController listViewController = ScrollController();
  List<ChatMessageModel> listOfMessages = [];
  int myUserId = 0;

  late IO.Socket socket;

  @override
  void initState() {
    getUserId();
    getMessages();
    readMessages();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myUserId = prefs.getInt('user_id') ?? 0;
    // print(prefs.getString('token'));
    setState(() {});

    socketInit();
  }

  void socketInit() {
    socket = IO.io('http://167.235.196.229:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket.onConnect((_) {
      print('Connected!');
      socket.emit('join', myUserId);
    });

    socket.on('chat_message', (newMessage) async {
      print(newMessage);
      getMessagesFromBackground();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(color: AppColors.white, height: 30),
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child:
                                SvgPicture.asset('assets/icons/back_arrow.svg'),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          '${widget.chat.user?.name ?? ''} ${widget.chat.user?.surname ?? ''}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ListView(
                    controller: listViewController,
                    shrinkWrap: true,
                    reverse: true,
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      for (int i = 0; i < listOfMessages.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Spacer(),
                              listOfMessages[i].user?.id != myUserId
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        child: SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: CachedNetworkImage(
                                            imageUrl: listOfMessages[i]
                                                    .user
                                                    ?.avatar ??
                                                '',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              const Spacer(),
                              ChatMessageCard(listOfMessages[i], myUserId),
                              const Spacer(),
                              listOfMessages[i].user?.id == myUserId
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        child: SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: CachedNetworkImage(
                                            imageUrl: listOfMessages[i]
                                                    .user
                                                    ?.avatar ??
                                                '',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              const Spacer(),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  color: AppColors.white,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(),
                          SvgPicture.asset('assets/icons/attach_icon.svg'),
                          const Spacer(),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 1, color: AppColors.grey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              child: TextField(
                                controller: messageController,
                                maxLength: 200,
                                style: const TextStyle(fontSize: 14),
                                decoration: const InputDecoration(
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
                                  border: InputBorder.none,
                                  hintText: 'Сообщение',
                                  hintStyle: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              if (messageController.text.isNotEmpty) {
                                sendMessage();
                              }
                            },
                            child: SvgPicture.asset(
                                'assets/icons/send_message_icon.svg'),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getMessages() async {
    var response = await MainProvider().getChatMessages(widget.chat.user!.id!);
    if (response['response_status'] == 'ok') {
      List<ChatMessageModel> tempList = [];
      for (int i = 0; i < response['data'].length; i++) {
        tempList.add(ChatMessageModel.fromJson(response['data'][i]));
      }
      listOfMessages = tempList;
      if (mounted) {
        setState(() {});
        listViewController.animateTo(
          listViewController.position.minScrollExtent,
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 300),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(response['message'], style: const TextStyle(fontSize: 20)),
      ));
    }
  }

  void getMessagesFromBackground() async {
    var response = await MainProvider().getChatMessages(widget.chat.user!.id!);
    if (response['response_status'] == 'ok') {
      List<ChatMessageModel> tempList = [];
      for (int i = 0; i < response['data'].length; i++) {
        tempList.add(ChatMessageModel.fromJson(response['data'][i]));
      }
      listOfMessages = tempList;
      if (mounted) {
        setState(() {});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(response['message'], style: const TextStyle(fontSize: 20)),
      ));
    }
  }

  void sendMessage() async {
    var response = await MainProvider()
        .sendMessageInChat(messageController.text, widget.chat.user!.id!);
    if (response['response_status'] == 'ok') {
      messageController.text = '';
      getMessages();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 20)),
      ));
    }
  }

  void readMessages() async {
    var response =
        await MainProvider().readMessageInChat(widget.chat.user!.id!);
    if (response['response_status'] == 'ok') {
      print('Readed');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 20)),
      ));
    }
  }
}
