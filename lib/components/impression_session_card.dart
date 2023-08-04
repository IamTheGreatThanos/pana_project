import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/models/impressionDetail.dart';
import 'package:pana_project/models/impressionSession.dart';
import 'package:pana_project/utils/ImpressionData.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';

class ImpressionSessionCard extends StatelessWidget {
  const ImpressionSessionCard({
    Key? key,
    required this.session,
    required this.impression,
    required this.startDate,
    required this.endDate,
    required this.impressionData,
  }) : super(key: key);
  final ImpressionSessionModel session;
  final ImpressionDetailModel impression;
  final String startDate;
  final String endDate;
  final ImpressionData impressionData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            border: Border.all(width: 1, color: AppColors.grey)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              session.startDate != session.endDate
                  ? Text(
                      '${DateFormat("d MMMM", 'ru').format(DateTime.parse(session.startDate ?? ''))} - ${DateFormat("d MMMM", 'ru').format(DateTime.parse(session.endDate ?? ''))}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Text(
                      DateFormat("d MMMM", 'ru')
                          .format(DateTime.parse(session.startDate ?? '')),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              const SizedBox(height: 10),
              Text(
                'Начинается: ${session.startDate == session.endDate ? session.startTime?.substring(0, 5) : '${DateFormat("EEEE", 'ru').format(DateTime.parse(session.startDate ?? ''))}, ${session.startTime?.substring(0, 5)}'}',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45),
              ),
              Text(
                'Завершается: ${session.startDate == session.endDate ? session.endTime?.substring(0, 5) : '${DateFormat("EEEE", 'ru').format(DateTime.parse(session.endDate ?? ''))}, ${session.endTime?.substring(0, 5)}'}',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'от ${formatNumberString(session.openPrice.toString())}\₸',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            ' за группу',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        session.type == 1
                            ? 'Открытая группа'
                            : session.type == 2
                                ? 'Закрытая группа'
                                : 'Открытая и закрытая группа',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackWithOpacity,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 39,
                    width: 107,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          width: 1,
                          color: AppColors.accent,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Выбрать",
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
