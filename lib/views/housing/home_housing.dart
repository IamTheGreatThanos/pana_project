import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/housing_card.dart';
import 'package:pana_project/models/housingCard.dart';
import 'package:pana_project/services/main_api_provider.dart';
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

  List<HousingCardModel> housingList = [];

  int selectedCategoryId = 1;

  @override
  void initState() {
    getHousingList();
    super.initState();
    _tabController = TabController(vsync: this, length: 12);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset('assets/icons/heart_empty.svg'),
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
                    setState(() {
                      selectedCategoryId = categories[index]['id'];
                    });
                    getHousingList();
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
                            vertical: 20, horizontal: 10),
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            for (int i = 0; i < 6; i++) StoriesCard(i),
                          ],
                        ),
                      ),
                      for (int i = 0; i < housingList.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: HousingCard(housingList[i]),
                        )
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void getHousingList() async {
    var response = await MainProvider().getHousingData(selectedCategoryId);
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        housingList.add(HousingCardModel.fromJson(response['data'][i]));
      }
      if (mounted) {
        setState(() {});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(response['message'], style: const TextStyle(fontSize: 20)),
      ));
    }
  }
}
