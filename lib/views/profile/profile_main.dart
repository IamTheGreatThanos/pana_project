import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pana_project/components/profile_menu_item.dart';
import 'package:pana_project/services/profile_api_provider.dart';
import 'package:pana_project/views/auth/auth_page.dart';
import 'package:pana_project/views/profile/change_language.dart';
import 'package:pana_project/views/profile/my_booked_objects_page.dart';
import 'package:pana_project/views/profile/my_reviews.dart';
import 'package:pana_project/views/profile/my_transactions.dart';
import 'package:pana_project/views/profile/payment_methods.dart';
import 'package:pana_project/views/profile/personal_information_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/const.dart';

class ProfileMainPage extends StatefulWidget {
  const ProfileMainPage(this.onButtonPressed);
  final void Function() onButtonPressed;
  @override
  _ProfileMainPageState createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  String name = 'Пользователь';
  String avatarUrl = '';

  bool isLogedIn = false;

  @override
  void initState() {
    checkIsLogedIn();
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
          child: Container(
            color: AppColors.lightGray,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Container(
                  color: AppColors.grey,
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                ),
                SvgPicture.asset(
                  'assets/images/profile_bg.svg',
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 90),
                      Row(
                        children: [
                          const Spacer(),
                          const SizedBox(width: 15),
                          Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    child: SizedBox(
                                      width: 90,
                                      height: 90,
                                      child: image != null
                                          ? Image.file(
                                              File(image!.path),
                                              fit: BoxFit.fitWidth,
                                            )
                                          : avatarUrl != ''
                                              ? CachedNetworkImage(
                                                  imageUrl: avatarUrl,
                                                  fit: BoxFit.cover,
                                                )
                                              : SvgPicture.asset(
                                                  'assets/images/add_photo_placeholder.svg'),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(70, 70, 0, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (isLogedIn = true) {
                                      changeAvatar();
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/avatar_edit_icon.svg',
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(60, 10, 60, 0),
                        child: SizedBox(
                          height: 60,
                          child: Text(
                            name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) =>
                      //                   LoyaltyProgramPage()));
                      //     },
                      //     child: Container(
                      //       decoration: const BoxDecoration(
                      //         color: Colors.black87,
                      //         borderRadius:
                      //             BorderRadius.all(const Radius.circular(8)),
                      //       ),
                      //       child: Padding(
                      //         padding:
                      //             const EdgeInsets.fromLTRB(15, 70, 15, 20),
                      //         child: Row(
                      //           children: const [
                      //             Text(
                      //               'Программа лояльности',
                      //               style: TextStyle(
                      //                   fontSize: 14, color: Colors.white),
                      //             ),
                      //             Spacer(),
                      //             Icon(
                      //               Icons.arrow_forward_ios,
                      //               color: Colors.white,
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PersonalInformationPage()));
                          getProfile();
                        },
                        child: ProfileMenuItem('assets/icons/profile_user.svg',
                            'Личная информация'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyTransactionsPage()));
                        },
                        child: ProfileMenuItem(
                            'assets/icons/profile_card.svg', 'Мои транзакции'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentMethodsPage()));
                        },
                        child: ProfileMenuItem(
                            'assets/icons/profile_card.svg', 'Способы оплаты'),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => LoyaltyProgramPage()));
                      //   },
                      //   child: ProfileMenuItem('assets/icons/profile_chat.svg',
                      //       'Служба поддержки'),
                      // ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeLanguagePage()));
                        },
                        child: ProfileMenuItem(
                            'assets/icons/profile_globe.svg', 'Выбор языка'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyReviewsPage()));
                        },
                        child: ProfileMenuItem(
                            'assets/icons/profile_star.svg', 'Мои отзывы'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyBookedObjectsPage()));
                        },
                        child: ProfileMenuItem('assets/icons/flag_icon.svg',
                            'Забронированные места'),
                      ),
                      GestureDetector(
                        onTap: () {
                          logOut();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            'Выйти из аккаунта',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeAvatar() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        image = selectedImage;
      });
      uploadAvatar(selectedImage);
    }
  }

  void uploadAvatar(XFile image) async {
    var response = await ProfileProvider().changeAvatar(image);
    if (response['response_status'] == 'ok') {
      print('Successfully uploaded!');
      getProfile();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Ошибка загрузки!', style: TextStyle(fontSize: 14)),
      ));
    }
  }

  void getProfile() async {
    var response = await ProfileProvider().getProfileData();
    if (response['response_status'] == 'ok') {
      if (response['data']['avatar'] != null) {
        avatarUrl = response['data']['avatar'];
      }
      name = '${response['data']['name']} ${response['data']['surname']}';
      if (mounted) {
        setState(() {});
      }
    }
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogedIn', false);
    prefs.remove('user_avatar');
    prefs.remove('user_name');
    prefs.remove('user_surname');

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthPage()),
        (Route<dynamic> route) => false);
  }

  void checkIsLogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogedIn') == true) {
      isLogedIn = true;
      name = (prefs.getString('user_name') ?? '') +
          ' ' +
          (prefs.getString('user_surname') ?? '');
      avatarUrl = prefs.getString('user_avatar') ?? '';
      getProfile();
      setState(() {});
    } else {
      isLogedIn = false;
      showAlertDialog(context);
    }
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Отмена"),
      onPressed: () {
        widget.onButtonPressed();
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Да"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AuthPage()));
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Внимание"),
      content: const Text("Вы не вошли в аккаунт. Войти?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).whenComplete(() => widget.onButtonPressed());
  }
}
