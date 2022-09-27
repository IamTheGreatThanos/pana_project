import 'package:flutter/material.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/home/tabbar_page.dart';

class ReenterLockCodePage extends StatefulWidget {
  // ReenterLockCodePage(this.product);
  // final Product product;

  @override
  _ReenterLockCodePageState createState() => _ReenterLockCodePageState();
}

class _ReenterLockCodePageState extends State<ReenterLockCodePage> {
  String secureCode = '';

  double _width = 30;
  double _height = 5;
  Color _color = AppColors.accent;

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
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 650,
            child: Column(
              children: [
                const Spacer(),
                const SizedBox(height: 80),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Text(
                    'Повторите код-пароль',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      width: _width,
                      height: _height,
                      decoration: BoxDecoration(
                        color: secureCode.length > 0 ? _color : AppColors.grey,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,
                    ),
                    const SizedBox(width: 5),
                    AnimatedContainer(
                      width: _width,
                      height: _height,
                      decoration: BoxDecoration(
                        color: secureCode.length > 1 ? _color : AppColors.grey,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,
                    ),
                    const SizedBox(width: 5),
                    AnimatedContainer(
                      width: _width,
                      height: _height,
                      decoration: BoxDecoration(
                        color: secureCode.length > 2 ? _color : AppColors.grey,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,
                    ),
                    const SizedBox(width: 5),
                    AnimatedContainer(
                      width: _width,
                      height: _height,
                      decoration: BoxDecoration(
                        color: secureCode.length > 3 ? _color : AppColors.grey,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          if (secureCode.length < 4) {
                            setState(() {
                              secureCode += '1';
                            });
                            checkCode();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                            side: const BorderSide(color: AppColors.grey),
                          ),
                        ),
                        child: const Text(
                          '1',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          if (secureCode.length < 4) {
                            setState(() {
                              secureCode += '2';
                            });
                            checkCode();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                            side: const BorderSide(color: AppColors.grey),
                          ),
                        ),
                        child: const Text(
                          '2',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          if (secureCode.length < 4) {
                            setState(() {
                              secureCode += '3';
                            });
                            checkCode();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                            side: const BorderSide(color: AppColors.grey),
                          ),
                        ),
                        child: const Text(
                          '3',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          if (secureCode.length < 4) {
                            setState(() {
                              secureCode += '4';
                            });
                            checkCode();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                            side: const BorderSide(color: AppColors.grey),
                          ),
                        ),
                        child: const Text(
                          '4',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          if (secureCode.length < 4) {
                            setState(() {
                              secureCode += '5';
                            });
                            checkCode();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                            side: const BorderSide(color: AppColors.grey),
                          ),
                        ),
                        child: const Text(
                          '5',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          if (secureCode.length < 4) {
                            setState(() {
                              secureCode += '6';
                            });
                            checkCode();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                            side: const BorderSide(color: AppColors.grey),
                          ),
                        ),
                        child: const Text(
                          '6',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          if (secureCode.length < 4) {
                            setState(() {
                              secureCode += '7';
                            });
                            checkCode();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                            side: const BorderSide(color: AppColors.grey),
                          ),
                        ),
                        child: const Text(
                          '7',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          if (secureCode.length < 4) {
                            setState(() {
                              secureCode += '8';
                            });
                            checkCode();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                            side: const BorderSide(color: AppColors.grey),
                          ),
                        ),
                        child: const Text(
                          '8',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          if (secureCode.length < 4) {
                            setState(() {
                              secureCode += '9';
                            });
                            checkCode();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                            side: const BorderSide(color: AppColors.grey),
                          ),
                        ),
                        child: const Text(
                          '9',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 70,
                      height: 70,
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          if (secureCode.length < 4) {
                            setState(() {
                              secureCode += '0';
                            });
                            checkCode();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                            side: const BorderSide(color: AppColors.grey),
                          ),
                        ),
                        child: const Text(
                          '0',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          if (secureCode.length > 0) {
                            setState(() {
                              secureCode = secureCode.substring(
                                  0, secureCode.length - 1);
                              _width = 30;
                              _height = 5;
                              _color = AppColors.accent;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                            side: const BorderSide(color: AppColors.grey),
                          ),
                        ),
                        child: const Icon(
                          Icons.backspace_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Изменить пароль',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkCode() {
    if (secureCode.length == 4) {
      if (secureCode == '1234') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TabBarPage()),
        );
      } else {
        setState(() {
          _width = 40;
          _height = 6;
          _color = AppColors.black;
        });
      }
    }
  }
}
