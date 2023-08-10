import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/views/profile/loyalty_program/bonus_history_page.dart';
import 'package:pana_project/views/profile/loyalty_program/loyalty_program_detail.dart';

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
                      Container(color: AppColors.white, child: const Divider()),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(24),
                            bottomLeft: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Image.asset(
                                      widget.cashbackLevel == 1
                                          ? 'assets/images/loyalty_card_1.png'
                                          : widget.cashbackLevel == 2
                                              ? 'assets/images/loyalty_card_2.png'
                                              : 'assets/images/loyalty_card_3.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(34),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 5),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: 15,
                                                      height: 15,
                                                      child: SvgPicture.asset(widget
                                                                  .cashbackLevel ==
                                                              1
                                                          ? 'assets/icons/assik_icon_1.svg'
                                                          : widget.cashbackLevel ==
                                                                  2
                                                              ? 'assets/icons/assik_icon_2.svg'
                                                              : 'assets/icons/assik_icon_3.svg'),
                                                    ),
                                                    const SizedBox(width: 7),
                                                    Text(
                                                      widget.cashbackLevel == 1
                                                          ? 'Qola'
                                                          : widget.cashbackLevel ==
                                                                  2
                                                              ? 'Kumis'
                                                              : 'Altyn',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(34),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 5),
                                                child: Text(
                                                  widget.cashbackLevel == 1
                                                      ? 'Кешбэк: 3%'
                                                      : widget.cashbackLevel ==
                                                              2
                                                          ? 'Кешбэк: 5%'
                                                          : 'Кешбэк: 7%',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(
                                          'Мои асыки',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: widget.cashbackLevel == 1
                                                ? Colors.white60
                                                : Colors.black45,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Text(
                                          formatNumberString((double.tryParse(
                                                      widget.cashbackBalance) ??
                                                  0.0)
                                              .toInt()
                                              .toString()),
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w500,
                                            color: widget.cashbackLevel == 1
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(
                                          '1 асык = 1 тенге',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: widget.cashbackLevel == 1
                                                ? Colors.white60
                                                : Colors.black45,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BonusHistoryPage(widget.id)));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 20),
                                child: Row(
                                  children: const [
                                    Text(
                                      'История начислений',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
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
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: const BoxDecoration(
                                  color: AppColors.lightGray,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Как получить бонусы?',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Вы можете заработать "Асыки", оплачивая свои бронирования в заведениях, присоединившихся к программе лояльности "Pana club".',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.blackWithOpacity,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
