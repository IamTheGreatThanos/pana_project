import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/views/travel/travel_plan_page.dart';

class TravelCard extends StatefulWidget {
  TravelCard(this.title);
  final String title;

  @override
  _TravelCardState createState() => _TravelCardState();
}

class _TravelCardState extends State<TravelCard> {
  @override
  void initState() {
    super.initState();
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TravelPlanePage()));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(24),
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.darken),
                image: const NetworkImage(
                  'https://a.cdn-hotels.com/gdcs/production128/d1581/5051d8fd-8069-4c18-b58a-b12af862bcbc.jpg?impolicy=fcrop&w=800&h=533&q=medium',
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://www.w3schools.com/w3images/avatar2.png',
                          height: 24,
                          width: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: const Text(
                          'Dinmukhammed Mussilim',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '29.07.2022 - 04.08.2022',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              height: 34,
                              width: 70,
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.0)),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              height: 34,
                              width: 70,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 5),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/map_pin.svg',
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 5),
                                  const SizedBox(
                                    width: 30,
                                    child: Text(
                                      '13',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              height: 34,
                              width: 70,
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.0)),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              height: 34,
                              width: 70,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 5),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/user_icon.svg',
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 5),
                                  const SizedBox(
                                    width: 30,
                                    child: Text(
                                      '13',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
