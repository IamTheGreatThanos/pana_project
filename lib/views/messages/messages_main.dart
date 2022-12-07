import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/messages_card.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/messages/list_of_chats.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  bool isHaveNewMessages = true;
  int newMessageCount = 2;

  @override
  void initState() {
    super.initState();
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                        bottomRight:
                            Radius.circular(AppConstants.cardBorderRadius),
                        bottomLeft:
                            Radius.circular(AppConstants.cardBorderRadius)),
                  ),
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
                          color: isHaveNewMessages
                              ? AppColors.accent
                              : AppColors.black,
                          child: Row(
                            children: [
                              const SizedBox(width: 20),
                              SizedBox(
                                  width: 34,
                                  height: 34,
                                  child: SvgPicture.asset(
                                      'assets/icons/m_message_${isHaveNewMessages ? '1' : '0'}.svg')),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.72,
                                child: Text(
                                  isHaveNewMessages
                                      ? '$newMessageCount новых сообщения'
                                      : 'Нет новых сообщений',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      for (int i = 0; i < 3; i++)
                        const MessagesWidget(
                          title: 'Добро пожаловать в Италию!',
                          subtitle: '10.20.2022',
                          status: true,
                          categoryId: 1,
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
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
                      for (int i = 0; i < 3; i++)
                        const MessagesWidget(
                          title: 'Скидка 20% на добавления нового места в Pana',
                          subtitle: '10.20.2022',
                          status: false,
                          categoryId: 1,
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
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
    );
  }

  void goToChats() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListOfChatsPage(),
      ),
    );

    setState(() {});
  }
}
