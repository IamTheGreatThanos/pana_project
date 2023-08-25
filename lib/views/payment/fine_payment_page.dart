import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/payment_method_card.dart';
import 'package:pana_project/models/creditCard.dart';
import 'package:pana_project/models/receipt_order.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/checkReviewsCount.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/views/home/tabbar_page.dart';
import 'package:pana_project/views/payment/epay_webview.dart';
import 'package:slide_to_act/slide_to_act.dart';

class FinePaymentPage extends StatefulWidget {
  FinePaymentPage(
    this.order,
    this.finePrice,
  );
  final ReceiptOrder order;
  final double finePrice;

  @override
  _FinePaymentPageState createState() => _FinePaymentPageState();
}

class _FinePaymentPageState extends State<FinePaymentPage> {
  TextEditingController commentController = TextEditingController();
  List<CreditCard> cards = [];
  int selectedCardIndex = -1;
  int orderId = 0;

  @override
  void initState() {
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
                            imageUrl: widget.order.housing != null
                                ? (widget.order.housing!.images?[0].path ??
                                    AppConstants.imagePlaceholderUrl)
                                : (widget.order.impression!.images?[0].path ??
                                    AppConstants.imagePlaceholderUrl),
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
                              widget.order.housing != null
                                  ? widget.order.housing?.name ?? ''
                                  : widget.order.impression?.name ?? '',
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
                              widget.order.housing != null
                                  ? '${widget.order.housing?.city?.name ?? ''}, ${widget.order.housing?.country?.name ?? ''}'
                                  : '${widget.order.impression?.city?.name ?? ''}, ${widget.order.impression?.city?.country?.name ?? ''}',
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
                                    widget.order.housing != null
                                        ? widget.order.housing
                                                ?.reviewsBallAvg ??
                                            '0'
                                        : widget.order.impression
                                                ?.reviewsAvgBall ??
                                            '0',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    checkReviewsCount(
                                        (widget.order.housing != null
                                                ? widget.order.housing
                                                        ?.reviewsCount ??
                                                    0
                                                : widget.order.impression
                                                        ?.reviewsCount ??
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
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
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
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: const Text(
                            'Штраф за отмену бронирования:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${formatNumberString(widget.finePrice.toString())} \₸',
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
                        '${formatNumberString(widget.finePrice.toString())} \₸',
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'Карты',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackWithOpacity,
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
                    ],
                  ),
                  const SizedBox(height: 20),
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
                          onSubmit: () async {
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

  void sendOrder(GlobalKey<SlideActionState> _key) async {
    var paymentPermissionResponse =
        await MainProvider().requestPaymentPermission();
    if (paymentPermissionResponse['data']['is_public'] == true) {
      // if (selectedCardIndex == -2) {
      //   var response = await HousingProvider().housingPayment(
      //     widget.housing.id!,
      //     dateFrom,
      //     dateTo,
      //     sharedHousingPaymentData.adults,
      //     sharedHousingPaymentData.children,
      //     sharedHousingPaymentData.babies,
      //     sharedHousingPaymentData.pets,
      //     widget.selectedRooms,
      //     -2,
      //     commentController.text,
      //   );
      //
      //   if (response['response_status'] == 'ok') {
      //     orderId = response['data']['order_id'];
      //     goToEPay(_key, response['data']);
      //   } else {
      //     _key.currentState!.reset();
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       content: Text(response['data']['message'],
      //           style: const TextStyle(fontSize: 14)),
      //     ));
      //   }
      // } else {
      //   if (cards.isNotEmpty) {
      //     // TODO: Payment
      //     var response = await HousingProvider().housingPayment(
      //       widget.housing.id!,
      //       dateFrom,
      //       dateTo,
      //       sharedHousingPaymentData.adults,
      //       sharedHousingPaymentData.children,
      //       sharedHousingPaymentData.babies,
      //       sharedHousingPaymentData.pets,
      //       widget.selectedRooms,
      //       cards[selectedCardIndex].id!,
      //       commentController.text,
      //     );
      //
      //     if (response['response_status'] == 'ok') {
      //       orderId = response['data']['order_id'];
      //
      //       showSuccessfullyPaySheet();
      //     } else {
      //       _key.currentState!.reset();
      //       showPaymentErrorSheet();
      //     }
      //
      //     // TODO: End ----------------------
      //   } else {
      //     _key.currentState!.reset();
      //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //       content:
      //           Text("Добавьте способ оплаты.", style: TextStyle(fontSize: 14)),
      //     ));
      //   }
      // }
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
    } else if (response == '') {
      _key.currentState?.reset();
      return;
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
                          'Вы отменили бронирование',
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
                          'Вы успешно отменили свое бронирование',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
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
                                    builder: (context) =>
                                        TabBarPage(AppConstants.mainTabIndex)),
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
                          'Возникли проблемы, возможно у вас на счету не хватает средств для оплаты, повторите попытку или выберите другой способ оплаты',
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
                              SvgPicture.asset(selectedCardIndex == -2
                                  ? 'assets/icons/payment_card.svg'
                                  : cards[selectedCardIndex].type == 'VISA'
                                      ? 'assets/icons/visa_icon.svg'
                                      : 'assets/icons/mastercard_icon.svg'),
                              const SizedBox(width: 10),
                              Text(
                                selectedCardIndex == -2
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
                            '${formatNumberString(widget.finePrice.toString())} \₸',
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
