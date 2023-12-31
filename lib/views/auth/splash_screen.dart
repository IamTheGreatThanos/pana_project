import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pana_project/services/housing_api_provider.dart';
import 'package:pana_project/services/impression_api_provider.dart';
import 'package:pana_project/services/profile_api_provider.dart';
import 'package:pana_project/utils/globalVariables.dart';
import 'package:pana_project/views/auth/lock_screen.dart';
import 'package:pana_project/views/home/tabbar_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/const.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  int _start = 2;
  double iconPadding = 0;
  double wordPadding = 0;
  double _width = 0;
  double _secondWidth = 50;
  bool isLocked = false;

  @override
  void initState() {
    checkLockScreenState();
    getListOfFavorites();
    confOneSignal();
    startTimer();
    super.initState();
  }

  void checkLockScreenState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLocked = prefs.getBool('isBiometricsUse') ?? false;
    setState(() {});
  }

  void confOneSignal() async {
    await OneSignal.shared.setAppId('47781c01-87c4-45c0-ad57-3b8d1fd6f48b');
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      // print("Accepted permission: $accepted");
      if (accepted) {
        getOneSignalUserToken();
        OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {
          OSNotificationDisplayType.notification;
          event.complete(event.notification);
        });
        OneSignal.shared.setOnWillDisplayInAppMessageHandler((message) {
          OSNotificationDisplayType.notification;
        });
        OneSignal.shared
            .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => TabBarPage(2)),
              (Route<dynamic> route) => false);
        });
      }
    });
  }

  void getOneSignalUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var deviceState = await OneSignal.shared.getDeviceState();
    if (deviceState != null || deviceState?.userId != null) {
      String? userId = deviceState!.userId;
      // print("TOKEN ID: " + userId);

      if (prefs.getBool('isLogedIn') == true) {
        if (userId != null) {
          var response = await ProfileProvider().setOneSignalUserToken(userId);
          if (response['response_status'] == 'ok') {
            // print(response);
          }
        }
      }
    }
  }

  void removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('lock_code');
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
          if (isLocked) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => LockScreen(
                        TabBarPage(AppConstants.mainTabIndex), false)),
                (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        TabBarPage(AppConstants.mainTabIndex)),
                (Route<dynamic> route) => false);
          }

          setState(() {
            timer.cancel();
          });
        } else if (_start == 1) {
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
                    duration: const Duration(milliseconds: 800),
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
                    duration: const Duration(milliseconds: 800),
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
                          duration: const Duration(milliseconds: 800),
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogedIn') == true) {
      GlobalVariables.favoritesHousing = [];
      GlobalVariables.favoritesImpression = [];

      var response = await HousingProvider().getFavoritesHousing('', '');
      if (response['response_status'] == 'ok') {
        for (var item in response['data']) {
          GlobalVariables.favoritesHousing.add(item['id']);
          if (mounted) {
            setState(() {});
          }
        }
      }

      var responseImpression =
          await ImpressionProvider().getFavoritesImpression();
      if (responseImpression['response_status'] == 'ok') {
        for (var item in responseImpression['data']) {
          GlobalVariables.favoritesImpression.add(item['id']);
          if (mounted) {
            setState(() {});
          }
        }
      }
    }
  }
}
