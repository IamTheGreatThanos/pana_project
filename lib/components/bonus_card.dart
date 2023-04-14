import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pana_project/utils/const.dart';

class BonusCard extends StatelessWidget {
  const BonusCard({
    Key? key,
    required this.colorType,
    required this.title,
    required this.imageUrl,
    required this.isTaken,
    required this.bonusType,
    required this.count,
  }) : super(key: key);

  final int
      colorType; // TODO: 1 - white, 2 - light grey, 3 - dark, 4 - brown, 5 - green.
  final String title;
  final String imageUrl;
  final bool isTaken;
  final int bonusType; // TODO: 1 - visits, 2 - asyki.
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorType == 1
            ? AppColors.white
            : colorType == 2
                ? const Color(0xFFF5F5F5)
                : colorType == 3
                    ? const Color(0xFF575757)
                    : colorType == 4
                        ? const Color(0xFF2B2B2B)
                        : colorType == 5
                            ? const Color(0xFF9F6856)
                            : const Color(0xFF58542F),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      width: 129,
      height: 230,
      child: Column(
        children: [
          const SizedBox(height: 15),
          Container(
            width: 97,
            height: 97,
            decoration: BoxDecoration(
              color: colorType == 1 ? AppColors.lightGray : AppColors.white,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorType == 1 || colorType == 2
                    ? AppColors.black
                    : AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: isTaken
                ? const Text(
                    'Получено',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.accent,
                    ),
                  )
                : Column(
                    children: [
                      bonusType == 1
                          ? Text(
                              'Осталось посещений:',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: colorType == 1 || colorType == 2
                                    ? AppColors.blackWithOpacity
                                    : Colors.white54,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              'Осталось асыков:',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: colorType == 1 || colorType == 2
                                    ? AppColors.blackWithOpacity
                                    : Colors.white54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                      Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colorType == 1 || colorType == 2
                              ? AppColors.black
                              : AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
