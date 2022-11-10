import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pana_project/components/audio_review_card.dart';
import 'package:pana_project/components/facilities_widget.dart';
import 'package:pana_project/components/impression_card.dart';
import 'package:pana_project/components/stories_card.dart';
import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/housing/select_room_page.dart';
import 'package:pana_project/views/other/audio_reviews_page.dart';
import 'package:pana_project/views/other/media_detail_page.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class HousingInfo extends StatefulWidget {
  const HousingInfo(this.id, this.thisStoryItems, this.mediaStoryItems);
  final int id;
  final List<StoryItem?> thisStoryItems;
  final List<StoryItem?> mediaStoryItems;

  @override
  _HousingInfoState createState() => _HousingInfoState();
}

class _HousingInfoState extends State<HousingInfo> {
  final _storyController = StoryController();
  late GoogleMapController _mapController;

  CameraPosition _initPosition =
      CameraPosition(target: LatLng(43.236431, 76.917994), zoom: 14);
  final Set<Marker> _markers = {};

  HousingDetailModel thisHousing = HousingDetailModel();

  @override
  void initState() {
    getHousingInfo();
    setupMarkers();
    super.initState();
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void setupMarkers() async {}

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
            // height: 1200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: StoryView(
                        storyItems: widget.thisStoryItems,
                        onStoryShow: (s) {},
                        onComplete: () {},
                        progressPosition: ProgressPosition.bottom,
                        repeat: true,
                        controller: _storyController,
                        onVerticalSwipeComplete: (direction) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MediaDetailPage(widget.mediaStoryItems)));
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
                                    offset: Offset(
                                        0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
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
                                    offset: Offset(
                                        0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child:
                                    SvgPicture.asset('assets/icons/share.svg'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
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
                                    offset: Offset(
                                        0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
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
                        '${thisHousing.distance ?? 0} км от вас',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        '${thisHousing.city?.name ?? ''}, Kazakhstan',
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
                        padding: const EdgeInsets.only(bottom: 2, left: 20),
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: SvgPicture.asset('assets/icons/star.svg'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          thisHousing.star.toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          '${thisHousing.reviewsCount ?? 0} Отзыва',
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
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
                              //     child: SvgPicture.asset(
                              //         'assets/icons/star.svg'),
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Здание целиком, 3 комнаты, 2 этажа',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
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
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 20),
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
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 10),
                  child: Wrap(
                    children: [
                      for (var item in thisHousing.comforts ?? [])
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FacilitiesWidget(title: item.name ?? ''),
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
                    height: MediaQuery.of(context).size.width * 0.9 / 1.23,
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
                  padding: const EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Row(
                    children: const [
                      Text(
                        'Отзывы',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Перейти',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, bottom: 10),
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
                            double.parse(thisHousing.reviewsPriceAvg ?? '0')
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
                          value:
                              double.parse(thisHousing.reviewsPriceAvg ?? '0') /
                                  5,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, bottom: 10),
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
                            double.parse(thisHousing.reviewsPurityAvg ?? '0')
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
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, bottom: 10),
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
                            double.parse(thisHousing.reviewsStaffAvg ?? '0')
                                .roundToDouble()
                                .toString(),
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 20),
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
                          value:
                              double.parse(thisHousing.reviewsStaffAvg ?? '0') /
                                  5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
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
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (int i = 0; i < 6; i++) StoriesCard(i),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, bottom: 10),
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
                                  builder: (context) => AudioReviewsPage()));
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: AudioReviewCard(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: AudioReviewCard(),
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
                ImpressionCard(),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Text(
                    'Свободные даты',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: const Text(
                      '28 сен. - 2 окт.',
                      style: TextStyle(
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
                    'Правила дома',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 20),
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
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: const Text(
                      'Отклонение проецирует суммарный поворот. Гировертикаль, в силу третьего закона Ньютона, даёт большую проекцию на оси, чем тангаж. Ротор безусловно заставляет иначе взглянуть на то, что такое уходящий ньютонометр, сводя задачу к квадратурам.',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'от \$${thisHousing.basePriceMin}',
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
                          const Text(
                            '12-14 июля',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.black,
                                decoration: TextDecoration.underline),
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
                              borderRadius:
                                  BorderRadius.circular(10), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectRoomPage(
                                        thisHousing.id!,
                                        thisHousing.basePriceMin!)));
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
        ),
      ),
    );
  }

  void getHousingInfo() async {
    var response = await MainProvider().getHousingDetail(widget.id);
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
        content:
            Text(response['message'], style: const TextStyle(fontSize: 20)),
      ));
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
