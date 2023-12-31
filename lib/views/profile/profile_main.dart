import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pana_project/components/profile_menu_item.dart';
import 'package:pana_project/services/profile_api_provider.dart';
import 'package:pana_project/views/auth/auth_page.dart';
import 'package:pana_project/views/home/tabbar_page.dart';
import 'package:pana_project/views/messages/support_chat_page.dart';
import 'package:pana_project/views/profile/change_language.dart';
import 'package:pana_project/views/profile/my_booked_objects_page.dart';
import 'package:pana_project/views/profile/my_reviews.dart';
import 'package:pana_project/views/profile/my_transactions.dart';
import 'package:pana_project/views/profile/personal_information_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/const.dart';

class ProfileMainPage extends StatefulWidget {
  const ProfileMainPage(this.onButtonPressed);
  final void Function(int) onButtonPressed;
  @override
  _ProfileMainPageState createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  String name = 'Пользователь';
  String avatarUrl = '';
  int id = 0;
  String cashbackBalance = '';
  int cashbackLevel = 1;
  String spentMoney = '';

  bool isLogIn = false;
  bool isLoading = true;

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
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: AppColors.blackWithOpacity2,
              ))
            : isLogIn
                ? SingleChildScrollView(
                    child: Container(
                      color: AppColors.lightGray,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          // Container(
                          //   color: AppColors.grey,
                          //   width: MediaQuery.of(context).size.width,
                          //   height: 300,
                          // ),
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
                                        GestureDetector(
                                          onTap: () {
                                            changeAvatar();
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(12)),
                                                child: SizedBox(
                                                  width: 90,
                                                  height: 90,
                                                  child: image != null
                                                      ? Image.file(
                                                          File(image!.path),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : avatarUrl != ''
                                                          ? CachedNetworkImage(
                                                              imageUrl:
                                                                  avatarUrl,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : SvgPicture.asset(
                                                              'assets/images/add_photo_placeholder.svg'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              70, 70, 0, 0),
                                          child: GestureDetector(
                                            onTap: () {
                                              changeAvatar();
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
                                  padding:
                                      const EdgeInsets.fromLTRB(60, 10, 60, 0),
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
                                //                   LoyaltyProgramPage(
                                //                     id,
                                //                     name,
                                //                     avatarUrl,
                                //                     cashbackBalance,
                                //                     cashbackLevel,
                                //                     spentMoney,
                                //                   )));
                                //     },
                                //     child: Container(
                                //       decoration: const BoxDecoration(
                                //         color: Colors.black87,
                                //         borderRadius: BorderRadius.all(
                                //             const Radius.circular(8)),
                                //       ),
                                //       child: Padding(
                                //         padding: const EdgeInsets.fromLTRB(
                                //             15, 70, 15, 20),
                                //         child: Row(
                                //           children: const [
                                //             Text(
                                //               'Программа лояльности',
                                //               style: TextStyle(
                                //                   fontSize: 14,
                                //                   color: Colors.white),
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
                                  child: ProfileMenuItem(
                                      'assets/icons/profile_user.svg',
                                      'Личная информация'),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyTransactionsPage()));
                                  },
                                  child: ProfileMenuItem(
                                      'assets/icons/profile_card.svg',
                                      'Мои транзакции'),
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) => PaymentMethodsPage()));
                                //   },
                                //   child: ProfileMenuItem(
                                //       'assets/icons/profile_card.svg', 'Способы оплаты'),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SupportChatPage(),
                                      ),
                                    );
                                  },
                                  child: ProfileMenuItem(
                                      'assets/icons/profile_chat.svg',
                                      'Служба поддержки'),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChangeLanguagePage()));
                                  },
                                  child: ProfileMenuItem(
                                      'assets/icons/profile_globe.svg',
                                      'Выбор языка'),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyReviewsPage()));
                                  },
                                  child: ProfileMenuItem(
                                      'assets/icons/profile_star.svg',
                                      'Мои отзывы'),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyBookedObjectsPage()));
                                  },
                                  child: ProfileMenuItem(
                                      'assets/icons/flag_icon.svg',
                                      'Забронированные места'),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showLogoutConfirmation();
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
                  )
                : AuthPage(),
      ),
    );
  }

  void changeAvatar() async {
    PermissionStatus status = await Permission.photos.status;

    if (status == PermissionStatus.granted) {
      final XFile? selectedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        setState(() {
          image = selectedImage;
        });
        uploadAvatar(selectedImage);
      }
    } else {
      PermissionStatus requestStatus = Platform.isIOS
          ? await Permission.photos.request()
          : await Permission.mediaLibrary.request();
      // PermissionStatus requestStatus = await Permission.photos.request();
      if (requestStatus.isGranted) {
        final XFile? selectedImage =
            await _picker.pickImage(source: ImageSource.gallery);
        if (selectedImage != null) {
          setState(() {
            image = selectedImage;
          });
          uploadAvatar(selectedImage);
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Доступ к галерее запрещен'),
            content: Text(
                'Пожалуйста, откройте настройки и предоставьте доступ к галерее.'),
            actions: <Widget>[
              TextButton(
                child: Text('Отмена'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Настройки'),
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
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
      id = response['data']['id'];
      cashbackBalance = response['data']['cashback_balance'].toString();
      spentMoney = response['data']['money_spent'].toString();
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
    prefs.remove('isBiometricsUse');

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => TabBarPage(AppConstants.mainTabIndex)),
        (Route<dynamic> route) => false);

    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => AuthPage()),
    //     (Route<dynamic> route) => false);
  }

  void checkIsLogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogedIn') == true) {
      isLogIn = true;
      name = (prefs.getString('user_name') ?? '') +
          ' ' +
          (prefs.getString('user_surname') ?? '');
      avatarUrl = prefs.getString('user_avatar') ?? '';
      getProfile();
    } else {
      // showAlertDialog(context);
    }
    isLoading = false;
    setState(() {});
  }

  // showAlertDialog(BuildContext context) {
  //   Widget cancelButton = TextButton(
  //     child: const Text("Отмена"),
  //     onPressed: () {
  //       widget.onButtonPressed(2);
  //       Navigator.of(context).pop();
  //     },
  //   );
  //   Widget continueButton = TextButton(
  //     child: const Text("Да"),
  //     onPressed: () {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => AuthPage()));
  //     },
  //   );
  //
  //   AlertDialog alert = AlertDialog(
  //     title: const Text("Внимание"),
  //     content: const Text("Вы не вошли в аккаунт. Войти?"),
  //     actions: [
  //       cancelButton,
  //       continueButton,
  //     ],
  //   );
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   ).whenComplete(() => widget.onButtonPressed(2));
  // }

  void showLogoutConfirmation() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.cardBorderRadius),
            topRight: Radius.circular(AppConstants.cardBorderRadius)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const Text(
                          'Внимание',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Вы уверены, что хотите выйти из аккаунта?',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 60,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Отмена",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.accent,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                logOut();
                              },
                              child: const Text(
                                "Да, выйти",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
