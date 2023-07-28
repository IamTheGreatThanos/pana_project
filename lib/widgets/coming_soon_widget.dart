import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Здесь скоро появиться страница',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 30),
            SvgPicture.asset('assets/images/smile.svg'),
          ],
        ),
      ),
    );
  }
}
