import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/loyalty_bonus_card.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/views/profile/loyalty_program_detail.dart';

class LoyaltyProgramPage extends StatefulWidget {
  final int id;
  final String name;
  final String avatar;
  final String cashbackBalance;
  final int cashbackLevel;
  final String spentMoney;

  LoyaltyProgramPage(
    this.id,
    this.name,
    this.avatar,
    this.cashbackBalance,
    this.cashbackLevel,
    this.spentMoney,
  );

  @override
  _LoyaltyProgramPageState createState() => _LoyaltyProgramPageState();
}

class _LoyaltyProgramPageState extends State<LoyaltyProgramPage> {
  @override
  void initState() {
    super.initState();
  }

  void getProfileData() async {
    print(1);
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
          child: Container(
            color: AppColors.white,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(height: 30),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
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
                        'Моя программа',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 50)
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  color: AppColors.lightGray,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    child: SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: widget.avatar != ''
                                          ? CachedNetworkImage(
                                              imageUrl: widget.avatar,
                                              fit: BoxFit.cover,
                                            )
                                          : SvgPicture.asset(
                                              'assets/images/add_photo_placeholder.svg'),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.65,
                                        child: Text(
                                          widget.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'ID: ${widget.id}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.blackWithOpacity,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              Stack(
                                children: [
                                  SizedBox(
                                    child: Image.asset(
                                      'assets/images/loyalty_card.png',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.cashbackLevel == 1
                                              ? 'Qola'
                                              : widget.cashbackLevel == 2
                                                  ? 'Kumis'
                                                  : 'Altyn',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                        ),
                                        const Text(
                                          'Мои асыки',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white60,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          formatNumberString((double.tryParse(
                                                      widget.cashbackBalance) ??
                                                  0.0)
                                              .toInt()
                                              .toString()),
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Мой прогресс',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoyaltyProgramDetailPage(
                                                    widget.cashbackLevel,
                                                    widget.cashbackBalance,
                                                    widget.spentMoney,
                                                  )));
                                    },
                                    child: const Text(
                                      'Подробнее',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Image.asset('assets/images/loyalty_progress.png'),
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child: SizedBox(
                                  height: 3,
                                  child: LinearProgressIndicator(
                                    value: widget.cashbackLevel == 1
                                        ? 0.33
                                        : widget.cashbackLevel == 2
                                            ? 0.66
                                            : 1.00,
                                    color: AppColors.accent,
                                    backgroundColor: AppColors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Как я могу получить бонусы?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.blackWithOpacity,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                        child: Text(
                          'История бонусов',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      for (int i = 0; i < 5; i++) LoyaltyBonusCard(),
                      const SizedBox(height: 20),
                    ],
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
