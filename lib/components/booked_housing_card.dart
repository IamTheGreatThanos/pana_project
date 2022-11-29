import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/models/housingCard.dart';
import 'package:pana_project/utils/const.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

class BookedHousingCard extends StatefulWidget {
  BookedHousingCard(this.housing);
  final HousingCardModel housing;
  @override
  _BookedHousingCardState createState() => _BookedHousingCardState();
}

class _BookedHousingCardState extends State<BookedHousingCard> {
  final CarouselController _controller = CarouselController();
  final _storyController = StoryController();
  int _current = 0;

  List<StoryItem?> thisStoryItems = [];
  List<StoryItem?> mediaStoryItems = [];

  @override
  void initState() {
    for (int i = 0; i < widget.housing.images!.length; i++) {
      thisStoryItems.add(
        StoryItem.pageImage(
          url: widget.housing.images![i].path!,
          controller: _storyController,
          imageFit: BoxFit.fitHeight,
        ),
      );

      mediaStoryItems.add(
        StoryItem.pageImage(
          url: widget.housing.images![i].path!,
          controller: _storyController,
          imageFit: BoxFit.fitWidth,
        ),
      );
    }
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
          height: 330,
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
                          height: 200,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              height: 200,
                              aspectRatio: 16 / 9,
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
                                CachedNetworkImage(
                              fit: BoxFit.fitHeight,
                              imageUrl: widget.housing.images![itemIndex].path!,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 170),
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
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (Colors.white).withOpacity(
                                          _current == entry.key ? 0.9 : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 15,
                              left:
                                  MediaQuery.of(context).size.width * 0.9 - 70),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                  'assets/icons/heart_empty_2.svg'),
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
                      '${widget.housing.city!.name}, ${widget.housing.country!.name}',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Spacer(),
                    Text(
                      widget.housing.reviewsAvgBall.toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                Text(
                  '${widget.housing.distance} км от вас',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black45),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: const [
                    Text(
                      '\$324',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
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
              ],
            ),
          )),
    );
  }

  void createBookedPlan() async {
    Navigator.pop(context);
  }
}
