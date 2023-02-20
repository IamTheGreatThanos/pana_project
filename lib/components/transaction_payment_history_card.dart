import 'package:flutter/material.dart';
import 'package:pana_project/models/transactionHistory.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/views/profile/my_transaction_detail.dart';

class TransactionPaymentHistoryCard extends StatefulWidget {
  TransactionPaymentHistoryCard(this.transaction);
  final TransactionHistory transaction;

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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyTransactionDetailPage(widget.transaction)));
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
                      widget.transaction.type == 'housing'
                          ? 'Бронирование жилья'
                          : 'Бронирование впечатления',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.transaction.paymentAt?.substring(0, 10) ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackWithOpacity,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Сумма: ${formatNumberString(widget.transaction.totalPrice.toString())} тг',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackWithOpacity),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Подробнее о платеже',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
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
