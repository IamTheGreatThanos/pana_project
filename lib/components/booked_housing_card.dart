import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/models/housingCard.dart';
import 'package:pana_project/services/travel_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';

class BookedHousingCard extends StatefulWidget {
  BookedHousingCard(this.housing, this.travelId);
  final HousingCardModel housing;
  final int travelId;

  @override
  _BookedHousingCardState createState() => _BookedHousingCardState();
}

class _BookedHousingCardState extends State<BookedHousingCard> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        createBookedPlan();
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppConstants.cardBorderRadius),
              color: AppColors.white),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppConstants.cardBorderRadius),
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
                            itemCount: widget.housing.images?.length ?? 0,
                            itemBuilder: (BuildContext context, int itemIndex,
                                    int pageViewIndex) =>
                                SizedBox(
                              width: double.infinity,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    widget.housing.images![itemIndex].path!,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 240),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: widget.housing.images!
                                .asMap()
                                .entries
                                .map((entry) {
                              return GestureDetector(
                                onTap: () =>
                                    _controller.animateToPage(entry.key),
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
                      ],
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.housing.city?.name ?? ''}, ${widget.housing.country?.name ?? ''}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const Spacer(),
                    widget.housing.reviewsAvgBall != 0
                        ? Row(
                            children: [
                              Text(
                                widget.housing.reviewsAvgBall.toString(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 2, left: 5),
                                child: SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: SvgPicture.asset(
                                        'assets/icons/star.svg')),
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
                  '${widget.housing.distance} км от вас',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black45),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      '${formatNumberString('123')} \₸',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.black),
                    ),
                    const Text(
                      ' за ночь',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black45),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          )),
    );
  }

  void createBookedPlan() async {
    var response = await TravelProvider().createBookedHousing(
      widget.travelId,
      widget.housing.id!,
    );

    if (response['response_status'] == 'ok') {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }
}
