import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/utils/const.dart';

class ChangeLanguagePage extends StatefulWidget {
  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  TextEditingController phoneController = TextEditingController();

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
                        'Выбрать язык',
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
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const SizedBox(width: 10),
                                  SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: SvgPicture.asset(
                                          'assets/icons/kz_icon.svg')),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Казахский',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  SvgPicture.asset(
                                      'assets/icons/radio_button_0.svg'),
                                ],
                              ),
                              const Divider(),
                              Row(
                                children: [
                                  const SizedBox(width: 10),
                                  SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: SvgPicture.asset(
                                          'assets/icons/ru_icon.svg')),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Русский',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  SvgPicture.asset(
                                      'assets/icons/radio_button_1.svg'),
                                ],
                              ),
                              const Divider(),
                              Row(
                                children: [
                                  const SizedBox(width: 10),
                                  SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: SvgPicture.asset(
                                          'assets/icons/en_icon.svg')),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Английский',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  SvgPicture.asset(
                                      'assets/icons/radio_button_0.svg'),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.accent,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10), // <-- Radius
                              ),
                            ),
                            onPressed: () {
                              if (true) {
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Заполните все поля.",
                                      style: const TextStyle(fontSize: 14)),
                                ));
                              }
                            },
                            child: const Text("Сохранить",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
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
