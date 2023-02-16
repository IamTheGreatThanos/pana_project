import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/components/audio_review_card.dart';
import 'package:pana_project/components/facilities_widget.dart';
import 'package:pana_project/components/impression_card.dart';
import 'package:pana_project/components/stories_card.dart';
import 'package:pana_project/models/audioReview.dart';
import 'package:pana_project/models/chat.dart';
import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/models/impressionCard.dart';
import 'package:pana_project/models/reels.dart';
import 'package:pana_project/models/textReview.dart';
import 'package:pana_project/services/housing_api_provider.dart';
import 'package:pana_project/services/impression_api_provider.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/checkReviewsCount.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/utils/get_bytes_from_asset.dart';
import 'package:pana_project/utils/globalVariables.dart';
import 'package:pana_project/views/housing/select_room_page.dart';
import 'package:pana_project/views/impression/impression_info.dart';
import 'package:pana_project/views/messages/chat_messages_page.dart';
import 'package:pana_project/views/other/audio_reviews_page.dart';
import 'package:pana_project/views/other/media_detail_page.dart';
import 'package:pana_project/views/other/text_reviews_page.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HousingInfo extends StatefulWidget {
  const HousingInfo(
      this.id, this.thisStoryItems, this.mediaStoryItems, this.distance);
  final int id;
  final List<StoryItem?> thisStoryItems;
  final List<StoryItem?> mediaStoryItems;
  final String distance;

  @override
  _HousingInfoState createState() => _HousingInfoState();
}

class _HousingInfoState extends State<HousingInfo> {
  final storyController = StoryController();
  late GoogleMapController _mapController;
  final DateRangePickerController _datePickerController =
      DateRangePickerController();
  String selectedRange = 'Выбрать даты';

  CameraPosition _initPosition =
      const CameraPosition(target: LatLng(43.236431, 76.917994), zoom: 14);
  final Set<Marker> _markers = {};

  HousingDetailModel thisHousing = HousingDetailModel();

  List<TextReviewModel> textReviews = [];
  List<AudioReviewModel> audioReviews = [];

  List<ImpressionCardModel> nearbyImpressionList = [];
  List<Reels> reels = [];

  String startDate = '';
  String endDate = '';

  @override
  void initState() {
    getHousingInfo();
    getNearbyImpression();
    getReels();
    getAudioReviews();
    getTextReviews();
    super.initState();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
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
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // height: 1200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 385,
                            width: MediaQuery.of(context).size.width,
                            child: StoryView(
                              storyItems: widget.thisStoryItems,
                              onStoryShow: (s) {},
                              onComplete: () {},
                              progressPosition: ProgressPosition.bottom,
                              repeat: true,
                              controller: storyController,
                              onVerticalSwipeComplete: (direction) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MediaDetailPage(
                                            widget.mediaStoryItems)));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
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
                                          offset: Offset(0,
                                              4), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(9),
                                      child: SvgPicture.asset(
                                          'assets/icons/back_arrow.svg'),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
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
                                          offset: Offset(0,
                                              4), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(9),
                                      child: SvgPicture.asset(
                                          'assets/icons/share.svg'),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () {
                                    tapFavoritesButton();
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
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
                                          offset: Offset(0,
                                              4), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(9),
                                      child: GlobalVariables.favoritesHousing
                                              .contains(widget.id)
                                          ? SvgPicture.asset(
                                              'assets/icons/heart_full.svg')
                                          : SvgPicture.asset(
                                              'assets/icons/heart_empty.svg'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          thisHousing.name ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              '${widget.distance == '-1' ? "-" : widget.distance} км от вас',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black45),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              '${thisHousing.city?.name ?? ''}, Казахстан',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 2, left: 20),
                              child: SizedBox(
                                width: 15,
                                height: 15,
                                child:
                                    SvgPicture.asset('assets/icons/star.svg'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                '${thisHousing.reviewsBallAvg ?? 0}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                checkReviewsCount(
                                    (thisHousing.reviewsCount ?? 0).toString()),
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black45),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: CachedNetworkImage(
                                  imageUrl: thisHousing.user?.avatar ?? '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.58,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              '${thisHousing.user?.name ?? ''} ${thisHousing.user?.surname ?? ''}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding:
                                        //       const EdgeInsets.only(bottom: 2, left: 5),
                                        //   child: SizedBox(
                                        //     width: 15,
                                        //     height: 15,
                                        //     child:
                                        //         SvgPicture.asset('assets/icons/star.svg'),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.58,
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Владелец',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45,
                                          ),
                                        ),
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
                                            user: thisHousing.user,
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
                            )
                          ],
                        ),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                        child: Text(
                          'Описание',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 20, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(
                            thisHousing.description ?? '',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45),
                          ),
                        ),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                        child: Text(
                          'Удобства',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 20, right: 10),
                        child: Wrap(
                          children: [
                            for (var item in thisHousing.comforts ?? [])
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: FacilitiesWidget(
                                        title: item.name ?? ''),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                        child: Text(
                          'Расположение',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height:
                              MediaQuery.of(context).size.width * 0.9 / 1.23,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                            color: Colors.orange[50],
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                            child: GoogleMap(
                              gestureRecognizers: Set()
                                ..add(Factory<PanGestureRecognizer>(
                                    () => PanGestureRecognizer()))
                                ..add(Factory<ScaleGestureRecognizer>(
                                    () => ScaleGestureRecognizer()))
                                ..add(Factory<TapGestureRecognizer>(
                                    () => TapGestureRecognizer()))
                                ..add(Factory<VerticalDragGestureRecognizer>(
                                    () => VerticalDragGestureRecognizer())),
                              mapType: MapType.normal,
                              initialCameraPosition: _initPosition,
                              onMapCreated: _onMapCreated,
                              markers: _markers,
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 20, bottom: 10),
                        child: Row(
                          children: [
                            const Text(
                              'Отзывы',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TextReviewsPage(textReviews)));
                              },
                              child: const Text(
                                'Перейти',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, bottom: 10),
                            child: Row(
                              children: [
                                const Text(
                                  'Цена/Качество',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  double.parse(
                                          thisHousing.reviewsPriceAvg ?? '0')
                                      .roundToDouble()
                                      .toString(),
                                  style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 20, bottom: 10, right: 20),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              child: LinearProgressIndicator(
                                backgroundColor: AppColors.grey,
                                color: AppColors.accent,
                                minHeight: 3,
                                value: double.parse(
                                        thisHousing.reviewsPriceAvg ?? '0') /
                                    5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, bottom: 10),
                            child: Row(
                              children: [
                                const Text(
                                  'Чистота',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  double.parse(
                                          thisHousing.reviewsPurityAvg ?? '0')
                                      .roundToDouble()
                                      .toString(),
                                  style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 20, bottom: 10, right: 20),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              child: LinearProgressIndicator(
                                backgroundColor: AppColors.grey,
                                color: AppColors.accent,
                                minHeight: 3,
                                value: double.parse(
                                        thisHousing.reviewsPurityAvg ?? '0') /
                                    5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, bottom: 10),
                            child: Row(
                              children: [
                                const Text(
                                  'Персонал',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  double.parse(
                                          thisHousing.reviewsStaffAvg ?? '0')
                                      .roundToDouble()
                                      .toString(),
                                  style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 20, bottom: 10, right: 20),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              child: LinearProgressIndicator(
                                backgroundColor: AppColors.grey,
                                color: AppColors.accent,
                                minHeight: 3,
                                value: double.parse(
                                        thisHousing.reviewsStaffAvg ?? '0') /
                                    5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 20, bottom: 10),
                        child: Row(
                          children: [
                            const Text(
                              'Аудио-отзывы',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AudioReviewsPage(audioReviews)));
                              },
                              child: const Text(
                                'Перейти',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                      audioReviews.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Text(
                                'Аудио-отзывов пока нет...',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.blackWithOpacity),
                              ),
                            )
                          : Container(),
                      for (int i = 0;
                          i <
                              (audioReviews.length > 2
                                  ? 2
                                  : audioReviews.length);
                          i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(24),
                                ),
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.lightGray,
                                ),
                              ),
                              child: AudioReviewCard(audioReviews[i])),
                        ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                        child: Text(
                          'Истории с этого места',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      reels.isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              height: 150,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  for (int i = 0; i < reels.length; i++)
                                    StoriesCard(reels, i),
                                ],
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Text(
                                'Истории отсутствуют...',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.blackWithOpacity),
                              ),
                            ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                        child: Text(
                          'Впечатления рядом',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      nearbyImpressionList.isNotEmpty
                          ? SizedBox(
                              height: 430,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    for (int i = 0;
                                        i < nearbyImpressionList.length;
                                        i++)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: GestureDetector(
                                            onTap: () async {
                                              StoryController _storyController =
                                                  StoryController();
                                              List<StoryItem?> thisStoryItems =
                                                  [];
                                              List<StoryItem?> mediaStoryItems =
                                                  [];

                                              for (int j = 0;
                                                  j <
                                                      nearbyImpressionList[i]
                                                          .videos!
                                                          .length;
                                                  j++) {
                                                thisStoryItems.add(
                                                  StoryItem.pageVideo(
                                                    nearbyImpressionList[i]
                                                        .videos![j]
                                                        .path!,
                                                    controller:
                                                        _storyController,
                                                    imageFit: BoxFit.cover,
                                                  ),
                                                );

                                                mediaStoryItems.add(
                                                  StoryItem.pageVideo(
                                                    nearbyImpressionList[i]
                                                        .videos![j]
                                                        .path!,
                                                    controller:
                                                        _storyController,
                                                    imageFit: BoxFit.fitWidth,
                                                  ),
                                                );
                                              }

                                              for (int j = 0;
                                                  j <
                                                      nearbyImpressionList[i]
                                                          .images!
                                                          .length;
                                                  j++) {
                                                thisStoryItems.add(
                                                  StoryItem.pageImage(
                                                    url: nearbyImpressionList[i]
                                                        .images![j]
                                                        .path!,
                                                    controller:
                                                        _storyController,
                                                    imageFit: BoxFit.cover,
                                                  ),
                                                );

                                                mediaStoryItems.add(
                                                  StoryItem.pageImage(
                                                    url: nearbyImpressionList[i]
                                                        .images![j]
                                                        .path!,
                                                    controller:
                                                        _storyController,
                                                    imageFit: BoxFit.fitWidth,
                                                  ),
                                                );
                                              }

                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImpressionInfo(
                                                    nearbyImpressionList[i],
                                                    thisStoryItems,
                                                    mediaStoryItems,
                                                  ),
                                                ),
                                              );

                                              setState(() {});
                                            },
                                            child: ImpressionCard(
                                                nearbyImpressionList[i],
                                                () {})),
                                      )
                                  ]))
                          : const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Text(
                                'Впечатления поблизости отсутствуют...',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.blackWithOpacity),
                              ),
                            ),
                      const Divider(),
                      // const Padding(
                      //   padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                      //   child: Text(
                      //     'Свободные даты',
                      //     style: TextStyle(
                      //       fontSize: 24,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                      //   child: SizedBox(
                      //     width: MediaQuery.of(context).size.width * 0.9,
                      //     child: Text(
                      //       thisHousing.freeDates ?? '',
                      //       style: const TextStyle(
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500,
                      //           color: Colors.black45),
                      //     ),
                      //   ),
                      // ),
                      // const Divider(),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                        child: Text(
                          'Правила дома',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 20, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(
                            'Заезд до ${thisHousing.checkInFrom ?? ''}, выезд до ${thisHousing.checkOutFrom ?? ''}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45),
                          ),
                        ),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                        child: Text(
                          'Правила отмены',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 20, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: const Text(
                            'Гости могут получить полный возврат при отмене не позднее чем за 7 дней до начала Впечатления или в течение 24 часов с момента бронирования (при условии, что Впечатление забронировано более чем за 48 часов до начала).',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 3),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'от ${formatNumberString(thisHousing.basePriceMin.toString())} \₸',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: AppColors.black),
                          ),
                          const Text(
                            ' за сутки',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black45),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          showDatePicker();
                        },
                        child: Text(
                          selectedRange,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppColors.black,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 48,
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (startDate != '' && endDate != '') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectRoomPage(
                                thisHousing,
                                thisHousing.basePriceMin!,
                                startDate,
                                endDate,
                              ),
                            ),
                          );
                        } else {
                          showDatePicker();
                        }
                      },
                      child: const Text(
                        "Выбрать номер",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDatePicker() async {
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
            height: 500,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Назад',
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Выбрать даты',
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            if (startDate != '' && endDate != '') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectRoomPage(
                                    thisHousing,
                                    thisHousing.basePriceMin!,
                                    startDate,
                                    endDate,
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Готово',
                            style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  SfDateRangePicker(
                    controller: _datePickerController,
                    onSelectionChanged: _onSelectionChanged,
                    startRangeSelectionColor: Colors.black,
                    endRangeSelectionColor: Colors.black,
                    rangeSelectionColor: Colors.black12,
                    selectionColor: AppColors.accent,
                    headerStyle: const DateRangePickerHeaderStyle(
                        textAlign: TextAlign.center),
                    selectionMode: DateRangePickerSelectionMode.range,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        selectedRange =
            '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
        if (args.value.startDate != null && args.value.endDate != null) {
          startDate = DateFormat('yyyy-MM-dd').format(args.value.startDate);
          endDate = DateFormat('yyyy-MM-dd').format(args.value.endDate);
        }
      }
    });
  }

  void getHousingInfo() async {
    var response = await HousingProvider().getHousingDetail(widget.id);
    if (response['response_status'] == 'ok') {
      thisHousing = HousingDetailModel.fromJson(response['data']);
      final Uint8List customMarker =
          await getBytesFromAsset('assets/icons/map_pin.png', 150);

      _markers.add(Marker(
        markerId: const MarkerId('point-1'),
        position: LatLng(double.parse(thisHousing.lat ?? '43.236431'),
            double.parse(thisHousing.lng ?? '76.917994')),
        infoWindow: InfoWindow(
          title: thisHousing.name,
        ),
        icon: BitmapDescriptor.fromBytes(customMarker),
      ));

      CameraPosition housingLocation = CameraPosition(
        target: LatLng(
          double.parse(thisHousing.lat ?? '43.236431'),
          double.parse(thisHousing.lng ?? '76.917994'),
        ),
        zoom: 14,
      );

      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(housingLocation));

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void tapFavoritesButton() async {
    if (GlobalVariables.favoritesHousing.contains(widget.id)) {
      var response = await MainProvider().deleteFavorite(widget.id, 1);
      if (response['response_status'] == 'ok') {
        GlobalVariables.favoritesHousing.remove(widget.id);
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
      var response = await MainProvider().addToFavorite(widget.id, 1);
      if (response['response_status'] == 'ok') {
        GlobalVariables.favoritesHousing.add(widget.id);
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

  void getTextReviews() async {
    textReviews = [];
    var response = await HousingProvider().getTextReviewsInHousing(widget.id);
    if (response['response_status'] == 'ok') {
      for (var item in response['data']) {
        textReviews.add(TextReviewModel.fromJson(item));
      }
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void getAudioReviews() async {
    audioReviews = [];
    var response = await HousingProvider().getAudioReviewsInHousing(widget.id);
    if (response['response_status'] == 'ok') {
      for (var item in response['data']) {
        audioReviews.add(AudioReviewModel.fromJson(item));
      }
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void getNearbyImpression() async {
    nearbyImpressionList = [];
    var response = await ImpressionProvider().getNearbyImpression(widget.id);
    if (response['response_status'] == 'ok') {
      for (var item in response['data']) {
        nearbyImpressionList.add(ImpressionCardModel.fromJson(item));
      }
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void getReels() async {
    reels = [];
    var response = await HousingProvider().getReelsById(widget.id);
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
