import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/utils/const.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EpayWebViewPage extends StatefulWidget {
  final Map<String, dynamic> paymentData;
  EpayWebViewPage(this.paymentData);

  @override
  _EpayWebViewPageState createState() => _EpayWebViewPageState();
}

class _EpayWebViewPageState extends State<EpayWebViewPage> {
  late WebViewController _webViewController;
  final webViewKey = UniqueKey();

  String htmlString = '';

  @override
  void initState() {
    Map<String, dynamic> paymentObject = widget.paymentData;
    paymentObject['language'] = "rus";
    paymentObject['description'] = "Оплата Pana";

    print('<--------------->');
    print(jsonEncode(paymentObject));
    print('<--------------->');

    htmlString = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport"
            content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
      <meta http-equiv="X-UA-Compatible" content="ie=edge">
      <title>Pana</title>
      <script src="https://epay.homebank.kz/payform/payment-api.js"></script>
      <script>
        
        document.addEventListener('DOMContentLoaded', function() {
          halyk.showPaymentWidget(createPaymentObject(${jsonEncode(paymentObject['auth']['access_token'])}, ${jsonEncode(paymentObject['auth']['expires_in'])}, ${jsonEncode(paymentObject['invoiceId'])}, ${jsonEncode(paymentObject['amount'])}
          , ${jsonEncode(paymentObject['backLink'])}, ${jsonEncode(paymentObject['failureBackLink'])}, ${jsonEncode(paymentObject['postLink'])}, ${jsonEncode(paymentObject['accountId'])}, ${jsonEncode(paymentObject['terminal'])}, ${jsonEncode(paymentObject['description'])}), callBk);
        });
        
        function createPaymentObject(accessToken, expiresIn, invoiceId, amount, backLink, failureBackLink, postLink, accountId, terminalId, description) {
            var paymentObject = {
              invoiceId: invoiceId,
              backLink: backLink,
              failureBackLink: failureBackLink,
              postLink: postLink,
              failurePostLink: "https://back.pana.world/api/payment/postLink",
              language: "rus",
              description: description,
              accountId: accountId,
              terminal: terminalId,
              amount: amount,
              currency: "KZT",
              cardSave: true,
              auth: {
                "access_token": accessToken,
                "expires_in": expiresIn,
                "refresh_token": "",
                "scope": "payment",
                "token_type": "Bearer"
              }
            };
            return paymentObject;
        };
        
        function callBk(response) {
          var data = { message: 'callbackMethod', payload: response };
          window.flutterChannel.postMessage(JSON.stringify(data));
        }
      </script>
    </head>
    <body>
      <!-- <div class="loader"></div> -->
    </body>
    <style>
      .loader {
        border: 16px solid #f3f3f3; /* Light grey */
        border-top: 16px solid #1A601A; /* Blue */
        border-radius: 50%;
        width: 120px;
        height: 120px;
        animation: spin 2s linear infinite;
        margin: auto;
      }
      
      @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }
    </style>
    </html>
  ''';

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'flutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          var jsonData = message.message;
          var data = jsonDecode(jsonData);
          if (data['message'] == 'callbackMethod') {
            var payload = data['payload'];
            callbackMethod(payload);
          }
        },
      )
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.dataFromString(
        htmlString,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')!,
      ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
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
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset('assets/icons/back_arrow.svg'),
                    ),
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
          SizedBox(
            height: 600,
            child: WebViewWidget(
              controller: _webViewController,
              key: webViewKey,
            ),
          ),
        ],
      ),
    );
  }

  void callbackMethod(dynamic data) {
    print(data);
    if (data['success'] == true) {
      Navigator.of(context).pop('Success');
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => TabBarPage(2)),
      //         (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pop('Error');
    }
  }
}
