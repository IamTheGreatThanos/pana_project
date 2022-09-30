import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/utils/const.dart';

class AudioReviewCard extends StatefulWidget {
  // AudioReviewCard(this.product);
  // final Product product;

  @override
  _AudioReviewCardState createState() => _AudioReviewCardState();
}

class _AudioReviewCardState extends State<AudioReviewCard> {
  double audioReviewWidth = 0.0;
  bool playingState = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 82,
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  width: audioReviewWidth,
                  height: 82,
                  color: AppColors.grey,
                ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            border: Border.all(width: 1, color: AppColors.grey),
          ),
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=2000',
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: const Text(
                      'Dinmukhammed Muslim',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: SizedBox(
                          width: 12,
                          height: 12,
                          child: SvgPicture.asset('assets/icons/star.svg'),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          '4.9',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
              )
            ],
          ),
        ),
      ],
    );
  }

  void playAudioReview() async {
    setState(() {
      audioReviewWidth = 200;
      playingState = !playingState;
    });
  }
}
