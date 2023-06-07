import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/impression_card.dart';
import 'package:pana_project/components/selections_card.dart';
import 'package:pana_project/components/stories_card.dart';
import 'package:pana_project/models/images.dart';
import 'package:pana_project/models/impressionCard.dart';
import 'package:pana_project/models/reels.dart';
import 'package:pana_project/models/selections.dart';
import 'package:pana_project/services/impression_api_provider.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/auth/auth_page.dart';
import 'package:pana_project/views/housing/filter_page.dart';
import 'package:pana_project/views/housing/search_page.dart';
import 'package:pana_project/views/impression/impression_info.dart';
import 'package:pana_project/views/other/favorites_page.dart';
import 'package:pana_project/views/other/select_reels_booked_object_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class HomeImpression extends StatefulWidget {
  @override
  _HomeImpressionState createState() => _HomeImpressionState();
}

class _HomeImpressionState extends State<HomeImpression>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StoryController controller = StoryController();

  List<Map<String, dynamic>> categories = [
    {'name': 'Все', 'asset': 'assets/icons/category_0.svg', 'id': 0},
    {
      'name': 'Здоровье',
      'asset': 'assets/icons/impression_cat_1.svg',
      'id': 13
    },
    {
      'name': 'Творчество',
      'asset': 'assets/icons/impression_cat_2.svg',
      'id': 14
    },
    {'name': 'Еда', 'asset': 'assets/icons/impression_cat_3.svg', 'id': 15},
    {
      'name': 'Историческое',
      'asset': 'assets/icons/impression_cat_4.svg',
      'id': 16
    },
    {'name': 'Напитки', 'asset': 'assets/icons/impression_cat_5.svg', 'id': 17},
    {
      'name': 'Развлечения',
      'asset': 'assets/icons/impression_cat_6.svg',
      'id': 18
    },
    {'name': 'Спорт', 'asset': 'assets/icons/impression_cat_7.svg', 'id': 19},
    {
      'name': 'Экскурсии',
      'asset': 'assets/icons/impression_cat_8.svg',
      'id': 20
    },
    {
      'name': 'Животные',
      'asset': 'assets/icons/impression_cat_9.svg',
      'id': 21
    },
    {
      'name': 'Культура',
      'asset': 'assets/icons/impression_cat_10.svg',
      'id': 22
    },
    {
      'name': 'Природа',
      'asset': 'assets/icons/impression_cat_11.svg',
      'id': 23
    },
  ];

  List<String> continentNames = [
    'Гибкий поиск',
    'Казахстан',
    'Россия',
    'Узбекистан',
    'Турция',
    'ОАЭ',
  ];

  List<ImpressionCardModel> impressionList = [];
  List<Reels> reels = [];
  Selections selections = Selections();
  List<Images> selectionsImage = [];

  int selectedCategoryId = 0;
  String selectedRange = '';
  int selectedCountryId = 0;
  String searchText = '';
  bool isLoggedIn = false;

  bool loading = true;

  List<dynamic> searchParams = [0, 0, 0, 0, 0, 'Выбрать даты', '', '', 0, ''];
  List<dynamic> savedFilter = [];
  List<dynamic> filterList = [
    0,
    5000000,
    <int>[],
    <int>[],
    <int>[],
  ];
  bool isFilterOn = false;

  @override
  void initState() {
    searchImpressionList(searchParams);
    checkIsLogedIn();
    getReels();
    getSelections();
    _tabController = TabController(vsync: this, length: 12);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  void checkIsLogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogedIn') == true) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
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
                child: Column(children: [
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
                                offset:
                                    Offset(0, 4), // changes position of shadow
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
                                      width: MediaQuery.of(context).size.width *
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
                              GestureDetector(
                                onTap: () {
                                  goToFiltersPage();
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 15, 5),
                                  child: SvgPicture.asset(isFilterOn
                                      ? 'assets/icons/slider_11.svg'
                                      : 'assets/icons/slider_01.svg'),
                                ),
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
                                offset:
                                    Offset(0, 4), // changes position of shadow
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
                      loading = true;
                      setState(() {
                        selectedCategoryId = categories[index]['id'];
                      });
                      searchImpressionList(searchParams);
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
                                  if (isLoggedIn == true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectReelsBookedObjectPage(
                                                    'impression')));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AuthPage()));
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
                        for (int i = 0; i < impressionList.length; i++)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: GestureDetector(
                                    onTap: () async {
                                      if (isLoggedIn == true) {
                                        StoryController _storyController =
                                            StoryController();
                                        List<StoryItem?> thisStoryItems = [];
                                        List<StoryItem?> mediaStoryItems = [];

                                        for (int j = 0;
                                            j <
                                                impressionList[i]
                                                    .videos!
                                                    .length;
                                            j++) {
                                          thisStoryItems.add(
                                            StoryItem.pageVideo(
                                              impressionList[i]
                                                  .videos![j]
                                                  .path!,
                                              controller: _storyController,
                                              imageFit: BoxFit.cover,
                                            ),
                                          );

                                          mediaStoryItems.add(
                                            StoryItem.pageVideo(
                                              impressionList[i]
                                                  .videos![j]
                                                  .path!,
                                              controller: _storyController,
                                              imageFit: BoxFit.fitWidth,
                                            ),
                                          );
                                        }

                                        for (int j = 0;
                                            j <
                                                impressionList[i]
                                                    .images!
                                                    .length;
                                            j++) {
                                          thisStoryItems.add(
                                            StoryItem.pageImage(
                                              url: impressionList[i]
                                                  .images![j]
                                                  .path!,
                                              controller: _storyController,
                                              imageFit: BoxFit.cover,
                                            ),
                                          );

                                          mediaStoryItems.add(
                                            StoryItem.pageImage(
                                              url: impressionList[i]
                                                  .images![j]
                                                  .path!,
                                              controller: _storyController,
                                              imageFit: BoxFit.fitWidth,
                                            ),
                                          );
                                        }

                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ImpressionInfo(
                                              impressionList[i],
                                              thisStoryItems,
                                              mediaStoryItems,
                                            ),
                                          ),
                                        );

                                        setState(() {});
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AuthPage()));
                                      }
                                    },
                                    child: ImpressionCard(
                                        impressionList[i], () {})),
                              ),
                              (i + 1) % 3 == 0
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: SelectionsCard(selections,
                                          selectionsImage, isLoggedIn),
                                    )
                                  : const SizedBox()
                            ],
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
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    searchImpressionList(searchParams);
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

  void goToFiltersPage() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FiltersPage(false, savedFilter),
      ),
    );

    savedFilter = result;

    List<int> rating = [];
    List<int> comforts = [];
    List<int> languages = [];

    for (int i = 0; i < result[2].length; i++) {
      if (result[2][i]['state'] == true) {
        rating.add(5 - i);
      }
    }

    for (var i in result[3]) {
      for (var j in i['comforts']) {
        if (j['state'] == true) {
          comforts.add(j['id']);
        }
      }
    }

    for (int i = 0; i < result[4].length; i++) {
      if (result[4][i]['state'] == true) {
        languages.add(result[4][i]['id']);
      }
    }

    filterList = [result[0], result[1], rating, comforts, languages];
    print(filterList);

    if (rating.isEmpty &&
        comforts.isEmpty &&
        languages.isEmpty &&
        result[0] == 0 &&
        result[1] == 5000000) {
      isFilterOn = false;
    } else {
      isFilterOn = true;
    }

    loading = true;
    impressionList = [];
    setState(() {});

    searchImpressionList(searchParams);
  }

  void openSearchPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(false),
      ),
    );

    if (mounted) {
      if (result != null) {
        if (result == 'toFilter') {
          goToFiltersPage();
        } else {
          searchParams = result;
          searchImpressionList(result);
          setState(() {
            selectedCountryId = result[0];
            if (result[5] != 'Выбрать даты') {
              selectedRange = result[5];
            } else {
              selectedRange = '';
            }
            searchText = result[9];
          });
        }
      } else {
        setState(() {
          selectedCountryId = 0;
          selectedRange = '';
        });
      }
    }
  }

  void searchImpressionList(List<dynamic> params) async {
    impressionList = [];
    var response = await ImpressionProvider().getImpressionFromSearch(
      selectedCategoryId,
      params[0],
      params[1],
      params[2],
      params[3],
      params[4],
      params[6],
      params[7],
      params[8],
      params[9],
      double.parse(filterList[0].toString()),
      double.parse(filterList[1].toString()),
      filterList[2],
      filterList[3],
      filterList[4],
    );
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        impressionList.add(ImpressionCardModel.fromJson(response['data'][i]));
      }
      if (mounted) {
        loading = false;
        setState(() {});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void getReels() async {
    reels = [];
    var response = await MainProvider().getReels('impression');
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

  void getSelections() async {
    var response = await MainProvider().getSelections();
    if (response['response_status'] == 'ok') {
      selections = Selections.fromJson(response['data']);
      selectionsImage = [];

      for (int i = 0; i < selections.items!.length; i++) {
        if (selections.items![i].type == 'housing') {
          if (selections.items![i].housing!.images!.isNotEmpty) {
            selectionsImage.add(selections.items![i].housing!.images!.first);
          }
        } else {
          if (selections.items![i].impression!.images!.isNotEmpty) {
            selectionsImage.add(selections.items![i].impression!.images!.first);
          }
        }
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
