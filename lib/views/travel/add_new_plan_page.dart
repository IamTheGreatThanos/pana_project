import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/services/travel_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/other/list_of_countries_page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddNewPlanPage extends StatefulWidget {
  AddNewPlanPage(this.id);
  final int id;

  @override
  _AddNewPlanPageState createState() => _AddNewPlanPageState();
}

class _AddNewPlanPageState extends State<AddNewPlanPage> {
  final DateRangePickerController _datePickerController =
      DateRangePickerController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _toDoItemController = TextEditingController();

  var _switchValue = false;

  List<Map<String, dynamic>> toDoList = [];

  String selectedRange = 'Выбрать даты';
  String startDate = '';
  String endDate = '';

  String startTime = '';
  String endTime = '';
  int selectedCityId = 0;
  String selectedCityName = 'Выбрать город';

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
        backgroundColor: AppColors.lightGray,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(color: AppColors.white, height: 30),
                Container(
                  color: Colors.white,
                  child: Row(
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
                            child:
                                SvgPicture.asset('assets/icons/back_arrow.svg'),
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Добавить план',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
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
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                        bottomRight:
                            Radius.circular(AppConstants.cardBorderRadius),
                        bottomLeft:
                            Radius.circular(AppConstants.cardBorderRadius)),
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset('assets/images/calendar_image.svg'),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 20, left: 30, right: 30, bottom: 20),
                        child: Text(
                          'Создание нового плана внутри вашей поездки',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 30, right: 30, bottom: 20),
                        child: Text(
                          'Если вам нужно посетить какие либо места между забронированными отелями и впечатлениями, их можно добавить тут',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.blackWithOpacity,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              child: TextField(
                                controller: _titleController,
                                maxLength: 100,
                                decoration: const InputDecoration(
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
                                  border: InputBorder.none,
                                  hintText: 'Введите название',
                                  hintStyle: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppConstants.cardBorderRadius),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/map_pin.svg'),
                        const SizedBox(width: 20),
                        const Text(
                          'Локация',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            goToCountriesPage();
                          },
                          child: Text(
                            selectedCityName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: selectedCityId != 0
                                  ? AppColors.accent
                                  : AppColors.blackWithOpacity,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppConstants.cardBorderRadius),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/calendar_icon.svg'),
                        const SizedBox(width: 20),
                        const Text(
                          'Дата и время',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            showDatePicker();
                          },
                          child: Text(
                            selectedRange,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackWithOpacity,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppConstants.cardBorderRadius),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          'Список дел',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Divider(),
                      for (var item in toDoList)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (item['status'] == 0) {
                                        item['status'] = 1;
                                      } else {
                                        item['status'] = 0;
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                          color: item['status'] == 1
                                              ? AppColors.accent
                                              : Colors.transparent,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          border: Border.all(
                                              width: 1, color: AppColors.grey)),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Divider(),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              child: TextField(
                                controller: _toDoItemController,
                                onSubmitted: (value) {
                                  if (_toDoItemController.text != '') {
                                    toDoList.add({
                                      'name': _toDoItemController.text,
                                      'status': 0
                                    });
                                    _toDoItemController.text = '';
                                    setState(() {});
                                  }
                                },
                                maxLength: 100,
                                decoration: const InputDecoration(
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
                                  border: InputBorder.none,
                                  hintText: 'Название плана',
                                  hintStyle: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            if (_toDoItemController.text != '') {
                              toDoList.add({
                                'name': _toDoItemController.text,
                                'status': 0
                              });
                              _toDoItemController.text = '';
                              setState(() {});
                            }
                          },
                          child: const Text(
                            'Добавить элемент',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackWithOpacity,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 20),
                        SvgPicture.asset(
                          'assets/icons/lock_icon.svg',
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Сделать план приватным',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: _switchValue,
                            activeColor: AppColors.accent,
                            onChanged: (value) {
                              setState(() {
                                _switchValue = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10)
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 30, bottom: 20, right: 30),
                  child: Text(
                    'Если вдруг вы запланировали поездку с компанией, но у вас есть свои планы, вы можете сделать этот список дел приватным, он не будет виден другим',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.accent,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      onPressed: () {
                        if (_titleController.text != '' &&
                            toDoList.isNotEmpty &&
                            selectedRange != 'Выбрать даты' &&
                            selectedCityId != 0) {
                          saveChanges();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Заполните все поля.",
                                style: const TextStyle(fontSize: 14)),
                          ));
                        }
                      },
                      child: const Text("Сохранить план",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void goToCountriesPage() async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ListOfCountriesPage()));
    selectedCityId = result[0];
    selectedCityName = result[1];

    setState(() {});
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
            height: 370,
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
                            showHours();
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
                    selectionMode: DateRangePickerSelectionMode.single,
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
      if (args.value is DateTime) {
        selectedRange = DateFormat('dd/MM/yyyy').format(args.value);
        // ignore: lines_longer_than_80_chars
        // ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
        if (args.value != null) {
          startDate = DateFormat('yyyy-MM-dd').format(args.value);
          // endDate = DateFormat('yyyy-MM-dd').format(args.value);
        }
        // else {
        //   startDate = DateFormat('yyyy-MM-dd').format(args.value.startDate);
        //   endDate = DateFormat('yyyy-MM-dd').format(args.value.startDate);
        // }
      }
    });
  }

  void showHours() async {
    TimeRange result = await showTimeRangePicker(
      context: context,
      interval: const Duration(minutes: 5),
      fromText: 'начало',
      toText: 'конец',
    );

    if (result != null) {
      if (result.startTime.hour > 9) {
        if (result.startTime.minute > 9) {
          startTime = ' ${result.startTime.hour}:${result.startTime.minute}';
        } else {
          startTime = ' ${result.startTime.hour}:0${result.startTime.minute}';
        }
      } else {
        if (result.startTime.minute > 9) {
          startTime = ' 0${result.startTime.hour}:${result.startTime.minute}';
        } else {
          startTime = ' 0${result.startTime.hour}:0${result.startTime.minute}';
        }
      }

      if (result.endTime.hour > 9) {
        if (result.endTime.minute > 9) {
          endTime = ' ${result.endTime.hour}:${result.endTime.minute}';
        } else {
          endTime = ' ${result.endTime.hour}:0${result.endTime.minute}';
        }
      } else {
        if (result.endTime.minute > 9) {
          endTime = ' 0${result.endTime.hour}:${result.endTime.minute}';
        } else {
          endTime = ' 0${result.endTime.hour}:0${result.endTime.minute}';
        }
      }
    }
  }

  void saveChanges() async {
    var response = await TravelProvider().createOwnPlan(
        widget.id,
        _titleController.text,
        startDate + (startTime == '' ? ' 10:00' : startTime),
        endDate + (endTime == '' ? ' 10:00' : endTime),
        _switchValue == false ? 0 : 1,
        selectedCityId);
    print(response['data']);

    if (response['response_status'] == 'ok') {
      addToDoList(response['data']['id']);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void addToDoList(int planId) async {
    for (var i in toDoList) {
      var response = await TravelProvider()
          .addItemToPlansToDoList(planId, i['name'], i['status']);
      if (response['response_status'] == 'ok') {
        print('Created!');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['data']['message'],
              style: const TextStyle(fontSize: 14)),
        ));
      }
    }

    Navigator.of(context).pop();
  }
}
