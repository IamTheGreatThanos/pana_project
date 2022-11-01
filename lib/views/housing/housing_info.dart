import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/audio_review_card.dart';
import 'package:pana_project/components/facilities_widget.dart';
import 'package:pana_project/components/impression_card.dart';
import 'package:pana_project/components/stories_card.dart';
import 'package:pana_project/models/housingCard.dart';
import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/housing/select_room_page.dart';
import 'package:pana_project/views/other/audio_reviews_page.dart';
import 'package:pana_project/views/other/media_detail_page.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class HousingInfo extends StatefulWidget {
  HousingInfo(this.housing);
  final HousingCardModel housing;

  @override
  _HousingInfoState createState() => _HousingInfoState();
}

class _HousingInfoState extends State<HousingInfo> {
  final storyController = StoryController();

  HousingDetailModel thisHousing = HousingDetailModel();

  @override
  void initState() {
    getHousingInfo();
    super.initState();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            // height: 1200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: StoryView(
                          storyItems: [
                            StoryItem.pageImage(
                              url:
                                  "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
                              controller: storyController,
                              imageFit: BoxFit.fitHeight,
                            ),
                            StoryItem.pageImage(
                              url:
                                  "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
                              controller: storyController,
                              imageFit: BoxFit.fitHeight,
                            ),
                            StoryItem.pageImage(
                              url:
                                  "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
                              controller: storyController,
                              imageFit: BoxFit.fitHeight,
                            ),
                            StoryItem.pageImage(
                              url:
                                  "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
                              controller: storyController,
                              imageFit: BoxFit.fitHeight,
                            ),
                          ],
                          onStoryShow: (s) {},
                          onComplete: () {},
                          progressPosition: ProgressPosition.bottom,
                          repeat: true,
                          controller: storyController,
                          onVerticalSwipeComplete: (direction) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MediaDetailPage()));
                          },
                        )
                        // CarouselSlider.builder(
                        //   options: CarouselOptions(
                        //     height: 300,
                        //     aspectRatio: 16 / 9,
                        //     viewportFraction: 1,
                        //     initialPage: 0,
                        //     enableInfiniteScroll: true,
                        //     reverse: false,
                        //     autoPlay: false,
                        //     // autoPlayInterval: const Duration(seconds: 3),
                        //     // autoPlayAnimationDuration:
                        //     //     const Duration(milliseconds: 800),
                        //     autoPlayCurve: Curves.fastOutSlowIn,
                        //     enlargeCenterPage: false,
                        //     onPageChanged: (index, reason) {
                        //       imageChanged(index);
                        //     },
                        //     scrollDirection: Axis.horizontal,
                        //   ),
                        //   itemCount: lenOfList,
                        //   itemBuilder: (BuildContext context, int itemIndex,
                        //           int pageViewIndex) =>
                        //       CachedNetworkImage(
                        //     fit: BoxFit.fitHeight,
                        //     imageUrl:
                        //         'https://images.unsplash.com/photo-1568605114967-8130f3a36994?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80',
                        //   ),
                        // ),
                        ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 0,
                                    blurRadius: 24,
                                    offset: Offset(
                                        0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                    'assets/icons/back_arrow.svg'),
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 0,
                                    blurRadius: 24,
                                    offset: Offset(
                                        0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child:
                                    SvgPicture.asset('assets/icons/share.svg'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 0,
                                    blurRadius: 24,
                                    offset: Offset(
                                        0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                    'assets/icons/heart_empty.svg'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    thisHousing.name != null ? thisHousing.name! : '',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        '324 км от вас',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        '${thisHousing.city!.name}, Kazakhstan',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2, left: 20),
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: SvgPicture.asset('assets/icons/star.svg'),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          '4.9',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          '18 Отзывов',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=2000',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Dinmukhammed Muslim',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.only(bottom: 2, left: 5),
                              //   child: SizedBox(
                              //     width: 15,
                              //     height: 15,
                              //     child: SvgPicture.asset(
                              //         'assets/icons/star.svg'),
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Здание целиком, 3 комнаты, 2 этажа',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Text(
                    'Описание',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      thisHousing.description!,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45),
                    ),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Text(
                    'Удобства',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 10),
                  child: Row(
                    children: const [
                      FacilitiesWidget(title: 'Wi-Fi'),
                      SizedBox(width: 10),
                      FacilitiesWidget(title: 'Кондиционер'),
                      SizedBox(width: 10),
                      FacilitiesWidget(title: 'Фен'),
                    ],
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Text(
                    'Расположение',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.9 / 1.23,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                      color: Colors.orange[50],
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Row(
                    children: const [
                      Text(
                        'Отзывы',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Перейти',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, bottom: 10),
                      child: Row(
                        children: const [
                          Text(
                            'Цена/Качество',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '5.0',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 20),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 0, left: 20, bottom: 10, right: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        child: LinearProgressIndicator(
                          backgroundColor: AppColors.grey,
                          color: AppColors.accent,
                          minHeight: 3,
                          value: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, bottom: 10),
                      child: Row(
                        children: const [
                          Text(
                            'Чистота',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '4.6',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 20),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 0, left: 20, bottom: 10, right: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        child: LinearProgressIndicator(
                          backgroundColor: AppColors.grey,
                          color: AppColors.accent,
                          minHeight: 3,
                          value: 4.6 / 5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Text(
                    'Истории с этого места',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (int i = 0; i < 6; i++) StoriesCard(i),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Row(
                    children: [
                      const Text(
                        'Аудио-отзывы',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AudioReviewsPage()));
                        },
                        child: const Text(
                          'Перейти',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: AudioReviewCard(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: AudioReviewCard(),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Text(
                    'Впечатления рядом',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ImpressionCard(),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Text(
                    'Свободные даты',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: const Text(
                      '28 сен. - 2 окт.',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45),
                    ),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Text(
                    'Правила дома',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: const Text(
                      'Заезд до 13:00, выезд до 12:00',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45),
                    ),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Text(
                    'Правила отмены',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: const Text(
                      'Отклонение проецирует суммарный поворот. Гировертикаль, в силу третьего закона Ньютона, даёт большую проекцию на оси, чем тангаж. Ротор безусловно заставляет иначе взглянуть на то, что такое уходящий ньютонометр, сводя задачу к квадратурам.',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'от \$324',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: AppColors.black),
                              ),
                              Text(
                                ' за сутки',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.black45),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '12-14 июля',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.black,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 48,
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectRoomPage()));
                          },
                          child: const Text(
                            "Выбрать номер",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getHousingInfo() async {
    var response = await MainProvider().getHousingDetail(widget.housing.id!);
    if (response['response_status'] == 'ok') {
      setState(() {
        thisHousing = HousingDetailModel.fromJson(response['data']);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(response['message'], style: const TextStyle(fontSize: 20)),
      ));
    }
  }
}
