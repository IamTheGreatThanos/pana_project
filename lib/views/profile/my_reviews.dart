import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/my_audio_review_card.dart';
import 'package:pana_project/components/my_text_review_card.dart';
import 'package:pana_project/models/audioReview.dart';
import 'package:pana_project/models/textReview.dart';
import 'package:pana_project/services/profile_api_provider.dart';
import 'package:pana_project/utils/const.dart';

class MyReviewsPage extends StatefulWidget {
  @override
  _MyReviewsPageState createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  TextEditingController phoneController = TextEditingController();

  List<TextReviewModel> textReviews = [];
  List<AudioReviewModel> audioReviews = [];

  @override
  void initState() {
    getTextReviews();
    getAudioReviews();
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
                              audioReviews.isNotEmpty
                                  ? ListView(
                                      children: [
                                        for (int i = 0;
                                            i < audioReviews.length;
                                            i++)
                                          MyAudioReviewCard(audioReviews[i]),
                                        const SizedBox(height: 20)
                                      ],
                                    )
                                  : const Center(
                                      child: Text('Аудио отзывов пока нет...'),
                                    ),
                              // TODO: Текстовые отзывы
                              textReviews.isNotEmpty
                                  ? ListView(
                                      children: [
                                        for (int i = 0;
                                            i < textReviews.length;
                                            i++)
                                          MyTextReviewCard(textReviews[i]),
                                        const SizedBox(height: 20)
                                      ],
                                    )
                                  : const Center(
                                      child: Text('Отзывов пока нет...'),
                                    )
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

  void getTextReviews() async {
    textReviews = [];
    var response = await ProfileProvider().getTextReviews();
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        textReviews.add(TextReviewModel.fromJson(response['data'][i]));
      }
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

  void getAudioReviews() async {
    audioReviews = [];
    var response = await ProfileProvider().getAudioReviews();
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        audioReviews.add(AudioReviewModel.fromJson(response['data'][i]));
      }
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
}
