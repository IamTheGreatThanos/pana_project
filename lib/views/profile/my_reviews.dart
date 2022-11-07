import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/my_audio_review_card.dart';
import 'package:pana_project/components/my_text_review_card.dart';
import 'package:pana_project/utils/const.dart';

class MyReviewsPage extends StatefulWidget {
  @override
  _MyReviewsPageState createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  TextEditingController phoneController = TextEditingController();

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
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
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
                          'Мои отзывы',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 50)
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                    child: TabBar(
                      isScrollable: true,
                      indicatorColor: AppColors.accent,
                      labelColor: AppColors.black,
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      unselectedLabelColor: AppColors.blackWithOpacity,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(
                          text: 'Аудио-отзывы',
                        ),
                        Tab(
                          text: 'Текстовые',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: AppColors.lightGray,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 120,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 120,
                          child: TabBarView(
                            children: [
                              // TODO: Аудио отзывы
                              ListView(
                                children: [
                                  for (int i = 0; i < 10; i++)
                                    MyAudioReviewCard(),
                                  const SizedBox(height: 20)
                                ],
                              ),
                              // TODO: Текстовые отзывы
                              ListView(
                                children: [
                                  for (int i = 0; i < 10; i++)
                                    MyTextReviewCard(),
                                  const SizedBox(height: 20)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
