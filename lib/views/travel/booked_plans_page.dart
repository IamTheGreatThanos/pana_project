import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/booked_housing_card.dart';
import 'package:pana_project/components/booked_impression_card.dart';
import 'package:pana_project/models/order.dart';
import 'package:pana_project/services/travel_api_provider.dart';
import 'package:pana_project/utils/const.dart';

class BookedPlansPage extends StatefulWidget {
  BookedPlansPage(this.travelId);
  final int travelId;

  @override
  _BookedPlansPageState createState() => _BookedPlansPageState();
}

class _BookedPlansPageState extends State<BookedPlansPage> {
  List<Order> housingList = [];
  List<Order> impressionList = [];

  @override
  void initState() {
    getHousingList();
    getImpressionList();
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
      child: DefaultTabController(
        length: 2,
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
                              child: SvgPicture.asset(
                                  'assets/icons/back_arrow.svg'),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Забронированное',
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
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: TabBar(
                        isScrollable: true,
                        indicatorColor: AppColors.accent,
                        labelColor: AppColors.black,
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        unselectedLabelColor: AppColors.blackWithOpacity,
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: [
                          Tab(
                            text: 'Жилье',
                          ),
                          Tab(
                            text: 'Впечатления',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: AppColors.lightGray,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 120,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 120,
                          child: TabBarView(
                            children: [
                              // TODO: Жилье
                              ListView(
                                children: [
                                  for (int i = 0; i < housingList.length; i++)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: BookedHousingCard(
                                          housingList[i].housing!,
                                          widget.travelId),
                                    )
                                ],
                              ),
                              // TODO: Впечатления
                              ListView(
                                children: [
                                  for (int i = 0;
                                      i < impressionList.length;
                                      i++)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: BookedImpressionCard(
                                          impressionList[i].impression!,
                                          widget.travelId),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getHousingList() async {
    housingList = [];
    var response = await TravelProvider().getBookedHousing();
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        housingList.add(Order.fromJson(response['data'][i]));
      }
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

  void getImpressionList() async {
    impressionList = [];
    var response = await TravelProvider().getBookedImpression();
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        impressionList.add(Order.fromJson(response['data'][i]));
      }
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
}
