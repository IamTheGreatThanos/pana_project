import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/housing_card.dart';
import 'package:pana_project/components/impression_card.dart';
import 'package:pana_project/models/selections.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/housing/housing_info.dart';
import 'package:pana_project/views/impression/impression_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class SelectionsPage extends StatefulWidget {
  SelectionsPage(this.selections);
  final Selections selections;
  @override
  _SelectionsPageState createState() => _SelectionsPageState();
}

class _SelectionsPageState extends State<SelectionsPage> {
  bool loadingHousing = true;
  bool loadingImpression = true;

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
                            'Подборка',
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
                    color: AppColors.lightGray,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 120,
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height - 120,
                            child: ListView(
                              children: [
                                for (int i = 0;
                                    i < widget.selections.items!.length;
                                    i++)
                                  widget.selections.items![i].type == 'housing'
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: GestureDetector(
                                            onTap: () async {
                                              StoryController _storyController =
                                                  StoryController();
                                              List<StoryItem?> thisStoryItems =
                                                  [];
                                              List<StoryItem?> mediaStoryItems =
                                                  [];

                                              // for (int j = 0;
                                              //     j <
                                              //         housingList[i]
                                              //             .videos!
                                              //             .length;
                                              //     j++) {
                                              //   thisStoryItems.add(
                                              //     StoryItem.pageVideo(
                                              //       housingList[i]
                                              //           .videos![j]
                                              //           .path!,
                                              //       controller:
                                              //           _storyController,
                                              //       imageFit: BoxFit.cover,
                                              //     ),
                                              //   );
                                              //
                                              //   mediaStoryItems.add(
                                              //     StoryItem.pageVideo(
                                              //       housingList[i]
                                              //           .videos![j]
                                              //           .path!,
                                              //       controller:
                                              //           _storyController,
                                              //       imageFit: BoxFit.fitWidth,
                                              //     ),
                                              //   );
                                              // }

                                              for (int j = 0;
                                                  j <
                                                      widget
                                                          .selections
                                                          .items![i]
                                                          .housing!
                                                          .images!
                                                          .length;
                                                  j++) {
                                                thisStoryItems.add(
                                                  StoryItem.pageImage(
                                                    url: widget
                                                        .selections
                                                        .items![i]
                                                        .housing!
                                                        .images![j]
                                                        .path!,
                                                    controller:
                                                        _storyController,
                                                    imageFit: BoxFit.cover,
                                                  ),
                                                );

                                                mediaStoryItems.add(
                                                  StoryItem.pageImage(
                                                    url: widget
                                                        .selections
                                                        .items![i]
                                                        .housing!
                                                        .images![j]
                                                        .path!,
                                                    controller:
                                                        _storyController,
                                                    imageFit: BoxFit.fitWidth,
                                                  ),
                                                );
                                              }

                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();

                                              String? lat =
                                                  prefs.getString('lastLat');
                                              String? lng =
                                                  prefs.getString('lastLng');

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      HousingInfo(
                                                    widget.selections.items![i]
                                                        .housing!.id!,
                                                    thisStoryItems,
                                                    mediaStoryItems,
                                                    lat ?? '',
                                                    lng ?? '',
                                                    // widget.selections.items![i]
                                                    //     .housing!.distance
                                                    //     .toString(),
                                                    '',
                                                    '',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: HousingCard(
                                                widget.selections.items![i]
                                                    .housing!,
                                                () {}),
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
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
                                                        widget
                                                            .selections
                                                            .items![i]
                                                            .impression!
                                                            .videos!
                                                            .length;
                                                    j++) {
                                                  thisStoryItems.add(
                                                    StoryItem.pageVideo(
                                                      widget
                                                          .selections
                                                          .items![i]
                                                          .impression!
                                                          .videos![j]
                                                          .path!,
                                                      controller:
                                                          _storyController,
                                                      imageFit: BoxFit.cover,
                                                    ),
                                                  );

                                                  mediaStoryItems.add(
                                                    StoryItem.pageVideo(
                                                      widget
                                                          .selections
                                                          .items![i]
                                                          .impression!
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
                                                        widget
                                                            .selections
                                                            .items![i]
                                                            .impression!
                                                            .images!
                                                            .length;
                                                    j++) {
                                                  thisStoryItems.add(
                                                    StoryItem.pageImage(
                                                      url: widget
                                                          .selections
                                                          .items![i]
                                                          .impression!
                                                          .images![j]
                                                          .path!,
                                                      controller:
                                                          _storyController,
                                                      imageFit: BoxFit.cover,
                                                    ),
                                                  );

                                                  mediaStoryItems.add(
                                                    StoryItem.pageImage(
                                                      url: widget
                                                          .selections
                                                          .items![i]
                                                          .impression!
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
                                                        ImpressionInfo(
                                                      widget
                                                          .selections
                                                          .items![i]
                                                          .impression!,
                                                      thisStoryItems,
                                                      mediaStoryItems,
                                                    ),
                                                  ),
                                                );

                                                setState(() {});
                                              },
                                              child: ImpressionCard(
                                                  widget.selections.items![i]
                                                      .impression!,
                                                  () {})),
                                        )
                              ],
                            )),
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
}
