import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/utils/const.dart';

class FilterCheckboxItem extends StatelessWidget {
  const FilterCheckboxItem(
      {Key? key,
      required this.title,
      required this.isChecked,
      required this.withCheckbox})
      : super(key: key);
  final String title;
  final bool isChecked;
  final bool withCheckbox;

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
              padding: const EdgeInsets.only(left: 5),
              child: title.length > 30
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.68,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isChecked ? AppColors.white : AppColors.black,
                        ),
                      ),
                    )
                  : SizedBox(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isChecked ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ),
            ),
            withCheckbox
                ? Row(
                    children: [
                      const SizedBox(width: 10),
                      SvgPicture.asset(isChecked
                          ? 'assets/icons/filter_checkbox_1.svg'
                          : 'assets/icons/filter_checkbox_0.svg'),
                    ],
                  )
                : const SizedBox.shrink(),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
