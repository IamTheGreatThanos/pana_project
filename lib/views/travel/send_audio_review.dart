import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendAudioReviewPage extends StatefulWidget {
  // SendAudioReviewPage(this.product);
  // final Product product;

  @override
  _SendAudioReviewPageState createState() => _SendAudioReviewPageState();
}

class _SendAudioReviewPageState extends State<SendAudioReviewPage> {
  String recordTime = '00:00:00';
  double seekWidth = 0;
  int recordState = 0;

  late Timer _timer;
  late Timer _timerForTime;

  List<Widget> bars = [
    const Spacer(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _timerForTime.cancel();
    super.dispose();
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
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(color: AppColors.white, height: 30),
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
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
                          'Оставьте отзыв',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
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
                const Spacer(),
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 2),
                            curve: Curves.easeInOut,
                            width: MediaQuery.of(context).size.width * 0.48 -
                                seekWidth,
                            height: 4,
                            color: Colors.transparent,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 2),
                            curve: Curves.easeInOut,
                            width: seekWidth,
                            height: 4,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Container(
                            width: 4,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.48,
                            height: 4,
                            color: AppColors.lightGray,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.48 + 10,
                      height: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: bars,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  recordTime,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                    onTap: () {
                      recordAction();
                    },
                    child: recordState == 0
                        ? SvgPicture.asset('assets/icons/start_record.svg')
                        : recordState == 1
                            ? SvgPicture.asset('assets/icons/stop_record.svg')
                            : SvgPicture.asset('assets/icons/re_record.svg')),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    recordState == 0
                        ? 'Нажмите кнопку для записи'
                        : recordState == 1
                            ? 'Нажмите, чтобы остановить запись'
                            : 'Нажмите, чтобы перезаписать отзыв',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.accent,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      onPressed: () {
                        if (true) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Заполните все поля.",
                                style: TextStyle(fontSize: 20)),
                          ));
                        } else {
                          saveChanges();
                        }
                      },
                      child: const Text("Опубликовать отзыв",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void recordAction() async {
    if (recordState == 0) {
      recordState = 1;
      seekWidth = MediaQuery.of(context).size.width * 0.48;
      addBars();
      addSeconds();
    } else if (recordState == 1) {
      recordState = 2;
      _timer.cancel();
      _timerForTime.cancel();
    } else {
      seekWidth = 0;
      bars = [const Spacer()];
      recordState = 0;
      recordTime = '00:00:00';
    }
    setState(() {});
  }

  void addSeconds() {
    _timerForTime = Timer.periodic(
      const Duration(milliseconds: 17),
      (Timer timer) {
        int minutes = int.parse(recordTime.substring(0, 2));
        int seconds = int.parse(recordTime.substring(3, 5));
        int milliseconds = int.parse(recordTime.substring(6, 8));

        if (milliseconds > 59) {
          seconds += 1;
          milliseconds = 0;
        } else {
          milliseconds += 1;
        }

        if (seconds > 59) {
          minutes += 1;
          seconds = 0;
        }

        if (minutes > 58) {
          _timer.cancel();
          _timerForTime.cancel();
          recordState = 2;
        } else {
          recordTime = '';
          if (minutes > 9) {
            recordTime += '$minutes';
          } else {
            recordTime += '0$minutes';
          }

          recordTime += ':';

          if (seconds > 9) {
            recordTime += '$seconds';
          } else {
            recordTime += '0$seconds';
          }

          recordTime += ':';

          if (milliseconds > 9) {
            recordTime += '$milliseconds';
          } else {
            recordTime += '0$milliseconds';
          }
        }

        setState(() {});
      },
    );
  }

  void addBars() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 200),
      (Timer timer) {
        if (bars.length > (MediaQuery.of(context).size.width * 0.48) / 13) {
          bars.removeAt(1);
        }
        bars.add(
          Padding(
            padding: const EdgeInsets.only(right: 5, top: 38, left: 5),
            child: Container(
              width: 3,
              height: 20 + double.parse(Random().nextInt(20).toString()),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  void saveChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var response = await AuthProvider()
    //     .changeFullName(nameController.text, surnameController.text);
    //
    // if (response['response_status'] == 'ok') {
    //   Navigator.of(context).pop();
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content:
    //     Text(response['message'], style: const TextStyle(fontSize: 20)),
    //   ));
    // }
  }
}
