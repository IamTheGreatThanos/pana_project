import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/housing/housing_info.dart';

class ImpressionCard extends StatefulWidget {
  @override
  _ImpressionCardState createState() => _ImpressionCardState();
}

class _ImpressionCardState extends State<ImpressionCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HousingInfo()));
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppConstants.cardBorderRadius),
              color: AppColors.white),
          // height: 330,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppConstants.cardBorderRadius),
                    ),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: CachedNetworkImage(
                            fit: BoxFit.fitWidth,
                            imageUrl:
                                'https://wanderluxe.s3.ap-southeast-1.amazonaws.com/wp-content/uploads/2018/11/14151607/man-yacht-oliver-sjostrom-unsplash.jpg',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 15,
                              left:
                                  MediaQuery.of(context).size.width * 0.9 - 70),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                  'assets/icons/heart_empty_2.svg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Испания',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      '4.9',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2, left: 5),
                      child: SizedBox(
                          width: 15,
                          height: 15,
                          child: SvgPicture.asset('assets/icons/star.svg')),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Прогулка на яхте Merak к “Седлу дьявола”',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: const Text(
                        '4 часа • Включено: Еда, напитки и оборудование',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black45),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: const [
                    Text(
                      '\$85',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.black),
                    ),
                    Text(
                      ' с человека',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black45),
                    ),
                  ],
                ),
                const SizedBox(height: 20)
              ],
            ),
          )),
    );
  }
}
