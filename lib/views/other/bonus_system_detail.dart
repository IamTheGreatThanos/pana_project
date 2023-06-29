import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/bonus_card.dart';
import 'package:pana_project/models/bonusItems.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/other/about_bonus_system_page.dart';

class BonusSystemDetailPage extends StatefulWidget {
  final List<BonusItems> bonusItems;
  final int count1;
  final int count2;
  final int bonusSystemId;

  BonusSystemDetailPage(
      this.bonusItems, this.count1, this.count2, this.bonusSystemId);

  @override
  _BonusSystemDetailPageState createState() => _BonusSystemDetailPageState();
}

class _BonusSystemDetailPageState extends State<BonusSystemDetailPage> {
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
        backgroundColor: AppColors.black.withOpacity(0.7),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const SizedBox(
                        width: 50,
                        height: 50,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Мой прогресс',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 50)
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Кол-во посещений до следующего подарка:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${widget.count1} / ${widget.count2}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 380,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 0, left: 75),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: ((85 *
                                                            ((widget.bonusItems
                                                                        .length -
                                                                    1) *
                                                                2))
                                                        .toDouble() *
                                                    widget.bonusSystemId /
                                                    widget.bonusItems.length) -
                                                25,
                                          ),
                                          SizedBox(
                                            width: 50,
                                            height: 67,
                                            child: Image.asset(
                                                'assets/icons/progress_assik.png'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        child: SizedBox(
                                          height: 5,
                                          width: (85 *
                                                  ((widget.bonusItems.length -
                                                          1) *
                                                      2))
                                              .toDouble(),
                                          child: LinearProgressIndicator(
                                            value: widget.bonusSystemId /
                                                widget.bonusItems.length,
                                            color: AppColors.white,
                                            backgroundColor: Color(0xFF2B2B2B),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const SizedBox(width: 20),
                                    for (int i = 0;
                                        i < widget.bonusItems.length;
                                        i++)
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              const SizedBox(height: 70),
                                              SvgPicture.asset(
                                                  './assets/icons/bonus_gift_1.svg'),
                                              const SizedBox(height: 20),
                                              BonusCard(
                                                colorType: (widget
                                                            .bonusItems[i]
                                                            .bonusSystemItem
                                                            ?.level ??
                                                        1) +
                                                    1,
                                                title: widget
                                                        .bonusItems[i]
                                                        .bonusSystemItem
                                                        ?.description ??
                                                    '',
                                                imageUrl: widget
                                                        .bonusItems[i]
                                                        .bonusSystemItem
                                                        ?.image ??
                                                    '',
                                                isTaken: false,
                                                bonusType: 1,
                                                count: widget.bonusItems[i]
                                                        .countOrder ??
                                                    0,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: i ==
                                                    widget.bonusItems.length - 1
                                                ? 20
                                                : 40,
                                          )
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AboutBonusSystemPage()));
                  },
                  child: const Text(
                    'Как я могу получить бонусы?',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white60,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
