import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/models/notification.dart';
import 'package:pana_project/utils/const.dart';

class MessagesWidget extends StatelessWidget {
  const MessagesWidget(this.notification, this.status);
  final NotificationModel notification;
  final bool status;

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      'plan',
      'impression',
      'percent',
      'percent',
      'housing',
      'location',
      'plan',
      'plan',
      'plan',
      'plan',
      'plan',
      'plan',
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
                        'assets/icons/m_${categories[(notification.type ?? 1) - 1]}_${status ? '1' : '0'}.svg')),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(
                        notification.title ?? '',
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
                        notification.description ?? '',
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
