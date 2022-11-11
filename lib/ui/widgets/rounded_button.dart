import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {Key? key,
      required this.buttonColor,
      required this.buttonTitle,
      required this.buttonTitleColor,
      this.onTap,
      required this.titleFontSize})
      : super(key: key);
  final void Function()? onTap;
  final Color buttonColor;
  final String buttonTitle;
  final Color buttonTitleColor;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: buttonColor,),
        child: Center(
          child: onTap == null?const CircularProgressIndicator.adaptive():Text(
            buttonTitle,
            style: TextStyle(color: buttonTitleColor, fontSize: titleFontSize),
          ),
        ),
      ),
    );
  }
}
