import 'package:flutter/material.dart';
import 'package:pana_project/utils/const.dart';

class LoyaltyProgramDetailPage extends StatefulWidget {
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
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  width: 161,
                  height: 38,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: const [
                        Text(
                          'Кешбэк',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '5%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                Row(
                  children: [
                    SizedBox(
                      width: true
                          ? 27
                          : false
                              ? MediaQuery.of(context).size.width * 0.44
                              : MediaQuery.of(context).size.width * 0.81,
                    ),
                    SizedBox(
                      width: 50,
                      height: 67,
                      child: Image.asset('assets/icons/progress_assik.png'),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Image.asset('assets/icons/bronze_assik.png'),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.23,
                        child: const LinearProgressIndicator(
                          value: 0.3,
                          color: AppColors.white,
                          backgroundColor: Colors.white10,
                        ),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Image.asset('assets/icons/silver_assik.png'),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.23,
                        child: const LinearProgressIndicator(
                          value: 0.0,
                          color: AppColors.white,
                          backgroundColor: Colors.white10,
                        ),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Image.asset('assets/icons/gold_assik.png'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
