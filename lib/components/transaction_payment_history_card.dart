import 'package:flutter/material.dart';
import 'package:pana_project/utils/const.dart';

class TransactionPaymentHistoryCard extends StatefulWidget {
  // TransactionPaymentHistoryCard(this.title);
  // final String title;

  @override
  _TransactionPaymentHistoryCardState createState() =>
      _TransactionPaymentHistoryCardState();
}

class _TransactionPaymentHistoryCardState
    extends State<TransactionPaymentHistoryCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => TextReviewDetailPage()));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24), color: AppColors.white),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Бронирование жилья',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '20.01.2023',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackWithOpacity,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Сумма: 543.000 тг',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackWithOpacity),
                ),
                SizedBox(height: 10),
                const Divider(),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Подробнее о платеже',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
