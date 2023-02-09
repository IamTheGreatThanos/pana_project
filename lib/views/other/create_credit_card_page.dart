import 'package:cloudpayments/cloudpayments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';

class CreateCreditCardPage extends StatefulWidget {
  @override
  _CreateCreditCardPageState createState() => _CreateCreditCardPageState();
}

class _CreateCreditCardPageState extends State<CreateCreditCardPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  String cardType = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(height: 30),
                Row(
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
                        'Добавить карту',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 50)
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  color: AppColors.lightGray,
                  width: MediaQuery.of(context).size.width,
                  height: 690,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CreditCardWidget(
                                cardBgColor: AppColors.accent,
                                cardNumber: cardNumber,
                                expiryDate: expiryDate,
                                cardHolderName: cardHolderName,
                                cvvCode: cvvCode,
                                showBackView: isCvvFocused,
                                obscureCardNumber: true,
                                obscureCardCvv: true,
                                isHolderNameVisible: true,
                                onCreditCardWidgetChange: (CreditCardBrand) {
                                  cardType =
                                      CreditCardBrand.brandName.toString();
                                  print(cardType);
                                },
                              ),
                              CreditCardForm(
                                themeColor: AppColors.accent,
                                cardNumber: cardNumber,
                                expiryDate: expiryDate,
                                cardHolderName: cardHolderName,
                                cvvCode: cvvCode,
                                formKey: formKey,
                                onCreditCardModelChange:
                                    onCreditCardModelChange,
                                obscureCvv: true,
                                obscureNumber: true,
                                cardNumberDecoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Номер',
                                  hintText: 'XXXX XXXX XXXX XXXX',
                                ),
                                expiryDateDecoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Дата',
                                  hintText: 'XX/XX',
                                ),
                                cvvCodeDecoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'CVV',
                                  hintText: 'XXX',
                                ),
                                cardHolderDecoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'ФИО на карточке',
                                  hintText: 'ФИО',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.accent,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10), // <-- Radius
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate() == true) {
                                saveCardButtonAction();
                              }
                            },
                            child: const Text("Сохранить",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
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
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void saveCardButtonAction() async {
    cardNumber = cardNumber.replaceAll(' ', '');
    bool isValidCardNumber = await Cloudpayments.isValidNumber(cardNumber);
    bool isValidExpireDate = await Cloudpayments.isValidExpiryDate(expiryDate);

    if (isValidCardNumber && isValidExpireDate) {
      final cryptogram = await Cloudpayments.cardCryptogram(
          cardNumber: cardNumber,
          cardDate: expiryDate,
          cardCVC: cvvCode,
          publicId: 'pk_03c4a34922cc4734c0e2b7a46a62a');

      var response = await MainProvider().createCard(
        cardHolderName,
        cardNumber,
        expiryDate.substring(0, 2),
        expiryDate.substring(3, 5),
        cvvCode,
        1,
        cryptogram.cryptogram!,
        cardType == 'CardType.mastercard' ? 1 : 2,
      );
      if (response['response_status'] == 'ok') {
        print(response['data']);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['data']['message'],
              style: const TextStyle(fontSize: 14)),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Данная карта недействительна.",
            style: TextStyle(fontSize: 14)),
      ));
    }
  }
}
