import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/globalVariables.dart';
import 'package:pana_project/views/home/tabbar_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  int _start = 6;
  double iconPadding = 0;
  double wordPadding = 0;
  double _width = 0;
  double _secondWidth = 50;

  @override
  void initState() {
    getListOfFavorites();
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TabBarPage()),
            // MaterialPageRoute(builder: (context) => AuthPage()),
          );

          setState(() {
            timer.cancel();
          });
        } else if (_start == 2) {
          setState(() {
            iconPadding = 80;
            wordPadding = 80;
            _width = 120;
            _secondWidth = 0;
            _start--;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  AnimatedPadding(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.fromLTRB(
                        ((MediaQuery.of(context).size.width - 210) / 2) +
                            50 -
                            iconPadding,
                        5,
                        0,
                        5),
                    child: SizedBox(
                      width: 160,
                      height: 40,
                      child: SizedBox(
                        width: 160,
                        height: 40,
                        child: SvgPicture.asset(
                          'assets/images/logo_word.svg',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                  AnimatedPadding(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.only(
                        left: ((MediaQuery.of(context).size.width -
                                    320 -
                                    _width) /
                                2) +
                            iconPadding),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          color: Colors.white,
                          width: _width + _secondWidth,
                          height: 50,
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child:
                              SvgPicture.asset('assets/images/logo_icon.svg'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getListOfFavorites() async {
    var response = await MainProvider().getFavorites();
    if (response['response_status'] == 'ok') {
      GlobalVariables().favoritesHousing = response['data'];
    }
  }
}
