import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/housing_card.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/housing/search_page.dart';
import 'package:story_view/controller/story_controller.dart';

import '../../components/stories_card.dart';

class HomeHousing extends StatefulWidget {
  @override
  _HomeHousingState createState() => _HomeHousingState();
}

class _HomeHousingState extends State<HomeHousing>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StoryController controller = StoryController();

  List<Map<String, String>> categories = [
    {'name': 'Отели', 'asset': 'assets/icons/category_1.svg'},
    {'name': 'Бутик-отели', 'asset': 'assets/icons/category_2.svg'},
    {'name': 'Загородный дом', 'asset': 'assets/icons/category_3.svg'},
    {'name': 'Апартаменты', 'asset': 'assets/icons/category_4.svg'},
    {'name': 'Юрта', 'asset': 'assets/icons/category_5.svg'},
    {'name': 'Шалаши', 'asset': 'assets/icons/category_6.svg'},
    {'name': 'У моря', 'asset': 'assets/icons/category_7.svg'},
    {'name': 'Кемпинги', 'asset': 'assets/icons/category_8.svg'},
    {'name': 'Авто-дом', 'asset': 'assets/icons/category_9.svg'},
    {'name': 'Особняк', 'asset': 'assets/icons/category_10.svg'},
    {'name': 'С историей', 'asset': 'assets/icons/category_11.svg'},
    {'name': 'На дереве', 'asset': 'assets/icons/category_12.svg'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 12);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {});
    print(_tabController.index);
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
            body: SingleChildScrollView(
              child: Container(
                color: AppColors.lightGray,
                width: MediaQuery.of(context).size.width,
                child: Column(children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage()));
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.66,
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
                              const Text(
                                'Поиск...',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 5),
                                child: VerticalDivider(),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 15, 5),
                                child: SvgPicture.asset(
                                    'assets/icons/slider_01.svg'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
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
                              offset:
                                  Offset(0, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child:
                              SvgPicture.asset('assets/icons/heart_empty.svg'),
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
                              vertical: 20, horizontal: 10),
                          height: 150,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              for (int i = 0; i < 6; i++) StoriesCard(i),
                            ],
                          ),
                        ),
                        for (int i = 0; i < 10; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: HousingCard(),
                          )
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ));
  }
}
