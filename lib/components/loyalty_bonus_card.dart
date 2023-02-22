import 'package:flutter/material.dart';
import 'package:pana_project/utils/const.dart';

class LoyaltyBonusCard extends StatefulWidget {
  // LoyaltyBonusCard(this.transaction);
  // final TransactionHistory transaction;

  @override
  _LoyaltyBonusCardState createState() => _LoyaltyBonusCardState();
}

class _LoyaltyBonusCardState extends State<LoyaltyBonusCard> {
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
          //         builder: (context) =>
          //             MyTransactionDetailPage(widget.transaction)));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24), color: AppColors.white),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.62,
                      child: Text(
                        'asd' == 'housing'
                            ? 'Бронирование жилья'
                            : 'Бронирование впечатления',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '20.01.2023',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackWithOpacity,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(8)),
                  width: 104,
                  height: 54,
                  child: Center(
                    child: Text(
                      '+345',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
