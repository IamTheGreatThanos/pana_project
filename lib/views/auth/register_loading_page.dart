import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pana_project/views/auth/enter_personal_information_page.dart';

class RegisterLoadingPage extends StatefulWidget {
  // RegisterLoadingPage(this.product);
  // final Product product;

  @override
  _RegisterLoadingPageState createState() => _RegisterLoadingPageState();
}

class _RegisterLoadingPageState extends State<RegisterLoadingPage> {
  late Timer _timer;
  int _start = 6;

  @override
  void initState() {
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
          setState(() {
            timer.cancel();
          });

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EnterPersonalInformationPage()),
          );
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
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  children: [
                    const Spacer(),
                    SizedBox(
                        width: 200,
                        height: 150,
                        child: Image.asset('assets/gifs/loading.gif')),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 60),
                      child: Text(
                        "Программируем вашу личность",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              )),
        ));
  }
}
