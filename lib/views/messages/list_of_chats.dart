import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/chat_card.dart';
import 'package:pana_project/models/chat.dart';
import 'package:pana_project/services/messages_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/messages/chat_messages_page.dart';
import 'package:pana_project/views/messages/support_chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ListOfChatsPage extends StatefulWidget {
  @override
  _ListOfChatsPageState createState() => _ListOfChatsPageState();
}

class _ListOfChatsPageState extends State<ListOfChatsPage> {
  bool isHaveNewMessages = true;
  int newMessageCount = 2;
  int myUserId = 0;

  List<ChatModel> listOfChats = [];

  late IO.Socket socket;

  bool isHaveSupportChat = false;
  ChatModel supportChat = ChatModel();

  bool isLoading = true;

  @override
  void initState() {
    getChats();
    getSupportChat();
    getUserId();
    super.initState();
  }

  void getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myUserId = prefs.getInt('user_id') ?? 0;
    setState(() {});

    socketInit();
  }

  void socketInit() {
    socket = IO.io('https://back.pana.world:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      socket.emit('join', myUserId);
    });

    socket.on('chat', (newMessage) async {
      getChats();
      getSupportChat();
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
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Список чатов',
                          style: TextStyle(
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
                listOfChats.isNotEmpty
                    ? Container(color: Colors.white, child: const Divider())
                    : const SizedBox(),
                isHaveSupportChat
                    ? GestureDetector(
                        onTap: () {
                          goToSupportChat();
                        },
                        child: ChatCard(supportChat, true))
                    : Container(),
                isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Загрузка...',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackWithOpacity,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                for (int i = 0; i < listOfChats.length; i++)
                  GestureDetector(
                      onTap: () {
                        goToChat(listOfChats[i]);
                      },
                      child: ChatCard(listOfChats[i], false)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getChats() async {
    listOfChats = [];

    var response = await MessagesProvider().getListOfChats();
    if (response['response_status'] == 'ok') {
      List<ChatModel> tempList = [];
      for (int i = 0; i < response['data'].length; i++) {
        tempList.add(ChatModel.fromJson(response['data'][i]));
      }
      listOfChats = tempList;
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void getSupportChat() async {
    try {
      var responseSupport = await MessagesProvider().getListOfChatsSupport();
      print(responseSupport);

      if (responseSupport['response_status'] == 'ok') {
        isHaveSupportChat = true;
        supportChat = ChatModel.fromJson(responseSupport['data']);
        if (mounted) {
          setState(() {});
        }
      }
    } catch (error) {
      isHaveSupportChat = false;
      if (mounted) {
        setState(() {});
      }
      print(error);
    }
  }

  void goToChat(ChatModel chat) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatMessagesPage(chat),
      ),
    );

    getChats();
    getSupportChat();
  }

  void goToSupportChat() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupportChatPage(),
      ),
    );

    getChats();
    getSupportChat();
  }
}
