import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/services/profile_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmPhonePage extends StatefulWidget {
  final String phone;
  ConfirmPhonePage(this.phone);
  @override
  _ConfirmPhonePageState createState() => _ConfirmPhonePageState();
}

class _ConfirmPhonePageState extends State<ConfirmPhonePage> {
  TextEditingController codeController = TextEditingController();

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
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Телефон',
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
                              const Text(
                                'Введите код',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Вам пришло письмо с кодом на новый телефон, введите его для подтверждения',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black45),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1, color: AppColors.grey),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: SizedBox(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: TextField(
                                        controller: codeController,
                                        maxLength: 30,
                                        decoration: const InputDecoration(
                                          counterStyle: TextStyle(
                                            height: double.minPositive,
                                          ),
                                          counterText: "",
                                          border: InputBorder.none,
                                          hintText: 'Код',
                                          hintStyle: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                              if (codeController.text == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Заполните все поля.",
                                      style: const TextStyle(fontSize: 14)),
                                ));
                              } else {
                                saveChanges();
                              }
                            },
                            child: const Text("Отправить",
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

  void saveChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response =
        await ProfileProvider().changePhone(widget.phone, codeController.text);

    if (response['response_status'] == 'ok') {
      prefs.setString("user_phone", widget.phone);
      Navigator.of(context).pop('Success');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(response['message'], style: const TextStyle(fontSize: 14)),
      ));
    }
  }
}
