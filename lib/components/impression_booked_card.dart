import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/models/receipt_order.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/utils/globalVariables.dart';

class ImpressionBookedCard extends StatefulWidget {
  ImpressionBookedCard(this.order, this.onChangeParentWidgetAction);
  final VoidCallback onChangeParentWidgetAction;
  final ReceiptOrder order;

  @override
  _ImpressionBookedCardState createState() => _ImpressionBookedCardState();
}

class _ImpressionBookedCardState extends State<ImpressionBookedCard> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          color: AppColors.white),
      // height: 330,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 270,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          height: 270,
                          aspectRatio: 16 / 10,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          reverse: false,
                          autoPlay: false,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                          scrollDirection: Axis.horizontal,
                        ),
                        itemCount:
                            widget.order.impressionCard?.images?.length ?? 0,
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            SizedBox(
                          width: double.infinity,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.order.impressionCard
                                    ?.images?[itemIndex].path ??
                                '',
                            placeholder: (context, url) => const Center(
                                child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: CircularProgressIndicator(
                                      color: AppColors.grey,
                                    ))),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 240),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.order.impressionCard!.images!
                            .asMap()
                            .entries
                            .map((entry) {
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(entry.key),
                            child: Container(
                              width: _current == entry.key ? 24 : 12,
                              height: 4,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  color: (Colors.white).withOpacity(
                                      _current == entry.key ? 0.9 : 0.4)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10,
                          left: MediaQuery.of(context).size.width * 0.9 - 60),
                      child: GestureDetector(
                        onTap: () {
                          tapFavoritesButton();
                        },
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: GlobalVariables.favoritesImpression
                                    .contains(widget.order.impressionCard?.id!)
                                ? SvgPicture.asset(
                                    'assets/icons/heart_full.svg')
                                : SvgPicture.asset(
                                    'assets/icons/heart_empty_2.svg'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.order.impressionCard?.city!.name ?? '',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                widget.order.impressionCard?.reviewsAvgBall != 0
                    ? Row(
                        children: [
                          Text(
                            widget.order.impressionCard!.reviewsAvgBall
                                .toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2, left: 5),
                            child: SizedBox(
                                width: 15,
                                height: 15,
                                child:
                                    SvgPicture.asset('assets/icons/star.svg')),
                          ),
                        ],
                      )
                    : const Text(
                        "Отзывов нет",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackWithOpacity,
                        ),
                      ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.order.impressionCard?.name ?? '',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.order.dateFrom == widget.order.dateTo
                  ? '${DateFormat("d MMMM", 'ru').format(DateTime.parse(widget.order.dateFrom ?? ''))}, ${widget.order.timeStart?.substring(0, 5)} - ${widget.order.timeEnd?.substring(0, 5)};'
                  : '${DateFormat("d MMMM", 'ru').format(DateTime.parse(widget.order.dateFrom ?? ''))}, ${widget.order.timeStart?.substring(0, 5)} - ${DateFormat("d MMMM", 'ru').format(DateTime.parse(widget.order.dateTo ?? ''))}, ${widget.order.timeEnd?.substring(0, 5)};',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black45,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                  '${formatNumberString(widget.order.impressionCard!.price.toString())} \₸',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.black),
                ),
                const Text(
                  ' с человека',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black45),
                ),
                const Spacer(),
                Text(
                  'Статус: ${widget.order.status == 6 ? 'Отменено' : widget.order.bookingStatus == 2 ? 'Завершено' : widget.order.bookingStatus == 3 ? 'Началось' : 'Ожидает начала'}',
                  style: const TextStyle(
                    color: AppColors.blackWithOpacity,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  void tapFavoritesButton() async {
    if (GlobalVariables.favoritesImpression
        .contains(widget.order.impressionCard?.id!)) {
      var response = await MainProvider()
          .deleteFavorite(widget.order.impressionCard!.id!, 2);
      if (response['response_status'] == 'ok') {
        GlobalVariables.favoritesImpression
            .remove(widget.order.impressionCard?.id!);
        if (mounted) {
          setState(() {});
          widget.onChangeParentWidgetAction();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['data']['message'],
              style: const TextStyle(fontSize: 14)),
        ));
      }
    } else {
      var response = await MainProvider()
          .addToFavorite(widget.order.impressionCard!.id!, 2);
      if (response['response_status'] == 'ok') {
        GlobalVariables.favoritesImpression
            .add(widget.order.impressionCard?.id!);
        if (mounted) {
          setState(() {});
          widget.onChangeParentWidgetAction();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['data']['message'],
              style: const TextStyle(fontSize: 14)),
        ));
      }
    }
  }
}
