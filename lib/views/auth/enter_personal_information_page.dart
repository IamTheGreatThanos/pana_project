import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/services/auth_api_provider.dart';
import 'package:pana_project/services/profile_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/auth/create_lock_code_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterPersonalInformationPage extends StatefulWidget {
  // EnterPersonalInformationPage(this.product);
  // final Product product;

  @override
  _EnterPersonalInformationPageState createState() =>
      _EnterPersonalInformationPageState();
}

class _EnterPersonalInformationPageState
    extends State<EnterPersonalInformationPage> {
  final ImagePicker _picker = ImagePicker();

  String name = '';
  var selectedSex = 1;
  String selectedDate = 'Выбрать дату';
  XFile? image;
  bool imageSelected = false;

  @override
  void initState() {
    super.initState();
    getInfoFromPrefs();
  }

  void getInfoFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user_name')) {
      setState(() {
        name = prefs.getString('user_name')!;
      });
    }
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
          child: Container(
              color: AppColors.lightGray,
              width: MediaQuery.of(context).size.width,
              height: 850,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(60, 40, 60, 0),
                    child: SizedBox(
                      height: 60,
                      child: Text(
                        "Приветствуем, ${name} 👋🏻",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                    child: Text(
                      "Заполните Ваши личные данные, это можно сделать позже в профиле",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          height: 538,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 1.62,
                        child: SvgPicture.asset(
                          'assets/images/register_bg.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 15),
                            GestureDetector(
                              onTap: () {
                                changeAvatar();
                              },
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3.8,
                                  height:
                                      MediaQuery.of(context).size.width / 3.8,
                                  child: imageSelected
                                      ? Image.file(File(image!.path))
                                      : SvgPicture.asset(
                                          'assets/images/add_photo_placeholder.svg'),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(60, 20, 60, 0),
                              child: Text(
                                "Выберите пол",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 100,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: selectedSex == 1
                                            ? AppColors.black
                                            : AppColors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                                width: 1,
                                                color: selectedSex == 1
                                                    ? Colors.transparent
                                                    : AppColors.grey)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectedSex = 1;
                                        });
                                      },
                                      child: Text(
                                        "Мужской",
                                        style: TextStyle(
                                            color: selectedSex == 1
                                                ? AppColors.white
                                                : AppColors.blackWithOpacity,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    height: 40,
                                    width: 100,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: selectedSex == 0
                                            ? AppColors.black
                                            : AppColors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                                width: 1,
                                                color: selectedSex == 0
                                                    ? Colors.transparent
                                                    : AppColors.grey)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectedSex = 0;
                                        });
                                      },
                                      child: Text(
                                        "Женский",
                                        style: TextStyle(
                                            color: selectedSex == 0
                                                ? AppColors.white
                                                : Colors.black45,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border: Border.all(
                                      width: 1, color: AppColors.grey),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        'Дата рождения',
                                        style: TextStyle(
                                            color: AppColors.blackWithOpacity,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: GestureDetector(
                                        child: Text(
                                          selectedDate,
                                          style: const TextStyle(
                                              color: AppColors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onTap: () {
                                          showDatePicker();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: SizedBox(
                                height: 60,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: AppColors.accent,
                                    minimumSize: const Size.fromHeight(50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // <-- Radius
                                    ),
                                  ),
                                  onPressed: () {
                                    if (selectedDate != 'Выбрать дату') {
                                      saveData();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("Заполните все поля.",
                                            style:
                                                const TextStyle(fontSize: 14)),
                                      ));
                                    }
                                  },
                                  child: const Text("Сохранить",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            GestureDetector(
                              child: const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  'Заполнить позже',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreateLockCodePage()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void showDatePicker() async {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.cardBorderRadius),
            topRight: Radius.circular(AppConstants.cardBorderRadius)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: SizedBox(
            height: 320,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Назад',
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Выбрать дату',
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Готово',
                            style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  SizedBox(
                    height: 250,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: DateTime.now(),
                      maximumDate: DateTime.now(),
                      onDateTimeChanged: (DateTime newDateTime) {
                        setState(() {
                          selectedDate =
                              DateFormat('yyyy-MM-dd').format(newDateTime);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void changeAvatar() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        image = selectedImage;
        imageSelected = true;
      });
      uploadAvatar(selectedImage);
    }
  }

  void saveData() async {
    var response = await AuthProvider().updateProfileOnRegister(
        selectedSex == 1 ? 'male' : 'female', selectedDate);

    if (response['response_status'] == 'ok') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateLockCodePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void uploadAvatar(XFile image) async {
    var response = await ProfileProvider().changeAvatar(image);
    if (response['response_status'] == 'ok') {
      print('Successfully uploaded!');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ошибка загрузки!', style: const TextStyle(fontSize: 14)),
      ));
    }
  }
}
