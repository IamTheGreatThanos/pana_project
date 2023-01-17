import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/models/roomCard.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/housing/room_info.dart';

class RoomCard extends StatefulWidget {
  RoomCard(this.room);
  final RoomCardModel room;

  @override
  _RoomCardState createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  final CarouselController _controller = CarouselController();
  int _current = 0;
  int count = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RoomInfoPage(widget.room)));
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppConstants.cardBorderRadius),
              color: AppColors.white),
          // height: 380,
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
                          height: 270,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              height: 270,
                              aspectRatio: 16 / 10,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: false,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              },
                              scrollDirection: Axis.horizontal,
                            ),
                            itemCount: widget.room.images?.length ?? 0,
                            itemBuilder: (BuildContext context, int itemIndex,
                                    int pageViewIndex) =>
                                SizedBox(
                              width: double.infinity,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: widget.room.images![itemIndex].path!,
                                placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: CircularProgressIndicator(
                                          color: AppColors.grey,
                                        ))),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 240),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: widget.room.images!
                                .asMap()
                                .entries
                                .map((entry) {
                              return GestureDetector(
                                onTap: () =>
                                    _controller.animateToPage(entry.key),
                                child: Container(
                                  width: _current == entry.key ? 24 : 12,
                                  height: 4,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                      color: (Colors.white).withOpacity(
                                          _current == entry.key ? 0.9 : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        widget.room.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
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
                          child: SvgPicture.asset('assets/icons/bed_icon.svg')),
                    ),
                    Text(
                      widget.room.description ?? '',
                      style: const TextStyle(
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
                  children: [
                    Text(
                      '\$${widget.room.basePrice}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.black),
                    ),
                    const Text(
                      ' за сутки',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black45),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Выберите количество',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: minusFunction,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 1.0,
                            ),
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        child: const Icon(Icons.remove),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: plusFunction,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 1.0,
                            ),
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                //   child: SizedBox(
                //     height: 48,
                //     child: ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         primary: GlobalVariables()
                //                 .selectedRoomIds
                //                 .contains(widget.room.id)
                //             ? AppColors.accent
                //             : AppColors.grey,
                //         minimumSize: const Size.fromHeight(50),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //       ),
                //       onPressed: () {
                //         widget.selectionFunc;
                //       },
                //       child: Text(
                //         "Выбрать этот номер",
                //         style: TextStyle(
                //             fontSize: 14,
                //             fontWeight: FontWeight.w500,
                //             color: GlobalVariables()
                //                     .selectedRoomIds
                //                     .contains(widget.room.id)
                //                 ? AppColors.white
                //                 : AppColors.blackWithOpacity),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          )),
    );
  }

  void plusFunction() {
    setState(() {
      count += 1;
    });
  }

  void minusFunction() {
    setState(() {
      if (count > 1) {
        count -= 1;
      }
    });
  }
}
