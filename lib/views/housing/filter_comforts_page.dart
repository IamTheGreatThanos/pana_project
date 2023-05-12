import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/filter_checkbox_item.dart';
import 'package:pana_project/utils/const.dart';

class FilterComfortsPage extends StatefulWidget {
  FilterComfortsPage();

  @override
  _FilterComfortsPageState createState() => _FilterComfortsPageState();
}

class _FilterComfortsPageState extends State<FilterComfortsPage> {
  List<Map<String, dynamic>> popularComfortList = [
    {'title': 'Wifi', 'state': false},
    {'title': 'Парковка', 'state': false},
    {'title': 'Завтрак', 'state': false},
    {'title': 'Утюг', 'state': false},
    {'title': 'Посудомойка', 'state': false},
    {'title': 'Вентилятор', 'state': false},
    {'title': 'Кондиционер', 'state': false},
    {'title': 'Пылесос', 'state': false},
    {'title': 'Чайник', 'state': false},
    {'title': 'Приборы', 'state': false},
    {'title': 'Ванная', 'state': false},
    {'title': 'Кухня', 'state': false},
    {'title': 'Стиралка', 'state': false},
    {'title': 'Кухня', 'state': false},
  ];

  List<Map<String, dynamic>> hotelComfortList = [
    {'title': 'Wifi', 'state': false},
    {'title': 'Парковка', 'state': false},
    {'title': 'Завтрак', 'state': false},
    {'title': 'Утюг', 'state': false},
    {'title': 'Посудомойка', 'state': false},
    {'title': 'Вентилятор', 'state': false},
    {'title': 'Кондиционер', 'state': false},
    {'title': 'Пылесос', 'state': false},
    {'title': 'Чайник', 'state': false},
    {'title': 'Приборы', 'state': false},
    {'title': 'Ванная', 'state': false},
    {'title': 'Кухня', 'state': false},
    {'title': 'Стиралка', 'state': false},
    {'title': 'Кухня', 'state': false},
  ];

  List<Map<String, dynamic>> bathroomComfortList = [
    {'title': 'Wifi', 'state': false},
    {'title': 'Парковка', 'state': false},
    {'title': 'Завтрак', 'state': false},
    {'title': 'Утюг', 'state': false},
    {'title': 'Посудомойка', 'state': false},
    {'title': 'Вентилятор', 'state': false},
    {'title': 'Кондиционер', 'state': false},
    {'title': 'Пылесос', 'state': false},
    {'title': 'Чайник', 'state': false},
    {'title': 'Приборы', 'state': false},
    {'title': 'Ванная', 'state': false},
    {'title': 'Кухня', 'state': false},
    {'title': 'Стиралка', 'state': false},
    {'title': 'Кухня', 'state': false},
  ];

  List<Map<String, dynamic>> guestroomComfortList = [
    {'title': 'Wifi', 'state': false},
    {'title': 'Парковка', 'state': false},
    {'title': 'Завтрак', 'state': false},
    {'title': 'Утюг', 'state': false},
    {'title': 'Посудомойка', 'state': false},
    {'title': 'Вентилятор', 'state': false},
    {'title': 'Кондиционер', 'state': false},
    {'title': 'Пылесос', 'state': false},
    {'title': 'Чайник', 'state': false},
    {'title': 'Приборы', 'state': false},
    {'title': 'Ванная', 'state': false},
    {'title': 'Кухня', 'state': false},
    {'title': 'Стиралка', 'state': false},
    {'title': 'Кухня', 'state': false},
  ];

  @override
  void initState() {
    super.initState();
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
        backgroundColor: AppColors.lightGray,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  color: AppColors.white,
                  height: 20,
                ),
                Container(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop('sdf');
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                  'assets/icons/back_arrow.svg'),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Удобства',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(right: 0),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    height: 2, color: AppColors.white, child: const Divider()),
                const SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TODO: Популярные удобства
                        const Text(
                          'Популярные удобства',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackWithOpacity,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          children: [
                            for (var i in popularComfortList)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    i['state'] = !i['state'];
                                    setState(() {});
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FilterCheckboxItem(
                                        title: i['title'],
                                        isChecked: i['state'],
                                        withCheckbox: true,
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 15),
                        // TODO: Удобства в отеле
                        const Text(
                          'Удобства в отеле',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackWithOpacity,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          children: [
                            for (var i in hotelComfortList)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    i['state'] = !i['state'];
                                    setState(() {});
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FilterCheckboxItem(
                                        title: i['title'],
                                        isChecked: i['state'],
                                        withCheckbox: true,
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 15),
                        // TODO: Ванная комната
                        const Text(
                          'Ванная комната',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackWithOpacity,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          children: [
                            for (var i in bathroomComfortList)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    i['state'] = !i['state'];
                                    setState(() {});
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FilterCheckboxItem(
                                        title: i['title'],
                                        isChecked: i['state'],
                                        withCheckbox: true,
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 15),
                        // TODO: Гостинная
                        const Text(
                          'Гостинная',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackWithOpacity,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          children: [
                            for (var i in guestroomComfortList)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    i['state'] = !i['state'];
                                    setState(() {});
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FilterCheckboxItem(
                                        title: i['title'],
                                        isChecked: i['state'],
                                        withCheckbox: true,
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
