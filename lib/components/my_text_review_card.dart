import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pana_project/models/textReview.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/other/text_review_detail_page.dart';

class MyTextReviewCard extends StatefulWidget {
  MyTextReviewCard(this.review);
  final TextReviewModel review;

  @override
  _MyTextReviewCardState createState() => _MyTextReviewCardState();
}

class _MyTextReviewCardState extends State<MyTextReviewCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TextReviewDetailPage(widget.review)));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppConstants.cardBorderRadius),
              color: AppColors.white),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: SizedBox(
                        width: 64,
                        height: 64,
                        child: CachedNetworkImage(
                          imageUrl: widget.review.user?.avatar ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            '${widget.review.user?.name ?? ''} ${widget.review.user?.surname ?? ''}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            '${widget.review.housing?.city?.name ?? ''}, ${widget.review.housing?.city?.country?.name ?? ''}',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SizedBox(
                  child: Text(
                    widget.review.description ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.blackWithOpacity,
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              (widget.review.images?.length ?? 0) > 0
                  ? Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                      height: 70,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          for (int i = 0;
                              i < (widget.review.images?.length ?? 0);
                              i++)
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        widget.review.images?[i].path ?? '',
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(width: 10),
                          (widget.review.images?.length ?? 0) > 3
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  child: Container(
                                    color: AppColors.grey,
                                    width: 70,
                                    height: 70,
                                    child: Center(
                                      child: Text(
                                        '+ ${(widget.review.images?.length ?? 3) - 3}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    )
                  : Container(),
              widget.review.answers?.isNotEmpty ?? false
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child: SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: CachedNetworkImage(
                                    imageUrl: widget
                                            .review.answers?[0].user?.avatar ??
                                        '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      '${widget.review.answers?[0].user?.name ?? ''} ${widget.review.answers?[0].user?.surname ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: const Text(
                                      'Ответ от владельца',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: SizedBox(
                            child: Text(
                              widget.review.answers?[0].description ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.blackWithOpacity,
                              ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
