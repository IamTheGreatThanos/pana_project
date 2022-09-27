import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/const.dart';
import '../views/other/stories_view.dart';

class StoriesCard extends StatefulWidget {
  StoriesCard(this.index);
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
              builder: (context) => StoriesView(widget.index)));
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          child: Stack(
            children: [
              Container(
                width: 85,
                height: 150,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.fitHeight,
                  imageUrl:
                      'https://images.unsplash.com/photo-1541963463532-d68292c34b19?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8&w=1000&q=80',
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
                    const SizedBox(
                      width: 45,
                      child: Text(
                        '1 453',
                        style: TextStyle(
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
