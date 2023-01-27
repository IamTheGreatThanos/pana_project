import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/models/audioReview.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/other/audio_review_detail_page.dart';

class AudioReviewCard extends StatefulWidget {
  AudioReviewCard(this.review);
  final AudioReviewModel review;

  @override
  _AudioReviewCardState createState() => _AudioReviewCardState();
}

class _AudioReviewCardState extends State<AudioReviewCard> {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AudioReviewDetailPage(widget.review)));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            color: AppColors.white),
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: CachedNetworkImage(
                        imageUrl: widget.review.user?.avatar ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Text(
                          '${widget.review.user?.name ?? ''} ${widget.review.user?.surname ?? ''}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Text(
                          'Опубликовано: ${widget.review.createdAt ?? ''}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      playAudioReview();
                    },
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: !playingState
                          ? SvgPicture.asset('assets/icons/play_audio.svg')
                          : SvgPicture.asset('assets/icons/pause_audio.svg'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: 12,
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        tween: Tween<double>(
                          begin: 0,
                          end: position.inSeconds.toDouble() /
                              duration.inSeconds.toDouble(),
                        ),
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: position.inSeconds.toDouble() /
                              duration.inSeconds.toDouble(),
                          color: AppColors.blackWithOpacity,
                          backgroundColor: AppColors.lightGray,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 20),
                Text(
                  '00:${position.inSeconds > 9 ? position.inSeconds.toString() : '0' + position.inSeconds.toString()}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' / 00:${duration.inSeconds > 9 ? duration.inSeconds.toString() : '0' + duration.inSeconds.toString()}',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
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
