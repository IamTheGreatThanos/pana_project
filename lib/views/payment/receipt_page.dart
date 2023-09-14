import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/models/impressionDetail.dart';
import 'package:pana_project/models/impressionSession.dart';
import 'package:pana_project/models/receipt_order.dart';
import 'package:pana_project/services/housing_api_provider.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/checkNightCount.dart';
import 'package:pana_project/utils/checkPeopleCount.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/utils/format_number_string.dart';
import 'package:pana_project/views/home/tabbar_page.dart';
import 'package:pana_project/views/messages/support_chat_page.dart';
import 'package:pana_project/views/payment/fine_payment_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:share_plus/share_plus.dart';
import 'package:skeletons/skeletons.dart';

class ReceiptPage extends StatefulWidget {
  ReceiptPage(
    this.housing,
    this.startDate,
    this.endDate,
    this.peopleCount,
    this.babies,
    this.pets,
    this.orderId,
    this.fromHousing,
    this.impression,
    this.session,
    this.type,
  );

  final HousingDetailModel housing;
  final String startDate;
  final String endDate;
  final int peopleCount;
  final int babies;
  final int pets;
  final int orderId;
  final bool fromHousing;
  final ImpressionDetailModel impression;
  final ImpressionSessionModel session;
  final int type; // 2 - closed, 1 - open

  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  ReceiptOrder order = ReceiptOrder();
  bool isLoading = false;
  double returnPrice = 0;
  double totalPrice = 0;

  int days = 0;
  double sum = 0;

  double penaltyPrice = -1;

  bool isCancelAvailable = false;

  @override
  void initState() {
    super.initState();
    getOrder();
    requestReturnPrice();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void calcSumAndDays() async {
    DateTime dateFromFormatted =
        DateTime.parse(order.dateFrom ?? DateTime.now().toString());
    DateTime dateToFormatted =
        DateTime.parse(order.dateTo ?? DateTime.now().toString());

    if (dateFromFormatted.isAfter(DateTime.now())) {
      isCancelAvailable = true;
    }

    Duration difference = dateToFormatted.difference(dateFromFormatted);
    days = difference.inDays;

    if (dateFromFormatted == dateToFormatted) {
      days = 1;
    }

    sum = 0;

    for (int i = 0; i < (order.roomNumbers?.length ?? 0); i++) {
      sum += (order.roomNumbers?[i].price ?? 0) *
          (order.roomNumbers?[i].count ?? 1) *
          days;
    }
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
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
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
                                  offset: Offset(
                                      0, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                  'assets/icons/back_arrow.svg'),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Квитанция',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (!isLoading) {
                              generatePDF();
                            }
                          },
                          child: Container(
                            width: 40,
                            height: 40,
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
                                  offset: Offset(
                                      0, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset('assets/icons/share.svg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 10,
                  color: AppColors.white,
                ),
                isLoading
                    ? const SkeletonLine()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        color: order.status == 6
                            ? AppColors.red
                            : order.paymentStatus == 0
                                ? AppColors.yellow
                                : AppColors.green,
                        child: Center(
                          child: Text(
                            order.status == 6
                                ? 'Оплата отменена'
                                : order.paymentStatus == 0
                                    ? 'Ожидается оплата'
                                    : 'Оплачено',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                Container(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: widget.fromHousing
                                      ? (widget.housing.images?[0].path ?? '')
                                      : (widget.impression.images?[0].path ??
                                          ''),
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
                                    widget.fromHousing
                                        ? (widget.housing.name ?? '')
                                        : (widget.impression.name ?? ''),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    widget.fromHousing
                                        ? '${widget.housing.city?.name ?? ''}, ${widget.housing.city?.country?.name ?? ''}'
                                        : '${widget.impression.city?.name ?? ''}, ${widget.impression.city?.country?.name ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        const Text(
                          'О бронировании:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Дата бронирования:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45,
                              ),
                            ),
                            const Spacer(),
                            isLoading
                                ? const SizedBox(
                                    width: 70, child: SkeletonLine())
                                : widget.fromHousing
                                    ? Text(
                                        widget.startDate == widget.endDate
                                            ? DateFormat("d MMM", 'ru').format(
                                                DateTime.parse(
                                                    widget.startDate))
                                            : '${DateFormat("d MMM", 'ru').format(DateTime.parse(widget.startDate))} - ${DateFormat("d MMM", 'ru').format(DateTime.parse(widget.endDate))}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      )
                                    : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          order.dateFrom == order.dateTo
                                              ? '${DateFormat("d MMMM", 'ru').format(DateTime.parse(order.dateFrom ?? ''))}, ${order.timeStart?.substring(0, 5)} - ${order.timeEnd?.substring(0, 5)}; ${order.session?.type == 2 ? 'Закрытая группа' : 'Открытая группа'}'
                                              : '${DateFormat("d MMMM", 'ru').format(DateTime.parse(order.dateFrom ?? ''))}, ${order.timeStart?.substring(0, 5)} - ${DateFormat("d MMMM", 'ru').format(DateTime.parse(order.dateTo ?? ''))}, ${order.timeEnd?.substring(0, 5)}; ${order.session?.type == 2 ? 'Закрытая группа' : 'Открытая группа'}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              widget.fromHousing
                                  ? 'Кол-во гостей:'
                                  : 'Кол-во участников:',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              widget.fromHousing
                                  ? '${widget.peopleCount} гостя, ${widget.babies} млад., ${widget.pets} питом.'
                                  : checkPeopleCount(
                                      widget.peopleCount.toString()),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        const Text(
                          'Детализация цены:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        isLoading
                            ? const SizedBox(width: 70, child: SkeletonLine())
                            : widget.fromHousing
                                ? Column(
                                    children: [
                                      for (int i = 0;
                                          i < (order.roomNumbers?.length ?? 0);
                                          i++)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(
                                                  '${i + 1}. ${order.roomNumbers?[i].roomName ?? ''} x ${checkNightCount(days.toString())}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black45,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${formatNumberString(((order.roomNumbers?[i].price ?? 0) * days).toString())} \₸',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Text(
                                            'Сеанс: ${order.dateFrom == order.dateTo ? '${DateFormat("d MMMM", 'ru').format(DateTime.parse(order.dateFrom ?? ''))}, ${order.timeStart?.substring(0, 5)} - ${order.timeEnd?.substring(0, 5)}; ${order.session?.type == 2 ? 'Закрытая группа' : 'Открытая группа'}' : '${DateFormat("d MMMM", 'ru').format(DateTime.parse(order.dateFrom ?? ''))}, ${order.timeStart?.substring(0, 5)} - ${DateFormat("d MMMM", 'ru').format(DateTime.parse(order.dateTo ?? ''))}, ${order.timeEnd?.substring(0, 5)}; ${order.session?.type == 2 ? 'Закрытая группа' : 'Открытая группа'}'}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${formatNumberString((((order.session?.type == 1 ? order.session?.openPrice ?? 0 : order.session?.closedPrice ?? 0))).toString())} \₸',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Итого:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              widget.fromHousing
                                  ? '${formatNumberString(sum.toString())} \₸'
                                  : '${formatNumberString(((order.session?.type == 1 ? order.session?.openPrice ?? 0 : order.session?.closedPrice ?? 0) * (widget.peopleCount ?? 1)).toString())} \₸',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        const Text(
                          'Платежная информация:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Номер квитанции:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45,
                              ),
                            ),
                            const Spacer(),
                            isLoading
                                ? const SizedBox(
                                    width: 70, child: SkeletonLine())
                                : Text(
                                    '${order.id ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Дата транзакции:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45,
                              ),
                            ),
                            const Spacer(),
                            isLoading
                                ? const SizedBox(
                                    width: 70, child: SkeletonLine())
                                : Text(
                                    order.paymentAt ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Ф.И.О. плательщика:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45,
                              ),
                            ),
                            const Spacer(),
                            isLoading
                                ? const SizedBox(
                                    width: 70, child: SkeletonLine())
                                : Text(
                                    '${order.user?.name ?? ''} ${order.user?.surname ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Способ оплаты:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45,
                              ),
                            ),
                            const Spacer(),
                            isLoading
                                ? const SizedBox(
                                    width: 70, child: SkeletonLine())
                                : Text(
                                    order.paymentType == 1
                                        ? order.successPaymentOperation != null
                                            ? 'Картой **** ${jsonDecode(order.successPaymentOperation?['description'])['cardMask'].toString().substring(9, 13)}'
                                            : ''
                                        : 'Оплата при заезде',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                order.paymentType == 1
                    ? returnPrice != 0
                        ? buildCancelWidget()
                        : const SizedBox.shrink()
                    : isCancelAvailable
                        ? buildCancelWidget()
                        : const SizedBox.shrink(),
                Container(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Возникли проблемы?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: const BorderSide(
                                width: 2,
                                color: AppColors.grey,
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SupportChatPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Служба поддержки",
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCancelWidget() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Правила отмены:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  order.housing?.cancelFineDay != null
                      ? 'Бесплатная отмена ${order.housing?.cancelFineDay ?? ''} дней до заезда'
                      : 'Бесплатная отмена',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    if (order.paymentType == 1) {
                      showCancelingConfirmation(returnPrice, totalPrice);
                    } else {
                      if (penaltyPrice == 0) {
                        cancelOrder();
                      } else {
                        showCancelingConfirmationWithoutPayment(penaltyPrice);
                      }
                    }
                  },
                  child: const Text(
                    'Отменить бронирование',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // TODO: Generate PDF

  void generatePDF() async {
    final pdf = pdfWidgets.Document();

    final response = await http.get(Uri.parse(widget.fromHousing
        ? (widget.housing.images?[0].path ?? '')
        : (widget.impression.images?[0].path ?? '')));
    final Uint8List imageBytes = response.bodyBytes;

    final fontData =
        await rootBundle.load("assets/fonts/Montserrat-Regular.ttf");
    final ttf = pdfWidgets.Font.ttf(fontData);
    final fontDataBold =
        await rootBundle.load("assets/fonts/Montserrat-Bold.ttf");
    final ttfBold = pdfWidgets.Font.ttf(fontDataBold);

    const blackWithOpacity = PdfColor.fromInt(0xFF2B2B2B);
    const red = PdfColor.fromInt(0xFFF65151);
    const green = PdfColor.fromInt(0xFF46CB63);
    const yellow = PdfColor.fromInt(0xFFFFB930);
    const white = PdfColor.fromInt(0xFFFFFFFF);
    const black = PdfColor.fromInt(0xFF000000);
    const double width = 375;

    pdf.addPage(
      pdfWidgets.Page(
        build: (context) {
          return pdfWidgets.Container(
            padding: const pdfWidgets.EdgeInsets.all(20),
            width: width,
            color: PdfColors.white,
            child: pdfWidgets.Column(
              crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
              children: [
                pdfWidgets.Container(
                  width: width,
                  height: 40,
                  color: order.status == 6
                      ? red
                      : order.paymentStatus == 0
                          ? yellow
                          : green,
                  child: pdfWidgets.Center(
                    child: pdfWidgets.Text(
                      order.status == 6
                          ? 'Оплата отменена'
                          : order.paymentStatus == 0
                              ? 'Ожидается оплата'
                              : 'Оплачено',
                      style: pdfWidgets.TextStyle(
                        font: ttfBold,
                        color: white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                pdfWidgets.SizedBox(height: 20),
                pdfWidgets.Row(
                  children: [
                    pdfWidgets.ClipRRect(
                      verticalRadius: 12,
                      horizontalRadius: 12,
                      child: pdfWidgets.SizedBox(
                        width: 48,
                        height: 48,
                        child: pdfWidgets.Image(
                          pdfWidgets.MemoryImage(imageBytes),
                          fit: pdfWidgets.BoxFit.cover,
                        ),
                      ),
                    ),
                    pdfWidgets.SizedBox(width: 15),
                    pdfWidgets.Column(
                      crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
                      children: [
                        pdfWidgets.SizedBox(
                          width: 200,
                          child: pdfWidgets.Text(
                            widget.fromHousing
                                ? (widget.housing.name ?? '')
                                : (widget.impression.name ?? ''),
                            style: pdfWidgets.TextStyle(
                              font: ttf,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        pdfWidgets.SizedBox(height: 10),
                        pdfWidgets.SizedBox(
                          width: 250,
                          child: pdfWidgets.Text(
                            widget.fromHousing
                                ? '${widget.housing.city?.name ?? ''}, ${widget.housing.city?.country?.name ?? ''}'
                                : '${widget.impression.city?.name ?? ''}, ${widget.impression.city?.country?.name ?? ''}',
                            style: pdfWidgets.TextStyle(
                              font: ttf,
                              fontSize: 14,
                              color: blackWithOpacity,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pdfWidgets.SizedBox(height: 10),
                pdfWidgets.Divider(),
                pdfWidgets.SizedBox(height: 10),
                pdfWidgets.Text(
                  'О бронировании:',
                  style: pdfWidgets.TextStyle(
                    font: ttfBold,
                    fontSize: 16,
                    color: blackWithOpacity,
                  ),
                ),
                pdfWidgets.SizedBox(height: 10),
                pdfWidgets.Row(
                  children: [
                    pdfWidgets.Text(
                      'Дата бронирования:',
                      style: pdfWidgets.TextStyle(
                        font: ttf,
                        fontSize: 16,
                        color: blackWithOpacity,
                      ),
                    ),
                    pdfWidgets.Spacer(),
                    widget.fromHousing
                        ? pdfWidgets.Text(
                            widget.startDate == widget.endDate
                                ? DateFormat("d MMM", 'ru')
                                    .format(DateTime.parse(widget.startDate))
                                : '${DateFormat("d MMM", 'ru').format(DateTime.parse(widget.startDate))} - ${DateFormat("d MMM", 'ru').format(DateTime.parse(widget.endDate))}',
                            style: pdfWidgets.TextStyle(
                              font: ttf,
                              fontSize: 14,
                              color: black,
                            ),
                          )
                        : pdfWidgets.SizedBox(
                            width: width * 0.4,
                            child: pdfWidgets.Text(
                              order.dateFrom == order.dateTo
                                  ? '${DateFormat("d MMMM", 'ru').format(DateTime.parse(order.dateFrom ?? ''))}, ${order.timeStart?.substring(0, 5)} - ${order.timeEnd?.substring(0, 5)}; ${order.session?.type == 2 ? 'Закрытая группа' : 'Открытая группа'}'
                                  : '${DateFormat("d MMMM", 'ru').format(DateTime.parse(order.dateFrom ?? ''))}, ${order.timeStart?.substring(0, 5)} - ${DateFormat("d MMMM", 'ru').format(DateTime.parse(order.dateTo ?? ''))}, ${order.timeEnd?.substring(0, 5)}; ${order.session?.type == 2 ? 'Закрытая группа' : 'Открытая группа'}',
                              style: pdfWidgets.TextStyle(
                                font: ttf,
                                fontSize: 14,
                                color: black,
                              ),
                              textAlign: pdfWidgets.TextAlign.right,
                            ),
                          ),
                  ],
                ),
                pdfWidgets.SizedBox(height: 10),
                pdfWidgets.Row(
                  children: [
                    pdfWidgets.Text(
                      widget.fromHousing
                          ? 'Кол-во гостей:'
                          : 'Кол-во участников:',
                      style: pdfWidgets.TextStyle(
                        font: ttf,
                        fontSize: 14,
                        color: blackWithOpacity,
                      ),
                    ),
                    pdfWidgets.Spacer(),
                    pdfWidgets.Text(
                      widget.fromHousing
                          ? '${widget.peopleCount} гостя, ${widget.babies} млад., ${widget.pets} питом.'
                          : checkPeopleCount(widget.peopleCount.toString()),
                      style: pdfWidgets.TextStyle(
                        font: ttf,
                        fontSize: 14,
                        color: black,
                      ),
                    ),
                  ],
                ),
                pdfWidgets.SizedBox(height: 10),
                pdfWidgets.Divider(),
                pdfWidgets.SizedBox(height: 10),
                pdfWidgets.Text(
                  'Детализация цены:',
                  style: pdfWidgets.TextStyle(
                    font: ttfBold,
                    fontSize: 16,
                    color: black,
                  ),
                ),
                pdfWidgets.SizedBox(height: 10),
                widget.fromHousing
                    ? pdfWidgets.Column(
                        children: [
                          for (int i = 0;
                              i < (order.roomNumbers?.length ?? 0);
                              i++)
                            pdfWidgets.Padding(
                              padding:
                                  const pdfWidgets.EdgeInsets.only(bottom: 8),
                              child: pdfWidgets.Row(
                                children: [
                                  pdfWidgets.SizedBox(
                                    width: width * 0.6,
                                    child: pdfWidgets.Text(
                                      '${i + 1}. ${order.roomNumbers?[i].roomName ?? ''} x ${checkNightCount(days.toString())}',
                                      style: pdfWidgets.TextStyle(
                                        font: ttf,
                                        fontSize: 14,
                                        color: blackWithOpacity,
                                      ),
                                    ),
                                  ),
                                  pdfWidgets.Spacer(),
                                  pdfWidgets.Text(
                                    '${formatNumberString(((order.roomNumbers?[i].price ?? 0) * days).toString())} \₸',
                                    style: pdfWidgets.TextStyle(
                                      font: ttfBold,
                                      fontSize: 16,
                                      color: black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      )
                    : pdfWidgets.Padding(
                        padding: const pdfWidgets.EdgeInsets.only(bottom: 8),
                        child: pdfWidgets.Row(
                          children: [
                            pdfWidgets.SizedBox(
                              width: width * 0.7,
                              child: pdfWidgets.Text(
                                'Сеанс: ${order.dateFrom == order.dateTo ? '${DateFormat("d MMMM", 'ru').format(DateTime.parse(order.dateFrom ?? ''))}, ${order.timeStart?.substring(0, 5)} - ${order.timeEnd?.substring(0, 5)}; ${order.session?.type == 2 ? 'Закрытая группа' : 'Открытая группа'}' : '${DateFormat("d MMMM", 'ru').format(DateTime.parse(order.dateFrom ?? ''))}, ${order.timeStart?.substring(0, 5)} - ${DateFormat("d MMMM", 'ru').format(DateTime.parse(order.dateTo ?? ''))}, ${order.timeEnd?.substring(0, 5)}; ${order.session?.type == 2 ? 'Закрытая группа' : 'Открытая группа'}'}',
                                style: pdfWidgets.TextStyle(
                                  font: ttf,
                                  fontSize: 14,
                                  color: blackWithOpacity,
                                ),
                              ),
                            ),
                            pdfWidgets.Spacer(),
                            pdfWidgets.Text(
                              '${formatNumberString((((order.session?.type == 1 ? order.session?.openPrice ?? 0 : order.session?.closedPrice ?? 0))).toString())} \₸',
                              style: pdfWidgets.TextStyle(
                                font: ttfBold,
                                fontSize: 16,
                                color: black,
                              ),
                            ),
                          ],
                        ),
                      ),
                pdfWidgets.SizedBox(height: 10),
                pdfWidgets.Row(
                  children: [
                    pdfWidgets.Text(
                      'Итого:',
                      style: pdfWidgets.TextStyle(
                        font: ttf,
                        fontSize: 14,
                        color: black,
                      ),
                    ),
                    pdfWidgets.Spacer(),
                    pdfWidgets.Text(
                      widget.fromHousing
                          ? '${formatNumberString(sum.toString())} \₸'
                          : '${formatNumberString(((order.session?.type == 1 ? order.session?.openPrice ?? 0 : order.session?.closedPrice ?? 0) * (widget.peopleCount ?? 1)).toString())} \₸',
                      style: pdfWidgets.TextStyle(
                        font: ttfBold,
                        fontSize: 16,
                        color: black,
                      ),
                    ),
                  ],
                ),
                pdfWidgets.SizedBox(height: 10),
                pdfWidgets.Divider(),
                pdfWidgets.SizedBox(height: 10),
                pdfWidgets.Text(
                  'Платежная информация:',
                  style: pdfWidgets.TextStyle(
                    font: ttfBold,
                    fontSize: 16,
                    color: black,
                  ),
                ),
                pdfWidgets.SizedBox(height: 10),
                pdfWidgets.Row(
                  children: [
                    pdfWidgets.Text(
                      'Номер квитанции:',
                      style: pdfWidgets.TextStyle(
                        font: ttf,
                        fontSize: 14,
                        color: blackWithOpacity,
                      ),
                    ),
                    pdfWidgets.Spacer(),
                    pdfWidgets.Text(
                      '${order.id ?? ''}',
                      style: pdfWidgets.TextStyle(
                        font: ttf,
                        fontSize: 14,
                        color: black,
                      ),
                    ),
                  ],
                ),
                pdfWidgets.SizedBox(height: 10),
                pdfWidgets.Row(
                  children: [
                    pdfWidgets.Text(
                      'Дата транзакции:',
                      style: pdfWidgets.TextStyle(
                        font: ttf,
                        fontSize: 14,
                        color: blackWithOpacity,
                      ),
                    ),
                    pdfWidgets.Spacer(),
                    pdfWidgets.Text(
                      order.paymentAt ?? '',
                      style: pdfWidgets.TextStyle(
                        font: ttf,
                        fontSize: 14,
                        color: black,
                      ),
                    ),
                  ],
                ),
                pdfWidgets.SizedBox(height: 10),
                pdfWidgets.Row(
                  children: [
                    pdfWidgets.Text(
                      'Ф.И.О. плательщика:',
                      style: pdfWidgets.TextStyle(
                        font: ttf,
                        fontSize: 14,
                        color: blackWithOpacity,
                      ),
                    ),
                    pdfWidgets.Spacer(),
                    pdfWidgets.SizedBox(
                      width: width * 0.45,
                      child: pdfWidgets.Text(
                        '${order.user?.name ?? ''} ${order.user?.surname ?? ''}',
                        style: pdfWidgets.TextStyle(
                          font: ttf,
                          fontSize: 14,
                          color: black,
                        ),
                        textAlign: pdfWidgets.TextAlign.right,
                      ),
                    ),
                  ],
                ),
                pdfWidgets.SizedBox(height: 10),
                pdfWidgets.Row(
                  children: [
                    pdfWidgets.Text(
                      'Способ оплаты:',
                      style: pdfWidgets.TextStyle(
                        font: ttf,
                        fontSize: 14,
                        color: blackWithOpacity,
                      ),
                    ),
                    pdfWidgets.Spacer(),
                    pdfWidgets.Text(
                      order.paymentType == 1
                          ? order.successPaymentOperation != null
                              ? 'Картой **** ${jsonDecode(order.successPaymentOperation?['description'])['cardMask'].toString().substring(9, 13)}'
                              : ''
                          : 'Оплата при заезде',
                      style: pdfWidgets.TextStyle(
                        font: ttf,
                        fontSize: 14,
                        color: black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    final pdfOutput = await pdf.save();

    final fileName = 'check_${widget.orderId}.pdf';

    final appDir = await getApplicationDocumentsDirectory();
    final pdfFile = File('${appDir.path}/$fileName');
    await pdfFile.writeAsBytes(pdfOutput);

    await Share.shareXFiles(
      [XFile(pdfFile.path)],
      text: 'PDF',
      subject: 'Поделиться PDF',
    );
  }

  void getOrder() async {
    isLoading = true;
    setState(() {});
    var response = await MainProvider().getOrder(widget.orderId);

    if (response['response_status'] == 'ok') {
      order = ReceiptOrder.fromJson(response['data']);

      isLoading = false;
      calcSumAndDays();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void cancelOrder() async {
    var response = await HousingProvider().cancelOrder(widget.orderId);
    if (response['response_status'] == 'ok') {
      showSuccessfullyCanceledSheet();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void requestReturnPrice() async {
    if (order.paymentType == 1) {
      var response =
          await MainProvider().requestOrderReturnPrices(widget.orderId);
      if (response['response_status'] == 'ok') {
        returnPrice = double.parse(response['data']['refund_price'].toString());
        totalPrice = double.parse(response['data']['total_price'].toString());
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['data']['message'],
              style: const TextStyle(fontSize: 14)),
        ));
      }
    } else {
      var response =
          await MainProvider().requestOrderReturnPenalty(widget.orderId);
      if (response['response_status'] == 'ok') {
        penaltyPrice =
            double.parse(response['data']['penalty_price'].toString());
        if (mounted) {
          setState(() {});
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['data']['message'],
              style: const TextStyle(fontSize: 14)),
        ));
      }
    }
  }

  void showCancelingConfirmation(double returnPrice, double totalPrice) async {
    var returnPercent =
        (returnPrice / (totalPrice == 0 ? 1 : totalPrice) * 100).toInt();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.cardBorderRadius),
            topRight: Radius.circular(AppConstants.cardBorderRadius)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                height: 400,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const Text(
                          'Отменить бронирование?',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Вы уверены, что хотите отменить бронь? Для отмены брони штраф составит ${totalPrice == 0 ? 0 : 100 - returnPercent}% (${formatNumberString((totalPrice - returnPrice).toString())}₸). Остальная сумма вернется вам на карту',
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: AppColors.grey,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Сумма к возврату: $returnPercent% (${formatNumberString(returnPrice.toString())}₸)',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const Spacer(),
                          SizedBox(
                            height: 60,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Не отменять",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 60,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.accent,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                if (returnPrice != '0') {
                                  Navigator.of(context).pop();
                                  cancelOrder();
                                }
                              },
                              child: const Text(
                                "Да,отменить",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showCancelingConfirmationWithoutPayment(double finePrice) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.cardBorderRadius),
            topRight: Radius.circular(AppConstants.cardBorderRadius)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                height: 410,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const Text(
                          'Отменить бронирование?',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Вы уверены, что хотите отменить бронь? Для отмены брони штраф составит (${formatNumberString(finePrice.toString())}₸). При последующем бронировании будет добавлено возмещение за отмену текущего бронирования, которое будет учтено в общей сумме оплаты.',
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: AppColors.red,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Штраф за отмену: ${formatNumberString(finePrice.toString())}₸ ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const Spacer(),
                          SizedBox(
                            height: 60,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Не отменять",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 60,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.accent,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FinePaymentPage(
                                      order,
                                      0,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Да,отменить",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showSuccessfullyCanceledSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.cardBorderRadius),
            topRight: Radius.circular(AppConstants.cardBorderRadius)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                height: 400,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      SvgPicture.asset('assets/icons/big_checkmark.svg'),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const Text(
                          'Вы отменили бронирование',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          'Вы успешно отменили свое бронирование${order.paymentType == 1 ? ', средства за бронирование будут отправлены вам, в течение дня' : ''}!',
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TabBarPage(AppConstants.mainTabIndex)),
                                (Route<dynamic> route) => false);
                          },
                          child: const Text(
                            "Отлично!",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
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
      },
    );
  }
}
