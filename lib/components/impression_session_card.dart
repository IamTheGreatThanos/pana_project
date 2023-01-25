import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/models/impressionDetail.dart';
import 'package:pana_project/models/impressionSession.dart';
import 'package:pana_project/utils/ImpressionData.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/payment/impression_payment_page.dart';

class ImpressionSessionCard extends StatelessWidget {
  const ImpressionSessionCard(
      {Key? key,
      required this.session,
      required this.impression,
      required this.startDate,
      required this.endDate,
      required this.impressionData})
      : super(key: key);
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
              Text(
                DateFormat("EE, d MMMM", 'ru')
                    .format(DateTime.parse(session.startDate ?? '')),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${session.startTime?.substring(0, 5)} - ${session.endTime?.substring(0, 5)}',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45),
              ),
              const SizedBox(height: 2),
              const Text(
                'Только для частных групп',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45,
                    decoration: TextDecoration.underline),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'от ${session.openPrice} \₸',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'за группу',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 39,
                    width: 107,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: AppColors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              width: 1,
                              color: AppColors.accent,
                            )),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImpressionPaymentPage(
                                impression, startDate, endDate, impressionData),
                          ),
                        );
                      },
                      child: const Text(
                        "Выбрать",
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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
