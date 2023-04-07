import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/facilities_widget.dart';
import 'package:pana_project/models/comforts.dart';
import 'package:pana_project/utils/const.dart';

class HousingComfortsDetail extends StatefulWidget {
  const HousingComfortsDetail({Key? key, required this.comforts})
      : super(key: key);

  final List<Comforts> comforts;

  @override
  State<HousingComfortsDetail> createState() => _HousingComfortsDetailState();
}

class _HousingComfortsDetailState extends State<HousingComfortsDetail> {
  List<String> categories = [];

  @override
  void initState() {
    for (int i = 0; i < widget.comforts.length; i++) {
      !categories.contains(widget.comforts[i].parent?['name'])
          ? categories.add(widget.comforts[i].parent?['name'])
          : null;
    }
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
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(color: AppColors.white, height: 30),
              Container(
                color: AppColors.white,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child:
                              SvgPicture.asset('assets/icons/back_arrow.svg'),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Удобства',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 50)
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                color: AppColors.white,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [
                      for (int i = 0; i < categories.length; i++)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 20, bottom: 10, right: 20),
                              child: Text(
                                categories[i],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackWithOpacity,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, bottom: 0, right: 10),
                              child: Wrap(
                                children: [
                                  for (int j = 0;
                                      j < widget.comforts.length;
                                      j++)
                                    widget.comforts[j].parent?['name'] ==
                                            categories[i]
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5),
                                                  child: FacilitiesWidget(
                                                      title: widget.comforts[j]
                                                              .name ??
                                                          ''),
                                                ),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                ],
                              ),
                            ),
                            const Divider(height: 20),
                          ],
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
