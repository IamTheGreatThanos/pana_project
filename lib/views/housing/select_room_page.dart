import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/components/room_card.dart';
import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/models/roomCard.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/views/payment/payment_page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SelectRoomPage extends StatefulWidget {
  const SelectRoomPage(this.housing, this.price, this.startDate, this.endDate);
  final HousingDetailModel housing;
  final int price;
  final String startDate;
  final String endDate;

  @override
  _SelectRoomPageState createState() => _SelectRoomPageState();
}

class _SelectRoomPageState extends State<SelectRoomPage> {
  final DateRangePickerController _datePickerController =
      DateRangePickerController();
  String selectedRange = 'Выбрать даты';

  List<RoomCardModel> roomsList = [];
  List<int> roomCounts = [];
  List<int> selectedRoomIds = [];
  List<int> selectedRoomCounts = [];
  List<RoomCardModel> selectedRooms = [];

  String startDate = '';
  String endDate = '';

  @override
  void initState() {
    if (widget.startDate != '') {
      startDate = widget.startDate;
      endDate = widget.endDate;

      selectedRange =
          '${DateFormat('dd/MM/yyyy').format(DateTime.parse(startDate))} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(endDate))}';

      getRoomListByDate();
    }
    // getRoomsList();
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
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(color: AppColors.white, height: 30),
                Container(
                  color: AppColors.white,
                  child: Row(
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
                          children: [
                            const Text(
                              'Выбрать номер',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.housing.name ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 50)
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  color: AppColors.lightGray,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.lightGray,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.67,
                        child: ListView(
                          children: [
                            roomsList.isEmpty
                                ? Column(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/images/calendar_image.svg'),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 20,
                                          horizontal: 40,
                                        ),
                                        child: Text(
                                          'Чтобы увидеть список свободных комнат выберите дату',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            for (int i = 0; i < roomsList.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.cardBorderRadius),
                                      color: AppColors.white),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      RoomCard(roomsList[i], selectedRange),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Выберите количество',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                minusFunction(i);
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      offset: Offset(
                                                          0.0, 1.0), //(x,y)
                                                      blurRadius: 1.0,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(16),
                                                  ),
                                                ),
                                                child: const Icon(Icons.remove),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                roomCounts[i].toString(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                plusFunction(i);
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      offset: Offset(
                                                          0.0, 1.0), //(x,y)
                                                      blurRadius: 1.0,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(16),
                                                  ),
                                                ),
                                                child: Icon(Icons.add),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 20),
                                        child: SizedBox(
                                          height: 48,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: selectedRoomIds
                                                      .contains(roomsList[i].id)
                                                  ? AppColors.accent
                                                  : AppColors.grey,
                                              minimumSize:
                                                  const Size.fromHeight(50),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              roomSelectionFunction(
                                                  roomsList[i].id!,
                                                  roomsList[i],
                                                  roomCounts[i]);
                                            },
                                            child: Text(
                                              "Выбрать этот номер",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: selectedRoomIds
                                                          .contains(
                                                              roomsList[i].id)
                                                      ? AppColors.white
                                                      : AppColors
                                                          .blackWithOpacity),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 30),
                                  Row(
                                    children: [
                                      Text(
                                        'от \₸${formatNumberString(widget.price.toString())}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: AppColors.black),
                                      ),
                                      const Text(
                                        ' за сутки',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.black45),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      showDatePicker();
                                    },
                                    child: Text(
                                      selectedRange,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: AppColors.black,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              SizedBox(
                                height: 48,
                                width: 150,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: AppColors.accent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // <-- Radius
                                    ),
                                  ),
                                  onPressed: () {
                                    List<Map<String, dynamic>>
                                        paymentSelectedRooms = [];

                                    for (int k = 0;
                                        k < selectedRoomIds.length;
                                        k++) {
                                      paymentSelectedRooms.add({
                                        'id': selectedRoomIds[k],
                                        'count': selectedRoomCounts[k]
                                      });
                                    }

                                    if (startDate != '' && endDate != '') {
                                      if (selectedRooms.isNotEmpty) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentPage(
                                                        selectedRooms,
                                                        paymentSelectedRooms,
                                                        widget.housing,
                                                        startDate,
                                                        endDate)));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Пожалуйста, выберите комнату.',
                                              style: TextStyle(fontSize: 14)),
                                        ));
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Пожалуйста, выберите дату.',
                                            style: TextStyle(fontSize: 14)),
                                      ));
                                    }
                                  },
                                  child: const Text(
                                    "Забронировать",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
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
                            if (startDate != '') {
                              getRoomListByDate();
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
        selectedRange =
            '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
        if (args.value.startDate != null && args.value.endDate != null) {
          startDate = DateFormat('yyyy-MM-dd').format(args.value.startDate);
          endDate = DateFormat('yyyy-MM-dd').format(args.value.endDate);
        }
      }
    });
  }

  void plusFunction(int index) {
    setState(() {
      roomCounts[index] += 1;
    });
  }

  void minusFunction(int index) {
    setState(() {
      if (roomCounts[index] > 1) {
        roomCounts[index] -= 1;
      }
    });
  }

  void getRoomsList() async {
    roomsList = [];
    roomCounts = [];
    var response = await MainProvider().getRoomsList(widget.housing.id!);
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        roomsList.add(RoomCardModel.fromJson(response['data'][i]));
        roomCounts.add(1);
      }
      setState(() {});
    } else {
      print(response['data']['message']);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 20)),
      ));
    }
  }

  void getRoomListByDate() async {
    roomsList = [];
    roomCounts = [];
    selectedRoomIds = [];
    selectedRoomCounts = [];
    var response = await MainProvider()
        .getRoomsListByDate(widget.housing.id!, startDate, endDate);
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        roomsList.add(RoomCardModel.fromJson(response['data'][i]));
        roomCounts.add(1);
      }

      if (mounted) {
        setState(() {});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 20)),
      ));
    }
  }

  void roomSelectionFunction(int id, RoomCardModel room, int roomCount) {
    setState(() {
      if (selectedRoomIds.contains(id)) {
        int index = selectedRoomIds.indexOf(id);
        selectedRoomIds.remove(id);
        selectedRooms.remove(room);
        selectedRoomCounts.removeAt(index);
      } else {
        selectedRoomIds.add(id);
        selectedRooms.add(room);
        selectedRoomCounts.add(roomCount);
      }
    });
  }
}
