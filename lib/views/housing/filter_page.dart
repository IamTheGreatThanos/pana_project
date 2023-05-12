import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/filter_checkbox_item.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/housing/filter_comforts_page.dart';

class FiltersPage extends StatefulWidget {
  FiltersPage(this.fromHousing, this.filterList);
  final bool fromHousing;
  final List<dynamic> filterList;

  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  TextEditingController priceFrom = TextEditingController();
  TextEditingController priceTo = TextEditingController();

  List<Map<String, dynamic>> ratingFilterList = [
    {'title': 'Отлично (5)', 'state': false},
    {'title': 'Хорошо (4)', 'state': false},
    {'title': 'Нормально (3)', 'state': false},
    {'title': 'Плохо (2)', 'state': false},
    {'title': 'Ужасно (1)', 'state': false},
  ];

  List<Map<String, dynamic>> starFilterList = [
    {'title': '5 Звезд', 'state': false},
    {'title': '4 Звезды', 'state': false},
    {'title': '3 Звезды', 'state': false},
    {'title': '2 Звезды', 'state': false},
    {'title': '1 Звезда', 'state': false},
    {'title': 'Без звезд', 'state': false},
  ];

  List<Map<String, dynamic>> foodFilterList = [
    {'title': 'Бесплатный завтрак', 'state': false},
    {'title': 'Платный завтрак', 'state': false},
  ];

  List<Map<String, dynamic>> bedsFilterList = [
    {'title': 'Не важно', 'state': false},
    {'title': '1', 'state': false},
    {'title': '2', 'state': false},
    {'title': '3', 'state': false},
    {'title': '4', 'state': false},
    {'title': '5', 'state': false},
    {'title': '6', 'state': false},
    {'title': '7', 'state': false},
    {'title': '8', 'state': false},
  ];

  List<Map<String, dynamic>> languageFilterList = [
    {'title': 'Русский', 'state': false},
    {'title': 'Казахский', 'state': false},
    {'title': 'Английский', 'state': false},
    {'title': 'Немецкий', 'state': false},
  ];

  double startVal = 0, endVal = 150000;

  @override
  void initState() {
    if (widget.filterList.isNotEmpty) {
      // TODO: this case for housing only
      if (widget.fromHousing) {
        starFilterList = widget.filterList[1];
      }
      ratingFilterList = widget.filterList[0];

      startVal = double.parse(widget.filterList[2].toString());
      priceFrom.text = startVal.toInt().toString();
      endVal = double.parse(widget.filterList[3].toString());
      priceTo.text = endVal.toInt().toString();
    }
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
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            Container(
              color: AppColors.lightGray,
              height: MediaQuery.of(context).size.height * 0.88,
              child: SingleChildScrollView(
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
                                  goBack();
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
                                  'Фильтры',
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
                          height: 2,
                          color: AppColors.white,
                          child: const Divider()),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.grey),
                          color: AppColors.white,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Оценка',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      for (var i in ratingFilterList) {
                                        i['state'] = false;
                                      }

                                      setState(() {});
                                    },
                                    child: const Text(
                                      'Очистить',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                children: [
                                  for (var i in ratingFilterList)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
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
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: widget.fromHousing ? 10 : 0),
                      widget.fromHousing
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: AppColors.grey),
                                color: AppColors.white,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Звездность отеля',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            for (var i in starFilterList) {
                                              i['state'] = false;
                                            }

                                            setState(() {});
                                          },
                                          child: const Text(
                                            'Очистить',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.accent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Wrap(
                                      children: [
                                        for (var i in starFilterList)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
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
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.grey),
                          color: AppColors.white,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Ценновой диапазон',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      startVal = 0;
                                      priceFrom.text =
                                          startVal.toInt().toString();
                                      endVal = 150000;
                                      priceTo.text = endVal.toInt().toString();

                                      setState(() {});
                                    },
                                    child: const Text(
                                      'Очистить',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.fromHousing
                                    ? 'За 1 ночь'
                                    : 'За 1 человека',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackWithOpacity,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SliderTheme(
                                data: const SliderThemeData(trackHeight: 2),
                                child: RangeSlider(
                                  min: 0,
                                  max: 150000,
                                  divisions: 150000,
                                  labels: RangeLabels("от ${startVal.toInt()}",
                                      "до ${endVal.toInt()}"),
                                  values: RangeValues(startVal, endVal),
                                  onChanged: (RangeValues value) {
                                    setState(() {
                                      startVal = value.start;
                                      priceFrom.text =
                                          value.start.toInt().toString();
                                      endVal = value.end;
                                      priceTo.text =
                                          value.end.toInt().toString();
                                    });
                                  },
                                  activeColor: AppColors.black,
                                  inactiveColor: AppColors.grey,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 55,
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: TextField(
                                        controller: priceFrom,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.done,
                                        maxLength: 10,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: AppColors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: AppColors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: AppColors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          counterStyle: const TextStyle(
                                            height: double.minPositive,
                                          ),
                                          counterText: "",
                                          hintText: 'От',
                                          hintStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.blackWithOpacity,
                                          ),
                                          labelStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 55,
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: TextField(
                                        controller: priceTo,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.done,
                                        maxLength: 10,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: AppColors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: AppColors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: AppColors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          counterStyle: const TextStyle(
                                            height: double.minPositive,
                                          ),
                                          counterText: "",
                                          hintText: 'До',
                                          hintStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.blackWithOpacity,
                                          ),
                                          labelStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.grey),
                          color: AppColors.white,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  goToComfortsPage();
                                },
                                child: Row(
                                  children: const [
                                    Text(
                                      'Удобства',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Выберите необходимые удобства',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackWithOpacity,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: widget.fromHousing ? 10 : 0),
                      widget.fromHousing
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: AppColors.grey),
                                color: AppColors.white,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Питание',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            for (var i in foodFilterList) {
                                              i['state'] = false;
                                            }

                                            setState(() {});
                                          },
                                          child: const Text(
                                            'Очистить',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.accent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Wrap(
                                      children: [
                                        for (var i in foodFilterList)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
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
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      SizedBox(height: widget.fromHousing ? 10 : 0),
                      widget.fromHousing
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: AppColors.grey),
                                color: AppColors.white,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Кровати',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            for (var i in bedsFilterList) {
                                              i['state'] = false;
                                            }
                                            setState(() {});
                                          },
                                          child: const Text(
                                            'Очистить',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.accent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Wrap(
                                      children: [
                                        for (var i in bedsFilterList)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
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
                                                    withCheckbox: false,
                                                  ),
                                                  const SizedBox(width: 10),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.grey),
                          color: AppColors.white,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Языки',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      for (var i in languageFilterList) {
                                        i['state'] = false;
                                      }
                                      setState(() {});
                                    },
                                    child: const Text(
                                      'Очистить',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                children: [
                                  for (var i in languageFilterList)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
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
                              )
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
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    for (var i in ratingFilterList) {
                      i['state'] = false;
                    }
                    for (var i in starFilterList) {
                      i['state'] = false;
                    }
                    for (var i in foodFilterList) {
                      i['state'] = false;
                    }
                    for (var i in bedsFilterList) {
                      i['state'] = false;
                    }
                    for (var i in languageFilterList) {
                      i['state'] = false;
                    }
                    startVal = 0;
                    priceFrom.text = startVal.toInt().toString();
                    endVal = 150000;
                    priceTo.text = endVal.toInt().toString();
                    setState(() {});
                  },
                  child: const Text(
                    'Очистить',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    primary: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    goBack();
                  },
                  child: const Text(
                    "Показать результаты",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void goToComfortsPage() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterComfortsPage(),
      ),
    );

    print(result);
  }

  void goBack() async {
    if (widget.fromHousing) {
      Navigator.of(context).pop(
          [ratingFilterList, starFilterList, startVal.toInt(), endVal.toInt()]);
    } else {
      Navigator.of(context)
          .pop([ratingFilterList, startVal.toInt(), endVal.toInt()]);
    }
  }
}
