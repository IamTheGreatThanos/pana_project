import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/payment_method_card.dart';
import 'package:pana_project/models/creditCard.dart';
import 'package:pana_project/models/impressionDetail.dart';
import 'package:pana_project/models/impressionSession.dart';
import 'package:pana_project/services/impression_api_provider.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/ImpressionData.dart';
import 'package:pana_project/utils/checkReviewsCount.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/views/home/tabbar_page.dart';
import 'package:pana_project/views/impression/impression_sessions.dart';
import 'package:pana_project/views/payment/epay_webview.dart';
import 'package:slide_to_act/slide_to_act.dart';

class ImpressionPaymentPage extends StatefulWidget {
  ImpressionPaymentPage(
    this.impression,
    this.startDate,
    this.endDate,
    this.impressionData,
    this.session,
    this.type,
  );
  final ImpressionDetailModel impression;
  final String startDate;
  final String endDate;
  final ImpressionData impressionData;
  final ImpressionSessionModel session;
  final int type;

  @override
  _ImpressionPaymentPageState createState() => _ImpressionPaymentPageState();
}

class _ImpressionPaymentPageState extends State<ImpressionPaymentPage> {
  var _switchValue = false;
  double sum = 0;
  String dateFrom = '-';
  String dateTo = '-';
  List<CreditCard> cards = [];
  int selectedCardIndex = -2;

  @override
  void initState() {
    if (widget.startDate != '') {
      dateFrom = widget.startDate;
      dateTo = widget.endDate;
    }

    calcSum();
    getCreditCards();
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            'Сеанс x ${widget.impressionData.peopleCount}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${formatNumberString((((widget.type == 1 ? widget.session.openPrice ?? 0 : widget.session.closedPrice ?? 0)) * widget.impressionData.peopleCount).toString())} \₸',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        '${formatNumberString(((widget.type == 1 ? widget.session.openPrice ?? 0 : widget.session.closedPrice ?? 0) * widget.impressionData.peopleCount).toString())} \₸',
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
                            cards[i].type == 'VISA'
                                ? 'assets/icons/visa_icon.svg'
                                : 'assets/icons/mastercard_icon.svg',
                            '**** ${cards[i].number!.substring(9, 13)}',
                            '${cards[i].month}/${cards[i].year}',
                            i == selectedCardIndex,
                            false,
                          ),
                        ),
                        const Divider(),
                        // const SizedBox(height: 10),
                      ],
                    ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          selectedCardIndex = -2;
                          setState(() {});
                        },
                        child: PaymentMethodCard(
                          'assets/icons/payment_card.svg',
                          'Оплата новой картой',
                          '',
                          selectedCardIndex == -2,
                          false,
                        ),
                      ),
                      const Divider(),
                      // const SizedBox(height: 10),
                    ],
                  ),
                  // GestureDetector(
                  //   onTap: () async {
                  //     await Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => CreateCreditCardPage()));
                  //
                  //     getCreditCards();
                  //   },
                  //   child: Container(
                  //     width: double.infinity,
                  //     height: 51,
                  //     decoration: const BoxDecoration(
                  //       borderRadius: BorderRadius.all(
                  //         Radius.circular(12),
                  //       ),
                  //       color: AppColors.lightGray,
                  //     ),
                  //     child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         SvgPicture.asset('./assets/icons/payment_card.svg'),
                  //         const SizedBox(width: 10),
                  //         const Text(
                  //           'Добавить карту',
                  //           style: TextStyle(
                  //             fontSize: 14,
                  //             fontWeight: FontWeight.w500,
                  //             color: AppColors.accent,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
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
                          text: 'Проведите для бронирования',
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
        return ImpressionPeopleCountBottomSheet(
          session: widget.session,
          impression: widget.impression,
          startDate: widget.startDate,
          endDate: widget.endDate,
          impressionData: widget.impressionData,
          isPrivate: widget.type,
          fromSearch: true,
        );
      },
    );

    setState(() {});
  }

  void calcSum() {
    sum += (widget.session.openPrice ?? 0) * widget.impressionData.peopleCount;
  }

  void sendOrder(GlobalKey<SlideActionState> _key) async {
    var paymentPermissionResponse =
        await MainProvider().requestPaymentPermission();
    if (paymentPermissionResponse['data']['is_public'] == true) {
      if (selectedCardIndex == -2) {
        var response = await ImpressionProvider().impressionPayment(
          widget.impression.id!,
          dateFrom,
          dateTo,
          widget.impressionData.peopleCount,
          widget.session.id!,
          widget.type,
          -2,
        );
        if (response['response_status'] == 'ok') {
          goToEPay(_key, response['data']);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response['data']['message'],
                style: const TextStyle(fontSize: 14)),
          ));
        }
      } else {
        if (cards.isNotEmpty) {
          var response = await ImpressionProvider().impressionPayment(
            widget.impression.id!,
            dateFrom,
            dateTo,
            widget.impressionData.peopleCount,
            widget.session.id!,
            widget.type,
            cards[selectedCardIndex].id!,
          );
          if (response['response_status'] == 'ok'
              // && response['data']['payment_operation']['status'] == 1
              ) {
            showSuccessfullyPaySheet();
            // String acsUrl =
            //     response['data']['payment_operation']['acs_url'].toString();
            // String transactionId = response['data']['payment_operation']
            //         ['transaction_id']
            //     .toString();
            // String paReq =
            //     response['data']['payment_operation']['pa_req'].toString();
            //
            // final result = await Cloudpayments.show3ds(
            //     acsUrl: acsUrl, transactionId: transactionId, paReq: paReq);
            //
            // if (result?.success == true) {
            //   var response3ds = await ImpressionProvider()
            //       .impressionPaymentSend3ds(result!.md!, result.paRes!);
            //   if (response3ds['response_status'] == 'ok') {
            //     showSuccessfullyPaySheet();
            //   } else {
            //     _key.currentState!.reset();
            //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //       content: Text(response3ds['data']['message'],
            //           style: const TextStyle(fontSize: 14)),
            //     ));
            //   }
            // }
          } else {
            _key.currentState!.reset();
            showPaymentErrorSheet();
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text(response['data']['payment_operation']['message'],
            //       style: const TextStyle(fontSize: 14)),
            // ));
          }
        } else {
          _key.currentState!.reset();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text("Добавьте способ оплаты.", style: TextStyle(fontSize: 14)),
          ));
        }
      }
    } else {
      _key.currentState!.reset();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Извините, ведутся технические работы, попробуйте позже.",
            style: TextStyle(fontSize: 14)),
      ));
    }
  }

  // TODO: Go to payment widget

  void goToEPay(
      GlobalKey<SlideActionState> _key, Map<String, dynamic> data) async {
    var response = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => EpayWebViewPage(data)));

    if (response == 'Success') {
      showSuccessfullyPaySheet();
    } else {
      _key.currentState?.reset();
      showPaymentErrorSheet();
    }
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

  void showSuccessfullyPaySheet() async {
    widget.impressionData.peopleCount = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.cardBorderRadius),
            topRight: Radius.circular(AppConstants.cardBorderRadius)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            // height: 400,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      SvgPicture.asset('assets/icons/big_checkmark.svg'),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const Text(
                          'Бронирование прошло успешно',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          'Поздравляем! Вы успешно забронировали “${widget.impression.name ?? ''}”',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
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
                                imageUrl:
                                    widget.impression.images?[0].path ?? '',
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
                                            (widget.impression.reviewsCount ??
                                                    0)
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Column(
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
                          ),
                          const SizedBox(width: 20, child: VerticalDivider()),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Гости',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${widget.impressionData.peopleCount} человек(а)',
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
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Способ оплаты:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackWithOpacity,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              SvgPicture.asset(selectedCardIndex == -1
                                  ? 'assets/icons/payment_type_in_a_place.svg'
                                  : selectedCardIndex == -2
                                      ? 'assets/icons/payment_card.svg'
                                      : cards[selectedCardIndex].type == 'VISA'
                                          ? 'assets/icons/visa_icon.svg'
                                          : 'assets/icons/mastercard_icon.svg'),
                              const SizedBox(width: 10),
                              Text(
                                selectedCardIndex == -1
                                    ? 'Оплата при заселении'
                                    : selectedCardIndex == -2
                                        ? 'Новой картой'
                                        : '**** ${cards[selectedCardIndex].number!.substring(9, 13)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => TabBarPage(2)),
                                (Route<dynamic> route) => false);
                          },
                          child: const Text(
                            "Отлично!",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showPaymentErrorSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.cardBorderRadius),
            topRight: Radius.circular(AppConstants.cardBorderRadius)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            // height: 400,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      SvgPicture.asset('assets/icons/big_checkmark.svg'),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: const Text(
                          'Оплата не прошла',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: const Text(
                          'Возникли проблемы, у вас на счету не хватает средств для оплаты, повторите попытку или выберите другой способ оплаты',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Способ оплаты:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackWithOpacity,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              SvgPicture.asset(selectedCardIndex == -1
                                  ? 'assets/icons/payment_type_in_a_place.svg'
                                  : selectedCardIndex == -2
                                      ? 'assets/icons/payment_card.svg'
                                      : cards[selectedCardIndex].type == 'VISA'
                                          ? 'assets/icons/visa_icon.svg'
                                          : 'assets/icons/mastercard_icon.svg'),
                              const SizedBox(width: 10),
                              Text(
                                selectedCardIndex == -1
                                    ? 'Оплата при заселении'
                                    : selectedCardIndex == -2
                                        ? 'Новой картой'
                                        : '**** ${cards[selectedCardIndex].number!.substring(9, 13)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Повторить",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
