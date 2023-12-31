import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/components/pana_travel_card.dart';
import 'package:pana_project/components/travel_card.dart';
import 'package:pana_project/models/panaTravelCard.dart';
import 'package:pana_project/models/travelCard.dart';
import 'package:pana_project/services/travel_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/auth/auth_page.dart';
import 'package:pana_project/views/travel/pana_travel_info.dart';
import 'package:pana_project/views/travel/travel_plan_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HomeTravel extends StatefulWidget {
  const HomeTravel(this.onButtonPressed);
  final void Function(int) onButtonPressed;

  @override
  _HomeTravelState createState() => _HomeTravelState();
}

class _HomeTravelState extends State<HomeTravel> {
  final DateRangePickerController _datePickerController =
      DateRangePickerController();
  TextEditingController _titleController = TextEditingController();
  String selectedRange = '';
  String startDate = '';
  String endDate = '';

  List<TravelCardModel> travelList = [];
  List<PanaTravelCardModel> panaTravelList = [];

  bool loading = true;

  @override
  void initState() {
    checkIsLogedIn();
    super.initState();
  }

  Future<void> _pullRefresh() async {
    getTravelList();
    getPanaTravelList();
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
      child: loading
          ? const Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  color: AppColors.grey,
                ),
              ),
            )
          : DefaultTabController(
              length: 2,
              child: Scaffold(
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            const SizedBox(width: 40),
                            const Spacer(),
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Поездки',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                showNewPlanOfTravelModalSheet();
                              },
                              child: const SizedBox(
                                width: 30,
                                height: 30,
                                child: Icon(
                                  Icons.add,
                                  size: 26,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        const TabBar(
                          labelColor: AppColors.black,
                          indicatorColor: AppColors.accent,
                          indicatorSize: TabBarIndicatorSize.label,
                          unselectedLabelColor: AppColors.blackWithOpacity,
                          labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          tabs: [
                            Tab(
                              text: 'Поездки Pana',
                            ),
                            Tab(text: 'Мои поездки'),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: TabBarView(
                            children: [
                              // TODO: Pana Travel list
                              panaTravelList.isNotEmpty
                                  ? Container(
                                      color: AppColors.lightGray,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: RefreshIndicator(
                                        onRefresh: _pullRefresh,
                                        child: ListView(
                                          children: [
                                            for (int i = 0;
                                                i < panaTravelList.length;
                                                i++)
                                              GestureDetector(
                                                onTap: () async {
                                                  StoryController
                                                      storyController =
                                                      StoryController();
                                                  List<StoryItem?>
                                                      thisStoryItems = [];
                                                  List<StoryItem?>
                                                      mediaStoryItems = [];

                                                  // TODO: Housing images

                                                  for (int j = 0;
                                                      j <
                                                          (panaTravelList[i]
                                                                  .housings?[0]
                                                                  .images
                                                                  ?.length ??
                                                              0);
                                                      j++) {
                                                    thisStoryItems.add(
                                                      StoryItem.pageImage(
                                                        url: panaTravelList[i]
                                                                .housings?[0]
                                                                .images?[j]
                                                                .path ??
                                                            '',
                                                        controller:
                                                            storyController,
                                                        imageFit: BoxFit.cover,
                                                      ),
                                                    );

                                                    mediaStoryItems.add(
                                                      StoryItem.pageImage(
                                                        url: panaTravelList[i]
                                                                .housings?[0]
                                                                .images?[j]
                                                                .path ??
                                                            '',
                                                        controller:
                                                            storyController,
                                                        imageFit:
                                                            BoxFit.fitWidth,
                                                      ),
                                                    );
                                                  }

                                                  // TODO: Impression images

                                                  for (int j = 0;
                                                      j <
                                                          (panaTravelList[i]
                                                                  .impressions?[
                                                                      0]
                                                                  .images
                                                                  ?.length ??
                                                              0);
                                                      j++) {
                                                    thisStoryItems.add(
                                                      StoryItem.pageImage(
                                                        url: panaTravelList[i]
                                                                .impressions?[0]
                                                                .images?[j]
                                                                .path ??
                                                            '',
                                                        controller:
                                                            storyController,
                                                        imageFit: BoxFit.cover,
                                                      ),
                                                    );

                                                    mediaStoryItems.add(
                                                      StoryItem.pageImage(
                                                        url: panaTravelList[i]
                                                                .impressions?[0]
                                                                .images?[j]
                                                                .path ??
                                                            '',
                                                        controller:
                                                            storyController,
                                                        imageFit:
                                                            BoxFit.fitWidth,
                                                      ),
                                                    );
                                                  }

                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PanaTravelInfo(
                                                                  panaTravelList[
                                                                      i],
                                                                  thisStoryItems,
                                                                  mediaStoryItems)));
                                                  setState(() {});
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 20),
                                                  child: PanaTravelCard(
                                                    panaTravelList[i],
                                                    () {},
                                                  ),
                                                ),
                                              ),
                                            const SizedBox(height: 130),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              80,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Spacer(),
                                              SizedBox(
                                                width: 120,
                                                height: 120,
                                                child: SvgPicture.asset(
                                                    'assets/images/placeholder_image.svg'),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                child: const Text(
                                                  'У Pana пока нет запланированных поездок',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const Spacer(),
                                            ],
                                          )),
                                    ),

                              // TODO: My travels
                              travelList.isNotEmpty
                                  ? Container(
                                      color: AppColors.lightGray,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: RefreshIndicator(
                                        onRefresh: _pullRefresh,
                                        child: ListView(
                                          children: [
                                            // Padding(
                                            //   padding: const EdgeInsets.all(20),
                                            //   child: Container(
                                            //     decoration: BoxDecoration(
                                            //       border: Border.all(
                                            //         color: AppColors.grey,
                                            //         width: 1,
                                            //       ),
                                            //       borderRadius: const BorderRadius.all(
                                            //         Radius.circular(100),
                                            //       ),
                                            //     ),
                                            //     child: const Padding(
                                            //       padding: EdgeInsets.symmetric(
                                            //           horizontal: 15, vertical: 7),
                                            //       child: Text(
                                            //         'Июль 2022',
                                            //         style: TextStyle(
                                            //           fontSize: 12,
                                            //           color: Colors.black45,
                                            //           fontWeight: FontWeight.bold,
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            for (int i = 0;
                                                i < travelList.length;
                                                i++)
                                              GestureDetector(
                                                  onTap: () {
                                                    goToTravelPlan(
                                                        travelList[i]);
                                                  },
                                                  child: TravelCard(
                                                      travelList[i])),
                                            const SizedBox(height: 150),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              80,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              const Spacer(),
                                              SizedBox(
                                                width: 120,
                                                height: 120,
                                                child: SvgPicture.asset(
                                                    'assets/images/placeholder_image.svg'),
                                              ),
                                              const Spacer(),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                child: const Text(
                                                  'У вас пока нет запланированных поездок',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                child: SizedBox(
                                                  height: 60,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0,
                                                      primary: AppColors.accent,
                                                      minimumSize:
                                                          const Size.fromHeight(
                                                              50),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10), // <-- Radius
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        widget
                                                            .onButtonPressed(2);
                                                      });
                                                    },
                                                    child: const Text(
                                                        "Перейти к поиску жилья",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                child: SizedBox(
                                                  height: 60,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0,
                                                      primary: AppColors.white,
                                                      minimumSize:
                                                          const Size.fromHeight(
                                                              50),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: const BorderSide(
                                                            width: 2,
                                                            color:
                                                                AppColors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      showNewPlanOfTravelModalSheet();
                                                    },
                                                    child: const Text(
                                                        "Создать план",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 80)
                                            ],
                                          )),
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
    );
  }

  void showNewPlanOfTravelModalSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.cardBorderRadius),
            topRight: Radius.circular(AppConstants.cardBorderRadius)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                height: 400,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const Text(
                          'Новый план поездки',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                                  hintText: 'Отдых с семьей, каникулы и т.д.',
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
                      const Text(
                        'Планы позволяют составить маршрут из мест, которые вы посетите в поездке',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          const Spacer(),
                          SizedBox(
                            height: 60,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Отмена",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 60,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.accent,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                if (_titleController.text != '') {
                                  Navigator.of(context).pop();
                                  showDatePicker();
                                }
                              },
                              child: const Text(
                                "Далее",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
                            if (startDate != '' && endDate != '') {
                              Navigator.of(context).pop();
                              createNewTravel();
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
                    minDate: DateTime.now(),
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
            '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} - ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
        if (args.value.startDate != null && args.value.endDate != null) {
          startDate = DateFormat('yyyy-MM-dd').format(args.value.startDate);
          endDate = DateFormat('yyyy-MM-dd').format(args.value.endDate);
        }
      }
    });
  }

  // TODO: Get Travel List

  void getTravelList() async {
    travelList = [];
    var response = await TravelProvider().getTravelList();
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        travelList.add(TravelCardModel.fromJson(response['data'][i]));
      }
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void goToTravelPlan(TravelCardModel travel) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TravelPlanePage(travel)));
    if (mounted) {
      getTravelList();
    }
  }

  // TODO: Get Pana Travel List

  void getPanaTravelList() async {
    panaTravelList = [];
    var response = await TravelProvider().getPanaTravelList();
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        panaTravelList.add(PanaTravelCardModel.fromJson(response['data'][i]));
      }
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void createNewTravel() async {
    var response = await TravelProvider()
        .createTravel(_titleController.text, startDate, endDate);
    if (response['response_status'] == 'ok') {
      _titleController.text = '';
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TravelPlanePage(TravelCardModel.fromJson(response['data']))));

      if (mounted) {
        getTravelList();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void checkIsLogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogedIn') == true) {
      getTravelList();
      getPanaTravelList();
    } else {
      showAlertDialog(context);
    }
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Отмена"),
      onPressed: () {
        widget.onButtonPressed(2);
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Да"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AuthPage()));
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Внимание"),
      content: const Text("Вы не вошли в аккаунт. Войти?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).whenComplete(() => widget.onButtonPressed(2));
  }
}
