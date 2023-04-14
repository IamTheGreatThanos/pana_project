import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/bonus_card.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/other/about_bonus_system_page.dart';

class BonusSystemDetailPage extends StatefulWidget {
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
                  'Собрано асыков для следующего уровня:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '2347 / 3000',
                  style: TextStyle(
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
                                            width: 120,
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
                                      const ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        child: SizedBox(
                                          height: 5,
                                          width: 140 * 5,
                                          child: LinearProgressIndicator(
                                            value: 0.2,
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
                                    for (int i = 0; i < 5; i++)
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              const SizedBox(height: 70),
                                              SvgPicture.asset(
                                                  './assets/icons/bonus_gift_1.svg'),
                                              const SizedBox(height: 20),
                                              BonusCard(
                                                colorType: i + 2,
                                                title:
                                                    '3 бесплатных кофе в кофейне Sandyq',
                                                imageUrl:
                                                    'https://stories.starbucks.com/uploads/2021/07/SBX20210707-ColdCoffees-Iced-Chocolate-Almondmilk-Shaken-Espresso-1024x1024.jpg',
                                                isTaken: false,
                                                bonusType: 1,
                                                count: 245,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: i == 5 - 1 ? 20 : 40,
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
