import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendTextReviewPage extends StatefulWidget {
  // SendTextReviewPage(this.product);
  // final Product product;

  @override
  _SendTextReviewPageState createState() => _SendTextReviewPageState();
}

class _SendTextReviewPageState extends State<SendTextReviewPage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _reviewController = TextEditingController();

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
                              maxLength: 10,
                              decoration: const InputDecoration(
                                counterStyle: TextStyle(
                                  height: double.minPositive,
                                ),
                                counterText: "",
                                border: InputBorder.none,
                                hintText: 'дд/мм/гггг',
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
                SizedBox(height: 20),
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
                            for (int i = 0; i < 3; i++)
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SvgPicture.asset(
                                  'assets/icons/star.svg',
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                            for (int i = 0; i < 2; i++)
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SvgPicture.asset(
                                  'assets/icons/star.svg',
                                  width: 28,
                                  height: 28,
                                  color: AppColors.lightGray,
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
                            for (int i = 0; i < 3; i++)
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SvgPicture.asset(
                                  'assets/icons/star.svg',
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                            for (int i = 0; i < 2; i++)
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SvgPicture.asset(
                                  'assets/icons/star.svg',
                                  width: 28,
                                  height: 28,
                                  color: AppColors.lightGray,
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
                            for (int i = 0; i < 3; i++)
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SvgPicture.asset(
                                  'assets/icons/star.svg',
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                            for (int i = 0; i < 2; i++)
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SvgPicture.asset(
                                  'assets/icons/star.svg',
                                  width: 28,
                                  height: 28,
                                  color: AppColors.lightGray,
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
                            for (int i = 0; i < 3; i++)
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SvgPicture.asset(
                                  'assets/icons/star.svg',
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                            for (int i = 0; i < 2; i++)
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SvgPicture.asset(
                                  'assets/icons/star.svg',
                                  width: 28,
                                  height: 28,
                                  color: AppColors.lightGray,
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
                              vertical: 20, horizontal: 10),
                          height: 150,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              DottedBorder(
                                color: AppColors.accent,
                                strokeWidth: 1,
                                dashPattern: [6, 2],
                                strokeCap: StrokeCap.round,
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(15),
                                child: Container(
                                  width: 85,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    color: AppColors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.add, color: AppColors.accent),
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
                              const SizedBox(width: 5),
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
                        if (true) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Заполните все поля.",
                                style: TextStyle(fontSize: 20)),
                          ));
                        } else {
                          saveChanges();
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

  void saveChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var response = await AuthProvider()
    //     .changeFullName(nameController.text, surnameController.text);
    //
    // if (response['response_status'] == 'ok') {
    //   Navigator.of(context).pop();
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content:
    //     Text(response['message'], style: const TextStyle(fontSize: 20)),
    //   ));
    // }
  }
}
