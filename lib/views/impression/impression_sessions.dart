import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/components/impression_session_card.dart';
import 'package:pana_project/models/impressionDetail.dart';
import 'package:pana_project/models/impressionSession.dart';
import 'package:pana_project/services/impression_api_provider.dart';
import 'package:pana_project/utils/ImpressionData.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/views/payment/impression_payment_page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ImpressionSessionsPage extends StatefulWidget {
  ImpressionSessionsPage(this.impression, this.startDate, this.endDate);
  final ImpressionDetailModel impression;
  final String startDate;
  final String endDate;

  @override
  _ImpressionSessionsPageState createState() => _ImpressionSessionsPageState();
}

class _ImpressionSessionsPageState extends State<ImpressionSessionsPage> {
  final DateRangePickerController _datePickerController =
      DateRangePickerController();
  final impressionData = ImpressionData();
  List<ImpressionSessionModel> sessionList = [];
  String dateText = '';
  int sessionCount = 0;

  String startDate = '';
  String endDate = '';

  @override
  void initState() {
    startDate = widget.startDate;
    endDate = widget.endDate;
    dateText =
        '${DateFormat('dd.MM.yyyy').format(DateTime.parse(startDate)).substring(0, 5)} - ${DateFormat('dd.MM.yyyy').format(DateTime.parse(endDate)).substring(0, 5)}';

    getSessions();

    super.initState();
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child:
                                SvgPicture.asset('assets/icons/back_arrow.svg'),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              'Число сеансов: $sessionCount',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'На $dateText',
                              style: const TextStyle(
                                color: AppColors.blackWithOpacity,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text('Фильтр:'),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            showDatePicker();
                          },
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: AppColors.accent),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: Row(
                                children: [
                                  Text(
                                    dateText,
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            showPeopleCountModalSheet();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: AppColors.accent),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: Row(
                                children: [
                                  Text(
                                    checkPersonCount(
                                        impressionData.peopleCount.toString()),
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  // StreamBuilder(
                                  //   stream: impressionData.dataStream
                                  //       .asBroadcastStream(),
                                  //   builder: (context, snapshot) {
                                  //     if (snapshot.hasData) {
                                  //       return Text(
                                  //         '${snapshot.data} персоны',
                                  //         style: const TextStyle(
                                  //           color: AppColors.accent,
                                  //           fontWeight: FontWeight.w500,
                                  //         ),
                                  //       );
                                  //     } else {
                                  //       return const Text(
                                  //         '1 персоны',
                                  //         style: TextStyle(
                                  //           color: AppColors.accent,
                                  //           fontWeight: FontWeight.w500,
                                  //         ),
                                  //       );
                                  //     }
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: AppColors.lightGray,
                  child: Column(
                    children: [
                      for (int i = 0; i < sessionList.length; i++)
                        GestureDetector(
                          onTap: () {
                            showPrivateModeModalSheet(i);
                          },
                          child: ImpressionSessionCard(
                            session: sessionList[i],
                            impressionData: impressionData,
                            impression: widget.impression,
                            startDate: widget.startDate,
                            endDate: widget.endDate,
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDatePicker() async {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.cardBorderRadius),
            topRight: Radius.circular(AppConstants.cardBorderRadius)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: SizedBox(
            height: 500,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Назад',
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Выбрать даты',
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            if (startDate != '') {
                              getSessions();
                            }
                          },
                          child: const Text(
                            'Готово',
                            style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  SfDateRangePicker(
                    controller: _datePickerController,
                    onSelectionChanged: _onSelectionChanged,
                    startRangeSelectionColor: Colors.black,
                    endRangeSelectionColor: Colors.black,
                    rangeSelectionColor: Colors.black12,
                    selectionColor: AppColors.accent,
                    headerStyle: const DateRangePickerHeaderStyle(
                        textAlign: TextAlign.center),
                    selectionMode: DateRangePickerSelectionMode.range,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        if (args.value.startDate != null && args.value.endDate != null) {
          startDate = DateFormat('yyyy-MM-dd').format(args.value.startDate);
          endDate = DateFormat('yyyy-MM-dd').format(args.value.endDate);
          dateText =
              '${DateFormat('dd.MM.yyyy').format(DateTime.parse(startDate)).substring(0, 5)} - ${DateFormat('dd.MM.yyyy').format(DateTime.parse(endDate)).substring(0, 5)}';
          setState(() {});
        }
      }
    });
  }

  void showPeopleCountModalSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.cardBorderRadius),
            topRight: Radius.circular(AppConstants.cardBorderRadius)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return ImpressionPeopleCountBottomSheet(impressionData);
      },
    );

    setState(() {});
  }

  void showPrivateModeModalSheet(int index) async {
    await showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.cardBorderRadius),
            topRight: Radius.circular(AppConstants.cardBorderRadius)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return ImpressionSessionPrivateModeModalBottomSheet(
          session: sessionList[index],
          impressionData: impressionData,
          impression: widget.impression,
          startDate: widget.startDate,
          endDate: widget.endDate,
        );
      },
    );

    setState(() {});
  }

  void getSessions() async {
    sessionList = [];
    var response = await ImpressionProvider()
        .getSessionsInImpression(widget.impression.id!, startDate, endDate);
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        sessionList.add(ImpressionSessionModel.fromJson(response['data'][i]));
      }

      sessionCount = sessionList.length;

      if (mounted) {
        setState(() {});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  String checkPersonCount(String personCount) {
    if (personCount.endsWith('1')) {
      return '$personCount персона';
    } else if (personCount.endsWith('2') ||
        personCount.endsWith('3') ||
        personCount.endsWith('4')) {
      return '$personCount персоны';
    }

    return '$personCount персон';
  }
}

class ImpressionPeopleCountBottomSheet extends StatefulWidget {
  ImpressionPeopleCountBottomSheet(this.impressionData);
  final ImpressionData impressionData;
  @override
  _ImpressionPeopleCountBottomSheetState createState() =>
      _ImpressionPeopleCountBottomSheetState();
}

class _ImpressionPeopleCountBottomSheetState
    extends State<ImpressionPeopleCountBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Выберите число персон:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(width: 1, color: AppColors.grey)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Персоны',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '0 - 99 лет',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          widget.impressionData.minusFunction();
                          setState(() {});
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: const Icon(Icons.remove),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          widget.impressionData.peopleCount.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.impressionData.plusFunction();
                          setState(() {});
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // <-- Radius
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Продолжить",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImpressionSessionPrivateModeModalBottomSheet extends StatefulWidget {
  const ImpressionSessionPrivateModeModalBottomSheet({
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
  State<ImpressionSessionPrivateModeModalBottomSheet> createState() =>
      _ImpressionSessionPrivateModeModalBottomSheetState();
}

class _ImpressionSessionPrivateModeModalBottomSheetState
    extends State<ImpressionSessionPrivateModeModalBottomSheet> {
  bool isPrivateSelected = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Выберите тип группы:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                isPrivateSelected = false;
                setState(() {});
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  border: Border.all(
                    width: 2,
                    color: AppColors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isPrivateSelected
                          ? SvgPicture.asset('assets/icons/radio_button_0.svg')
                          : SvgPicture.asset('assets/icons/radio_button_1.svg'),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          const Text(
                            'Открытая группа',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Это группа, доступная для \nбронирования любым человеком',
                            style: TextStyle(
                              color: AppColors.blackWithOpacity,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                                text:
                                    '${formatNumberString(widget.session.openPrice.toString())}₸ ',
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: const <InlineSpan>[
                                  TextSpan(
                                      text: 'за человека',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.blackWithOpacity,
                                      ))
                                ]),
                          ),
                          const SizedBox(height: 10),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                isPrivateSelected = true;
                setState(() {});
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  border: Border.all(
                    width: 2,
                    color: AppColors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isPrivateSelected
                          ? SvgPicture.asset('assets/icons/radio_button_1.svg')
                          : SvgPicture.asset('assets/icons/radio_button_0.svg'),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          const Text(
                            'Закрытая группа',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Это группа, предназначеная для \nбронирования 1 человеком, \nсразу всех мест',
                            style: TextStyle(
                              color: AppColors.blackWithOpacity,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                                text:
                                    '${formatNumberString(widget.session.closedPrice.toString())}₸ ',
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: const <InlineSpan>[
                                  TextSpan(
                                      text: 'за человека',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.blackWithOpacity,
                                      ))
                                ]),
                          ),
                          const SizedBox(height: 10),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // <-- Radius
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImpressionPaymentPage(
                        widget.impression,
                        widget.startDate,
                        widget.endDate,
                        widget.impressionData,
                        widget.session,
                        isPrivateSelected ? 2 : 1,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Далее",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
