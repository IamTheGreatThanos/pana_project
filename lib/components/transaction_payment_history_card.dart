import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/models/impressionDetail.dart';
import 'package:pana_project/models/impressionSession.dart';
import 'package:pana_project/models/receipt_order.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/views/payment/receipt_page.dart';

class TransactionPaymentHistoryCard extends StatefulWidget {
  TransactionPaymentHistoryCard(this.order);
  final ReceiptOrder order;

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
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReceiptPage(
                widget.order.housing ?? HousingDetailModel(),
                widget.order.dateFrom ?? '',
                widget.order.dateTo ?? '',
                widget.order.type == 'housing'
                    ? ((widget.order.adults ?? 0) +
                        (widget.order.children ?? 0))
                    : (widget.order.countPeople ?? 0),
                widget.order.babies ?? 0,
                widget.order.pets ?? 0,
                widget.order.id!,
                widget.order.type == 'housing' ? true : false,
                widget.order.impression ?? ImpressionDetailModel(),
                widget.order.session ?? ImpressionSessionModel(),
                widget.order.session?.type == 2 ? 2 : 1,
              ),
            ),
          );
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(
                        widget.order.type == 'housing'
                            ? 'Бронирование "${widget.order.housing?.name ?? ''}"'
                            : 'Бронирование "${widget.order.impression?.name ?? ''}"',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat("dd.MM.yyyy", 'ru')
                          .format(DateTime.parse(widget.order.createdAt ?? '')),
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
                  'Сумма: ${formatNumberString(widget.order.totalPrice.toString())} тг',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackWithOpacity,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Статус: ${widget.order.status == 6 ? 'Оплата отменена' : widget.order.paymentStatus == 0 ? 'Ожидается оплата' : 'Оплачено'}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackWithOpacity,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  children: const [
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
