import 'package:flutter/cupertino.dart';

class ThisPageRoute extends CupertinoPageRoute {
  ThisPageRoute(this.page) : super(builder: (BuildContext context) => page);
  final Widget page;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(opacity: animation, child: page);
  }
}
