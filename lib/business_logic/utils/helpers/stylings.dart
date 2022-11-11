import 'package:flutter/material.dart';
import 'package:movie_db/business_logic/utils/helpers/extensions.dart';

class Styling {
  Styling._privateConstructor();

  final Color rhythm = const Color(0xFF6E7191);
  final Color seaGreen = const Color(0xFF2C9949);
  final Color gainsboro = const Color(0xFFD9DBE9);
  final Color purpleNavy = const Color(0xFF505588);
  final Color platinum = const Color(0xFFE5E5E5);
  final Color platinum2 = const Color(0xFFE6E6E6);
  final Color wageningenGreen = const Color(0xFF2C9937);
  final Color lotion = const Color(0xFFFCFCFC);
  final Color independence = const Color(0xFF4E4B66);
  final Color white = const Color(0xFFFFFFFF);
  final Color antiFlashWhite = const Color(0xFFEFF0F6);
  final Color ghostWhite = const Color(0xFFFCFCFC);
  final Color blueDeFrance = const Color(0xFF2F80ED);
  final Color eerieBlack = const Color(0xFF14142B);
  final Color cadetBlue = const Color(0xFFA0A3BD);
  final Color mediumSlateBlue = const Color(0xFF7974E7);
  final Color paleChestnut = const Color(0xFFECACAD);
  final Color royalOrange = const Color(0xFFF2994A);
  final Color richLilac = const Color(0xFFBB6BD9);
  final Color darkCharcoal = const Color(0xFF333333);
  final Color gray = const Color(0xFF807A7A);
  final Color veryLightBlue = const Color(0xFF5669FF);
  final Color charlestonGreen = const Color(0xFF252631);
  final Color fireOpal = const Color(0xFFEB5757);

  final Border borderPoint5 =
      Border.all(color: const Color(0xFFD9DBE9), width: 0.5);
  final Border borderPoint3 =
      Border.all(color: const Color(0xFFD9DBE9), width: 0.3);
  final Border border1 = Border.all(color: const Color(0xFFD9DBE9), width: 1.0);

  late TextStyle bodyTitleStyle;
  late TextStyle appBarTitleStyle;
  late TextStyle textInputStyle;
  late TextStyle bodySubTitleStyle;
  late TextStyle textInputHintStyle;
  late TextStyle textInputLabelStyle;
  late TextStyle button;
  late TextStyle overline;
  late TextStyle caption;

  static final Styling instance = Styling._privateConstructor();

  void init() {
    bodyTitleStyle = TextStyle(
      fontSize: 24.w(),
      fontWeight: FontWeight.w500,
      color: const Color(0xFF120D26),
    );
    appBarTitleStyle = TextStyle(
      fontSize: 18.w(),
      fontWeight: FontWeight.w500,
      color: const Color(0xFF120D26),
    );
    textInputStyle = TextStyle(
      fontSize: 16.w(),
      fontWeight: FontWeight.w500,
      color: independence,
    );
    bodySubTitleStyle = TextStyle(
      fontSize: 15.w(),
      height: 1.5.h(),
      fontWeight: FontWeight.w400,
      color: const Color(0xFF120D26),
    );
    textInputHintStyle = TextStyle(
      fontSize: 14.w(),
      fontWeight: FontWeight.w400,
      color: const Color(0xFF6E7191),
    );
    textInputLabelStyle = TextStyle(
      fontSize: 13.w(),
      fontWeight: FontWeight.w400,
      color: const Color(0xFF6E7191),
    );
    button = TextStyle(
      fontSize: 16.w(),
      fontWeight: FontWeight.w500,
    );
    overline = TextStyle(
      fontSize: 12.w(),
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );
    caption = TextStyle(
      fontSize: 10.w(),
      fontWeight: FontWeight.w400,
      color: const Color(0xFF6E7191),
    );
  }
}
