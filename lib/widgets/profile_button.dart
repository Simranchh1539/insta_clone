import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final Function function;
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final Color borderColor;
  final double width;

  const ProfileButton(
      {Key key,
      this.function,
      @required this.backgroundColor,
      @required this.textColor,
      @required this.text,
      @required this.borderColor,
      @required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: function,
        child: Container(
          width: width,
          height: 36,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
