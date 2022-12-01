import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/profile_menu_item.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/profile/change_email.dart';
import 'package:pana_project/views/profile/change_full_name.dart';
import 'package:pana_project/views/profile/change_phone.dart';
import 'package:pana_project/views/profile/login_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInformationPage extends StatefulWidget {
  @override
  _PersonalInformationPageState createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  String phone = '';
  String email = '';

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = '+7' + (prefs.getString('user_phone') ?? '');
    email = prefs.getString('user_email') ?? '';
    setState(() {});
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
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Личная информация',
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
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeFullNamePage()));
                        },
                        child: ProfileMenuItem(
                            'assets/icons/profile_user.svg', 'Имя и фамилия'),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChangePhonePage()));
                            loadData();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/icons/mobile_icon.svg'),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Телефон',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        phone,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black45),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward_ios),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChangeEmailPage()));
                            loadData();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/icons/mail_icon.svg'),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Email',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        email,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black45),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward_ios),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginSettingsPage()));
                        },
                        child: ProfileMenuItem(
                            'assets/icons/lock_icon.svg', 'Настройки входа'),
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
