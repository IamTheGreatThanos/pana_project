import 'package:flutter/material.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/views/profile/about_loyalty_program_page.dart';

class LoyaltyProgramDetailPage extends StatefulWidget {
  final String cashbackBalance;
  final int cashbackLevel;
  final String spentMoney;
  LoyaltyProgramDetailPage(
      this.cashbackLevel, this.cashbackBalance, this.spentMoney);

  @override
  _LoyaltyProgramDetailPageState createState() =>
      _LoyaltyProgramDetailPageState();
}

class _LoyaltyProgramDetailPageState extends State<LoyaltyProgramDetailPage> {
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
          child: SizedBox(
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
                const SizedBox(height: 50),
                const Text(
                  'Потраченные деньги для следующего уровня:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteWithOpacity,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${formatNumberString(widget.spentMoney)} / ${widget.cashbackLevel == 1 ? '500 000' : widget.cashbackLevel == 2 ? '2 000 000' : '5 000 000'}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: AppColors.blackWithOpacity2),
                      child: Column(
                        children: [
                          Image.asset(
                              'assets/images/loyalty_progress_dark.png'),
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
                                backgroundColor: Colors.white24,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: Row(
                              children: const [
                                SizedBox(width: 40),
                                Text(
                                  '500 000',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.whiteWithOpacity,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Spacer(),
                                Text(
                                  '2 000 000',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.whiteWithOpacity,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Spacer(),
                                Text(
                                  '5 000 000',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.whiteWithOpacity,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(width: 40),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      width: double.infinity,
                      // height: 88,
                      decoration: const BoxDecoration(
                          color: AppColors.blackWithOpacity2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: [
                            // const SizedBox(width: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Мои асыки',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.whiteWithOpacity,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      formatNumberString(
                                          widget.cashbackBalance),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.white,
                                      ),
                                      // maxLines: 1,
                                      // overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 60,
                              child: VerticalDivider(
                                color: Colors.white24,
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Текущий кешбэк',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.whiteWithOpacity,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          widget.cashbackLevel == 1
                                              ? '3%'
                                              : widget.cashbackLevel == 2
                                                  ? '5%'
                                                  : '7%',
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.white,
                                          ),
                                        ),
                                        SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Image.asset(widget
                                                        .cashbackLevel ==
                                                    1
                                                ? './assets/icons/bronze_assik.png'
                                                : widget.cashbackLevel == 2
                                                    ? './assets/icons/silver_assik.png'
                                                    : './assets/icons/gold_assik.png'))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      width: double.infinity,
                      // height: 88,
                      decoration: const BoxDecoration(
                          color: AppColors.blackWithOpacity2),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Примечание:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Здесь отображается общее количество асыков, которые вы получили, и даже если вы потратили часть из них, количество на этой странице не изменится.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.whiteWithOpacity,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AboutLoyaltyProgramPage()));
                  },
                  child: const Text(
                    'О программе лояльности',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white60,
                      decoration: TextDecoration.underline,
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
