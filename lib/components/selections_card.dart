import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pana_project/models/images.dart';
import 'package:pana_project/models/selections.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/auth/auth_page.dart';
import 'package:pana_project/views/other/selections_page.dart';

class SelectionsCard extends StatefulWidget {
  SelectionsCard(this.selections, this.selectionsImage, this.isLoggedIn);
  final Selections selections;
  final List<Images> selectionsImage;
  final bool isLoggedIn;

  @override
  _SelectionsCardState createState() => _SelectionsCardState();
}

class _SelectionsCardState extends State<SelectionsCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          color: AppColors.white),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Text(
              "Подборка",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.blackWithOpacity,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.selections.title ?? '',
              style: const TextStyle(
                fontSize: 24,
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              height: 270,
              width: MediaQuery.of(context).size.width,
              child: widget.selectionsImage.isNotEmpty
                  ? CarouselSlider.builder(
                      options: CarouselOptions(
                        height: 270,
                        viewportFraction: 0.85,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {},
                        scrollDirection: Axis.horizontal,
                      ),
                      itemCount: widget.selectionsImage.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          SizedBox(
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.selectionsImage[itemIndex].path!,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator(
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: AppColors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2, color: AppColors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (widget.isLoggedIn == true) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SelectionsPage(widget.selections)));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AuthPage()));
                  }
                },
                child: const Text(
                  "Смотреть подборку",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}
