import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pana_project/models/reels.dart';

import '../utils/const.dart';
import '../views/other/stories_view.dart';

class StoriesCard extends StatefulWidget {
  StoriesCard(this.reels, this.index);
  final List<Reels> reels;
  final int index;

  @override
  _StoriesCardState createState() => _StoriesCardState();
}

class _StoriesCardState extends State<StoriesCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => StoriesView(widget.reels, widget.index)));
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          child: Stack(
            children: [
              Container(
                width: 85,
                height: 153,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.reels[widget.index].thumbnail ?? '',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 125, left: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: SvgPicture.asset('assets/icons/play.svg'),
                    ),
                    SizedBox(
                      width: 45,
                      child: Text(
                        (widget.reels[widget.index].showCount ?? 0).toString(),
                        style: const TextStyle(
                          color: AppColors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
