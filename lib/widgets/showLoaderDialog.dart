import 'package:flutter/material.dart';

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
