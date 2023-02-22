import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/housing/home_housing.dart';
import 'package:pana_project/views/housing/search_page.dart';
import 'package:pana_project/views/impression/home_impression.dart';
import 'package:pana_project/views/messages/messages_main.dart';
import 'package:pana_project/views/profile/profile_main.dart';
import 'package:pana_project/views/travel/home_travel.dart';
import 'package:uni_links/uni_links.dart';

class TabBarPage extends StatefulWidget {
  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  int selectedTabIndex = 2;
  GlobalKey globalKey = GlobalKey(debugLabel: 'btm_nav_bar');

  List<Widget> tabViews = <Widget>[];

  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    initUniLinks();
    tabViews = <Widget>[
      HomeTravel(changeTabMethod),
      HomeImpression(),
      HomeHousing(),
      MessagesPage(changeTabMethod),
      ProfileMainPage(changeTabMethod),
    ];
  }

  Future<void> initUniLinks() async {
    _sub = uriLinkStream.listen((uri) {
      if (!mounted) return;
      if (uri != null) {
        if (uri.path == '/housing') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchPage(true)));
        }
        print(uri.path);
        print(uri.data);
      }
    });

    // try {
    //   String? initialLink = await getInitialLink();
    //   print(initialLink);
    // } on PlatformException {
    //   print('Platfrom exception unilink.');
    // }
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
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/tab_bar_icon1.svg',
                color: AppColors.blackWithOpacity,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/tab_bar_icon1.svg',
                color: AppColors.accent,
              ),
              label: 'Поездки',
            ),
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
              label: 'Уведомления',
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

  void changeTabMethod() {
    setState(() {
      selectedTabIndex = 2;
    });
  }
}
