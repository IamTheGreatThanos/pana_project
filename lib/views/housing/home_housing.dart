import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pana_project/components/housing_card.dart';
import 'package:pana_project/models/housingCard.dart';
import 'package:pana_project/models/reels.dart';
import 'package:pana_project/services/housing_api_provider.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/PageTransitionRoute.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/auth/auth_page.dart';
import 'package:pana_project/views/housing/housing_info.dart';
import 'package:pana_project/views/housing/search_page.dart';
import 'package:pana_project/views/other/favorites_page.dart';
import 'package:pana_project/views/other/select_reels_booked_object_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

import '../../components/stories_card.dart';

class HomeHousing extends StatefulWidget {
  @override
  _HomeHousingState createState() => _HomeHousingState();
}

class _HomeHousingState extends State<HomeHousing>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StoryController controller = StoryController();

  List<Map<String, dynamic>> categories = [
    {'name': 'Отели', 'asset': 'assets/icons/category_1.svg', 'id': 1},
    {'name': 'Бутик-отели', 'asset': 'assets/icons/category_2.svg', 'id': 2},
    {'name': 'Загородный дом', 'asset': 'assets/icons/category_3.svg', 'id': 3},
    {'name': 'Апартаменты', 'asset': 'assets/icons/category_4.svg', 'id': 4},
    {'name': 'Юрта', 'asset': 'assets/icons/category_5.svg', 'id': 5},
    {'name': 'Шалаши', 'asset': 'assets/icons/category_6.svg', 'id': 6},
    {'name': 'У моря', 'asset': 'assets/icons/category_7.svg', 'id': 7},
    {'name': 'Кемпинги', 'asset': 'assets/icons/category_8.svg', 'id': 8},
    {'name': 'Авто-дом', 'asset': 'assets/icons/category_9.svg', 'id': 9},
    {'name': 'Особняк', 'asset': 'assets/icons/category_10.svg', 'id': 10},
    {'name': 'С историей', 'asset': 'assets/icons/category_11.svg', 'id': 11},
    {'name': 'На дереве', 'asset': 'assets/icons/category_12.svg', 'id': 12},
  ];

  List<String> continentNames = [
    'Гибкий поиск',
    'Казахстан',
    'Россия',
    'Узбекистан',
    'Турция',
    'ОАЭ',
  ];

  List<HousingCardModel> housingList = [];
  List<Reels> reels = [];

  int selectedCategoryId = 1;

  String selectedRange = '';
  int selectedCountryId = 0;
  String searchText = '';
  bool isLogedIn = false;

  bool fromSearch = false;
  List<dynamic> searchParams = [];

  bool loading = true;

  String lat = '';
  String lng = '';

  @override
  void initState() {
    checkIsLogedIn();
    getReels();
    getCurrentLocation();
    super.initState();
    _tabController = TabController(vsync: this, length: 12);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void checkIsLogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogedIn') == true) {
      isLogedIn = true;
    } else {
      isLogedIn = false;
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
      child: DefaultTabController(
        length: 12,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: SingleChildScrollView(
              child: Container(
                color: AppColors.lightGray,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            openSearchPage();
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.75,
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Icon(Icons.search),
                                ),
                                (selectedRange == '' && searchText == '')
                                    ? const Text(
                                        'Поиск...',
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : SizedBox(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              (searchText != ''
                                                      ? '$searchText, '
                                                      : '') +
                                                  continentNames[
                                                      selectedCountryId],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              selectedRange == ''
                                                  ? '- / -'
                                                  : selectedRange,
                                              style: const TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                Spacer(),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 5),
                                  child: VerticalDivider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 15, 5),
                                  child: SvgPicture.asset(
                                      'assets/icons/slider_01.svg'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            goToFavorites();
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
                                  offset: Offset(
                                      0, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                  'assets/icons/heart_empty.svg'),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TabBar(
                      controller: _tabController,
                      onTap: (index) {
                        fromSearch = false;
                        getCurrentLocation();
                        housingList = [];
                        loading = true;
                        setState(() {
                          selectedCategoryId = categories[index]['id'];
                        });
                      },
                      isScrollable: true,
                      indicatorColor: AppColors.accent,
                      labelColor: AppColors.black,
                      labelStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      unselectedLabelColor: AppColors.blackWithOpacity,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        for (int i = 0; i < categories.length; i++)
                          Tab(
                            icon: SvgPicture.asset(
                              categories[i]['asset']!,
                              color: _tabController.index == i
                                  ? AppColors.black
                                  : AppColors.blackWithOpacity,
                            ),
                            text: categories[i]['name'],
                          ),
                      ],
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            height: 150,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if (isLogedIn == true) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectReelsBookedObjectPage(
                                                      'housing')));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AuthPage()));
                                    }
                                  },
                                  child: DottedBorder(
                                    color: AppColors.accent,
                                    strokeWidth: 1,
                                    dashPattern: const [6, 2],
                                    strokeCap: StrokeCap.round,
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(8),
                                    child: Container(
                                      width: 85,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        color: AppColors.lightGray,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.add,
                                              color: AppColors.accent),
                                          Text(
                                            'Добавить',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.accent),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                for (int i = 0; i < reels.length; i++)
                                  StoriesCard(reels, i),
                              ],
                            ),
                          ),
                          for (int i = 0; i < housingList.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: GestureDetector(
                                onTap: () async {
                                  if (isLogedIn == true) {
                                    StoryController _storyController =
                                        StoryController();
                                    List<StoryItem?> thisStoryItems = [];
                                    List<StoryItem?> mediaStoryItems = [];

                                    // for (int j = 0;
                                    //     j < housingList[i].videos!.length;
                                    //     j++) {
                                    //   thisStoryItems.add(
                                    //     StoryItem.pageVideo(
                                    //       housingList[i].videos![j].path!,
                                    //       controller: _storyController,
                                    //       imageFit: BoxFit.cover,
                                    //     ),
                                    //   );
                                    //
                                    //   mediaStoryItems.add(
                                    //     StoryItem.pageVideo(
                                    //       housingList[i].videos![j].path!,
                                    //       controller: _storyController,
                                    //       imageFit: BoxFit.fitWidth,
                                    //     ),
                                    //   );
                                    // }

                                    for (int j = 0;
                                        j < housingList[i].images!.length;
                                        j++) {
                                      thisStoryItems.add(
                                        StoryItem.pageImage(
                                          url: housingList[i].images![j].path!,
                                          controller: _storyController,
                                          imageFit: BoxFit.cover,
                                        ),
                                      );

                                      mediaStoryItems.add(
                                        StoryItem.pageImage(
                                          url: housingList[i].images![j].path!,
                                          controller: _storyController,
                                          imageFit: BoxFit.fitWidth,
                                        ),
                                      );
                                    }

                                    await Navigator.push(
                                        context,
                                        ThisPageRoute(HousingInfo(
                                            housingList[i].id!,
                                            thisStoryItems,
                                            mediaStoryItems,
                                            housingList[i].distance == -1
                                                ? '-'
                                                : housingList[i]
                                                    .distance
                                                    .toString()))
                                        // MaterialPageRoute(
                                        //     builder: (context) => HousingInfo(
                                        //         housingList[i].id!,
                                        //         thisStoryItems,
                                        //         mediaStoryItems))
                                        );
                                    setState(() {});
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AuthPage()));
                                  }
                                },
                                child: HousingCard(housingList[i], () {}),
                              ),
                            )
                        ],
                      ),
                    ),
                    loading
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    if (fromSearch) {
      searchHousingList(searchParams);
    } else {
      getCurrentLocation();
    }

    getReels();
  }

  void goToFavorites() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesPage(),
      ),
    );

    setState(() {});
  }

  void getHousingList(String lat, String lng) async {
    housingList = [];
    var response =
        await HousingProvider().getHousingData(selectedCategoryId, lat, lng);
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        housingList.add(HousingCardModel.fromJson(response['data'][i]));
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
    loading = false;
  }

  void searchHousingList(List<dynamic> params) async {
    housingList = [];
    var response = await HousingProvider().getHousingFromSearch(
        params[0],
        params[1],
        params[2],
        params[3],
        params[4],
        params[6],
        params[7],
        params[8],
        params[9],
        lat,
        lng);
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        housingList.add(HousingCardModel.fromJson(response['data'][i]));
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

  void openSearchPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(true),
      ),
    );

    if (mounted) {
      if (result != null) {
        fromSearch = true;
        searchParams = result;
        searchHousingList(result);
        setState(() {
          selectedCountryId = result[0];
          if (result[5] != 'Выбрать даты') {
            selectedRange = result[5];
          } else {
            selectedRange = '';
          }
          searchText = result[9];
        });
      } else {
        setState(() {
          selectedCountryId = 0;
          selectedRange = '';
        });
      }
    }
  }

  void getReels() async {
    reels = [];
    var response = await MainProvider().getReels('housing');
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var position = await _determinePosition();
      lat = position.latitude.toString();
      lng = position.longitude.toString();

      prefs.setString('lastLat', lat);
      prefs.setString('lastLng', lng);

      getHousingList(
          position.latitude.toString(), position.longitude.toString());
    } catch (error) {
      getHousingList(lat, lng);
    }
  }
}
