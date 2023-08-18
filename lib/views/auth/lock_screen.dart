import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pana_project/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockScreen extends StatefulWidget {
  LockScreen(this.page, this.fromApp);
  final Widget page;
  final bool fromApp;

  @override
  _LockScreenState createState() => _LockScreenState();
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

class _LockScreenState extends State<LockScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  String secureCode = '';
  var savedCode;
  var useBiometrics;

  double _width = 30;
  double _height = 5;
  Color _color = AppColors.accent;
  String name = 'Пользователь';
  String avatarUrl = '';

  @override
  void initState() {
    getSavedCode();
    getUserData();
    super.initState();

    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );

    fastStartBiometrics();
  }

  void fastStartBiometrics() async {
    await Future.delayed(const Duration(seconds: 1));
    print(123);
    if (_supportState == _SupportState.supported && useBiometrics == true) {
      authByBiometrics();
    }
  }

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name =
        '${prefs.getString('user_name') ?? ''} ${prefs.getString('user_surname') ?? ''}';
    avatarUrl = prefs.getString('user_avatar') ?? '';
    setState(() {});
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Отсканируйте свой отпечаток пальца (или лицо) для аутентификации',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
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
            height: 780,
            child: Column(
              children: [
                const SizedBox(height: 60),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: avatarUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
                _supportState == _SupportState.supported &&
                        useBiometrics == true
                    ? GestureDetector(
                        onTap: () {
                          authByBiometrics();
                        },
                        child: SvgPicture.asset(
                          'assets/icons/face_id.svg',
                        ),
                      )
                    : Container(),
                const SizedBox(height: 40),
                // SizedBox(
                //   height: 20,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: const [
                //       SizedBox(width: 20),
                //       Text(
                //         'Забыл пароль',
                //         style: TextStyle(
                //           decoration: TextDecoration.underline,
                //           color: Colors.black45,
                //           fontWeight: FontWeight.w500,
                //           fontSize: 14,
                //         ),
                //       ),
                //       SizedBox(width: 10),
                //       VerticalDivider(),
                //       SizedBox(width: 10),
                //       Text(
                //         'Сменить аккаунт',
                //         style: TextStyle(
                //           decoration: TextDecoration.underline,
                //           color: Colors.black45,
                //           fontWeight: FontWeight.w500,
                //           fontSize: 14,
                //         ),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkCode() async {
    if (secureCode.length == 4) {
      if (secureCode == savedCode) {
        if (widget.fromApp) {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => widget.page));
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => widget.page),
              (Route<dynamic> route) => false);
        }
      } else {
        setState(() {
          _width = 40;
          _height = 6;
          _color = AppColors.black;
        });
      }
    }
  }

  void getSavedCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedCode = prefs.getString('lock_code');
    useBiometrics = prefs.getBool('isBiometricsUse');
    if (savedCode == null) {
      if (widget.fromApp) {
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => widget.page));
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => widget.page),
            (Route<dynamic> route) => false);
      }
    }
  }

  void authByBiometrics() async {
    _authenticateWithBiometrics().whenComplete(() async {
      if (_authorized == 'Authorized') {
        if (widget.fromApp) {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => widget.page));
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => widget.page),
              (Route<dynamic> route) => false);
        }
      }
    });
  }
}
