import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/messages_card.dart';
import 'package:pana_project/models/notification.dart';
import 'package:pana_project/services/messages_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/auth/auth_page.dart';
import 'package:pana_project/views/messages/list_of_chats.dart';
import 'package:pana_project/views/messages/notification_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage(this.onButtonPressed);
  final void Function() onButtonPressed;
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  int newMessageCount = 0;

  List<NotificationModel> newNotifications = [];
  List<NotificationModel> oldNotifications = [];

  @override
  void initState() {
    checkIsLogedIn();

    super.initState();
  }

  Future<void> _pullRefresh() async {
    getNotifications();
    readNotification();
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
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: AppColors.white,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                          child: Text(
                            'Новые уведомления',
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: goToChats,
                          child: Container(
                            height: 70,
                            color: newMessageCount != 0
                                ? AppColors.accent
                                : AppColors.black,
                            child: Row(
                              children: [
                                const SizedBox(width: 20),
                                SizedBox(
                                    width: 34,
                                    height: 34,
                                    child: SvgPicture.asset(
                                        'assets/icons/m_message_${newMessageCount != 0 ? '1' : '0'}.svg')),
                                const SizedBox(width: 10),
                                SizedBox(
                                  height: 70,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.72,
                                        child: const Text(
                                          'Список чатов',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.72,
                                        child: Text(
                                          newMessageCount != 0
                                              ? '$newMessageCount новых сообщения'
                                              : 'Нет новых сообщений',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  newNotifications.isNotEmpty
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(
                                    AppConstants.cardBorderRadius),
                                bottomLeft: Radius.circular(
                                    AppConstants.cardBorderRadius)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0; i < newNotifications.length; i++)
                                GestureDetector(
                                    onTap: () {
                                      goToNotificationDetail(
                                          newNotifications[i]);
                                    },
                                    child: MessagesWidget(
                                        newNotifications[i], true)),
                              const SizedBox(height: 20),
                            ],
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 20),
                  oldNotifications.isNotEmpty
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppConstants.cardBorderRadius),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                                child: Text(
                                  'Просмотренно',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              for (int i = 0; i < oldNotifications.length; i++)
                                GestureDetector(
                                    onTap: () {
                                      goToNotificationDetail(
                                          oldNotifications[i]);
                                    },
                                    child: MessagesWidget(
                                        oldNotifications[i], false)),
                              const SizedBox(height: 20),
                            ],
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        SvgPicture.asset('assets/images/smile.svg'),
                        const SizedBox(height: 10),
                        const Text(
                          'Вы долистали до конца',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void goToChats() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListOfChatsPage(),
      ),
    );

    getNotifications();
  }

  void goToNotificationDetail(NotificationModel notification) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailPage(notification),
      ),
    );

    getNotifications();
  }

  void getNotifications() async {
    var response = await MessagesProvider().getNotifications();
    if (response['response_status'] == 'ok') {
      print(response['data']);
      int messageCount = 0;
      List<NotificationModel> tempList1 = [];
      List<NotificationModel> tempList2 = [];
      for (int i = 0; i < response['data']['new'].length; i++) {
        NotificationModel notification =
            NotificationModel.fromJson(response['data']['new'][i]);
        if (notification.type == 1) {
          messageCount += 1;
        } else {
          tempList1.add(notification);
        }
      }
      for (int i = 0; i < response['data']['old'].length; i++) {
        NotificationModel notification =
            NotificationModel.fromJson(response['data']['old'][i]);
        tempList2.add(notification);
      }
      if (mounted) {
        newMessageCount = messageCount;
        newNotifications = tempList1;
        oldNotifications = tempList2;
        setState(() {});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void readNotification() async {
    var response = await MessagesProvider().readNotification();
    if (response['response_status'] == 'ok') {
      print('Readed');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void checkIsLogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogedIn') == true) {
      readNotification();
      getNotifications();
      setState(() {});
    } else {
      showAlertDialog(context);
    }
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Отмена"),
      onPressed: () {
        widget.onButtonPressed();
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Да"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AuthPage()));
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Внимание"),
      content: const Text("Вы не вошли в аккаунт. Войти?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).whenComplete(() => widget.onButtonPressed());
  }
}
