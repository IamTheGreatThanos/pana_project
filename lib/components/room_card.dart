import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/utils/const.dart';

class RoomCard extends StatefulWidget {
  // RoomCard(this.housing);
  // final RoomCardModel housing;

  @override
  _RoomCardState createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => HousingInfo(widget.housing)));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(AppConstants.cardBorderRadius),
                color: AppColors.white),
            height: 380,
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
                      child: SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: CachedNetworkImage(
                          fit: BoxFit.fitWidth,
                          imageUrl:
                              // widget.housing.images != null
                              //     ? widget.housing.images![0].path!
                              //     :
                              "https://roadmap-tech.com/wp-content/uploads/2019/04/placeholder-image.jpg",
                        ),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        // '${widget.housing.city!.name}, ${widget.housing.country!.name}',
                        'Superior Twin',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      Spacer(),
                      Text(
                        '12-14 июля',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: SizedBox(
                            width: 24,
                            height: 24,
                            child:
                                SvgPicture.asset('assets/icons/bed_icon.svg')),
                      ),
                      Text(
                        '1 кровать на 2 места',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black45),
                      ),
                    ],
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
                        ' за сутки',
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
      ),
    );
  }
}
