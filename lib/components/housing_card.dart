import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/models/housingCard.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/utils/globalVariables.dart';

class HousingCard extends StatefulWidget {
  HousingCard(this.housing, this.onChangeParentWidgetAction);
  final VoidCallback onChangeParentWidgetAction;
  final HousingCardModel housing;
  @override
  _HousingCardState createState() => _HousingCardState();
}

class _HousingCardState extends State<HousingCard> {
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
      // height: 400,
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
                          // aspectRatio: 16 / 10,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
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
                            imageUrl: widget.housing.images![itemIndex].path!,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator(
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 240),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            widget.housing.images!.asMap().entries.map((entry) {
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
                            child: GlobalVariables.favoritesHousing
                                    .contains(widget.housing.id!)
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
                  widget.housing.name ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const Spacer(),
                Text(
                  widget.housing.reviewsAvgBall.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2, left: 5),
                  child: SizedBox(
                      width: 15,
                      height: 15,
                      child: SvgPicture.asset('assets/icons/star.svg')),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                  widget.housing.city!.name ?? '',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${widget.housing.distance == -1 ? "-" : widget.housing.distance} км от вас',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black45),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                  '${formatNumberString(widget.housing.basePriceMin.toString())} \₸',
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
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  void tapFavoritesButton() async {
    if (GlobalVariables.favoritesHousing.contains(widget.housing.id!)) {
      var response = await MainProvider().deleteFavorite(widget.housing.id!, 1);
      if (response['response_status'] == 'ok') {
        GlobalVariables.favoritesHousing.remove(widget.housing.id!);
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
      var response = await MainProvider().addToFavorite(widget.housing.id!, 1);
      if (response['response_status'] == 'ok') {
        GlobalVariables.favoritesHousing.add(widget.housing.id!);
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
