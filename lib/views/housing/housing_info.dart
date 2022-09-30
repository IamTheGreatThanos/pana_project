import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/audio_review_card.dart';
import 'package:pana_project/components/impression_card.dart';
import 'package:pana_project/components/stories_card.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/other/audio_reviews_page.dart';
import 'package:pana_project/views/payment/payment_page.dart';

class HousingInfo extends StatefulWidget {
  // HousingInfo(this.product);
  // final Product product;

  @override
  _HousingInfoState createState() => _HousingInfoState();
}

class _HousingInfoState extends State<HousingInfo> {
  int lenOfList = 5;
  int indexOfImage = 1;

  @override
  void initState() {
    super.initState();
  }

  void imageChanged(int index) async {
    setState(() {
      indexOfImage = index + 1;
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
                        child: CarouselSlider.builder(
                          options: CarouselOptions(
                            height: 300,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: false,
                            // autoPlayInterval: const Duration(seconds: 3),
                            // autoPlayAnimationDuration:
                            //     const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: false,
                            onPageChanged: (index, reason) {
                              imageChanged(index);
                            },
                            scrollDirection: Axis.horizontal,
                          ),
                          itemCount: lenOfList,
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              CachedNetworkImage(
                            fit: BoxFit.fitHeight,
                            imageUrl:
                                'https://images.unsplash.com/photo-1568605114967-8130f3a36994?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 260,
                          left: MediaQuery.of(context).size.width - 70,
                        ),
                        child: Container(
                          width: 48,
                          height: 23,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            color: AppColors.black,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$indexOfImage / $lenOfList',
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
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
                                  child: SvgPicture.asset(
                                      'assets/icons/share.svg'),
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
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Домик на берегу моря',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    children: const [
                      Padding(
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
                          'Almaty, Kazakhstan',
                          style: TextStyle(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
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
                      child: const Text(
                        'Отклонение проецирует суммарный поворот. Гировертикаль, в силу третьего закона Ньютона, даёт большую проекцию на оси, чем тангаж. Ротор безусловно заставляет иначе взглянуть на то, что такое уходящий ньютонометр, сводя задачу к квадратурам.',
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
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/check.svg'),
                                const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Wi-fi',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black45,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/check.svg'),
                                const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Кондиционер',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black45,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/check.svg'),
                                const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Фен',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black45,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
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
                  const Divider(),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, bottom: 10),
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
                        padding: const EdgeInsets.only(
                            top: 10, left: 20, bottom: 10),
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
                        padding: const EdgeInsets.only(
                            top: 10, left: 20, bottom: 10),
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
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
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
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, bottom: 10),
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
                                  '\$324',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: AppColors.black),
                                ),
                                Text(
                                  ' за ночь',
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
                                      builder: (context) => PaymentPage()));
                            },
                            child: const Text(
                              "Забронировать",
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
        ));
  }
}
