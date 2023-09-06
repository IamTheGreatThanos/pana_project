import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/services/auth_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/auth/register_loading_page.dart';
import 'package:pana_project/views/auth/sms_verification_page.dart';
import 'package:pana_project/views/home/tabbar_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController authPhoneController = TextEditingController();

  @override
  void initState() {
    checkLogin();
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
          body: Container(
              color: AppColors.lightGray,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SvgPicture.asset(
                        'assets/images/auth_bg.svg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 520, 20, 20),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 1, color: AppColors.grey),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    '+7',
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: VerticalDivider(),
                                ),
                                SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: TextField(
                                      controller: authPhoneController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      maxLength: 10,
                                      scrollPadding:
                                          const EdgeInsets.only(bottom: 100),
                                      decoration: const InputDecoration(
                                        counterStyle: TextStyle(
                                          height: double.minPositive,
                                        ),
                                        counterText: "",
                                        border: InputBorder.none,
                                        hintText: 'Номер телефона',
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
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
                                if (authPhoneController.text.isNotEmpty) {
                                  login();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                    content: Text("Заполните все поля.",
                                        style: const TextStyle(fontSize: 14)),
                                  ));
                                }
                              },
                              child: const Text("Войти",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'У вас нет аккаунта?',
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                        GestureDetector(
                          child: const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'Зарегистрироваться',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          onTap: () {
                            showRegisterView();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ));
  }

  void showRegisterView() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Scaffold(
        extendBody: false,
        // key: _modelScaffoldKey,
        resizeToAvoidBottomInset:
            false, // TODO: Change to true if use modal bottom sheet
        body: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                height: 800,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        "Создать аккаунт",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: AppColors.grey),
                        ),
                        child: SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 10),
                            child: TextField(
                              controller: nameController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.done,
                              maxLength: 30,
                              decoration: const InputDecoration(
                                counterStyle: TextStyle(
                                  height: double.minPositive,
                                ),
                                counterText: "",
                                border: InputBorder.none,
                                hintText: 'Как Вас зовут?',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: AppColors.grey),
                        ),
                        child: SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 10),
                            child: TextField(
                              controller: lastNameController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.done,
                              maxLength: 30,
                              decoration: const InputDecoration(
                                counterStyle: TextStyle(
                                  height: double.minPositive,
                                ),
                                counterText: "",
                                border: InputBorder.none,
                                hintText: 'Ваша фамилия',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: AppColors.grey),
                        ),
                        child: SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 10),
                            child: TextField(
                              controller: emailController,
                              maxLength: 50,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                counterStyle: TextStyle(
                                  height: double.minPositive,
                                ),
                                counterText: "",
                                border: InputBorder.none,
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: AppColors.grey),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                '+7',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: VerticalDivider(),
                            ),
                            SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  maxLength: 10,
                                  decoration: const InputDecoration(
                                    counterStyle: TextStyle(
                                      height: double.minPositive,
                                    ),
                                    counterText: "",
                                    border: InputBorder.none,
                                    hintText: 'Номер телефона',
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
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
                            if (nameController.text.isNotEmpty &&
                                lastNameController.text.isNotEmpty &&
                                emailController.text.isNotEmpty &&
                                phoneController.text.isNotEmpty) {
                              registerButtonTapped();
                            } else {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                // margin: EdgeInsets.only(20, 0, 20,
                                //     MediaQuery.of(context).size.height - 100),
                                content: Text("Заполните все поля.",
                                    style: const TextStyle(fontSize: 14)),
                              ));
                            }
                          },
                          child: const Text("Зарегистрироваться",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'У вас уже есть аккаунт?',
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    ),
                    GestureDetector(
                      child: const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          'Войти',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void registerButtonTapped() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_name', nameController.text);

    var response = await AuthProvider().register(phoneController.text, '7',
        nameController.text, lastNameController.text, emailController.text);
    // TODO: Действие при отправке номера телефона пользователя...
    if (response['response_status'] == 'ok') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SmsVerificationPage(
                  1,
                  RegisterLoadingPage(),
                  phoneController.text,
                  nameController.text,
                  lastNameController.text,
                  emailController.text)));
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        // margin: EdgeInsets.fromLTRB(
        //     20, 0, 20, MediaQuery.of(context).size.height - 100),
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void login() async {
    var response = await AuthProvider().login(authPhoneController.text, '7');
    // TODO: Действие при отправке номера телефона пользователя...
    if (response['response_status'] == 'ok') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SmsVerificationPage(
                  0,
                  TabBarPage(AppConstants.mainTabIndex),
                  authPhoneController.text,
                  '',
                  '',
                  '')));
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLogedIn = prefs.getBool('isLogedIn');
    if (isLogedIn == true) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => TabBarPage(AppConstants.mainTabIndex)),
          (Route<dynamic> route) => false);
    }
  }
}
