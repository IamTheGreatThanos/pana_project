import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pana_project/components/profile_menu_item.dart';
import 'package:pana_project/services/auth_api_provider.dart';
import 'package:pana_project/views/payment/payment_page.dart';
import 'package:pana_project/views/profile/personal_information_page.dart';

import '../../utils/const.dart';

class ProfileMainPage extends StatefulWidget {
  @override
  _ProfileMainPageState createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  String name = 'Dinmukhammed Mussilim';

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
                          SizedBox(width: 15),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentPage()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 70, 15, 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Программа лояльности',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ProfileMenuItem('assets/icons/profile_user.svg',
                          'Личная информация', PersonalInformationPage()),
                      ProfileMenuItem('assets/icons/profile_card.svg',
                          'Мои транзакции', PaymentPage()),
                      ProfileMenuItem('assets/icons/profile_card.svg',
                          'Способы оплаты', PaymentPage()),
                      ProfileMenuItem('assets/icons/profile_chat.svg',
                          'Служба поддержки', PaymentPage()),
                      ProfileMenuItem('assets/icons/profile_globe.svg',
                          'Выбор языка', PaymentPage()),
                      ProfileMenuItem('assets/icons/profile_star.svg',
                          'Мои отзывы', PaymentPage()),
                      GestureDetector(
                        onTap: () {},
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
    var response = await AuthProvider().changeAvatar(image);
    if (response['response_status'] == 'ok') {
      print('Successfully uploaded!');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ошибка загрузки!', style: const TextStyle(fontSize: 20)),
      ));
    }
  }
}
