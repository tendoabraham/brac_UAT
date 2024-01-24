import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  Alignment? alignment;

  AppLogo({this.alignment = Alignment.center, super.key});

  @override
  Widget build(BuildContext context) => Container(
      alignment: alignment,
      child: Image.asset(
        "assets/images/brac.png",
        height: 160,
        width: 180,
        fit: BoxFit.fitWidth,
      ));
}

class Label extends StatelessWidget {
  final String text;
  double? fontSize;
  Color? textColor;
  FontWeight? fontWeight;

  Label(
      {super.key,
      required this.text,
      this.fontSize = 12,
      this.textColor = Colors.black,
      this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
            fontSize: fontSize, color: textColor, fontFamily: 'Mulish', fontWeight: fontWeight),
      );
}
