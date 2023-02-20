import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/transaction_payment_history_card.dart';
import 'package:pana_project/models/transactionHistory.dart';
import 'package:pana_project/models/transactionMain.dart';
import 'package:pana_project/services/profile_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyTransactionsPage extends StatefulWidget {
  @override
  _MyTransactionsPageState createState() => _MyTransactionsPageState();
}

class _MyTransactionsPageState extends State<MyTransactionsPage> {
  TextEditingController phoneController = TextEditingController();
  TransactionMain transactionMain = TransactionMain();

  List<_ChartData> data = [];
  List<_ChartData> data2 = [];

  List<TransactionHistory> transactionHistory = [];

  late TooltipBehavior _tooltip;

  bool isHousingTapped = true;
  bool isImpressionTapped = true;

  @override
  void initState() {
    getMyTransactionsStatistic();
    getMyTransactionsHistory();
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
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
                              'Мои транзакции',
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
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Транзакции",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blackWithOpacity,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          "${formatNumberString(transactionMain.totalPriceSum.toString())} тг",
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.white,
                                  //       borderRadius: const BorderRadius.all(
                                  //           Radius.circular(8)),
                                  //       border: Border.all(
                                  //         width: 1,
                                  //         color: AppColors.grey,
                                  //       )),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 10, vertical: 5),
                                  //     child: Row(
                                  //       children: const [
                                  //         Text(
                                  //           "Год",
                                  //           style: TextStyle(
                                  //             fontSize: 14,
                                  //             fontWeight: FontWeight.w500,
                                  //             color: AppColors.blackWithOpacity,
                                  //           ),
                                  //         ),
                                  //         Icon(Icons.arrow_drop_down)
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              isHousingTapped || isImpressionTapped
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 150,
                                      child: SfCartesianChart(
                                        primaryXAxis: CategoryAxis(
                                          labelStyle: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.black,
                                          ),
                                        ),
                                        primaryYAxis: NumericAxis(
                                          isVisible: false,
                                        ),
                                        tooltipBehavior: _tooltip,
                                        series: <
                                            ChartSeries<_ChartData, String>>[
                                          isImpressionTapped
                                              ? AreaSeries<_ChartData, String>(
                                                  dataSource: data,
                                                  xValueMapper:
                                                      (_ChartData data, _) =>
                                                          data.x,
                                                  yValueMapper:
                                                      (_ChartData data, _) =>
                                                          data.y,
                                                  name: 'Инф.',
                                                  color: AppColors.accent
                                                      .withOpacity(0.2),
                                                  borderColor: AppColors.accent,
                                                  borderWidth: 1,
                                                )
                                              : AreaSeries(
                                                  dataSource: [],
                                                  xValueMapper:
                                                      (_ChartData data, _) =>
                                                          data.x,
                                                  yValueMapper:
                                                      (_ChartData data, _) =>
                                                          data.y),
                                          isHousingTapped
                                              ? AreaSeries<_ChartData, String>(
                                                  dataSource: data2,
                                                  xValueMapper:
                                                      (_ChartData data, _) =>
                                                          data.x,
                                                  yValueMapper:
                                                      (_ChartData data, _) =>
                                                          data.y,
                                                  name: 'Инф.',
                                                  color: AppColors.main
                                                      .withOpacity(0.2),
                                                  borderColor: AppColors.main,
                                                  borderWidth: 1,
                                                )
                                              : AreaSeries(
                                                  dataSource: [],
                                                  xValueMapper:
                                                      (_ChartData data, _) =>
                                                          data.x,
                                                  yValueMapper:
                                                      (_ChartData data, _) =>
                                                          data.y),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isImpressionTapped =
                                            !isImpressionTapped;
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      decoration: BoxDecoration(
                                        color: isImpressionTapped
                                            ? AppColors.accent
                                            : AppColors.grey,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Column(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/tab_bar_icon2.svg',
                                              color: isImpressionTapped
                                                  ? AppColors.white
                                                  : AppColors.black,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "${formatNumberString(transactionMain.impressionTotalPriceSum.toString())} тг",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: isImpressionTapped
                                                    ? AppColors.white
                                                    : AppColors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Впечатление",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: isImpressionTapped
                                                    ? Colors.white60
                                                    : Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isHousingTapped = !isHousingTapped;
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      decoration: BoxDecoration(
                                        color: isHousingTapped
                                            ? AppColors.main
                                            : AppColors.grey,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Column(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/tab_bar_icon3.svg',
                                              color: isHousingTapped
                                                  ? AppColors.white
                                                  : AppColors.black,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "${formatNumberString(transactionMain.housingTotalPriceSum.toString())} тг",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: isHousingTapped
                                                    ? AppColors.white
                                                    : AppColors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Жилье",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: isHousingTapped
                                                    ? Colors.white60
                                                    : Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    "История платежей",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
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

  void getMyTransactionsStatistic() async {
    var response = await ProfileProvider().getMyTransactionsStatistic();
    if (response['response_status'] == 'ok') {
      transactionMain = TransactionMain.fromJson(response['data']);

      for (int i = 0; i < transactionMain.month!.length; i++) {
        data.add(_ChartData(
            '${transactionMain.month![i].name!.substring(0, 3)}.\n${transactionMain.month![i].year}',
            transactionMain.month![i].housingPrice ?? 0));
        data2.add(_ChartData(
            '${transactionMain.month![i].name!.substring(0, 3)}.\n${transactionMain.month![i].year}',
            transactionMain.month![i].impressionPrice ?? 0));
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  void getMyTransactionsHistory() async {
    var response = await ProfileProvider().getMyTransactionsHistory();
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        transactionHistory
            .add(TransactionHistory.fromJson(response['data'][i]));
      }

      if (mounted) {
        setState(() {});
      }
    }
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
