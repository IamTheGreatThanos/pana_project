import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/filter_checkbox_item.dart';
import 'package:pana_project/components/filter_checkbox_item_for_stars.dart';
import 'package:pana_project/services/main_api_provider.dart';
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
    {'title': '5', 'state': false},
    {'title': '4', 'state': false},
    {'title': '3', 'state': false},
    {'title': '2', 'state': false},
    {'title': '1', 'state': false},
  ];
  List<Map<String, dynamic>> foodFilterList = [];
  List<Map<String, dynamic>> bedsFilterList = [];
  List<Map<String, dynamic>> languageFilterList = [];
  List<Map<String, dynamic>> petsFilterList = [
    {'title': 'Платно', 'state': false},
    {'title': 'Бесплатно', 'state': false},
  ];
  List<Map<String, dynamic>> childrenFilterList = [
    {'title': 'Платно', 'state': false},
    {'title': 'Бесплатно', 'state': false},
  ];
  List<Map<String, dynamic>> locationFilterList = [];

  double startVal = 0, endVal = 5000000;
  List<int> comforts = [];
  List<Map<String, dynamic>> comfortsTemp = [];

  @override
  void initState() {
    if (widget.filterList.isNotEmpty) {
      // TODO: this case for housing only
      if (widget.fromHousing) {
        starFilterList = widget.filterList[3];
        comfortsTemp = widget.filterList[4];

        comforts = [];

        for (var i in comfortsTemp) {
          for (var j in i['comforts']) {
            if (j['state'] == true) {
              comforts.add(j['id']);
            }
          }
        }

        foodFilterList = widget.filterList[5];

        bedsFilterList = widget.filterList[6];
        languageFilterList = widget.filterList[7];
        petsFilterList = widget.filterList[8];
        childrenFilterList = widget.filterList[9];
        locationFilterList = widget.filterList[10];
      } else {
        comfortsTemp = widget.filterList[3];

        comforts = [];

        for (var i in comfortsTemp) {
          for (var j in i['comforts']) {
            if (j['state'] == true) {
              comforts.add(j['id']);
            }
          }
        }
        languageFilterList = widget.filterList[4];
      }
      ratingFilterList = widget.filterList[2];

      startVal = double.parse(widget.filterList[0].toString());
      priceFrom.text = startVal.toInt().toString();
      endVal = double.parse(widget.filterList[1].toString());
      priceTo.text = endVal.toInt().toString();
    } else {
      getLocations();
      getBreakfasts();
      getBed();
      getLanguages();
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
                                    'Ценовой диапазон',
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
                                      endVal = 5000000;
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
                                  max: 5000000,
                                  divisions: 5000000,
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
                                        onChanged: (value) {
                                          if (int.tryParse(value.toString()) !=
                                              null) {
                                            double newValue =
                                                double.parse(value.toString());
                                            if (newValue < endVal &&
                                                newValue >= 0) {
                                              startVal = newValue;
                                            }

                                            setState(() {});
                                          }
                                        },
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
                                        onChanged: (value) {
                                          if (int.tryParse(value.toString()) !=
                                              null) {
                                            double newValue =
                                                double.parse(value.toString());
                                            if (newValue > startVal &&
                                                newValue <= 5000000) {
                                              endVal = newValue;
                                            }

                                            setState(() {});
                                          }
                                        },
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
                                                  FilterCheckboxItemForStars(
                                                    title: i['title'],
                                                    isChecked: i['state'],
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
                                          'Локации',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            for (var i in locationFilterList) {
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
                                        for (var i in locationFilterList)
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          goToComfortsPage();
                                        },
                                        child: const Text(
                                          'Удобства',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        comforts.isEmpty
                                            ? 'Выберите необходимые удобства'
                                            : 'Выбранно ${comforts.length} удобств',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.blackWithOpacity,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                              comforts.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          comforts = [];
                                          comfortsTemp = [];

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
                                    )
                                  : const SizedBox.shrink(),
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
                      widget.fromHousing
                          ? const SizedBox(height: 10)
                          : const SizedBox.shrink(),
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
                                          'Домашние животные',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            for (var i in petsFilterList) {
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
                                        for (var i in petsFilterList)
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
                      widget.fromHousing
                          ? const SizedBox(height: 10)
                          : const SizedBox.shrink(),
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
                                          'Размещение детей',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            for (var i in childrenFilterList) {
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
                                        for (var i in childrenFilterList)
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
                    for (var i in petsFilterList) {
                      i['state'] = false;
                    }
                    for (var i in childrenFilterList) {
                      i['state'] = false;
                    }
                    for (var i in locationFilterList) {
                      i['state'] = false;
                    }
                    startVal = 0;
                    priceFrom.text = startVal.toInt().toString();
                    endVal = 5000000;
                    priceTo.text = endVal.toInt().toString();
                    comforts = [];
                    comfortsTemp = [];
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
        builder: (context) =>
            FilterComfortsPage(widget.fromHousing, comfortsTemp),
      ),
    );

    comfortsTemp = result;

    comforts = [];

    for (var i in result) {
      for (var j in i['comforts']) {
        if (j['state'] == true) {
          comforts.add(j['id']);
        }
      }
    }

    setState(() {});

    print(comforts);
  }

  void goBack() async {
    if (widget.fromHousing) {
      Navigator.of(context).pop([
        startVal.toInt(),
        endVal.toInt(),
        ratingFilterList,
        starFilterList,
        comfortsTemp,
        foodFilterList,
        bedsFilterList,
        languageFilterList,
        petsFilterList,
        childrenFilterList,
        locationFilterList,
      ]);
    } else {
      Navigator.of(context).pop([
        startVal.toInt(),
        endVal.toInt(),
        ratingFilterList,
        comfortsTemp,
        languageFilterList,
      ]);
    }
  }

  void getBreakfasts() async {
    var response = await MainProvider().getBreakfasts();

    if (response['response_status'] == 'ok') {
      for (int j = 0; j < response['data'].length; j++) {
        foodFilterList.add({
          'title': response['data'][j]['name'],
          'id': response['data'][j]['id'],
          'state': false
        });
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

  void getBed() async {
    var response = await MainProvider().getBed();

    if (response['response_status'] == 'ok') {
      for (int j = 0; j < response['data'].length; j++) {
        bedsFilterList.add({
          'title': response['data'][j]['name'],
          'id': response['data'][j]['id'],
          'state': false
        });
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

  void getLanguages() async {
    var response = await MainProvider().getLanguages();

    if (response['response_status'] == 'ok') {
      for (int j = 0; j < response['data'].length; j++) {
        languageFilterList.add({
          'title': response['data'][j]['name'],
          'id': response['data'][j]['id'],
          'state': false
        });
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

  void getLocations() async {
    var response = await MainProvider().getLocations();

    if (response['response_status'] == 'ok') {
      for (int j = 0; j < response['data'].length; j++) {
        locationFilterList.add({
          'title': response['data'][j]['name'],
          'id': response['data'][j]['id'],
          'state': false
        });
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
