import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Color(0xFF2B2B2B);
  static const Color blackWithOpacity = Colors.black45;
  static const Color accent = Color(0xFFE56553);
  static const Color white = Color(0xFFffffff);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color grey = Color(0xFFE7E7E7);
  static const Color main = Color(0xFF4546c0);
}

class AppConstants {
  static const String baseUrl = "http://back.pana.world/";
  static String appVersion = '0.1';
  static double cardBorderRadius = 24;
  static List<String> countries = [
    "Казахстан",
    "Россия",
    "Узбекистан",
    "Турция",
    "ОАЭ"
  ];
}
