import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pana_project/components/travel_booked_card.dart';
import 'package:pana_project/components/travel_own_card.dart';
import 'package:pana_project/components/travel_user_card.dart';
import 'package:pana_project/models/travelCard.dart';
import 'package:pana_project/models/travelPlan.dart';
import 'package:pana_project/models/user.dart';
import 'package:pana_project/services/travel_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/get_bytes_from_asset.dart';
import 'package:pana_project/views/travel/add_new_plan_page.dart';
import 'package:pana_project/views/travel/add_user_to_travel_page.dart';
import 'package:pana_project/views/travel/booked_plans_page.dart';
import 'package:pana_project/views/travel/my_plan_detail.dart';

class TravelPlanePage extends StatefulWidget {
  TravelPlanePage(this.travel);
  final TravelCardModel travel;

  @override
  _TravelPlanePageState createState() => _TravelPlanePageState();
}

class _TravelPlanePageState extends State<TravelPlanePage> {
  late GoogleMapController _mapController;
  CameraPosition _initPosition = const CameraPosition(
      target: const LatLng(43.236431, 76.917994), zoom: 14);
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> mapPoints = [];

  List<TravelPlanModel> thisTravelPlans = [];
  List<User> userList = [];
  int lenOfRoadLine = 0;

  @override
  void initState() {
    getTravelPlans();
    getTravelUsers();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
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
                          'Поездка',
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
                  color: Colors.white,
                  child: const Divider(),
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
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          widget.travel.name ?? '',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Container(
                            width: 162,
                            height: 83,
                            decoration: const BoxDecoration(
                              color: AppColors.lightGray,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.travel.dateStart?.substring(0, 10) ??
                                      '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Начало поездки',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 162,
                            height: 83,
                            decoration: const BoxDecoration(
                              color: AppColors.lightGray,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.travel.dateEnd?.substring(0, 10) ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Конец поездки',
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
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/user_icon.svg'),
                            const SizedBox(width: 5),
                            Text(
                              '${(widget.travel.usersCount ?? 0) + 1} человек',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45,
                              ),
                            ),
                            const SizedBox(width: 15),
                            SvgPicture.asset('assets/icons/map_pin.svg'),
                            const SizedBox(width: 5),
                            Text(
                              '${widget.travel.routeCount} локации',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                  child: Text(
                    'Расписание поездки',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: (thisTravelPlans.isNotEmpty
                                      ? thisTravelPlans[0].type
                                      : 1) ==
                                  1
                              ? 20
                              : 50,
                          bottom: 20,
                          left: 25),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Container(
                              width: 2,
                              height: 12,
                              color: AppColors.lightGray,
                            ),
                          ),
                          for (int i = 0; i < lenOfRoadLine; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Container(
                                width: 2,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: AppColors.grey,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        for (int i = 0; i < thisTravelPlans.length; i++)
                          thisTravelPlans[i].type == 1
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 15),
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: const BoxDecoration(
                                            color: AppColors.lightGray,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: thisTravelPlans[i]
                                                          .status ==
                                                      1
                                                  ? SvgPicture.asset(
                                                      'assets/icons/geolocation_info_icon_checkmark.svg')
                                                  : thisTravelPlans[i].status ==
                                                          2
                                                      ? SvgPicture.asset(
                                                          'assets/icons/geolocation_info_icon_accent.svg')
                                                      : SvgPicture.asset(
                                                          'assets/icons/geolocation_info_icon_grey.svg')),
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          goToMyPlanDetail(thisTravelPlans[i]);
                                        },
                                        child: Stack(
                                          children: [
                                            TravelOwnCard(
                                                thisTravelPlans[i].name ?? '',
                                                '${thisTravelPlans[i].city?.name ?? ''}, ${AppConstants.countries[(thisTravelPlans[i].city?.countryId ?? 1) - 1]}',
                                                thisTravelPlans[i]
                                                        .dateStart
                                                        ?.substring(0, 16) ??
                                                    ''),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  top: 10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showAlertDialogForDeletingPlan(
                                                      context,
                                                      thisTravelPlans[i].id!);
                                                },
                                                child: const Icon(
                                                  Icons.close,
                                                  color: AppColors
                                                      .blackWithOpacity,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20)
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 15),
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: const BoxDecoration(
                                            color: AppColors.lightGray,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: thisTravelPlans[i]
                                                          .status ==
                                                      1
                                                  ? SvgPicture.asset(
                                                      'assets/icons/geolocation_info_icon_checkmark.svg')
                                                  : thisTravelPlans[i].status ==
                                                          2
                                                      ? SvgPicture.asset(
                                                          'assets/icons/geolocation_info_icon_accent.svg')
                                                      : SvgPicture.asset(
                                                          'assets/icons/geolocation_info_icon_grey.svg')),
                                        ),
                                      ),
                                      const Spacer(),
                                      Stack(
                                        children: [
                                          TravelBookedCard(thisTravelPlans[i]),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                top: 10),
                                            child: GestureDetector(
                                              onTap: () {
                                                showAlertDialogForDeletingPlan(
                                                    context,
                                                    thisTravelPlans[i].id!);
                                              },
                                              child: const Icon(
                                                Icons.close,
                                                color:
                                                    AppColors.blackWithOpacity,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(width: 20)
                                    ],
                                  ),
                                ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 37,
                                height: 22,
                              ),
                              const Spacer(),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  border: Border.all(
                                    width: 1,
                                    color: AppColors.grey,
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      showTripModalSheet();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.add, color: Colors.black45),
                                        SizedBox(width: 10),
                                        Text(
                                          'Добавить план',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20)
                            ],
                          ),
                        ),
                        const SizedBox(height: 20)
                      ],
                    )
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(24),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 30, left: 20, bottom: 10),
                        child: Text(
                          'Маршрут поездки',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height:
                              MediaQuery.of(context).size.width * 0.9 / 1.23,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                            child: GoogleMap(
                              gestureRecognizers: Set()
                                ..add(Factory<PanGestureRecognizer>(
                                    () => PanGestureRecognizer()))
                                ..add(Factory<ScaleGestureRecognizer>(
                                    () => ScaleGestureRecognizer()))
                                ..add(Factory<TapGestureRecognizer>(
                                    () => TapGestureRecognizer()))
                                ..add(Factory<VerticalDragGestureRecognizer>(
                                    () => VerticalDragGestureRecognizer())),
                              mapType: MapType.normal,
                              initialCameraPosition: _initPosition,
                              onMapCreated: _onMapCreated,
                              markers: _markers,
                              polylines: _polylines,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 10, left: 20, bottom: 20, right: 20),
                        child: Text(
                          'Ваш маршрут зависит от выстроенного расписания поездки',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(24),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 30, left: 20, bottom: 10),
                        child: Text(
                          'Участники',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TravelUserCard(widget.travel.user!, true),
                      for (var user in userList) TravelUserCard(user, false),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            goToAddUserPage();
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.add,
                                color: AppColors.accent,
                                size: 26,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 10,
                                ),
                                child: Text(
                                  'Добавить участника',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Divider(),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 10, left: 20, bottom: 20, right: 20),
                        child: Text(
                          'Только организатор может вносить изменения в расписание поездки и добавлять новые забронированные места и впечатления',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      showAlertDialog(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'Удалить поездку',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showTripModalSheet() async {
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
            height: 400,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Добавить план',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 60,
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        goToBookedObjects();
                      },
                      child: const Text(
                        "Забронированные",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 60,
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        goToAddMyPlan();
                      },
                      child: const Text(
                        "Личный план",
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
      },
    );
  }

  void goToBookedObjects() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BookedPlansPage(widget.travel.id!)));

    getTravelPlans();
  }

  void goToAddMyPlan() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddNewPlanPage(widget.travel.id!)));

    getTravelPlans();
  }

  void goToMyPlanDetail(TravelPlanModel plan) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyPlanDetailPage(plan)));

    getTravelPlans();
  }

  void goToAddUserPage() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddUserToTravelPage(widget.travel.id!)));

    getTravelUsers();
  }

  void deletePlanFromTravel(int planId) async {
    var response = await TravelProvider().deletePlan(planId);
    if (response['response_status'] == 'ok') {
      getTravelPlans();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  showAlertDialogForDeletingPlan(BuildContext context, int planId) {
    Widget okButton = TextButton(
      child: Text("Да"),
      onPressed: () {
        deletePlanFromTravel(planId);
      },
    );
    Widget cancelButton = TextButton(
      child: Text("Отмена"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Внимание"),
      content: Text("Вы точно хотите удалить?"),
      actions: [
        okButton,
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Отмена"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Да"),
      onPressed: () {
        deleteTravel();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Внимание"),
      content: const Text("Вы точно хотите удалить поездку?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void deleteTravel() async {
    var response = await TravelProvider().deleteTravel(widget.travel.id!);
    if (response['response_status'] == 'ok') {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void getTravelPlans() async {
    thisTravelPlans = [];
    _markers = {};
    _polylines = {};
    mapPoints = [];
    lenOfRoadLine = 0;

    var response = await TravelProvider().getTravelPlans(widget.travel.id!);
    if (response['response_status'] == 'ok') {
      for (var object in response['data']) {
        TravelPlanModel planObject = TravelPlanModel.fromJson(object);
        thisTravelPlans.add(planObject);
        if (planObject.type == 1) {
          lenOfRoadLine += 5;
        } else {
          lenOfRoadLine += 9;
        }

        final Uint8List customMarker =
            await getBytesFromAsset('assets/icons/map_pin.png', 150);

        LatLng thisPoint = LatLng(
            double.parse(
                (planObject.lat != 'null' ? planObject.lat : '43.236431') ??
                    '43.236431'),
            double.parse(
                (planObject.lng != 'null' ? planObject.lng : '43.236431') ??
                    '76.917994'));

        mapPoints.add(thisPoint);

        _markers.add(Marker(
          markerId: MarkerId('point-${planObject.id!}'),
          position: thisPoint,
          infoWindow: InfoWindow(
            title: planObject.name,
          ),
          icon: BitmapDescriptor.fromBytes(customMarker),
        ));
      }

      if (_markers.isNotEmpty) {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('1'),
            points: mapPoints,
            color: AppColors.accent,
            width: 2,
            patterns: [PatternItem.dash(10), PatternItem.gap(20)],
          ),
        );

        CameraPosition startLocation = CameraPosition(
          target: _markers.first.position,
          zoom: 10,
        );

        _mapController
            .animateCamera(CameraUpdate.newCameraPosition(startLocation));
      }

      setState(() {});
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['data']['message'],
              style: const TextStyle(fontSize: 14)),
        ));
      }
    }
  }

  void getTravelUsers() async {
    userList = [];
    var response = await TravelProvider().getTravelUsers(widget.travel.id!);
    if (response['response_status'] == 'ok') {
      for (var object in response['data']) {
        userList.add(User.fromJson(object));
      }

      setState(() {});
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['data']['message'],
              style: const TextStyle(fontSize: 14)),
        ));
      }
    }
  }
}
