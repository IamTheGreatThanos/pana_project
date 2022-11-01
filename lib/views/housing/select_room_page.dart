import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/components/room_card.dart';
import 'package:pana_project/utils/const.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SelectRoomPage extends StatefulWidget {
  // const SelectRoomPage(this.onButtonPressed);
  // final void Function() onButtonPressed;

  @override
  _SelectRoomPageState createState() => _SelectRoomPageState();
}

class _SelectRoomPageState extends State<SelectRoomPage> {
  final DateRangePickerController _datePickerController =
      DateRangePickerController();
  String selectedRange = '';

  @override
  void initState() {
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(height: 30),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child:
                              SvgPicture.asset('assets/icons/back_arrow.svg'),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: const [
                          Text(
                            'Выбрать номер',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Pana Boutiq Hotel',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(width: 50)
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  color: AppColors.lightGray,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      for (int i = 0; i < 10; i++) RoomCard(),
                      GestureDetector(
                        onTap: () {
                          showDatePicker();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Text(
                            'Выбрать другие даты',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
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
                            print(selectedRange);
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
        selectedRange =
            '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      }
    });
  }
}
