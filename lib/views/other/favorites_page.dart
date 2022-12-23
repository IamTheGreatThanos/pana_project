import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/housing_card.dart';
import 'package:pana_project/components/impression_card.dart';
import 'package:pana_project/models/housingCard.dart';
import 'package:pana_project/models/impressionCard.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/housing/housing_info.dart';
import 'package:pana_project/views/impression/impression_info.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<HousingCardModel> housingList = [];
  List<ImpressionCardModel> impressionList = [];

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
                            'Избранное',
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
                              housingList.isNotEmpty
                                  ? ListView(
                                      children: [
                                        for (int i = 0;
                                            i < housingList.length;
                                            i++)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: GestureDetector(
                                              onTap: () async {
                                                StoryController
                                                    _storyController =
                                                    StoryController();
                                                List<StoryItem?>
                                                    thisStoryItems = [];
                                                List<StoryItem?>
                                                    mediaStoryItems = [];

                                                for (int j = 0;
                                                    j <
                                                        housingList[i]
                                                            .videos!
                                                            .length;
                                                    j++) {
                                                  thisStoryItems.add(
                                                    StoryItem.pageVideo(
                                                      housingList[i]
                                                          .videos![j]
                                                          .path!,
                                                      controller:
                                                          _storyController,
                                                      imageFit: BoxFit.cover,
                                                    ),
                                                  );

                                                  mediaStoryItems.add(
                                                    StoryItem.pageVideo(
                                                      housingList[i]
                                                          .videos![j]
                                                          .path!,
                                                      controller:
                                                          _storyController,
                                                      imageFit: BoxFit.fitWidth,
                                                    ),
                                                  );
                                                }

                                                for (int j = 0;
                                                    j <
                                                        housingList[i]
                                                            .images!
                                                            .length;
                                                    j++) {
                                                  thisStoryItems.add(
                                                    StoryItem.pageImage(
                                                      url: housingList[i]
                                                          .images![j]
                                                          .path!,
                                                      controller:
                                                          _storyController,
                                                      imageFit: BoxFit.cover,
                                                    ),
                                                  );

                                                  mediaStoryItems.add(
                                                    StoryItem.pageImage(
                                                      url: housingList[i]
                                                          .images![j]
                                                          .path!,
                                                      controller:
                                                          _storyController,
                                                      imageFit: BoxFit.fitWidth,
                                                    ),
                                                  );
                                                }

                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HousingInfo(
                                                                housingList[i]
                                                                    .id!,
                                                                thisStoryItems,
                                                                mediaStoryItems)));

                                                getHousingList();
                                              },
                                              child: HousingCard(housingList[i],
                                                  getHousingList),
                                            ),
                                          )
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        const SizedBox(height: 150),
                                        SvgPicture.asset(
                                            'assets/images/favorites_empty.svg'),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: const Text(
                                            'У вас пока нет избранного жилья',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                              // TODO: Впечатления
                              impressionList.isNotEmpty
                                  ? ListView(
                                      children: [
                                        for (int i = 0;
                                            i < impressionList.length;
                                            i++)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: GestureDetector(
                                                onTap: () async {
                                                  StoryController
                                                      _storyController =
                                                      StoryController();
                                                  List<StoryItem?>
                                                      thisStoryItems = [];
                                                  List<StoryItem?>
                                                      mediaStoryItems = [];

                                                  for (int j = 0;
                                                      j <
                                                          impressionList[i]
                                                              .videos!
                                                              .length;
                                                      j++) {
                                                    thisStoryItems.add(
                                                      StoryItem.pageVideo(
                                                        impressionList[i]
                                                            .videos![j]
                                                            .path!,
                                                        controller:
                                                            _storyController,
                                                        imageFit: BoxFit.cover,
                                                      ),
                                                    );

                                                    mediaStoryItems.add(
                                                      StoryItem.pageVideo(
                                                        impressionList[i]
                                                            .videos![j]
                                                            .path!,
                                                        controller:
                                                            _storyController,
                                                        imageFit:
                                                            BoxFit.fitWidth,
                                                      ),
                                                    );
                                                  }

                                                  for (int j = 0;
                                                      j <
                                                          impressionList[i]
                                                              .images!
                                                              .length;
                                                      j++) {
                                                    thisStoryItems.add(
                                                      StoryItem.pageImage(
                                                        url: impressionList[i]
                                                            .images![j]
                                                            .path!,
                                                        controller:
                                                            _storyController,
                                                        imageFit: BoxFit.cover,
                                                      ),
                                                    );

                                                    mediaStoryItems.add(
                                                      StoryItem.pageImage(
                                                        url: impressionList[i]
                                                            .images![j]
                                                            .path!,
                                                        controller:
                                                            _storyController,
                                                        imageFit:
                                                            BoxFit.fitWidth,
                                                      ),
                                                    );
                                                  }

                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ImpressionInfo(
                                                        impressionList[i],
                                                        thisStoryItems,
                                                        mediaStoryItems,
                                                      ),
                                                    ),
                                                  );

                                                  setState(() {});
                                                },
                                                child: ImpressionCard(
                                                    impressionList[i], () {})),
                                          )
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        const SizedBox(height: 150),
                                        SvgPicture.asset(
                                            'assets/images/favorites_empty.svg'),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: const Text(
                                            'У вас пока нет избранных впечатлений',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
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
    var response = await MainProvider().getFavoritesHousing();
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        housingList.add(HousingCardModel.fromJson(response['data'][i]));
      }
      if (mounted) {
        setState(() {});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(response['message'], style: const TextStyle(fontSize: 20)),
      ));
    }
  }

  void getImpressionList() async {
    impressionList = [];
    var response = await MainProvider().getFavoritesImpression();
    if (response['response_status'] == 'ok') {
      for (int i = 0; i < response['data'].length; i++) {
        impressionList.add(ImpressionCardModel.fromJson(response['data'][i]));
      }
      if (mounted) {
        setState(() {});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(response['message'], style: const TextStyle(fontSize: 20)),
      ));
    }
  }
}
