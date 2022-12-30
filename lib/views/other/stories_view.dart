import 'dart:ui';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/models/reels.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/globalVariables.dart';

class StoriesView extends StatefulWidget {
  StoriesView(this.reels, this.index);
  final List<Reels> reels;
  final int index;

  @override
  _StoriesViewState createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  late PageController pageController;
  late CachedVideoPlayerController videoController;

  int currentPageIndex = 0;

  List<CachedVideoPlayerController> videoControllers = [];

  @override
  void initState() {
    for (int i = 0; i < widget.reels.length; i++) {
      videoController =
          CachedVideoPlayerController.network(widget.reels[i].video ?? '');
      videoController.initialize().then((value) {
        setState(() {});
      });
      videoController.setLooping(true);
      videoControllers.add(videoController);
    }

    pageController = PageController(initialPage: widget.index);

    videoControllers[widget.index].play();

    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < videoControllers.length; i++) {
      videoControllers[i].dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          onReelsChanged(index);
        },
        children: [
          for (int i = 0; i < videoControllers.length; i++)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
              child: Stack(
                children: [
                  Center(
                    child: videoControllers[i].value.isInitialized
                        ? AspectRatio(
                            aspectRatio: videoControllers[i].value.aspectRatio,
                            child: CachedVideoPlayer(videoControllers[i]),
                          )
                        : const CircularProgressIndicator(
                            color: AppColors.grey,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 24,
                                  offset: const Offset(
                                      0, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(7),
                              child: SvgPicture.asset(
                                'assets/icons/back_arrow.svg',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20, left: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.reels[i].city?.name ?? ''}, ${widget.reels[i].city?.country?.name ?? ''}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          decoration: TextDecoration.underline),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 3),
                                          child: SvgPicture.asset(
                                              'assets/icons/play.svg'),
                                        ),
                                        SizedBox(
                                          width: 45,
                                          child: Text(
                                            (widget.reels[i].showCount ?? 0)
                                                .toString(),
                                            style: const TextStyle(
                                              color: AppColors.white,
                                              fontSize: 12,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10.0, sigmaY: 10.0),
                                        child: Container(
                                          width: 170,
                                          height: 36,
                                          decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.16),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4))),
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: SvgPicture.asset(
                                                  'assets/icons/category_1.svg',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                width: 104,
                                                child: Text(
                                                  'Категория: ${widget.reels[i].category?.name ?? ''}',
                                                  style: const TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: 50,
                                      child: Text(
                                        widget.reels[i].category?.description ??
                                            '',
                                        style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 12,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        tapFavoritesButton(i);
                                      },
                                      child: SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: widget.reels[i].housing != null
                                            ? GlobalVariables.favoritesHousing
                                                    .contains(widget
                                                        .reels[i].housing!.id!)
                                                ? SvgPicture.asset(
                                                    'assets/icons/heart_full.svg')
                                                : SvgPicture.asset(
                                                    "assets/icons/heart_empty.svg",
                                                    color: Colors.white,
                                                  )
                                            : GlobalVariables
                                                    .favoritesImpression
                                                    .contains(widget.reels[i]
                                                        .impression!.id!)
                                                ? SvgPicture.asset(
                                                    'assets/icons/heart_full.svg')
                                                : SvgPicture.asset(
                                                    "assets/icons/heart_empty.svg",
                                                    color: Colors.white,
                                                  ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: SvgPicture.asset(
                                        "assets/icons/share.svg",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  void onReelsChanged(int index) async {
    videoControllers[currentPageIndex].pause();
    currentPageIndex = index;
    videoControllers[currentPageIndex].play();
  }

  void tapFavoritesButton(int tappedObjectIndex) async {
    int type = 0;
    if (widget.reels[tappedObjectIndex].housing != null) {
      type = 1;
    }

    if (widget.reels[tappedObjectIndex].impression != null) {
      type = 2;
    }

    if (type == 1) {
      if (GlobalVariables.favoritesHousing
          .contains(widget.reels[tappedObjectIndex].housing!.id!)) {
        var response = await MainProvider()
            .deleteFavorite(widget.reels[tappedObjectIndex].housing!.id!, 1);
        if (response['response_status'] == 'ok') {
          GlobalVariables.favoritesHousing
              .remove(widget.reels[tappedObjectIndex].housing!.id!);
          if (mounted) {
            setState(() {});
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response['data']['message'],
                style: const TextStyle(fontSize: 20)),
          ));
        }
      } else {
        var response = await MainProvider()
            .addToFavorite(widget.reels[tappedObjectIndex].housing!.id!, 1);
        if (response['response_status'] == 'ok') {
          GlobalVariables.favoritesHousing
              .add(widget.reels[tappedObjectIndex].housing!.id!);
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
    } else if (type == 2) {
      if (GlobalVariables.favoritesImpression
          .contains(widget.reels[tappedObjectIndex].impression!.id!)) {
        var response = await MainProvider()
            .deleteFavorite(widget.reels[tappedObjectIndex].impression!.id!, 1);
        if (response['response_status'] == 'ok') {
          GlobalVariables.favoritesImpression
              .remove(widget.reels[tappedObjectIndex].impression!.id!);
          if (mounted) {
            setState(() {});
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response['data']['message'],
                style: const TextStyle(fontSize: 20)),
          ));
        }
      } else {
        var response = await MainProvider()
            .addToFavorite(widget.reels[tappedObjectIndex].impression!.id!, 1);
        if (response['response_status'] == 'ok') {
          GlobalVariables.favoritesImpression
              .add(widget.reels[tappedObjectIndex].impression!.id!);
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
    }
  }
}
