import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/facilities_widget.dart';
import 'package:pana_project/models/roomCard.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/other/media_detail_page.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class RoomInfoPage extends StatefulWidget {
  const RoomInfoPage(this.room);
  final RoomCardModel room;

  @override
  _RoomInfoPageState createState() => _RoomInfoPageState();
}

class _RoomInfoPageState extends State<RoomInfoPage> {
  final storyController = StoryController();

  List<StoryItem?> thisStoryItems = [];
  List<StoryItem?> mediaStoryItems = [];

  @override
  void initState() {
    makeMedia();
    super.initState();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  void makeMedia() {
    for (int i = 0; i < widget.room.images!.length; i++) {
      thisStoryItems.add(
        StoryItem.pageImage(
          url: widget.room.images![i].path!,
          controller: storyController,
          imageFit: BoxFit.cover,
        ),
      );

      mediaStoryItems.add(
        StoryItem.pageImage(
          url: widget.room.images![i].path!,
          controller: storyController,
          imageFit: BoxFit.fitWidth,
        ),
      );
    }
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: StoryView(
                        storyItems: thisStoryItems,
                        onStoryShow: (s) {},
                        onComplete: () {},
                        progressPosition: ProgressPosition.bottom,
                        repeat: true,
                        controller: storyController,
                        onVerticalSwipeComplete: (direction) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MediaDetailPage(mediaStoryItems)));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                      child: GestureDetector(
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 0,
                                blurRadius: 24,
                                offset:
                                    Offset(0, 4), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child:
                                SvgPicture.asset('assets/icons/back_arrow.svg'),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    widget.room?.name ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/bed_icon.svg'),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          '${widget.room.roomType?.name ?? ''}, king size',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/size_icon.svg'),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Номер ${widget.room.size ?? 0} кв. м.',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Text(
                    'Описание',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      widget.room.description ?? '',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45),
                    ),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Text(
                    'Удобства',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 10),
                  child: Wrap(
                    children: [
                      for (int k = 0; k < widget.room.comforts!.length; k++)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FacilitiesWidget(
                                title: widget.room.comforts![k].name ?? ''),
                            const SizedBox(width: 10),
                          ],
                        ),
                    ],
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Text(
                    'Правила отмены',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: const Text(
                      'Отклонение проецирует суммарный поворот. Гировертикаль, в силу третьего закона Ньютона, даёт большую проекцию на оси, чем тангаж. Ротор безусловно заставляет иначе взглянуть на то, что такое уходящий ньютонометр, сводя задачу к квадратурам.',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45),
                    ),
                  ),
                ),
                const Divider(),
                // Padding(
                //   padding:
                //       const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                //   child: Row(
                //     children: [
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Row(
                //             children: [
                //               Text(
                //                 'от \$${widget.room.basePrice}',
                //                 style: const TextStyle(
                //                     fontWeight: FontWeight.w500,
                //                     fontSize: 18,
                //                     color: AppColors.black),
                //               ),
                //               const Text(
                //                 ' за сутки',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.w500,
                //                     fontSize: 14,
                //                     color: Colors.black45),
                //               ),
                //             ],
                //           ),
                //           const SizedBox(height: 10),
                //           const Text(
                //             '12-14 июля',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.w500,
                //                 fontSize: 14,
                //                 color: AppColors.black,
                //                 decoration: TextDecoration.underline),
                //           ),
                //         ],
                //       ),
                //       const Spacer(),
                //       SizedBox(
                //         height: 48,
                //         width: 150,
                //         child: ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //             primary: AppColors.accent,
                //             shape: RoundedRectangleBorder(
                //               borderRadius:
                //                   BorderRadius.circular(10), // <-- Radius
                //             ),
                //           ),
                //           onPressed: () {
                //             Navigator.of(context).pop();
                //           },
                //           child: const Text(
                //             "Забронировать",
                //             style: TextStyle(
                //                 fontSize: 14, fontWeight: FontWeight.w500),
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
