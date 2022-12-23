import 'package:flutter/material.dart';
import 'package:pana_project/utils/const.dart';

class TextWithBorderWidget extends StatelessWidget {
  const TextWithBorderWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(width: 1, color: AppColors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black45,
          ),
        ),
      ),
    );
  }
}
