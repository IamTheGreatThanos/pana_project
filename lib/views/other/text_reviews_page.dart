import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/text_review_card.dart';
import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/models/impressionDetail.dart';
import 'package:pana_project/models/textReview.dart';
import 'package:pana_project/utils/const.dart';

class TextReviewsPage extends StatefulWidget {
  TextReviewsPage(this.reviews, this.housing, this.impression);
  final List<TextReviewModel> reviews;
  final HousingDetailModel? housing;
  final ImpressionDetailModel? impression;

  @override
  _TextReviewsPageState createState() => _TextReviewsPageState();
}

class _TextReviewsPageState extends State<TextReviewsPage> {
  List<TextReviewModel> displayedReviews = [];
  String categoryFilterText = 'По категориям';
  String reviewFilterText = 'По отзывам';
  int choseCategoryFilterIndex = -1;
  int choseReviewFilterIndex = 0;

  @override
  void initState() {
    displayedReviews = widget.reviews;
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
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
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
                            child:
                                SvgPicture.asset('assets/icons/back_arrow.svg'),
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Отзывы',
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
                const Divider(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text('Фильтр:'),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            showCategoryFilterModalSheet();
                          },
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: AppColors.grey),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: Row(
                                children: [
                                  Text(
                                    categoryFilterText,
                                    style: const TextStyle(
                                      color: AppColors.blackWithOpacity,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: AppColors.grey,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            showReviewFilterModalSheet();
                          },
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: AppColors.grey),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: Row(
                                children: [
                                  Text(
                                    reviewFilterText,
                                    style: const TextStyle(
                                      color: AppColors.blackWithOpacity,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: AppColors.grey,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ),
                  ),
                ),
                Container(color: Colors.white, child: const Divider()),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.77,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Общая оценка',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    widget.housing != null
                                        ? (widget.housing?.reviewsBallAvg ??
                                            '0')
                                        : (widget.impression?.reviewsAvgBall ??
                                            '0'),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              for (int i = 0;
                                  i <
                                      double.parse(widget.housing != null
                                              ? (widget.housing
                                                      ?.reviewsBallAvg ??
                                                  '0')
                                              : (widget.impression
                                                      ?.reviewsAvgBall ??
                                                  '0'))
                                          .toInt();
                                  i++)
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SvgPicture.asset(
                                    'assets/icons/star.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              for (int i = 0;
                                  i <
                                      5 -
                                          double.parse(widget.housing != null
                                                  ? (widget.housing
                                                          ?.reviewsBallAvg ??
                                                      '0')
                                                  : (widget.impression
                                                          ?.reviewsAvgBall ??
                                                      '0'))
                                              .toInt();
                                  i++)
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SvgPicture.asset(
                                    'assets/icons/star.svg',
                                    width: 24,
                                    height: 24,
                                    color: AppColors.lightGray,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        widget.housing != null
                            ? Column(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Divider(),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 20, bottom: 10),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Цена/Качество',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              double.parse(widget.housing!
                                                          .reviewsPriceAvg ??
                                                      '0')
                                                  .toString(),
                                              style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0,
                                            left: 20,
                                            bottom: 10,
                                            right: 20),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          child: LinearProgressIndicator(
                                            backgroundColor: AppColors.grey,
                                            color: AppColors.accent,
                                            minHeight: 3,
                                            value: double.parse(widget.housing!
                                                        .reviewsPriceAvg ??
                                                    '0') /
                                                5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 20, bottom: 10),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Атмосфера',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              double.parse(widget.housing!
                                                          .reviewsAtmosphereAvg ??
                                                      '0')
                                                  .toString(),
                                              style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0,
                                            left: 20,
                                            bottom: 10,
                                            right: 20),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          child: LinearProgressIndicator(
                                            backgroundColor: AppColors.grey,
                                            color: AppColors.accent,
                                            minHeight: 3,
                                            value: double.parse(widget.housing!
                                                        .reviewsAtmosphereAvg ??
                                                    '0') /
                                                5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 20, bottom: 10),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Чистота',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              double.parse(widget.housing!
                                                          .reviewsPurityAvg ??
                                                      '0')
                                                  .toString(),
                                              style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0,
                                            left: 20,
                                            bottom: 10,
                                            right: 20),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          child: LinearProgressIndicator(
                                            backgroundColor: AppColors.grey,
                                            color: AppColors.accent,
                                            minHeight: 3,
                                            value: double.parse(widget.housing!
                                                        .reviewsPurityAvg ??
                                                    '0') /
                                                5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 20, bottom: 10),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Персонал',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              double.parse(widget.housing!
                                                          .reviewsStaffAvg ??
                                                      '0')
                                                  .toString(),
                                              style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0,
                                            left: 20,
                                            bottom: 10,
                                            right: 20),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          child: LinearProgressIndicator(
                                            backgroundColor: AppColors.grey,
                                            color: AppColors.accent,
                                            minHeight: 3,
                                            value: double.parse(widget.housing!
                                                        .reviewsStaffAvg ??
                                                    '0') /
                                                5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        Container(color: Colors.white, child: const Divider()),
                        for (int i = 0; i < displayedReviews.length; i++)
                          Column(
                            children: [
                              TextReviewCard(
                                displayedReviews[i],
                              ),
                              const Divider(thickness: 2),
                            ],
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showReviewFilterModalSheet() async {
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
            height: 400,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: const Text(
                      'Сортировать по:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      choseReviewFilterIndex = 0;
                      reviewFilterText = 'Недавно побывавшие';
                      setState(() {});
                      Navigator.pop(context);
                      sortByReview();
                    },
                    child: Row(
                      children: [
                        const Text(
                          'Недавно побывавшие',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.blackWithOpacity,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        choseReviewFilterIndex == 0
                            ? SvgPicture.asset('assets/icons/checkbox_full.svg')
                            : SvgPicture.asset(
                                'assets/icons/checkbox_empty.svg'),
                      ],
                    ),
                  ),
                  const Divider(height: 35),
                  GestureDetector(
                    onTap: () {
                      choseReviewFilterIndex = 1;
                      reviewFilterText = 'Сначала новые отзывы';
                      setState(() {});
                      Navigator.pop(context);
                      sortByReview();
                    },
                    child: Row(
                      children: [
                        const Text(
                          'Сначала новые отзывы',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.blackWithOpacity,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        choseReviewFilterIndex == 1
                            ? SvgPicture.asset('assets/icons/checkbox_full.svg')
                            : SvgPicture.asset(
                                'assets/icons/checkbox_empty.svg'),
                      ],
                    ),
                  ),
                  const Divider(height: 35),
                  GestureDetector(
                    onTap: () {
                      choseReviewFilterIndex = 2;
                      reviewFilterText = 'Сначала с низкой оценкой';
                      setState(() {});
                      Navigator.pop(context);
                      sortByReview();
                    },
                    child: Row(
                      children: [
                        const Text(
                          'Сначала с низкой оценкой',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.blackWithOpacity,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        choseReviewFilterIndex == 2
                            ? SvgPicture.asset('assets/icons/checkbox_full.svg')
                            : SvgPicture.asset(
                                'assets/icons/checkbox_empty.svg'),
                      ],
                    ),
                  ),
                  const Divider(height: 35),
                  GestureDetector(
                    onTap: () {
                      choseReviewFilterIndex = 3;
                      reviewFilterText = 'Сначала с высокой оценкой';
                      setState(() {});
                      Navigator.pop(context);
                      sortByReview();
                    },
                    child: Row(
                      children: [
                        const Text(
                          'Сначала с высокой оценкой',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.blackWithOpacity,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        choseReviewFilterIndex == 3
                            ? SvgPicture.asset('assets/icons/checkbox_full.svg')
                            : SvgPicture.asset(
                                'assets/icons/checkbox_empty.svg'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: AppColors.accent),
                              borderRadius:
                                  BorderRadius.circular(10), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            choseReviewFilterIndex = 0;
                            reviewFilterText = 'По отзывам';
                            sortByCategory();
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Сбросить",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: AppColors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: AppColors.accent),
                              borderRadius:
                                  BorderRadius.circular(10), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Отмена",
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showCategoryFilterModalSheet() async {
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
            height: 400,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: const Text(
                      'Сортировать по:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      choseCategoryFilterIndex = 0;
                      categoryFilterText = 'Цена / Качество';
                      setState(() {});
                      Navigator.pop(context);
                      sortByCategory();
                    },
                    child: Row(
                      children: [
                        const Text(
                          'Цена / Качество',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.blackWithOpacity,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        choseCategoryFilterIndex == 0
                            ? SvgPicture.asset('assets/icons/checkbox_full.svg')
                            : SvgPicture.asset(
                                'assets/icons/checkbox_empty.svg'),
                      ],
                    ),
                  ),
                  const Divider(height: 35),
                  GestureDetector(
                    onTap: () {
                      choseCategoryFilterIndex = 1;
                      categoryFilterText = 'Персонал';
                      setState(() {});
                      Navigator.pop(context);
                      sortByCategory();
                    },
                    child: Row(
                      children: [
                        const Text(
                          'Персонал',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.blackWithOpacity,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        choseCategoryFilterIndex == 1
                            ? SvgPicture.asset('assets/icons/checkbox_full.svg')
                            : SvgPicture.asset(
                                'assets/icons/checkbox_empty.svg'),
                      ],
                    ),
                  ),
                  const Divider(height: 35),
                  GestureDetector(
                    onTap: () {
                      choseCategoryFilterIndex = 2;
                      categoryFilterText = 'Атмосфера';
                      setState(() {});
                      Navigator.pop(context);
                      sortByCategory();
                    },
                    child: Row(
                      children: [
                        const Text(
                          'Атмосфера',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.blackWithOpacity,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        choseCategoryFilterIndex == 2
                            ? SvgPicture.asset('assets/icons/checkbox_full.svg')
                            : SvgPicture.asset(
                                'assets/icons/checkbox_empty.svg'),
                      ],
                    ),
                  ),
                  const Divider(height: 35),
                  GestureDetector(
                    onTap: () {
                      choseCategoryFilterIndex = 3;
                      categoryFilterText = 'Чистота';
                      setState(() {});
                      Navigator.pop(context);
                      sortByCategory();
                    },
                    child: Row(
                      children: [
                        const Text(
                          'Чистота',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.blackWithOpacity,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        choseCategoryFilterIndex == 3
                            ? SvgPicture.asset('assets/icons/checkbox_full.svg')
                            : SvgPicture.asset(
                                'assets/icons/checkbox_empty.svg'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: AppColors.accent),
                              borderRadius:
                                  BorderRadius.circular(10), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            choseCategoryFilterIndex = -1;
                            categoryFilterText = 'По категориям';
                            sortByCategory();
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Сбросить",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: AppColors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: AppColors.accent),
                              borderRadius:
                                  BorderRadius.circular(10), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Отмена",
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void sortByReview() {
    choseCategoryFilterIndex = -1;
    categoryFilterText = 'По категориям';

    if (choseReviewFilterIndex == 0) {
      displayedReviews = widget.reviews;
    } else if (choseReviewFilterIndex == 1) {
      displayedReviews = widget.reviews;
      displayedReviews.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    } else if (choseReviewFilterIndex == 2) {
      displayedReviews = widget.reviews;
      displayedReviews.sort((a, b) => (a.ball ?? 0).compareTo((b.ball ?? 0)));
    } else if (choseReviewFilterIndex == 3) {
      displayedReviews = widget.reviews;
      displayedReviews.sort((a, b) => (b.ball ?? 0).compareTo((a.ball ?? 0)));
    }

    setState(() {});
  }

  void sortByCategory() {
    choseReviewFilterIndex = 0;
    reviewFilterText = 'По отзывам';

    if (choseCategoryFilterIndex == 0) {
      displayedReviews = widget.reviews;
      displayedReviews.sort((a, b) => a.price!.compareTo(b.price!));
    } else if (choseCategoryFilterIndex == 1) {
      displayedReviews = widget.reviews;
      displayedReviews.sort((a, b) => a.staff!.compareTo(b.staff!));
    } else if (choseCategoryFilterIndex == 2) {
      displayedReviews = widget.reviews;
      displayedReviews.sort((a, b) => a.atmosphere!.compareTo(b.atmosphere!));
    } else {
      displayedReviews = widget.reviews;
      displayedReviews.sort((a, b) => a.purity!.compareTo(b.purity!));
    }

    setState(() {});
  }
}
