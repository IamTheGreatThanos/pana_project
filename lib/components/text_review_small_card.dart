import 'package:flutter/material.dart';
import 'package:pana_project/models/textReview.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/other/text_review_detail_page.dart';

class TextReviewSmallCard extends StatefulWidget {
  TextReviewSmallCard(this.review);
  final TextReviewModel review;

  @override
  _TextReviewSmallCardState createState() => _TextReviewSmallCardState();
}

class _TextReviewSmallCardState extends State<TextReviewSmallCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TextReviewDetailPage(widget.review)));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            color: AppColors.white),
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          widget.review.user?.name ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Text(
                          widget.review.createdAt ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackWithOpacity,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                child: Text(
                  widget.review.description ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.blackWithOpacity,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
