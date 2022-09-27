import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/housing/housing_info.dart';

class HousingCard extends StatefulWidget {
  @override
  _HousingCardState createState() => _HousingCardState();
}

class _HousingCardState extends State<HousingCard> {
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
          height: 330,
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
                                'https://images.unsplash.com/photo-1568605114967-8130f3a36994?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80',
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
                    Text(
                      'Almaty, Kazakhstan',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Spacer(),
                    Text(
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
                  '324 км от вас',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black45),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: const [
                    Text(
                      '\$324',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.black),
                    ),
                    Text(
                      ' за ночь',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black45),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
