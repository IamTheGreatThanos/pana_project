import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/models/audioReview.dart';
import 'package:pana_project/utils/const.dart';

class AudioReviewDetailPage extends StatefulWidget {
  AudioReviewDetailPage(this.review);
  final AudioReviewModel review;

  @override
  _AudioReviewDetailPageState createState() => _AudioReviewDetailPageState();
}

class _AudioReviewDetailPageState extends State<AudioReviewDetailPage> {
  final audioPlayer = AudioPlayer();
  Duration duration = const Duration(seconds: 1);
  Duration position = const Duration(seconds: 1);
  bool playingState = false;

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        playingState = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
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
              children: [
                Container(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: Row(
                      children: [
                        GestureDetector(
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
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                  'assets/icons/back_arrow.svg'),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            const Text(
                              'Отзыв',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.review.createdAt ?? '',
                              style: const TextStyle(
                                color: AppColors.blackWithOpacity,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight:
                            Radius.circular(AppConstants.cardBorderRadius),
                        topLeft:
                            Radius.circular(AppConstants.cardBorderRadius)),
                    color: AppColors.white,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: Column(
                    children: [
                      widget.review.answers?.isNotEmpty ?? false
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        child: SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: CachedNetworkImage(
                                            imageUrl: widget.review.answers?[0]
                                                    .user?.avatar ??
                                                '',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                '${widget.review.answers?[0].user?.name ?? ''} ${widget.review.answers?[0].user?.surname ?? ''}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Text(
                                                  'Ответ от владельца',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.accent,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  widget.review.answers?[0]
                                                          .updatedAt
                                                          ?.substring(0, 10) ??
                                                      '',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors
                                                        .blackWithOpacity,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 20, right: 20),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height *
                                        0.45,
                                    child: Text(
                                      widget.review.answers?[0].description ??
                                          '',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(
                              // height: MediaQuery.of(context).size.height * 0.6,
                              child: Column(
                                children: [
                                  const SizedBox(height: 30),
                                  SvgPicture.asset(
                                      'assets/images/review_no_answer.svg'),
                                  const Padding(
                                    padding: EdgeInsets.all(30),
                                    child: Text(
                                      'Мы еще не получили ответ от владельца',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                      Spacer(),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                playAudioReview();
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: AppColors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40))),
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: !playingState
                                        ? SvgPicture.asset(
                                            'assets/icons/play_audio.svg',
                                            color: AppColors.white,
                                          )
                                        : SvgPicture.asset(
                                            'assets/icons/pause_audio.svg',
                                            color: AppColors.white,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.68,
                                    height: 65,
                                    child: TweenAnimationBuilder<double>(
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeInOut,
                                      tween: Tween<double>(
                                        begin: 0,
                                        end: position.inSeconds == 1 &&
                                                duration.inSeconds == 1
                                            ? 0.0
                                            : position.inSeconds.toDouble() /
                                                duration.inSeconds.toDouble(),
                                      ),
                                      builder: (context, value, _) =>
                                          LinearProgressIndicator(
                                        value: value,
                                        color: AppColors.blackWithOpacity,
                                        backgroundColor: AppColors.lightGray,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 65,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 20),
                                      Text(
                                        '00:${(position.inSeconds == 1 && duration.inSeconds == 1) ? '00' : position.inSeconds > 9 ? position.inSeconds.toString() : '0' + position.inSeconds.toString()}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        ' / 00:${(position.inSeconds == 1 && duration.inSeconds == 1) ? '00' : duration.inSeconds > 9 ? duration.inSeconds.toString() : '0' + duration.inSeconds.toString()}',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
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

  void playAudioReview() async {
    if (playingState) {
      await audioPlayer.pause();
      setState(() {
        playingState = !playingState;
      });
    } else {
      UrlSource url = UrlSource(widget.review.audio ?? '');
      await audioPlayer.play(url);
      setState(() {
        playingState = !playingState;
      });
    }
  }
}
