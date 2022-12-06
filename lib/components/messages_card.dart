import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/utils/const.dart';

class MessagesWidget extends StatelessWidget {
  const MessagesWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.categoryId,
  }) : super(key: key);
  final String title;
  final String subtitle;
  final bool status;
  final int categoryId;

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      'housing',
      'impression',
      'percent',
      'location',
      'plan'
    ];
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              children: [
                SizedBox(
                    width: 34,
                    height: 34,
                    child: SvgPicture.asset(
                        'assets/icons/m_${categories[categoryId - 1]}_${status ? '1' : '0'}.svg')),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.blackWithOpacity,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
        Divider(color: AppColors.lightGray)
      ],
    );
  }
}
