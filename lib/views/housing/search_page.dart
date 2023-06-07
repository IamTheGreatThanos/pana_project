import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/other/list_of_countries_page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SearchPage extends StatefulWidget {
  SearchPage(this.fromHousing);
  final bool fromHousing;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final DateRangePickerController _datePickerController =
      DateRangePickerController();
  TextEditingController nameController = TextEditingController();
  int selectedContinentIndex = 0;

  int adultCount = 0;
  int childAfter4Count = 0;
  int childBefore4Count = 0;
  int petsCount = 0;

  String selectedRange = 'Выбрать даты';
  String startDate = '';
  String endDate = '';

  int selectedCityId = 0;
  String selectedCityName = 'Город';

  bool searchBool = true;

  List<Map<String, String>> continents = [
    {'name': 'Гибкий поиск', 'asset': 'assets/images/map_1.png'},
    {'name': 'Казахстан', 'asset': 'assets/images/map_2.png'},
    {'name': 'Россия', 'asset': 'assets/images/map_3.png'},
    {'name': 'Узбекистан', 'asset': 'assets/images/map_4.png'},
    {'name': 'Турция', 'asset': 'assets/images/map_5.png'},
    {'name': 'ОАЭ', 'asset': 'assets/images/map_6.png'},
  ];

  List<Map<String, String>> countrySuggestions = [];
  List<Map<String, String>> citySuggestions = [];
  List<Map<String, String>> impressionSuggestions = [];
  List<Map<String, String>> housingSuggestions = [];

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
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              color: AppColors.lightGray,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: selectedContinentIndex == 0 ? 300 : 380,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                          bottomRight:
                              Radius.circular(AppConstants.cardBorderRadius),
                          bottomLeft:
                              Radius.circular(AppConstants.cardBorderRadius)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
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
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Icon(Icons.arrow_back_ios),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.67,
                                child: TextField(
                                  controller: nameController,
                                  maxLength: 100,
                                  decoration: const InputDecoration(
                                    counterStyle: TextStyle(
                                      height: double.minPositive,
                                    ),
                                    counterText: "",
                                    border: InputBorder.none,
                                    hintText: 'Поиск...',
                                    hintStyle: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      if (selectedContinentIndex == 0 &&
                                          nameController.text != '' &&
                                          searchBool) {
                                        getAutocompleteVariants();
                                      } else {
                                        countrySuggestions = [];
                                        citySuggestions = [];
                                        housingSuggestions = [];
                                        impressionSuggestions = [];
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              height: 170,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  for (int i = 0; i < continents.length; i++)
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedContinentIndex = i;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        selectedContinentIndex ==
                                                                i
                                                            ? AppColors.black
                                                            : AppColors.white,
                                                    width: 2),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                child: SizedBox(
                                                  height: 120,
                                                  width: 120,
                                                  child: Image.asset(
                                                    continents[i]['asset']!,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: Center(
                                            child: Text(
                                              continents[i]['name']!,
                                              style: TextStyle(
                                                  color:
                                                      selectedContinentIndex ==
                                                              i
                                                          ? AppColors.black
                                                          : AppColors
                                                              .blackWithOpacity,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: nameController.text.isNotEmpty &&
                                  (citySuggestions.isNotEmpty ||
                                      countrySuggestions.isNotEmpty ||
                                      (widget.fromHousing
                                          ? housingSuggestions.isNotEmpty
                                          : impressionSuggestions.isNotEmpty)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Container(
                                  height: 190,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        spreadRadius: 0,
                                        blurRadius: 24,
                                        offset: Offset(
                                            0, 4), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                    color: AppColors.white,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        // TODO: Country suggestion
                                        countrySuggestions.isNotEmpty &&
                                                widget.fromHousing
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10, left: 20),
                                                    child: Text(
                                                      'Страна',
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackWithOpacity,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  for (int h = 0;
                                                      h <
                                                          countrySuggestions
                                                              .length;
                                                      h++)
                                                    GestureDetector(
                                                      onTap: () {
                                                        nameController.text =
                                                            countrySuggestions[
                                                                h]['name']!;
                                                        countrySuggestions
                                                            .clear();
                                                        citySuggestions.clear();
                                                        housingSuggestions
                                                            .clear();
                                                        impressionSuggestions
                                                            .clear();
                                                        setState(() {});
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10,
                                                                horizontal: 20),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              decoration: const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              12))),
                                                              width: 24,
                                                              height: 24,
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    countrySuggestions[
                                                                            h][
                                                                        'img']!,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 20),
                                                            Text(
                                                              countrySuggestions[
                                                                  h]['name']!,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            const Spacer(),
                                                            const Icon(Icons
                                                                .arrow_forward_ios),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  const Divider(),
                                                ],
                                              )
                                            : const SizedBox.shrink(),
                                        // TODO: City suggestion
                                        citySuggestions.isNotEmpty
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10, left: 20),
                                                    child: Text(
                                                      'Город',
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackWithOpacity,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  for (int h = 0;
                                                      h <
                                                          citySuggestions
                                                              .length;
                                                      h++)
                                                    GestureDetector(
                                                      onTap: () {
                                                        nameController.text =
                                                            citySuggestions[h]
                                                                ['name']!;
                                                        countrySuggestions
                                                            .clear();
                                                        citySuggestions.clear();
                                                        housingSuggestions
                                                            .clear();
                                                        impressionSuggestions
                                                            .clear();
                                                        setState(() {});
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10,
                                                                horizontal: 20),
                                                        child: Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  citySuggestions[
                                                                          h]
                                                                      ['name']!,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                const SizedBox(
                                                                    height: 5),
                                                                Text(
                                                                  citySuggestions[
                                                                          h][
                                                                      'country']!,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: AppColors
                                                                        .blackWithOpacity,
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                            const Icon(Icons
                                                                .arrow_forward_ios),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  const Divider(),
                                                ],
                                              )
                                            : const SizedBox.shrink(),
                                        // TODO: Housing suggestion
                                        housingSuggestions.isNotEmpty &&
                                                widget.fromHousing
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10, left: 20),
                                                    child: Text(
                                                      'Отель',
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackWithOpacity,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  for (int h = 0;
                                                      h <
                                                          housingSuggestions
                                                              .length;
                                                      h++)
                                                    GestureDetector(
                                                      onTap: () {
                                                        nameController.text =
                                                            housingSuggestions[
                                                                h]['name']!;
                                                        countrySuggestions
                                                            .clear();
                                                        citySuggestions.clear();
                                                        housingSuggestions
                                                            .clear();
                                                        impressionSuggestions
                                                            .clear();
                                                        setState(() {});
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10,
                                                                horizontal: 20),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    12),
                                                              ),
                                                              child: SizedBox(
                                                                width: 40,
                                                                height: 40,
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl:
                                                                      housingSuggestions[
                                                                              h]
                                                                          [
                                                                          'img']!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 20),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  housingSuggestions[
                                                                          h]
                                                                      ['name']!,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                const SizedBox(
                                                                    height: 5),
                                                                Text(
                                                                  housingSuggestions[
                                                                          h]
                                                                      ['city']!,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: AppColors
                                                                        .blackWithOpacity,
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                            const Icon(Icons
                                                                .arrow_forward_ios),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  const Divider(),
                                                ],
                                              )
                                            : const SizedBox.shrink(),
                                        // TODO: Impression suggestion
                                        impressionSuggestions.isNotEmpty &&
                                                !widget.fromHousing
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 0, left: 20),
                                                    child: Text(
                                                      'Впечатление',
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackWithOpacity,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  for (int h = 0;
                                                      h <
                                                          impressionSuggestions
                                                              .length;
                                                      h++)
                                                    GestureDetector(
                                                      onTap: () {
                                                        nameController.text =
                                                            impressionSuggestions[
                                                                h]['name']!;
                                                        countrySuggestions
                                                            .clear();
                                                        citySuggestions.clear();
                                                        housingSuggestions
                                                            .clear();
                                                        impressionSuggestions
                                                            .clear();
                                                        setState(() {});
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10,
                                                                horizontal: 20),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          12)),
                                                              child: SizedBox(
                                                                width: 24,
                                                                height: 24,
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl:
                                                                      impressionSuggestions[
                                                                              h]
                                                                          [
                                                                          'img']!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 20),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  impressionSuggestions[
                                                                          h]
                                                                      ['name']!,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                const SizedBox(
                                                                    height: 5),
                                                                Text(
                                                                  impressionSuggestions[
                                                                          h]
                                                                      ['city']!,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: AppColors
                                                                        .blackWithOpacity,
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                            const Icon(Icons
                                                                .arrow_forward_ios),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  const Divider(),
                                                ],
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        selectedContinentIndex != 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      border: Border.all(
                                          width: 1, color: AppColors.grey)),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Text(
                                          selectedCityName,
                                          style: const TextStyle(
                                              color: Colors.black45,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: GestureDetector(
                                          child: const Text(
                                            'Выбрать',
                                            style: TextStyle(
                                                color: AppColors.accent,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          onTap: () {
                                            goToCities();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop('toFilter');
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppConstants.cardBorderRadius),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          SvgPicture.asset('assets/icons/slider_01.svg'),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Фильтры',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 370,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppConstants.cardBorderRadius),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Кто поедет?',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 5, left: 20),
                                  child: Text(
                                    'Взрослые',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5, left: 20),
                                  child: Text(
                                    'от 18 лет',
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
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
                                child: const Icon(Icons.remove),
                              ),
                              onTap: () {
                                removeAction(1);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                adultCount.toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
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
                                  child: const Icon(Icons.add),
                                ),
                                onTap: () {
                                  addAction(1);
                                },
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Divider(),
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 5, left: 20),
                                  child: Text(
                                    'Дети',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5, left: 20),
                                  child: Text(
                                    'от 4 лет',
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
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
                                child: const Icon(Icons.remove),
                              ),
                              onTap: () {
                                removeAction(2);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                childAfter4Count.toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
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
                                  child: const Icon(Icons.add),
                                ),
                                onTap: () {
                                  addAction(2);
                                },
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Divider(),
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 5, left: 20),
                                  child: Text(
                                    'Младенцы',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5, left: 20),
                                  child: Text(
                                    'до 4 лет',
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
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
                                child: const Icon(Icons.remove),
                              ),
                              onTap: () {
                                removeAction(3);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                childBefore4Count.toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
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
                                  child: const Icon(Icons.add),
                                ),
                                onTap: () {
                                  addAction(3);
                                },
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Divider(),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 5, left: 20),
                              child: Text(
                                'Домашние животные',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
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
                                child: const Icon(Icons.remove),
                              ),
                              onTap: () {
                                removeAction(4);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                petsCount.toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
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
                                  child: const Icon(Icons.add),
                                ),
                                onTap: () {
                                  addAction(4);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppConstants.cardBorderRadius),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            'Дата поездки',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: GestureDetector(
                            child: Text(
                              selectedRange,
                              style: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              showDatePicker();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: SizedBox(
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.accent,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context, [
                                  selectedContinentIndex,
                                  adultCount,
                                  childAfter4Count,
                                  childBefore4Count,
                                  petsCount,
                                  selectedRange,
                                  startDate,
                                  endDate,
                                  selectedCityId,
                                  nameController.text,
                                ]);
                              },
                              child: const Text("Показать результаты",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void goToCities() async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ListOfCountriesPage()));
    selectedCityId = result[0];
    selectedCityName = result[1];

    setState(() {});
  }

  void addAction(int index) async {
    setState(() {
      if (index == 1) {
        adultCount += 1;
      } else if (index == 2) {
        childAfter4Count += 1;
      } else if (index == 3) {
        childBefore4Count += 1;
      } else {
        petsCount += 1;
      }
    });
  }

  void removeAction(int index) async {
    setState(() {
      if (index == 1) {
        if (adultCount > 0) adultCount -= 1;
      } else if (index == 2) {
        if (childAfter4Count > 0) childAfter4Count -= 1;
      } else if (index == 3) {
        if (childBefore4Count > 0) childBefore4Count -= 1;
      } else {
        if (petsCount > 0) petsCount -= 1;
      }
    });
  }

  void showDatePicker() async {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.cardBorderRadius),
            topRight: Radius.circular(AppConstants.cardBorderRadius)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: SizedBox(
            height: 370,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Назад',
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Выбрать даты',
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Готово',
                            style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  SfDateRangePicker(
                    controller: _datePickerController,
                    onSelectionChanged: _onSelectionChanged,
                    startRangeSelectionColor: Colors.black,
                    endRangeSelectionColor: Colors.black,
                    rangeSelectionColor: Colors.black12,
                    selectionColor: AppColors.accent,
                    headerStyle: const DateRangePickerHeaderStyle(
                        textAlign: TextAlign.center),
                    selectionMode: DateRangePickerSelectionMode.range,
                    minDate: DateTime.now(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        selectedRange =
            '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
        if (args.value.startDate != null && args.value.endDate != null) {
          startDate = DateFormat('yyyy-MM-dd').format(args.value.startDate);
          endDate = DateFormat('yyyy-MM-dd').format(args.value.endDate);
        }
      }
    });
  }

  void getAutocompleteVariants() async {
    searchBool = false;
    var response =
        await MainProvider().getAutocompleteText(nameController.text);
    print(response['data']);
    if (response['response_status'] == 'ok') {
      countrySuggestions = [];
      citySuggestions = [];
      impressionSuggestions = [];
      housingSuggestions = [];

      for (int i = 0; i < response['data']['countries'].length; i++) {
        countrySuggestions.add({
          'name': response['data']['countries'][i]['name'],
          'img': response['data']['countries'][i]['icon'],
        });
      }

      for (int i = 0; i < response['data']['cities'].length; i++) {
        citySuggestions.add({
          'name': response['data']['cities'][i]['name'],
          'country': response['data']['cities'][i]['country'] ?? '',
        });
      }

      for (int i = 0; i < response['data']['housings'].length; i++) {
        housingSuggestions.add({
          'name': response['data']['housings'][i]['name'],
          'city': response['data']['housings'][i]['city'] ?? '',
          'img': response['data']['housings'][i]['images'].length > 0
              ? response['data']['housings'][i]['images'][0]['path']
              : 'https://hryoutest.in.ua/uploads/images/default.jpg',
        });
      }

      for (int i = 0; i < response['data']['impressions'].length; i++) {
        impressionSuggestions.add({
          'name': response['data']['impressions'][i]['name'],
          'city': response['data']['impressions'][i]['city'] ?? '',
          'img': response['data']['impressions'][i]['images'].length > 0
              ? response['data']['impressions'][i]['images'][0]['path']
              : 'https://hryoutest.in.ua/uploads/images/default.jpg',
        });
      }

      if (mounted) {
        setState(() {});
        searchBool = true;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
      searchBool = true;
    }
  }
}
