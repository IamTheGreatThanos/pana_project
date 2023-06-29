import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/components/audio_review_card.dart';
import 'package:pana_project/components/text_review_card.dart';
import 'package:pana_project/models/audioReview.dart';
import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/models/panaTravelCard.dart';
import 'package:pana_project/models/textReview.dart';
import 'package:pana_project/services/housing_api_provider.dart';
import 'package:pana_project/utils/checkReviewsCount.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/utils/get_bytes_from_asset.dart';
import 'package:pana_project/views/housing/housing_info.dart';
import 'package:pana_project/views/housing/select_room_page.dart';
import 'package:pana_project/views/impression/impression_info.dart';
import 'package:pana_project/views/other/audio_reviews_page.dart';
import 'package:pana_project/views/other/media_detail_page.dart';
import 'package:pana_project/views/other/text_reviews_page.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PanaTravelInfo extends StatefulWidget {
  const PanaTravelInfo(
    this.travel,
    this.thisStoryItems,
    this.mediaStoryItems,
  );

  final PanaTravelCardModel travel;
  final List<StoryItem?> thisStoryItems;
  final List<StoryItem?> mediaStoryItems;

  @override
  _PanaTravelInfoState createState() => _PanaTravelInfoState();
}

class _PanaTravelInfoState extends State<PanaTravelInfo> {
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

  String startDate = '';
  String endDate = '';

  bool isLoading = false;

  @override
  void initState() {
    getPanaTravelInfo();
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
                                  onTap: () async {
                                    await FlutterShare.share(
                                      title: 'Pana',
                                      text: 'Поездки в Pana',
                                      linkUrl:
                                          'pana://pana.app/tour?id=${widget.travel.id!}',
                                    );
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
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Text(
                          widget.travel.name ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 10),
                        child: Text(
                          '${widget.travel.housings![0].city?.name ?? ''}, ${widget.travel.housings![0].country?.name ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 10),
                        child: Text(
                          'Жилье: ${widget.travel.housings![0].name ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackWithOpacity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 10),
                        child: Text(
                          '${widget.travel.impressions![0].city?.name ?? ''}, ${widget.travel.impressions![0].country?.name ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'Впечатление: ${widget.travel.impressions![0].name ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackWithOpacity,
                          ),
                        ),
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
                                '${widget.travel.reviewsBallAvg ?? 0}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                checkReviewsCount(
                                    (widget.travel.reviewsCount ?? 0)
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
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, left: 20, bottom: 10),
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
                            widget.travel.description ?? '',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45),
                          ),
                        ),
                      ),
                      const Divider(),
                      // TODO: Housing
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.travel.housings![0]
                                            .images?[0].path ??
                                        '',
                                    fit: BoxFit.cover,
                                  ),
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
                                              widget.travel.housings![0].name ??
                                                  '',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.58,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          '${widget.travel.housings![0].city?.name ?? ''} • Отель',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () async {
                                    StoryController storyController =
                                        StoryController();
                                    List<StoryItem?> thisStoryItems = [];
                                    List<StoryItem?> mediaStoryItems = [];

                                    // TODO: Housing images

                                    for (int j = 0;
                                        j <
                                            (widget.travel.housings?[0].images
                                                    ?.length ??
                                                0);
                                        j++) {
                                      thisStoryItems.add(
                                        StoryItem.pageImage(
                                          url: widget.travel.housings?[0]
                                                  .images?[j].path ??
                                              '',
                                          controller: storyController,
                                          imageFit: BoxFit.cover,
                                        ),
                                      );

                                      mediaStoryItems.add(
                                        StoryItem.pageImage(
                                          url: widget.travel.housings?[0]
                                                  .images?[j].path ??
                                              '',
                                          controller: storyController,
                                          imageFit: BoxFit.fitWidth,
                                        ),
                                      );
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HousingInfo(
                                          widget.travel.housings![0].id!,
                                          thisStoryItems,
                                          mediaStoryItems,
                                          widget.travel.housings![0].distance
                                              .toString(),
                                          '',
                                          '',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: Icon(Icons.arrow_forward_ios)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Divider(),
                      // TODO: Impression
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.travel.impressions![0]
                                            .images?[0].path ??
                                        '',
                                    fit: BoxFit.cover,
                                  ),
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
                                              widget.travel.impressions![0]
                                                      .name ??
                                                  '',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.58,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          '${widget.travel.impressions![0].city?.name ?? ''} • Впечатление',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () async {
                                    StoryController storyController =
                                        StoryController();
                                    List<StoryItem?> thisStoryItems = [];
                                    List<StoryItem?> mediaStoryItems = [];

                                    // TODO: Housing images

                                    for (int j = 0;
                                        j <
                                            (widget.travel.impressions?[0]
                                                    .images?.length ??
                                                0);
                                        j++) {
                                      thisStoryItems.add(
                                        StoryItem.pageImage(
                                          url: widget.travel.impressions?[0]
                                                  .images?[j].path ??
                                              '',
                                          controller: storyController,
                                          imageFit: BoxFit.cover,
                                        ),
                                      );

                                      mediaStoryItems.add(
                                        StoryItem.pageImage(
                                          url: widget.travel.impressions?[0]
                                                  .images?[j].path ??
                                              '',
                                          controller: storyController,
                                          imageFit: BoxFit.fitWidth,
                                        ),
                                      );
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImpressionInfo(
                                          widget.travel.impressions![0],
                                          thisStoryItems,
                                          mediaStoryItems,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: Icon(Icons.arrow_forward_ios)),
                                ),
                              ],
                            )
                          ],
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
                      textReviews.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Text(
                                'Отзывов пока нет...',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blackWithOpacity,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 310,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  for (int i = 0;
                                      i <
                                          (textReviews.length > 3
                                              ? 3
                                              : textReviews.length);
                                      i++)
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 10, bottom: 20),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(24),
                                                ),
                                                border: Border.all(
                                                  width: 1,
                                                  color: AppColors.lightGray,
                                                )),
                                            child: TextReviewCard(
                                                textReviews[i]))),
                                  const SizedBox(width: 20)
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
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 20, bottom: 10),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                'assets/icons/geolocation_info_icon.svg'),
                            const SizedBox(width: 10),
                            const Text(
                              'Жилье',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 5, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(
                            widget.travel.housings![0].name ?? '',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 10),
                        child: Text(
                          '${widget.travel.housings![0].city?.name ?? ''}, ${widget.travel.housings![0].country?.name ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 20, bottom: 10),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/geolocation_info_icon_accent.svg',
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Впечатление',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 5, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(
                            widget.travel.impressions![0].name ?? '',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 10),
                        child: Text(
                          '${widget.travel.impressions![0].city?.name ?? ''}, ${widget.travel.impressions![0].country?.name ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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
                            ' за человека',
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
                        "Забронировать",
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
                    minDate: DateTime.now(),
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

  void getPanaTravelInfo() async {
    isLoading = true;
    setState(() {});
    var response = await HousingProvider()
        .getHousingDetail(widget.travel.housings![0].id!);
    if (response['response_status'] == 'ok') {
      thisHousing = HousingDetailModel.fromJson(response['data']);
      final Uint8List customMarker =
          await getBytesFromAsset('assets/icons/map_pin_black.png', 150);

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

      isLoading = false;

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void getTextReviews() async {
    textReviews = [];
    var response = await HousingProvider()
        .getTextReviewsInHousing(widget.travel.housings![0].id!);
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
    var response = await HousingProvider()
        .getAudioReviewsInHousing(widget.travel.housings![0].id!);
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
}
