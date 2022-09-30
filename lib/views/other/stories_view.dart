import 'dart:ui';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/utils/const.dart';

class StoriesView extends StatefulWidget {
  StoriesView(this.index);
  final int index;

  @override
  _StoriesViewState createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  PageController pageController = PageController(initialPage: 0);
  late CachedVideoPlayerController videoController;

  int currentPageIndex = 0;

  List<CachedVideoPlayerController> videoControllers = [];
  List<String> videoUrls = [
    "https://scontent.cdninstagram.com/v/t50.2886-16/239303370_5868719483202497_3491967174967662953_n.mp4?efg=eyJ2ZW5jb2RlX3RhZyI6InZ0c192b2RfdXJsZ2VuLjcyMC5jbGlwcy5iYXNlbGluZSIsInFlX2dyb3VwcyI6IltcImlnX3dlYl9kZWxpdmVyeV92dHNfb3RmXCJdIn0&_nc_ht=scontent.cdninstagram.com&_nc_cat=105&_nc_ohc=zBnr3oBV47UAX9ITK4l&edm=AJBgZrYBAAAA&vs=400042941454379_2934785748&_nc_vs=HBksFQAYJEdNcDZRdzdCS3hXOGtka1VBR21aUmZlazlYVXdicV9FQUFBRhUAAsgBABUAGCRHSTN2TVE2UWJhUUZ2enNEQUwzSDM2cGtxVnQ4YnFfRUFBQUYVAgLIAQAoABgAGwAVAAAmyOCz4qLHxD8VAigCQzMsF0A83bItDlYEGBJkYXNoX2Jhc2VsaW5lXzNfdjERAHX%2BBwA%3D&_nc_rid=db2782cd7c&ccb=7-5&oe=63395699&oh=00_AT-uVCEdWBQsgTsxH-cd5KkTgvDD0_fb32w7A-wztJivgQ&_nc_sid=78c662",
    "https://scontent.cdninstagram.com/v/t50.2886-16/237704459_198415025528850_2757140387289014942_n.mp4?efg=eyJ2ZW5jb2RlX3RhZyI6InZ0c192b2RfdXJsZ2VuLjcyMC5jbGlwcy5kZWZhdWx0IiwicWVfZ3JvdXBzIjoiW1wiaWdfd2ViX2RlbGl2ZXJ5X3Z0c19vdGZcIl0ifQ&_nc_ht=scontent.cdninstagram.com&_nc_cat=106&_nc_ohc=jSAyXmTEtYwAX_04shG&edm=AJBgZrYBAAAA&vs=18125081635224389_2714619951&_nc_vs=HBksFQAYJEdBc1ZLdzRTWUIwWmRiUUFBSjZpUGdTVFZFTW1icV9FQUFBRhUAAsgBABUAGCRHSzRSSUE2TGNiRGl3bm9BQUUxek9GcG9TWkpTYnFfRUFBQUYVAgLIAQAoABgAGwAVAAAm0pb8xNLB1z8VAigCQzMsF0AjzMzMzMzNGBJkYXNoX2Jhc2VsaW5lXzFfdjERAHX%2BBwA%3D&_nc_rid=587e43c070&ccb=7-5&oe=63397529&oh=00_AT9K1YK5MSSYsZPt5S9GRxsWbI8xBmkKqqBxSnhqQx5m2w&_nc_sid=78c662",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4",
  ];

  @override
  void initState() {
    for (int i = 0; i < videoUrls.length; i++) {
      videoController = CachedVideoPlayerController.network(videoUrls[i]);
      videoController.initialize().then((value) {
        setState(() {});
      });
      videoController.setLooping(true);
      videoControllers.add(videoController);
    }

    videoControllers[0].play();

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
                                    const Text(
                                      'Almaty, Kazakhstan',
                                      style: TextStyle(
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
                                        const SizedBox(
                                          width: 45,
                                          child: Text(
                                            '1 453',
                                            style: TextStyle(
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
                                              const SizedBox(
                                                width: 104,
                                                child: Text(
                                                  'Категория: Отели',
                                                  style: TextStyle(
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
                                    const SizedBox(
                                      height: 50,
                                      child: Text(
                                        'Отклонение проецирует суммарный поворот. Гировертикаль, в силу третьего закона Ньютона, даёт большую проекцию на оси, чем тангаж. Ротор безусловно заставляет иначе взглянуть на то, что такое уходящий ньютонометр, сводя задачу к квадратурам.',
                                        style: TextStyle(
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
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: SvgPicture.asset(
                                        "assets/icons/heart_empty.svg",
                                        color: Colors.white,
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
}
