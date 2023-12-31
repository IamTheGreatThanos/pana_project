import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/models/housingCard.dart';
import 'package:pana_project/models/impressionCard.dart';
import 'package:pana_project/models/reels.dart';
import 'package:pana_project/services/housing_api_provider.dart';
import 'package:pana_project/services/impression_api_provider.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/PageTransitionRoute.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/auth/auth_page.dart';
import 'package:pana_project/views/housing/home_housing.dart';
import 'package:pana_project/views/housing/housing_info.dart';
import 'package:pana_project/views/impression/home_impression.dart';
import 'package:pana_project/views/impression/impression_info.dart';
import 'package:pana_project/views/messages/messages_main.dart';
import 'package:pana_project/views/other/stories_view.dart';
import 'package:pana_project/views/profile/profile_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_view/story_view.dart';
import 'package:uni_links/uni_links.dart';

class TabBarPage extends StatefulWidget {
  TabBarPage(this.selectedTab);
  int selectedTab;
  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  late int selectedTabIndex;
  GlobalKey globalKey = GlobalKey(debugLabel: 'btm_nav_bar');

  List<Widget> tabViews = <Widget>[];

  StreamSubscription? _sub;

  bool isLoggedIn = false;

  @override
  void initState() {
    selectedTabIndex = widget.selectedTab;
    checkIsLogedIn();
    super.initState();
    initUniLinks();
    tabViews = <Widget>[
      // HomeTravel(changeTabMethod),
      // const ComingSoonPage(),
      HomeImpression(changeTabMethod),
      HomeHousing(changeTabMethod),
      MessagesPage(changeTabMethod),
      ProfileMainPage(changeTabMethod),
    ];
  }

  void checkIsLogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogedIn') == true) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
  }

  Future<void> initUniLinks() async {
    _sub = uriLinkStream.listen((uri) {
      print('URI LINK: $uri');
      if (!mounted) return;
      if (uri != null) {
        if (uri.path == '/housing') {
          if (uri.queryParameters.containsKey('id')) {
            if (uri.queryParameters['id'] != null) {
              getHousingInfo(int.parse(uri.queryParameters['id']!));
            }
          }
        } else if (uri.path == '/impression') {
          if (uri.queryParameters.containsKey('id')) {
            if (uri.queryParameters['id'] != null) {
              getImpressionInfo(int.parse(uri.queryParameters['id']!));
            }
          }
        } else if (uri.path == '/reels') {
          if (uri.queryParameters.containsKey('id')) {
            if (uri.queryParameters['id'] != null) {
              getReelsInfo(int.parse(uri.queryParameters['id']!));
            }
          }
        }
      }
    });

    try {
      String? initialLink = await getInitialLink();

      if (!mounted) return;
      if (initialLink != null) {
        Uri uri = Uri.parse(initialLink);

        if (uri.path == '/housing') {
          if (uri.queryParameters.containsKey('id')) {
            if (uri.queryParameters['id'] != null) {
              getHousingInfo(int.parse(uri.queryParameters['id']!));
            }
          }
        } else if (uri.path == '/impression') {
          if (uri.queryParameters.containsKey('id')) {
            if (uri.queryParameters['id'] != null) {
              getImpressionInfo(int.parse(uri.queryParameters['id']!));
            }
          }
        } else if (uri.path == '/reels') {
          if (uri.queryParameters.containsKey('id')) {
            if (uri.queryParameters['id'] != null) {
              getReelsInfo(int.parse(uri.queryParameters['id']!));
            }
          }
        }
      }
    } on PlatformException {
      print('Platfrom exception unilink.');
    }
  }

  void getHousingInfo(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lat = prefs.getString('lastLat');
    String? lng = prefs.getString('lastLng');
    var response =
        await HousingProvider().getHousingDetail(id, lat ?? '', lng ?? '');
    if (response['response_status'] == 'ok') {
      HousingCardModel thisHousing =
          HousingCardModel.fromJson(response['data']);

      if (isLoggedIn == true) {
        StoryController storyController = StoryController();
        List<StoryItem?> thisStoryItems = [];
        List<StoryItem?> mediaStoryItems = [];

        for (int j = 0; j < thisHousing.images!.length; j++) {
          thisStoryItems.add(
            StoryItem.pageImage(
              url: thisHousing.images![j].path!,
              controller: storyController,
              imageFit: BoxFit.cover,
            ),
          );

          mediaStoryItems.add(
            StoryItem.pageImage(
              url: thisHousing.images![j].path!,
              controller: storyController,
              imageFit: BoxFit.fitWidth,
            ),
          );
        }

        await Navigator.push(
          context,
          ThisPageRoute(
            HousingInfo(
              thisHousing.id!,
              thisStoryItems,
              mediaStoryItems,
              lat ?? '', lng ?? '',
              // thisHousing.distance == -1
              //     ? '-'
              //     : thisHousing.distance.toString(),
              '',
              '',
            ),
          ),
        );
        setState(() {});
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AuthPage()));
      }
    } else {
      print(response['data']['message']);
    }
  }

  void getImpressionInfo(int id) async {
    var response = await ImpressionProvider().getImpressionDetail(id);
    if (response['response_status'] == 'ok') {
      ImpressionCardModel thisImpression =
          ImpressionCardModel.fromJson(response['data']);

      if (isLoggedIn == true) {
        StoryController _storyController = StoryController();
        List<StoryItem?> thisStoryItems = [];
        List<StoryItem?> mediaStoryItems = [];

        for (int j = 0; j < (thisImpression.videos?.length ?? 0); j++) {
          thisStoryItems.add(
            StoryItem.pageVideo(
              thisImpression.videos![j].path!,
              controller: _storyController,
              imageFit: BoxFit.cover,
            ),
          );

          mediaStoryItems.add(
            StoryItem.pageVideo(
              thisImpression.videos![j].path!,
              controller: _storyController,
              imageFit: BoxFit.fitWidth,
            ),
          );
        }

        for (int j = 0; j < thisImpression.images!.length; j++) {
          thisStoryItems.add(
            StoryItem.pageImage(
              url: thisImpression.images![j].path!,
              controller: _storyController,
              imageFit: BoxFit.cover,
            ),
          );

          mediaStoryItems.add(
            StoryItem.pageImage(
              url: thisImpression.images![j].path!,
              controller: _storyController,
              imageFit: BoxFit.fitWidth,
            ),
          );
        }

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImpressionInfo(
              thisImpression,
              thisStoryItems,
              mediaStoryItems,
            ),
          ),
        );

        setState(() {});
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AuthPage()));
      }
    } else {
      print(response['data']['message']);
    }
  }

  void getReelsInfo(int id) async {
    var response = await MainProvider().getReelInfo(id);

    if (response['response_status'] == 'ok') {
      Reels reel = Reels.fromJson(response['data']);

      if (isLoggedIn == true) {
        await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => StoriesView([reel], 0)));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AuthPage()));
      }
    } else {
      print(response['data']['message']);
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
        body: tabViews[selectedTabIndex],
        bottomNavigationBar: BottomNavigationBar(
          key: globalKey,
          items: <BottomNavigationBarItem>[
            // BottomNavigationBarItem(
            //   icon: SvgPicture.asset(
            //     'assets/icons/tab_bar_icon1.svg',
            //     color: AppColors.blackWithOpacity,
            //   ),
            //   activeIcon: SvgPicture.asset(
            //     'assets/icons/tab_bar_icon1.svg',
            //     color: AppColors.accent,
            //   ),
            //   label: 'Поездки',
            // ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/tab_bar_icon2.svg',
                color: AppColors.blackWithOpacity,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/tab_bar_icon2.svg',
                color: AppColors.accent,
              ),
              label: 'Впечатления',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/tab_bar_icon3.svg',
                color: AppColors.blackWithOpacity,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/tab_bar_icon3.svg',
                color: AppColors.accent,
              ),
              label: 'Жилье',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/tab_bar_icon4.svg',
                color: AppColors.blackWithOpacity,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/tab_bar_icon4.svg',
                color: AppColors.accent,
              ),
              label: 'Входящие',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/tab_bar_icon5.svg',
                color: AppColors.blackWithOpacity,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/tab_bar_icon5.svg',
                color: AppColors.accent,
              ),
              label: 'Профиль',
            ),
          ],
          currentIndex: selectedTabIndex,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.blackWithOpacity,
          showUnselectedLabels: true,
          selectedLabelStyle:
              const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          onTap: (int index) {
            setState(() {
              selectedTabIndex = index;
            });
          },
        ),
      ),
    );
  }

  void changeTabMethod(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }
}
