import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/transaction_payment_history_card.dart';
import 'package:pana_project/utils/const.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyTransactionsPage extends StatefulWidget {
  @override
  _MyTransactionsPageState createState() => _MyTransactionsPageState();
}

class _MyTransactionsPageState extends State<MyTransactionsPage> {
  TextEditingController phoneController = TextEditingController();
  List<_ChartData> data = [
    _ChartData('Янв', 6, 1),
    _ChartData('Фев', 10, 1),
    _ChartData('Мар', 12, 1),
    _ChartData('Апр', 6.4, 1),
    _ChartData('Май', 14, 1),
    _ChartData('Июн', 13, 1),
    _ChartData('Июл', 20, 1),
  ];

  List<_ChartData> data2 = [
    _ChartData('Янв', 30, 1),
    _ChartData('Фев', 9, 1),
    _ChartData('Мар', 12, 1),
    _ChartData('Апр', 6.4, 1),
    _ChartData('Май', 10, 1),
    _ChartData('Июн', 6, 1),
    _ChartData('Июл', 3, 1),
  ];

  late TooltipBehavior _tooltip;

  int choosedType = 2;

  @override
  void initState() {
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
                                    children: const [
                                      Text(
                                        "Транзакции",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blackWithOpacity,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "1.543.000 тг",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        border: Border.all(
                                          width: 1,
                                          color: AppColors.grey,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Row(
                                        children: const [
                                          Text(
                                            "Год",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.blackWithOpacity,
                                            ),
                                          ),
                                          Icon(Icons.arrow_drop_down)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
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
                                    minimum: 0,
                                    maximum: 40,
                                    interval: 50,
                                    isVisible: false,
                                  ),
                                  tooltipBehavior: _tooltip,
                                  series: <ChartSeries<_ChartData, String>>[
                                    AreaSeries<_ChartData, String>(
                                      dataSource: data,
                                      xValueMapper: (_ChartData data, _) =>
                                          '${data.x}\n2022',
                                      yValueMapper: (_ChartData data, _) =>
                                          data.y,
                                      name: 'Text',
                                      color: AppColors.accent.withOpacity(0.2),
                                      borderColor: AppColors.accent,
                                      borderWidth: 1,
                                    ),
                                    AreaSeries<_ChartData, String>(
                                      dataSource: data2,
                                      xValueMapper: (_ChartData data, _) =>
                                          '${data.x}\n2022',
                                      yValueMapper: (_ChartData data, _) =>
                                          data.y,
                                      name: 'Text',
                                      color: AppColors.main.withOpacity(0.2),
                                      borderColor: AppColors.main,
                                      borderWidth: 1,
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      color: choosedType == 2
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
                                            color: choosedType == 2
                                                ? AppColors.white
                                                : AppColors.black,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "1.543.000 тг",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: choosedType == 2
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
                                              color: choosedType == 2
                                                  ? Colors.white60
                                                  : Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      color: choosedType == 1
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
                                            color: choosedType == 1
                                                ? AppColors.white
                                                : AppColors.black,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "1.543.000 тг",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: choosedType == 1
                                                  ? AppColors.white
                                                  : AppColors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Жилье",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: choosedType == 1
                                                  ? Colors.white60
                                                  : Colors.black54,
                                            ),
                                          ),
                                        ],
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
                for (int i = 0; i < 3; i++) TransactionPaymentHistoryCard(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.type);

  final String x;
  final double y;
  final int type;
}
