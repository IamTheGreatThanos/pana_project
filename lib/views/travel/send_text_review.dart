import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';

class SendTextReviewPage extends StatefulWidget {
  SendTextReviewPage(this.type, this.id);
  final int type;
  final int id;

  @override
  _SendTextReviewPageState createState() => _SendTextReviewPageState();
}

class _SendTextReviewPageState extends State<SendTextReviewPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  var dateMaskFormatter = MaskTextInputFormatter(
    mask: '####/##/##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  List<XFile> images = [];

  int priceBall = 3;
  int fieldBall = 3;
  int purityBall = 3;
  int staffBall = 3;

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
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(color: AppColors.white, height: 30),
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
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
                          'Оставьте отзыв',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppConstants.cardBorderRadius),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Когда вы здесь были?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 10),
                            child: TextField(
                              controller: _dateController,
                              inputFormatters: [dateMaskFormatter],
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                counterStyle: TextStyle(
                                  height: double.minPositive,
                                ),
                                counterText: "",
                                border: InputBorder.none,
                                hintText: 'гггг/мм/дд',
                                hintStyle: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Напишите отзыв',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 115,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: AppColors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 10),
                            child: TextField(
                              controller: _reviewController,
                              maxLength: 2000,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                counterStyle: TextStyle(
                                  height: double.minPositive,
                                ),
                                counterText: "",
                                border: InputBorder.none,
                                hintText: 'Расскажите подробности',
                                hintStyle: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppConstants.cardBorderRadius),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Цена / Качество',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            for (int i = 0; i < priceBall; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    priceBall = i + 1;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SvgPicture.asset(
                                    'assets/icons/star.svg',
                                    width: 28,
                                    height: 28,
                                  ),
                                ),
                              ),
                            for (int i = 0; i < 5 - priceBall; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    priceBall += i + 1;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SvgPicture.asset(
                                    'assets/icons/star.svg',
                                    width: 28,
                                    height: 28,
                                    color: AppColors.lightGray,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Divider(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Атмосфера',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            for (int i = 0; i < fieldBall; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    fieldBall = i + 1;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SvgPicture.asset(
                                    'assets/icons/star.svg',
                                    width: 28,
                                    height: 28,
                                  ),
                                ),
                              ),
                            for (int i = 0; i < 5 - fieldBall; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    fieldBall += i + 1;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SvgPicture.asset(
                                    'assets/icons/star.svg',
                                    width: 28,
                                    height: 28,
                                    color: AppColors.lightGray,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Divider(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Чистота',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            for (int i = 0; i < purityBall; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    purityBall = i + 1;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SvgPicture.asset(
                                    'assets/icons/star.svg',
                                    width: 28,
                                    height: 28,
                                  ),
                                ),
                              ),
                            for (int i = 0; i < 5 - purityBall; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    purityBall += i + 1;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SvgPicture.asset(
                                    'assets/icons/star.svg',
                                    width: 28,
                                    height: 28,
                                    color: AppColors.lightGray,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Divider(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Персонал',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            for (int i = 0; i < staffBall; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    staffBall = i + 1;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SvgPicture.asset(
                                    'assets/icons/star.svg',
                                    width: 28,
                                    height: 28,
                                  ),
                                ),
                              ),
                            for (int i = 0; i < 5 - staffBall; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    staffBall += i + 1;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SvgPicture.asset(
                                    'assets/icons/star.svg',
                                    width: 28,
                                    height: 28,
                                    color: AppColors.lightGray,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppConstants.cardBorderRadius),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Добавьте фото (необязательно)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 0),
                          height: 120,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  addImage();
                                },
                                child: DottedBorder(
                                  color: AppColors.accent,
                                  strokeWidth: 1,
                                  dashPattern: [6, 2],
                                  strokeCap: StrokeCap.round,
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(8),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: const BoxDecoration(
                                      color: AppColors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.add,
                                            color: AppColors.accent),
                                        Text(
                                          'Добавить',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.accent),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              for (var image in images)
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    child: SizedBox(
                                      height: 120,
                                      width: 120,
                                      child: Image.file(
                                        File(image.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.accent,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      onPressed: () {
                        if (_dateController.text.length == 10 &&
                            _reviewController.text.isNotEmpty) {
                          saveChanges();
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Заполните все поля.",
                                style: TextStyle(fontSize: 20)),
                          ));
                        }
                      },
                      child: const Text("Опубликовать отзыв",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        images.add(selectedImage);
      });
    }
  }

  void saveChanges() async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    try {
      String wasAt = formatter
          .format(DateTime.parse(_dateController.text.replaceAll('/', '-')));
      showLoaderDialog(context);
      var response = await MainProvider().sendTextReview(
        widget.type,
        widget.id,
        wasAt,
        _reviewController.text,
        priceBall,
        fieldBall,
        purityBall,
        staffBall,
        images,
      );

      if (response['response_status'] == 'ok') {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        print(response['data']['message']);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ошибка загрузки...', style: TextStyle(fontSize: 20)),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text("Заполните правильную дату.", style: TextStyle(fontSize: 20)),
      ));
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: const [
          CircularProgressIndicator(),
          SizedBox(width: 10),
          Text("Загрузка..."),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
