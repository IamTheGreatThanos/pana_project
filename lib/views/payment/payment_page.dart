import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/components/payment_method_card.dart';
import 'package:pana_project/models/creditCard.dart';
import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/models/impressionDetail.dart';
import 'package:pana_project/models/impressionSession.dart';
import 'package:pana_project/models/roomCard.dart';
import 'package:pana_project/services/housing_api_provider.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/checkNightCount.dart';
import 'package:pana_project/utils/checkReviewsCount.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/views/payment/epay_webview.dart';
import 'package:pana_project/views/payment/payment_information_page.dart';
import 'package:slide_to_act/slide_to_act.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage(this.roomList, this.selectedRooms, this.housing, this.startDate,
      this.endDate);
  final List<RoomCardModel> roomList;
  final List<Map<String, dynamic>> selectedRooms;
  final HousingDetailModel housing;
  final String startDate;
  final String endDate;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController commentController = TextEditingController();
  var _switchValue = false;
  double sum = 0;
  String dateFrom = '-';
  String dateTo = '-';
  List<CreditCard> cards = [];
  int selectedCardIndex = -1;
  int days = 0;
  int orderId = 0;

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
    int count = 0;
    int count2 = 0;
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
                            imageUrl: widget.housing.images?[0].path ?? '',
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
                              widget.housing.name ?? '',
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
                              '${widget.housing.city?.name ?? ''}, ${widget.housing.city?.country?.name ?? ''}',
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
                                (widget.housing.reviewsBallAvg ?? '0') != '0'
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          widget.housing.reviewsBallAvg ?? '0',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    checkReviewsCount(
                                        (widget.housing.reviewsCount ?? 0)
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
                            dateFrom == dateTo
                                ? DateFormat("d MMM", 'ru')
                                    .format(DateTime.parse(dateFrom))
                                : '${DateFormat("d MMM", 'ru').format(DateTime.parse(dateFrom))} - ${DateFormat("d MMM", 'ru').format(DateTime.parse(dateTo))}',
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
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  Row(
                    children: [
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
                            '${sharedHousingPaymentData.adults + sharedHousingPaymentData.children} гостя${sharedHousingPaymentData.babies != 0 ? ', ${sharedHousingPaymentData.babies} младенца' : ''}${sharedHousingPaymentData.pets != 0 ? ', ${sharedHousingPaymentData.pets} питомца' : ''}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                          ),
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
                  const SizedBox(height: 5),
                  const Divider(),
                  for (int i = 0; i < widget.roomList.length; i++)
                    for (int j = 0; j < widget.selectedRooms[i]['count']; j++)
                      Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Номер №${count += 1}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      widget.roomList[i].roomName?.name ?? '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Divider(),
                        ],
                      ),

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
                  for (int i = 0; i < widget.roomList.length; i++)
                    for (int j = 0; j < widget.selectedRooms[i]['count']; j++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showRoomPrices(i);
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  '${count2 += 1}. ${widget.roomList[i].roomName?.name ?? ''} x ${checkNightCount(days.toString())}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black45,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${formatNumberString(((widget.roomList[i].basePrice ?? 0) * days).toString())} \₸',
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
                  widget.housing.guestPayCheckIn == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                'Альтернативные методы',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackWithOpacity,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                selectedCardIndex = -1;
                                setState(() {});
                              },
                              child: PaymentMethodCard(
                                  'assets/icons/payment_type_in_a_place.svg',
                                  'Оплата при заселении',
                                  'Нужно оплатить на ресепшене',
                                  -1 == selectedCardIndex,
                                  true),
                            ),
                            const Divider(),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(height: 10),
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
                  // TODO: Bonus system
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  //   child: Container(
                  //     decoration: const BoxDecoration(
                  //         color: AppColors.lightGray,
                  //         borderRadius: BorderRadius.all(Radius.circular(8))),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(10),
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 40,
                  //             height: 40,
                  //             child: SvgPicture.asset(
                  //                 'assets/icons/bonus_icon.svg'),
                  //           ),
                  //           const SizedBox(width: 10),
                  //           Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: const [
                  //               Text(
                  //                 'Оплата с помощью Асыков',
                  //                 style: TextStyle(
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.w500,
                  //                 ),
                  //               ),
                  //               Text(
                  //                 '2156 тг',
                  //                 style: TextStyle(
                  //                   fontSize: 14,
                  //                   color: AppColors.blackWithOpacity,
                  //                 ),
                  //               )
                  //             ],
                  //           ),
                  //           const Spacer(),
                  //           Transform.scale(
                  //             scale: 0.8,
                  //             child: CupertinoSwitch(
                  //               value: _switchValue,
                  //               activeColor: AppColors.accent,
                  //               onChanged: (value) {
                  //                 setState(() {
                  //                   _switchValue = value;
                  //                 });
                  //               },
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: commentController,
                      maxLines: 8,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(
                          color: AppColors.blackWithOpacity,
                        ),
                        hintText: "Добавьте заметку владельцу (по желанию)",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            width: 1,
                            color: AppColors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            width: 1,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      'Заезд/Выезд',
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
                      child: Text(
                        'Заезд в ${widget.housing.checkInFrom?.substring(0, 5) ?? ''}, выезд до ${widget.housing.checkOutFrom?.substring(0, 5) ?? ''}',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45),
                      ),
                    ),
                  ),
                  const Divider(),
                  // const Padding(
                  //   padding: EdgeInsets.only(top: 20, bottom: 10),
                  //   child: Text(
                  //     'Правила дома',
                  //     style: TextStyle(
                  //       fontSize: 24,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 20),
                  //   child: SizedBox(
                  //     width: MediaQuery.of(context).size.width * 0.9,
                  //     child: const Text(
                  //       'Отклонение проецирует суммарный поворот. Гировертикаль, в силу третьего закона Ньютона, даёт большую проекцию на оси, чем тангаж. Ротор безусловно заставляет иначе взглянуть на то, что такое уходящий ньютонометр, сводя задачу к квадратурам.',
                  //       style: TextStyle(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w500,
                  //           color: Colors.black45),
                  //     ),
                  //   ),
                  // ),
                  // const Divider(),
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
                          onSubmit: () async {
                            // TODO: Submit action
                            // await Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => ReceiptPage(
                            //       widget.housing,
                            //       widget.startDate,
                            //       widget.endDate,
                            //       sharedHousingPaymentData.adults +
                            //           sharedHousingPaymentData.children,
                            //       sharedHousingPaymentData.babies,
                            //       sharedHousingPaymentData.pets,
                            //       widget.roomList,
                            //       widget.selectedRooms,
                            //       days,
                            //       sum.toString(),
                            //     ),
                            //   ),
                            // );
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

  void calcSum() {
    DateTime dateFromFormatted = DateTime.parse(dateFrom);
    DateTime dateToFormatted = DateTime.parse(dateTo);

    Duration difference = dateToFormatted.difference(dateFromFormatted);
    days = difference.inDays;

    if (dateFromFormatted == dateToFormatted) {
      days = 1;
    }

    sum = 0;

    for (int i = 0; i < widget.roomList.length; i++) {
      sum += (widget.roomList[i].basePrice ?? 0) *
          widget.selectedRooms[i]['count'] *
          days;
    }
  }

  void sendOrder(GlobalKey<SlideActionState> _key) async {
    var paymentPermissionResponse =
        await MainProvider().requestPaymentPermission();
    if (paymentPermissionResponse['data']['is_public'] == true) {
      if (selectedCardIndex == -1) {
        var response = await HousingProvider().housingPayment(
          widget.housing.id!,
          dateFrom,
          dateTo,
          sharedHousingPaymentData.adults,
          sharedHousingPaymentData.children,
          sharedHousingPaymentData.babies,
          sharedHousingPaymentData.pets,
          widget.selectedRooms,
          -1,
          commentController.text,
        );
        if (response['response_status'] == 'ok') {
          orderId = response['data']['order_id'];
          showSuccessfullyPaySheet();

          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //   content: Text('Жилье успешно забронировано!',
          //       style: const TextStyle(fontSize: 14)),
          // ));
          //
          // Future.delayed(
          //   const Duration(seconds: 3),
          //   () => _key.currentState!.reset(),
          // ).whenComplete(() => Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) => TabBarPage()),
          //     (Route<dynamic> route) => false));
        } else {
          _key.currentState!.reset();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response['data']['message'],
                style: const TextStyle(fontSize: 14)),
          ));
        }
      } else if (selectedCardIndex == -2) {
        var response = await HousingProvider().housingPayment(
          widget.housing.id!,
          dateFrom,
          dateTo,
          sharedHousingPaymentData.adults,
          sharedHousingPaymentData.children,
          sharedHousingPaymentData.babies,
          sharedHousingPaymentData.pets,
          widget.selectedRooms,
          -2,
          commentController.text,
        );

        // print(response);

        if (response['response_status'] == 'ok') {
          orderId = response['data']['order_id'];
          goToEPay(_key, response['data']);
        } else {
          _key.currentState!.reset();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response['data']['message'],
                style: const TextStyle(fontSize: 14)),
          ));
        }
      } else {
        if (cards.isNotEmpty) {
          // TODO: Payment
          var response = await HousingProvider().housingPayment(
            widget.housing.id!,
            dateFrom,
            dateTo,
            sharedHousingPaymentData.adults,
            sharedHousingPaymentData.children,
            sharedHousingPaymentData.babies,
            sharedHousingPaymentData.pets,
            widget.selectedRooms,
            cards[selectedCardIndex].id!,
            commentController.text,
          );

          if (response['response_status'] == 'ok') {
            orderId = response['data']['order_id'];
            // print(response['data']);
            showSuccessfullyPaySheet();

            //   String acsUrl =
            //       response['data']['payment_operation']['acs_url'].toString();
            //   String transactionId = response['data']['payment_operation']
            //           ['transaction_id']
            //       .toString();
            //   String paReq =
            //       response['data']['payment_operation']['pa_req'].toString();
            //
            //   final result = await Cloudpayments.show3ds(
            //       acsUrl: acsUrl, transactionId: transactionId, paReq: paReq);
            //
            //   if (result?.success == true) {
            //     var response3ds = await HousingProvider()
            //         .housingPaymentSend3ds(result!.md!, result.paRes!);
            //     if (response3ds['response_status'] == 'ok') {
            //       showSuccessfullyPaySheet();
            //
            //       // Future.delayed(
            //       //   const Duration(seconds: 3),
            //       //   () => _key.currentState!.reset(),
            //       // ).whenComplete(() => Navigator.of(context).pushAndRemoveUntil(
            //       //     MaterialPageRoute(builder: (context) => TabBarPage()),
            //       //     (Route<dynamic> route) => false));
            //     } else {
            //       _key.currentState!.reset();
            //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //         content: Text(response3ds['data']['message'],
            //             style: const TextStyle(fontSize: 14)),
            //       ));
            //     }
            //   }
          } else {
            _key.currentState!.reset();
            showPaymentErrorSheet();
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text(response['data']['payment_operation']['message'],
            //       style: const TextStyle(fontSize: 14)),
            // ));
          }

          // TODO: End ----------------------
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
    } else if (response == '') {
      _key.currentState?.reset();
      return;
    } else {
      _key.currentState?.reset();
      showPaymentErrorSheet();
    }
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
        return HousingPaymentBottomSheet();
      },
    );

    calcSum();

    setState(() {});
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

  void showRoomPrices(int index) async {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.cardBorderRadius),
            topRight: Radius.circular(AppConstants.cardBorderRadius)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: SizedBox(
            // height: 370,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      children: [
                        const Text(
                          'Разбивка базовой цены',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                            color: AppColors.blackWithOpacity,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  for (var item in widget.roomList[index].roomPrices ?? [])
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey, width: 1),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Text(
                                item.date,
                                style: const TextStyle(
                                  color: AppColors.blackWithOpacity,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${formatNumberString(item.price.toString())} тг',
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Row(
                      children: [
                        const Text(
                          'Итоговая базовая цена:',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${formatNumberString(widget.roomList[index].basePrice.toString())} тг',
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
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
                          'Поздравляем! Вы успешно забронировали “${widget.housing.name ?? ''}”',
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PaymentInformationPage(
                                      true,
                                      ImpressionDetailModel(),
                                      ImpressionSessionModel(),
                                      sharedHousingPaymentData.adults +
                                          sharedHousingPaymentData.children,
                                      0,
                                      widget.roomList,
                                      widget.selectedRooms,
                                      days,
                                      sum.toString(),
                                      widget.housing,
                                      sharedHousingPaymentData.babies,
                                      sharedHousingPaymentData.pets,
                                      widget.startDate,
                                      widget.endDate,
                                      selectedCardIndex == -1
                                          ? 1
                                          : selectedCardIndex == -2
                                              ? 2
                                              : 3,
                                      selectedCardIndex < 0
                                          ? ''
                                          : cards[selectedCardIndex]
                                              .number!
                                              .substring(9, 13),
                                      selectedCardIndex < 0
                                          ? ''
                                          : cards[selectedCardIndex].type ?? '',
                                      orderId,
                                    )));
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

class HousingPaymentData {
  int adults = 1;
  int children = 0;
  int babies = 0;
  int pets = 0;

  void minusFunctionAdult() {
    if (adults > 1) {
      adults -= 1;
    }
  }

  void plusFunctionAdult() {
    if (adults < 99) {
      adults += 1;
    }
  }

  void minusFunctionChildren() {
    if (children > 0) {
      children -= 1;
    }
  }

  void plusFunctionChildren() {
    if (children < 99) {
      children += 1;
    }
  }

  void minusFunctionBabies() {
    if (babies > 0) {
      babies -= 1;
    }
  }

  void plusFunctionBabies() {
    if (babies < 99) {
      babies += 1;
    }
  }

  void minusFunctionPets() {
    if (pets > 0) {
      pets -= 1;
    }
  }

  void plusFunctionPets() {
    if (pets < 99) {
      pets += 1;
    }
  }
}

HousingPaymentData sharedHousingPaymentData = HousingPaymentData();

class HousingPaymentBottomSheet extends StatefulWidget {
  @override
  _HousingPaymentBottomSheetState createState() =>
      _HousingPaymentBottomSheetState();
}

class _HousingPaymentBottomSheetState extends State<HousingPaymentBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        // height: 300,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Выберите число гостей:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(width: 1, color: AppColors.grey)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Взрослые',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          sharedHousingPaymentData.minusFunctionAdult();
                          setState(() {});
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: const Icon(Icons.remove),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          sharedHousingPaymentData.adults.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sharedHousingPaymentData.plusFunctionAdult();
                          setState(() {});
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(width: 1, color: AppColors.grey)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Дети',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'От 4 лет',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackWithOpacity,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          sharedHousingPaymentData.minusFunctionChildren();
                          setState(() {});
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: const Icon(Icons.remove),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          sharedHousingPaymentData.children.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sharedHousingPaymentData.plusFunctionChildren();
                          setState(() {});
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(width: 1, color: AppColors.grey)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Младенцы',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Младше 4 лет',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackWithOpacity,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          sharedHousingPaymentData.minusFunctionBabies();
                          setState(() {});
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: const Icon(Icons.remove),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          sharedHousingPaymentData.babies.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sharedHousingPaymentData.plusFunctionBabies();
                          setState(() {});
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(width: 1, color: AppColors.grey)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Домашние животные',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          sharedHousingPaymentData.minusFunctionPets();
                          setState(() {});
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: const Icon(Icons.remove),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          sharedHousingPaymentData.pets.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sharedHousingPaymentData.plusFunctionPets();
                          setState(() {});
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // <-- Radius
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Продолжить",
                    style: TextStyle(
                      color: Colors.white,
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
    );
  }
}
