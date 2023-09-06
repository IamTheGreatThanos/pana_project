import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/transaction_payment_history_card.dart';
import 'package:pana_project/models/receipt_order.dart';
import 'package:pana_project/services/profile_api_provider.dart';
import 'package:pana_project/utils/const.dart';

class MyTransactionDetailPage extends StatefulWidget {
  @override
  _MyTransactionDetailPageState createState() =>
      _MyTransactionDetailPageState();
}

class _MyTransactionDetailPageState extends State<MyTransactionDetailPage> {
  List<ReceiptOrder> transactionHistory = [];

  @override
  void initState() {
    super.initState();
    getMyTransactionsHistory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColors.white,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                    'assets/icons/back_arrow.svg'),
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'История платежей',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 50)
                        ],
                      ),
                    ],
                  ),
                ),
                for (int i = 0; i < transactionHistory.length; i++)
                  TransactionPaymentHistoryCard(transactionHistory[i]),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getMyTransactionsHistory() async {
    var response = await ProfileProvider().getMyTransactionsHistory();
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        transactionHistory.add(ReceiptOrder.fromJson(response['data'][i]));
      }

      if (mounted) {
        setState(() {});
      }
    }
  }
}
