import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/profile_menu_item.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/auth/create_lock_code_page.dart';
import 'package:pana_project/views/auth/lock_screen.dart';
import 'package:pana_project/views/profile/change_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSettingsPage extends StatefulWidget {
  @override
  _LoginSettingsPageState createState() => _LoginSettingsPageState();
}

class _LoginSettingsPageState extends State<LoginSettingsPage> {
  var _switchValue = false;
  bool isHasLockCode = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  dispose() {
    setSwitchValue();
    super.dispose();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _switchValue = prefs.getBool('isBiometricsUse') ?? false;
    if (prefs.containsKey('lock_code')) {
      isHasLockCode = true;
    } else {
      isHasLockCode = false;
    }
    setState(() {});
  }

  void setSwitchValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isBiometricsUse', _switchValue);
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
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Настройки входа',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(width: 50)
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  color: AppColors.lightGray,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePasswordPage()));
                        },
                        child: ProfileMenuItem(
                            'assets/icons/lock_icon.svg', 'Сменить пароль'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LockScreen(CreateLockCodePage())));
                        },
                        child: ProfileMenuItem('assets/icons/pin_code_icon.svg',
                            'Изменить код-пароль'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Container(
                          height: 60,
                          decoration: const BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 10),
                              SvgPicture.asset(
                                'assets/icons/face_id.svg',
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Использовать Face ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value: _switchValue,
                                  activeColor: AppColors.accent,
                                  onChanged: (value) {
                                    setSwitchValue();
                                    setState(() {
                                      if (_switchValue == false) {
                                        isHasLockCode
                                            ? _switchValue = value
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LockScreen(
                                                            CreateLockCodePage())));
                                      } else {
                                        _switchValue = value;
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10)
                            ],
                          ),
                        ),
                      )
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
