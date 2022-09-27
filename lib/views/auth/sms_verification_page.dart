import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SmsVerificationPage extends StatefulWidget {
  SmsVerificationPage(this.page);
  final Widget page;

  @override
  _SmsVerificationPageState createState() => _SmsVerificationPageState();
}

class _SmsVerificationPageState extends State<SmsVerificationPage> {
  TextEditingController pinCodeController = TextEditingController();
  late Timer _timer;
  String _time = "00";

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
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const Spacer(),
                SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset('assets/gifs/sms_code.gif')),
                const Text(
                  'Введите код',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 32,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: Text(
                    'Мы отправили смс-код на номер, который вы указали при регистрации',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    cursorColor: AppColors.accent,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 65,
                        fieldWidth: 55,
                        inactiveColor: AppColors.grey,
                        inactiveFillColor: Colors.white,
                        activeFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        selectedColor: AppColors.accent,
                        activeColor: AppColors.black,
                        borderWidth: 2),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    controller: pinCodeController,
                    onCompleted: (value) {
                      sendVerificationCode();
                    },
                    onChanged: (value) {},
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      return true;
                    },
                  ),
                ),
                Text(
                  _time,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 3),
                    child: Text(
                      'Отправить код заново',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:
                              _time == '00' ? AppColors.accent : Colors.black45,
                          fontWeight: FontWeight.w500,
                          decoration: _time == '00'
                              ? TextDecoration.underline
                              : TextDecoration.none,
                          fontSize: 14),
                    ),
                  ),
                  onTap: () {
                    if (_time == '00') {
                      startTimer();
                    }
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    int _start = 60;
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
            _start < 10 ? _time = "0${_start}" : _time = "$_start";
          });
        }
      },
    );
  }

  void sendVerificationCode() async {
    if (pinCodeController.text == '1234') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => widget.page),
      );
    } else {
      print(pinCodeController.text);
    }
  }
}
