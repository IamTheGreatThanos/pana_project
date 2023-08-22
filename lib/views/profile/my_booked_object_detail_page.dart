import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/components/payment_method_card.dart';
import 'package:pana_project/models/chat.dart';
import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/models/impressionDetail.dart';
import 'package:pana_project/models/impressionSession.dart';
import 'package:pana_project/models/order.dart';
import 'package:pana_project/models/receipt_order.dart';
import 'package:pana_project/models/reels.dart';
import 'package:pana_project/services/housing_api_provider.dart';
import 'package:pana_project/services/impression_api_provider.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/PageTransitionRoute.dart';
import 'package:pana_project/utils/checkNightCount.dart';
import 'package:pana_project/utils/checkReviewsCount.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/views/home/tabbar_page.dart';
import 'package:pana_project/views/housing/housing_info.dart';
import 'package:pana_project/views/messages/chat_messages_page.dart';
import 'package:pana_project/views/payment/receipt_page.dart';
import 'package:pana_project/views/profile/my_reviews.dart';
import 'package:pana_project/views/travel/send_text_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

import '../impression/impression_info.dart';

class MyBookedObjectDetailPage extends StatefulWidget {
  MyBookedObjectDetailPage(this.type, this.order);
  final int type;
  final ReceiptOrder order;

  @override
  _MyBookedObjectDetailPageState createState() =>
      _MyBookedObjectDetailPageState();
}

class _MyBookedObjectDetailPageState extends State<MyBookedObjectDetailPage> {
  List<Reels> reels = [];
  int days = 0;
  double sum = 0;

  double returnPrice = 0;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    // getReels();
    calcSumAndDays();
    requestReturnPrice();
  }

  void calcSumAndDays() async {
    DateTime dateFromFormatted =
        DateTime.parse(widget.order.dateFrom ?? DateTime.now().toString());
    DateTime dateToFormatted =
        DateTime.parse(widget.order.dateTo ?? DateTime.now().toString());

    Duration difference = dateToFormatted.difference(dateFromFormatted);
    days = difference.inDays;

    if (dateFromFormatted == dateToFormatted) {
      days = 1;
    }

    sum = 0;

    for (int i = 0; i < (widget.order.roomNumbers?.length ?? 0); i++) {
      sum += (widget.order.roomNumbers?[i].price ?? 0) *
          (widget.order.roomNumbers?[i].count ?? 1) *
          days;
    }
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
        backgroundColor: AppColors.white,
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
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    // borderRadius: BorderRadius.only(
                    //     bottomRight:
                    //         Radius.circular(AppConstants.cardBorderRadius),
                    //     bottomLeft:
                    //         Radius.circular(AppConstants.cardBorderRadius)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: AppColors.lightGray,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text(
                              'Статус: ${widget.order.status == 1 ? '123' : '456'}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(children: [
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
                                        ? widget.order.housing?.images![0]
                                                .path ??
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
                                      widget.type == 2
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
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            widget.type == 2
                                                ? widget.order.housing!
                                                        .reviewsBallAvg ??
                                                    '0'
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
                                            widget.type == 2
                                                ? checkReviewsCount(widget
                                                    .order.housing!.reviewsCount
                                                    .toString())
                                                : checkReviewsCount(widget.order
                                                    .impression!.reviewsCount
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
                          widget.type == 2
                              ? Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          widget.order.dateFrom ==
                                                  widget.order.dateTo
                                              ? DateFormat("d MMM", 'ru')
                                                  .format(DateTime.parse(
                                                      widget.order.dateFrom ??
                                                          ''))
                                              : '${DateFormat("d MMM", 'ru').format(DateTime.parse(widget.order.dateFrom ?? ''))} - ${DateFormat("d MMM", 'ru').format(DateTime.parse(widget.order.dateTo ?? ''))}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Сеанс',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Text(
                                            widget.order.dateFrom ==
                                                    widget.order.dateTo
                                                ? '${DateFormat("d MMMM", 'ru').format(DateTime.parse(widget.order.dateFrom ?? ''))}, ${widget.order.timeStart?.substring(0, 5)} - ${widget.order.timeEnd?.substring(0, 5)}; ${widget.order.session?.type == 2 ? 'Закрытая группа' : 'Открытая группа'}'
                                                : '${DateFormat("d MMMM", 'ru').format(DateTime.parse(widget.order.dateFrom ?? ''))}, ${widget.order.timeStart?.substring(0, 5)} - ${DateFormat("d MMMM", 'ru').format(DateTime.parse(widget.order.dateTo ?? ''))}, ${widget.order.timeEnd?.substring(0, 5)}; ${widget.order.session?.type == 2 ? 'Закрытая группа' : 'Открытая группа'}',
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
                          const SizedBox(height: 5),
                          widget.type == 2
                              ? Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          '${(widget.order.adults ?? 0) + (widget.order.children ?? 0)} гостя, ${widget.order.babies} младенца, ${widget.order.pets} питомца',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Участники',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${widget.order.countPeople} человек(а)',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 5),
                          const Divider(),
                          for (int i = 0;
                              i < (widget.order.roomNumbers?.length ?? 0);
                              i++)
                            Column(
                              children: [
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Номер №${i + 1}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Text(
                                            widget.order.roomNumbers![i]
                                                    .roomName ??
                                                '',
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
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: widget.type == 2
                                      ? widget.order.housing?.user?.avatar ??
                                          AppConstants.imagePlaceholderUrl
                                      : widget.order.impression?.user?.avatar ??
                                          AppConstants.imagePlaceholderUrl,
                                  height: 64,
                                  width: 64,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Text(
                                          widget.type == 2
                                              ? widget.order.housing?.user
                                                      ?.name ??
                                                  ''
                                              : widget.order.impression?.user
                                                      ?.name ??
                                                  '',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: const Text(
                                          'Владелец',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.blackWithOpacity,
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
                                          builder: (context) =>
                                              ChatMessagesPage(
                                            ChatModel(
                                              user: widget.type == 2
                                                  ? widget.order.housing?.user
                                                  : widget
                                                      .order.impression?.user,
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
                          const SizedBox(height: 10),
                          const Divider(),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 2, color: AppColors.grey),
                                  borderRadius:
                                      BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              onPressed: () async {
                                if (widget.type == 2) {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? lat = prefs.getString('lastLat');
                                  String? lng = prefs.getString('lastLng');

                                  StoryController storyController =
                                      StoryController();
                                  List<StoryItem?> thisStoryItems = [];
                                  List<StoryItem?> mediaStoryItems = [];

                                  for (int j = 0;
                                      j < widget.order.housing!.images!.length;
                                      j++) {
                                    thisStoryItems.add(
                                      StoryItem.pageImage(
                                        url: widget
                                            .order.housing!.images![j].path!,
                                        controller: storyController,
                                        imageFit: BoxFit.cover,
                                      ),
                                    );

                                    mediaStoryItems.add(
                                      StoryItem.pageImage(
                                        url: widget
                                            .order.housing!.images![j].path!,
                                        controller: storyController,
                                        imageFit: BoxFit.fitWidth,
                                      ),
                                    );
                                  }

                                  await Navigator.push(
                                      context,
                                      ThisPageRoute(
                                        HousingInfo(
                                          widget.order.housing!.id!,
                                          thisStoryItems,
                                          mediaStoryItems,
                                          lat!,
                                          lng!,
                                          // housingList[i].distance == -1
                                          //     ? '-'
                                          //     : housingList[i]
                                          //         .distance
                                          //         .toString(),
                                          '',
                                          '',
                                        ),
                                      )
                                      // MaterialPageRoute(
                                      //     builder: (context) => HousingInfo(
                                      //         housingList[i].id!,
                                      //         thisStoryItems,
                                      //         mediaStoryItems))
                                      );
                                  setState(() {});
                                } else {
                                  StoryController _storyController =
                                      StoryController();
                                  List<StoryItem?> thisStoryItems = [];
                                  List<StoryItem?> mediaStoryItems = [];

                                  for (int j = 0;
                                      j <
                                          widget
                                              .order.impression!.images!.length;
                                      j++) {
                                    thisStoryItems.add(
                                      StoryItem.pageImage(
                                        url: widget
                                            .order.impression!.images![j].path!,
                                        controller: _storyController,
                                        imageFit: BoxFit.cover,
                                      ),
                                    );

                                    mediaStoryItems.add(
                                      StoryItem.pageImage(
                                        url: widget
                                            .order.impression!.images![j].path!,
                                        controller: _storyController,
                                        imageFit: BoxFit.fitWidth,
                                      ),
                                    );
                                  }

                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImpressionInfo(
                                        widget.order.impressionCard!,
                                        thisStoryItems,
                                        mediaStoryItems,
                                      ),
                                    ),
                                  );

                                  setState(() {});
                                }
                              },
                              child: const Text(
                                "Перейти к объекту",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ]),
                      ),
                      // TODO: Важная информация
                      widget.type == 2
                          ? ExpansionTile(
                              textColor: AppColors.black,
                              iconColor: AppColors.black,
                              title: const Text(
                                'Важная информация',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: const Text(
                                        'Время заезда:',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Text(
                                        'C ${widget.order.housing!.checkInFrom?.substring(0, 5) ?? ''} до ${widget.order.housing!.checkInBefore?.substring(0, 5) ?? ''}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Divider(),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: const Text(
                                        'Время отъезда:',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Text(
                                        'C ${widget.order.housing!.checkOutFrom?.substring(0, 5) ?? ''} до ${widget.order.housing!.checkOutBefore?.substring(0, 5) ?? ''}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Divider(),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: const Text(
                                        'Правила отмены',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Text(
                                        widget.order.housing!.cancelFineDay !=
                                                null
                                            ? 'Бесплатная отмена ${widget.order.housing!.cancelFineDay ?? ''} дней до заезда'
                                            : 'Бесплатная отмена',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Divider(),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: const Text(
                                        'Язык обслуживания:',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Text(
                                        '${widget.order.housing!.languages?.map((e) => e.name).join(', ')}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Divider(),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: const Text(
                                        'Парковка',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Text(
                                        widget.order.housing!.parking == 'no'
                                            ? 'Нет'
                                            : widget.order.housing!.parking ==
                                                    'yes_free'
                                                ? 'Бесплатная, ${widget.order.housing!.parkingLocation == 'inside' ? 'на территории объекта' : 'за пределами территории объекта'}'
                                                : 'Платная, ${widget.order.housing!.parkingLocation == 'inside' ? 'на территории объекта' : 'за пределами территории объекта'}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Divider(),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: const Text(
                                        'Размещение детей:',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Text(
                                        widget.order.housing!.childrenAllowed ==
                                                1
                                            ? 'Возможно'
                                            : 'Невозможно',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Divider(),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: const Text(
                                        'Размещение животных:',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Text(
                                        widget.order.housing!.pet == 'yes'
                                            ? 'Возможно'
                                            : 'Невозможно',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                )
                              ],
                            )
                          : ExpansionTile(
                              textColor: AppColors.black,
                              iconColor: AppColors.black,
                              title: const Text(
                                'Важная информация',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 10, right: 20),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: const Text(
                                          'Тема мероприятия:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black45),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Text(
                                          '${widget.order.impression!.topics?.map((e) => e.name).first}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ),
                                      const Divider(),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: const Text(
                                          'Основной язык:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black45),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Text(
                                          widget.order.impression!.mainLanguage
                                                  ?.name ??
                                              '',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ),
                                      const Divider(),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: const Text(
                                          'Дополнительные языки:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black45),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Text(
                                          '${widget.order.impression!.languages?.map((e) => e.name).join(', ')}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ),
                                      const Divider(),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: const Text(
                                          'Возраст:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black45),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Text(
                                          'От ${widget.order.impression!.minAge ?? ''} лет',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      ExpansionTile(
                          textColor: AppColors.black,
                          iconColor: AppColors.black,
                          title: const Text(
                            'Детализация цены',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: const [
                                  Text(
                                    'Способ оплаты:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  SvgPicture.asset(
                                    widget.order.successPaymentOperation != null
                                        ? (jsonDecode(widget.order
                                                        .successPaymentOperation?[
                                                    'description'])['cardType'] ==
                                                'VISA'
                                            ? 'assets/icons/visa_icon.svg'
                                            : 'assets/icons/mastercard_icon.svg')
                                        : 'assets/icons/payment_type_in_a_place.svg',
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.order.paymentType == 3
                                            ? 'Оплата при заезде'
                                            : widget.order
                                                        .successPaymentOperation !=
                                                    null
                                                ? '**** ${jsonDecode(widget.order.successPaymentOperation?['description'])['cardMask'].toString().substring(9, 13)}'
                                                : '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(),
                            ),
                            widget.type == 2
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: Column(
                                      children: [
                                        for (int i = 0;
                                            i <
                                                (widget.order.roomNumbers
                                                        ?.length ??
                                                    0);
                                            i++)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  child: Text(
                                                    '${i + 1}. ${widget.order.roomNumbers?[i].roomName ?? ''} x ${checkNightCount(days.toString())}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  '${formatNumberString(((widget.order.roomNumbers?[i].price ?? 0) * days).toString())} \₸',
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
                                                fontWeight: FontWeight.w600,
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
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: Text(
                                                '1. Сеанс: ${widget.order.dateFrom == widget.order.dateTo ? '${DateFormat("d MMMM", 'ru').format(DateTime.parse(widget.order.dateFrom ?? ''))}, ${widget.order.timeStart?.substring(0, 5)} - ${widget.order.timeEnd?.substring(0, 5)}; ${widget.order.session?.type == 2 ? 'Закрытая группа' : 'Открытая группа'}' : '${DateFormat("d MMMM", 'ru').format(DateTime.parse(widget.order.dateFrom ?? ''))}, ${widget.order.timeStart?.substring(0, 5)} - ${DateFormat("d MMMM", 'ru').format(DateTime.parse(widget.order.dateTo ?? ''))}, ${widget.order.timeEnd?.substring(0, 5)}; ${widget.order.session?.type == 2 ? 'Закрытая группа' : 'Открытая группа'}'}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              '${formatNumberString((((widget.order.session?.type == 1 ? widget.order.session?.openPrice ?? 0 : widget.order.session?.closedPrice ?? 0))).toString())} \₸',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Итого',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              '${formatNumberString(((widget.order.session?.type == 1 ? widget.order.session?.openPrice ?? 0 : widget.order.session?.closedPrice ?? 0) * (widget.order.countPeople ?? 1)).toString())} \₸',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: SizedBox(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    primary: AppColors.white,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 2, color: AppColors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReceiptPage(
                                          widget.order.housing ??
                                              HousingDetailModel(),
                                          widget.order.dateFrom ?? '',
                                          widget.order.dateTo ?? '',
                                          widget.type == 2
                                              ? ((widget.order.adults ?? 0) +
                                                  (widget.order.children ?? 0))
                                              : (widget.order.countPeople ?? 0),
                                          widget.order.babies ?? 0,
                                          widget.order.pets ?? 0,
                                          widget.order.id!,
                                          widget.type == 2 ? true : false,
                                          widget.order.impression ??
                                              ImpressionDetailModel(),
                                          widget.order.session ??
                                              ImpressionSessionModel(),
                                          widget.order.session?.type == 2
                                              ? 2
                                              : 1,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Квитанция",
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ],
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
                Container(color: Colors.white, child: const Divider()),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    // borderRadius: BorderRadius.all(
                    //   Radius.circular(AppConstants.cardBorderRadius),
                    // ),
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
                                fontSize: 24,
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SendTextReviewPage(
                                        widget.type,
                                        widget.type == 2
                                            ? widget.order.housing!.id!
                                            : widget.order.impression!.id!,
                                        widget.type == 2
                                            ? widget.order.dateFrom!
                                            : widget.order.dateFrom!)));
                          },
                          child: Container(
                            // width: 162,
                            width: double.infinity,
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
                                SvgPicture.asset('assets/icons/text_icon.svg'),
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
                      ],
                    ),
                  ),
                ),
                const Divider(),
                // TODO: Return
                returnPrice != 0
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 20, left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Правила отмены',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  widget.order.housing?.cancelFineDay != null
                                      ? 'Бесплатная отмена ${widget.order.housing?.cancelFineDay ?? ''} дней до заезда'
                                      : 'Бесплатная отмена',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black45,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                GestureDetector(
                                  onTap: () {
                                    if (widget.order.paymentType == 1) {
                                      showCancelingConfirmation(
                                          returnPrice, totalPrice);
                                    } else {
                                      showCancelingConfirmationWithoutPayment(
                                          0);
                                    }
                                  },
                                  child: const Text(
                                    'Отменить бронирование',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 30),
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
      returnPrice = double.parse(response['data']['refund_price'].toString());
      totalPrice = double.parse(response['data']['total_price'].toString());
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
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

  void showCancelingConfirmationWithoutPayment(double finePrice) async {
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
                height: 410,
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
                        'Вы уверены, что хотите отменить бронь? Для отмены брони штраф составит (${formatNumberString(finePrice.toString())}₸). При последующем бронировании будет добавлено возмещение за отмену текущего бронирования, которое будет учтено в общей сумме оплаты.',
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
                              color: AppColors.red,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Штраф за отмену: ${formatNumberString(finePrice.toString())}₸ ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.red,
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
                                Navigator.of(context).pop();
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
}
