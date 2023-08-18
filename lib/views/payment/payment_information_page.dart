import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/models/impressionDetail.dart';
import 'package:pana_project/models/impressionSession.dart';
import 'package:pana_project/models/roomCard.dart';
import 'package:pana_project/utils/checkReviewsCount.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/views/home/tabbar_page.dart';
import 'package:pana_project/views/payment/receipt_page.dart';

class PaymentInformationPage extends StatefulWidget {
  PaymentInformationPage(
    this.fromHousing,
    this.impression,
    this.session,
    this.peopleCount,
    this.type,
    this.roomList,
    this.selectedRooms,
    this.days,
    this.sum,
    this.housing,
    this.babies,
    this.pets,
    this.startDate,
    this.endDate,
    this.paymentType,
    this.cardInformation,
    this.cardType,
    this.orderId,
  );
  final bool fromHousing;
  final ImpressionDetailModel impression;
  final ImpressionSessionModel session;
  final int peopleCount;
  final int type; // 2 - closed, 1 - open
  final List<RoomCardModel> roomList;
  final List<Map<String, dynamic>> selectedRooms;
  final int days;
  final String sum;
  final HousingDetailModel housing;
  final int babies;
  final int pets;
  final String startDate;
  final String endDate;
  final int paymentType; // 1 - in a place, 2 - card, 3 - new card
  final String cardInformation;
  final String cardType;
  final int orderId;

  @override
  _PaymentInformationPageState createState() => _PaymentInformationPageState();
}

class _PaymentInformationPageState extends State<PaymentInformationPage> {
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Оплата',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TabBarPage(AppConstants.mainTabIndex)),
                              (Route<dynamic> route) => false);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 0,
                                blurRadius: 24,
                                offset:
                                    Offset(0, 4), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(Icons.close),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: SizedBox(
                          width: 86,
                          height: 86,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.fromHousing
                                ? widget.housing.images![0].path ?? ''
                                : widget.impression.images?[0].path ?? '',
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
                              widget.fromHousing
                                  ? widget.housing.name ?? ''
                                  : widget.impression.name ?? '',
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
                              widget.fromHousing
                                  ? '${widget.housing.city?.name ?? ''}, ${widget.housing.city?.country?.name ?? ''}'
                                      ''
                                  : '${widget.impression.city?.name ?? ''}, ${widget.impression.city?.country?.name ?? ''}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: SvgPicture.asset(
                                        'assets/icons/star.svg'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    widget.fromHousing
                                        ? widget.housing.reviewsBallAvg ?? '0'
                                        : widget.impression.reviewsAvgBall ??
                                            '0',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    checkReviewsCount((widget.fromHousing
                                            ? widget.housing.reviewsCount ?? 0
                                            : widget.impression.reviewsCount ??
                                                0)
                                        .toString()),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black45),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  widget.fromHousing
                      ? Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Даты',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    widget.startDate == widget.endDate
                                        ? DateFormat("d MMM", 'ru').format(
                                            DateTime.parse(widget.startDate))
                                        : '${DateFormat("d MMM", 'ru').format(DateTime.parse(widget.startDate))} - ${DateFormat("d MMM", 'ru').format(DateTime.parse(widget.endDate))}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20, child: VerticalDivider()),
                          ],
                        )
                      : Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Сеанс',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    widget.session.startDate ==
                                            widget.session.endDate
                                        ? '${DateFormat("d MMMM", 'ru').format(DateTime.parse(widget.session.startDate ?? ''))}, ${widget.session.startTime?.substring(0, 5)} - ${widget.session.endTime?.substring(0, 5)}; ${widget.type == 2 ? 'Закрытая группа' : 'Открытая группа'}'
                                        : '${DateFormat("d MMMM", 'ru').format(DateTime.parse(widget.session.startDate ?? ''))}, ${widget.session.startTime?.substring(0, 5)} - ${DateFormat("d MMMM", 'ru').format(DateTime.parse(widget.session.endDate ?? ''))}, ${widget.session.endTime?.substring(0, 5)}; ${widget.type == 2 ? 'Закрытая группа' : 'Открытая группа'}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 5),
                  widget.fromHousing
                      ? Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Гости',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${widget.peopleCount} гостя, ${widget.babies} младенца, ${widget.pets} питомца',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Участники',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${widget.peopleCount} человек(а)',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  const Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Способ оплаты:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackWithOpacity,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          SvgPicture.asset(widget.paymentType == 1
                              ? 'assets/icons/payment_type_in_a_place.svg'
                              : widget.paymentType == 2
                                  ? 'assets/icons/payment_card.svg'
                                  : widget.cardType == 'VISA'
                                      ? 'assets/icons/visa_icon.svg'
                                      : 'assets/icons/mastercard_icon.svg'),
                          const SizedBox(width: 10),
                          Text(
                            widget.paymentType == 1
                                ? 'Оплата при заселении'
                                : widget.paymentType == 2
                                    ? 'Новой картой'
                                    : '**** ${widget.cardInformation}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        const Text(
                          'Итого',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.fromHousing
                              ? '${formatNumberString(widget.sum)}  \₸'
                              : '${formatNumberString(((widget.type == 1 ? widget.session.openPrice ?? 0 : widget.session.closedPrice ?? 0) * widget.peopleCount).toString())} \₸',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                        side: const BorderSide(
                          width: 2,
                          color: AppColors.grey,
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        goToReceiptPage();
                      },
                      child: const Text(
                        "Квитанция",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void goToReceiptPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptPage(
          widget.housing,
          widget.startDate,
          widget.endDate,
          widget.peopleCount,
          widget.babies,
          widget.pets,
          widget.roomList,
          widget.selectedRooms,
          widget.days,
          widget.sum,
          widget.orderId,
          widget.fromHousing,
          widget.impression,
          widget.session,
          widget.type,
        ),
      ),
    );
  }
}
