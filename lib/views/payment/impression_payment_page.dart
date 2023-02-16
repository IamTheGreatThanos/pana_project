import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/payment_method_card.dart';
import 'package:pana_project/models/creditCard.dart';
import 'package:pana_project/models/impressionDetail.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/ImpressionData.dart';
import 'package:pana_project/utils/checkReviewsCount.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/views/home/tabbar_page.dart';
import 'package:pana_project/views/impression/impression_sessions.dart';
import 'package:pana_project/views/other/create_credit_card_page.dart';
import 'package:slide_to_act/slide_to_act.dart';

class ImpressionPaymentPage extends StatefulWidget {
  ImpressionPaymentPage(
      this.impression, this.startDate, this.endDate, this.impressionData);
  final ImpressionDetailModel impression;
  final String startDate;
  final String endDate;
  final ImpressionData impressionData;

  @override
  _ImpressionPaymentPageState createState() => _ImpressionPaymentPageState();
}

class _ImpressionPaymentPageState extends State<ImpressionPaymentPage> {
  var _switchValue = false;
  double sum = 0;
  String dateFrom = '-';
  String dateTo = '-';
  List<CreditCard> cards = [];
  int selectedCardIndex = 0;

  @override
  void initState() {
    if (widget.startDate != '') {
      dateFrom = widget.startDate;
      dateTo = widget.endDate;
    }

    calcSum();
    super.initState();
  }

  @override
  void dispose() {
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
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
                                offset:
                                    Offset(0, 4), // changes position of shadow
                              ),
                            ],
                          ),
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
                          'Оплата',
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
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: SizedBox(
                          width: 86,
                          height: 86,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.impression.images?[0].path ?? '',
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              widget.impression.name ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              '${widget.impression.city?.name ?? ''}, ${widget.impression.city?.country?.name ?? ''}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: SvgPicture.asset(
                                        'assets/icons/star.svg'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    widget.impression.reviewsAvgBall ?? '0',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    checkReviewsCount(
                                        (widget.impression.reviewsCount ?? 0)
                                            .toString()),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black45),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Даты',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '$dateFrom / $dateTo',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Персоны',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${widget.impressionData.peopleCount} человек(а)',
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          showPeopleCountModalSheet();
                        },
                        child: const Text(
                          'Изменить',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Детализация цены',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // for (int i = 0; i < widget.roomList.length; i++)
                  //   Padding(
                  //     padding: const EdgeInsets.only(bottom: 8),
                  //     child: Row(
                  //       children: [
                  //         SizedBox(
                  //           width: MediaQuery.of(context).size.width * 0.7,
                  //           child: Text(
                  //             (widget.roomList[i].roomName?.name ?? '') +
                  //                 ' x ${widget.selectedRooms[i]['count']}',
                  //             style: const TextStyle(
                  //               fontSize: 14,
                  //               fontWeight: FontWeight.w500,
                  //               color: Colors.black45,
                  //             ),
                  //           ),
                  //         ),
                  //         const Spacer(),
                  //         Text(
                  //           '${formatNumberString(((widget.roomList[i].basePrice ?? 0) * widget.selectedRooms[i]['count']).toString())} \₸',
                  //           style: const TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  Row(
                    children: [
                      const Text(
                        'Итого',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${formatNumberString(sum.toString())} \₸',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Способ оплаты',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  for (int i = 0; i < cards.length; i++)
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            selectedCardIndex = i;
                            setState(() {});
                          },
                          child: PaymentMethodCard(
                            cards[i].type == 1
                                ? 'assets/icons/mastercard_icon.svg'
                                : 'assets/icons/visa_icon.svg',
                            '**** ${cards[i].number!.substring(15, 19)}',
                            '${cards[i].month}/${cards[i].year}',
                            i == selectedCardIndex,
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateCreditCardPage()));

                      getCreditCards();
                    },
                    child: const Text(
                      'Добавить карту',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: SvgPicture.asset(
                                  'assets/icons/bonus_icon.svg'),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Использовать бонусы',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '2156 тг',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.blackWithOpacity,
                                  ),
                                )
                              ],
                            ),
                            const Spacer(),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: _switchValue,
                                activeColor: AppColors.accent,
                                onChanged: (value) {
                                  setState(() {
                                    _switchValue = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      'Правила впечатления',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
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
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      'Правила впечатления',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Builder(
                      builder: (context) {
                        final GlobalKey<SlideActionState> _key = GlobalKey();
                        return SlideAction(
                          key: _key,
                          sliderButtonIcon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                          text: 'Проведите для оплаты',
                          textStyle: const TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          innerColor: AppColors.accent,
                          outerColor: AppColors.white,
                          onSubmit: () {
                            sendOrder(_key);
                          },
                        );
                      },
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

  void showPeopleCountModalSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.cardBorderRadius),
            topRight: Radius.circular(AppConstants.cardBorderRadius)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return ImpressionPeopleCountBottomSheet(widget.impressionData);
      },
    );

    setState(() {});
  }

  void calcSum() {
    // for (int i = 0; i < widget.roomList.length; i++) {
    //   sum += (widget.roomList[i].basePrice ?? 0) *
    //       widget.selectedRooms[i]['count'];
    // }
  }

  void sendOrder(GlobalKey<SlideActionState> _key) async {
    //   var response = await MainProvider().housingPayment(widget.housing.id!,
    //       dateFrom, dateTo, peopleCount, widget.selectedRooms);
    //   if (response['response_status'] == 'ok') {
    //     print('Successfully created!');
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content:
    //           Text(response['data']['message'], style: const TextStyle(fontSize: 14)),
    //     ));
    //   }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Впечатление успешно забронировано!',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );

    Future.delayed(
      const Duration(seconds: 3),
      () => _key.currentState!.reset(),
    ).whenComplete(() => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => TabBarPage()),
        (Route<dynamic> route) => false));
  }

  void getCreditCards() async {
    var response = await MainProvider().getCards();
    if (response['response_status'] == 'ok') {
      List<CreditCard> thisCards = [];
      for (int i = 0; i < response['data'].length; i++) {
        CreditCard thisCard = CreditCard.fromJson(response['data'][i]);
        thisCards.add(thisCard);
        if (thisCard.isDefault == 1) {
          selectedCardIndex = i;
        }
      }

      cards = thisCards;
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
