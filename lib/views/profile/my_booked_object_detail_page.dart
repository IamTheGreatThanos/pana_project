import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/models/chat.dart';
import 'package:pana_project/models/order.dart';
import 'package:pana_project/models/reels.dart';
import 'package:pana_project/services/housing_api_provider.dart';
import 'package:pana_project/services/impression_api_provider.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/views/home/tabbar_page.dart';
import 'package:pana_project/views/messages/chat_messages_page.dart';
import 'package:pana_project/views/profile/my_reviews.dart';
import 'package:pana_project/views/travel/send_text_review.dart';

class MyBookedObjectDetailPage extends StatefulWidget {
  MyBookedObjectDetailPage(this.type, this.order);
  final int type;
  final Order order;

  @override
  _MyBookedObjectDetailPageState createState() =>
      _MyBookedObjectDetailPageState();
}

class _MyBookedObjectDetailPageState extends State<MyBookedObjectDetailPage> {
  List<Reels> reels = [];

  @override
  void initState() {
    getReels();
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
                Container(color: AppColors.white, height: 30),
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
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
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          widget.type == 2 ? 'Жилье' : 'Впечатление',
                          style: const TextStyle(
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
                ),
                const Divider(height: 2),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                        bottomRight:
                            Radius.circular(AppConstants.cardBorderRadius),
                        bottomLeft:
                            Radius.circular(AppConstants.cardBorderRadius)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
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
                                  imageUrl: widget.type == 2
                                      ? widget.order.housing?.images![0].path ??
                                          ''
                                      : widget.order.impression?.images?[0]
                                              .path ??
                                          '',
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    widget.type == 2
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    '${widget.type == 2 ? widget.order.housing?.city?.name ?? '' : widget.order.impression?.city?.name ?? ''} , ${widget.type == 2 ? widget.order.housing?.country?.name ?? '' : widget.order.impression?.country?.name ?? ''}',
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
                                        padding:
                                            const EdgeInsets.only(bottom: 2),
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
                                          widget.type == 2
                                              ? widget
                                                  .order.housing!.reviewsAvgBall
                                                  .toString()
                                              : widget.order.impression!
                                                  .reviewsAvgBall
                                                  .toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          '${widget.type == 2 ? widget.order.housing?.reviewsCount ?? '0' : widget.order.impression?.reviewsCount ?? '0'} Отзывов',
                                          style: TextStyle(
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
                            const Spacer(),
                            Container(
                              width: 162,
                              height: 83,
                              decoration: const BoxDecoration(
                                color: AppColors.lightGray,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.type == 2
                                        ? widget.order.dateFrom
                                                ?.substring(0, 10) ??
                                            '-'
                                        : widget.order.dateFrom
                                                ?.substring(0, 10) ??
                                            '-',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Заезд',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 162,
                              height: 83,
                              decoration: const BoxDecoration(
                                color: AppColors.lightGray,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.type == 2
                                        ? widget.order.dateTo
                                                ?.substring(0, 10) ??
                                            '-'
                                        : widget.order.dateTo
                                                ?.substring(0, 10) ??
                                            '-',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Выезд',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const Divider(height: 40),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: widget.type == 2
                                    ? widget.order.housing?.user?.avatar ?? ''
                                    : widget.order.impression?.user?.avatar ??
                                        '',
                                height: 44,
                                width: 44,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: const Text(
                                        'Забронировал(а)',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.blackWithOpacity,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        '${widget.type == 2 ? widget.order.housing?.user?.name ?? '' : widget.order.impression?.user?.name ?? ''} ${widget.type == 2 ? widget.order.housing?.user?.surname ?? '' : widget.order.impression?.user?.surname ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatMessagesPage(
                                          ChatModel(
                                            user: widget.type == 2
                                                ? widget.order.housing?.user
                                                : widget.order.impression?.user,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: Image.asset(
                                          'assets/icons/start_chat_icon.png')),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // TODO: Stories
                // const SizedBox(height: 20),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   decoration: BoxDecoration(
                //     color: AppColors.white,
                //     borderRadius: BorderRadius.all(
                //       Radius.circular(AppConstants.cardBorderRadius),
                //     ),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(20),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         const Text(
                //           'Видео с локации',
                //           style: TextStyle(
                //             fontSize: 18,
                //             fontWeight: FontWeight.w500,
                //           ),
                //           textAlign: TextAlign.center,
                //         ),
                //         const SizedBox(height: 20),
                //         Container(
                //           margin: const EdgeInsets.symmetric(
                //               vertical: 20, horizontal: 10),
                //           height: 150,
                //           child: ListView(
                //             scrollDirection: Axis.horizontal,
                //             children: <Widget>[
                //               GestureDetector(
                //                 onTap: () async {
                //                   await Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                       builder: (context) =>
                //                           ReelsVideoSelectionPage(
                //                               widget.type == 2
                //                                   ? 'housing'
                //                                   : 'impression',
                //                               widget.type == 2
                //                                   ? widget.order.housing!
                //                                   : HousingCardModel(),
                //                               widget.type == 2
                //                                   ? ImpressionCardModel()
                //                                   : widget.order.impression!,
                //                               false),
                //                     ),
                //                   );
                //
                //                   getReels();
                //                 },
                //                 child: DottedBorder(
                //                   color: AppColors.accent,
                //                   strokeWidth: 1,
                //                   dashPattern: const [6, 2],
                //                   strokeCap: StrokeCap.round,
                //                   borderType: BorderType.RRect,
                //                   radius: const Radius.circular(8),
                //                   child: Container(
                //                     width: 85,
                //                     height: 150,
                //                     decoration: const BoxDecoration(
                //                       color: AppColors.white,
                //                     ),
                //                     child: Column(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.center,
                //                       children: const [
                //                         Icon(Icons.add,
                //                             color: AppColors.accent),
                //                         Text(
                //                           'Добавить',
                //                           style: TextStyle(
                //                               fontSize: 12,
                //                               fontWeight: FontWeight.w500,
                //                               color: AppColors.accent),
                //                           textAlign: TextAlign.center,
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               const SizedBox(width: 5),
                //               for (int i = 0; i < reels.length; i++)
                //                 StoriesCard(reels, i),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppConstants.cardBorderRadius),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Оставить отзыв',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyReviewsPage()));
                              },
                              child: const Text(
                                'Мои отзывы',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.accent,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Spacer(),
                            // TODO: Audio review page.
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) =>
                            //                 SendAudioReviewPage(
                            //                     widget.type,
                            //                     widget.type == 2
                            //                         ? widget.order.housing!.id!
                            //                         : widget.order.impression!
                            //                             .id!)));
                            //   },
                            //   child: Container(
                            //     width: 162,
                            //     height: 83,
                            //     decoration: const BoxDecoration(
                            //       color: AppColors.lightGray,
                            //       borderRadius: BorderRadius.all(
                            //         Radius.circular(8),
                            //       ),
                            //     ),
                            //     child: Column(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       crossAxisAlignment: CrossAxisAlignment.center,
                            //       children: [
                            //         SvgPicture.asset(
                            //             'assets/icons/micro_icon.svg'),
                            //         const SizedBox(height: 5),
                            //         const Text(
                            //           'Голосовой',
                            //           style: TextStyle(
                            //             fontSize: 14,
                            //             fontWeight: FontWeight.w500,
                            //             color: Colors.black,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SendTextReviewPage(
                                                widget.type,
                                                widget.type == 2
                                                    ? widget.order.housing!.id!
                                                    : widget
                                                        .order.impression!.id!,
                                                widget.type == 2
                                                    ? widget.order.dateFrom!
                                                    : widget.order.dateFrom!)));
                              },
                              child: Container(
                                // width: 162,
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 83,
                                decoration: const BoxDecoration(
                                  color: AppColors.lightGray,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/icons/text_icon.svg'),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Текстовый',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      requestReturnPrice();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'Отменить бронирование',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void cancelOrder() async {
    var response = await HousingProvider().cancelOrder(widget.order.id!);
    if (response['response_status'] == 'ok') {
      showSuccessfullyCanceledSheet();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void getReels() async {
    reels = [];
    if (widget.type == 2) {
      var response =
          await HousingProvider().getReelsById(widget.order.housing!.id!);
      if (response['response_status'] == 'ok') {
        for (int i = 0; i < response['data'].length; i++) {
          reels.add(Reels.fromJson(response['data'][i]));
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
    } else {
      var response =
          await ImpressionProvider().getReelsById(widget.order.impression!.id!);
      if (response['response_status'] == 'ok') {
        for (int i = 0; i < response['data'].length; i++) {
          reels.add(Reels.fromJson(response['data'][i]));
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

  void requestReturnPrice() async {
    var response =
        await MainProvider().requestOrderReturnPrices(widget.order.id!);
    if (response['response_status'] == 'ok') {
      var returnPrice =
          double.parse(response['data']['refund_price'].toString());
      var totalPrice = double.parse(response['data']['total_price'].toString());
      showCancelingConfirmation(returnPrice, totalPrice);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void showSuccessfullyCanceledSheet() async {
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
            height: 400,
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
                height: 400,
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
                          'Поздравляем! Вы успешно отменили свое бронирование, средства за бронирование будут отправлены вам, в течение дня!',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.8,
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

  void showCancelingConfirmation(double returnPrice, double totalPrice) async {
    var returnPercent =
        (returnPrice / (totalPrice == 0 ? 1 : totalPrice) * 100).toInt();
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
            height: 400,
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
                height: 400,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const Text(
                          'Отменить бронирование?',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Вы уверены, что хотите отменить бронь? Для отмены брони штраф составит ${totalPrice == 0 ? 0 : 100 - returnPercent}% (${formatNumberString((totalPrice - returnPrice).toString())}₸). Остальная сумма вернется вам на карту',
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: AppColors.grey,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Сумма к возврату: $returnPercent% (${formatNumberString(returnPrice.toString())}₸)',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const Spacer(),
                          SizedBox(
                            height: 60,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Не отменять",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 60,
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
                                if (returnPrice != '0') {
                                  Navigator.of(context).pop();
                                  cancelOrder();
                                }
                              },
                              child: const Text(
                                "Да,отменить",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      )
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
