import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/utils/const.dart';

class FilterCheckboxItemForStars extends StatelessWidget {
  const FilterCheckboxItemForStars({
    Key? key,
    required this.title,
    required this.isChecked,
  }) : super(key: key);
  final String title;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          border: Border.all(width: 1, color: AppColors.grey),
          color: isChecked ? AppColors.blackWithOpacity2 : AppColors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 2),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isChecked ? AppColors.white : AppColors.black,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
                width: 15,
                height: 15,
                child: SvgPicture.asset(
                  'assets/icons/star.svg',
                  color: isChecked ? AppColors.white : AppColors.black,
                )),
            const SizedBox(width: 10),
            SvgPicture.asset(isChecked
                ? 'assets/icons/filter_checkbox_1.svg'
                : 'assets/icons/filter_checkbox_0.svg'),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
