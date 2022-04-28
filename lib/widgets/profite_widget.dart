import 'package:flutter/material.dart';

class BuildColumn extends StatelessWidget {
  final int num;
  final String label;

  const BuildColumn({Key key, @required this.num, @required this.label})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 7),
          child: Text(
            num.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4, left: 15),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ),
      ],
    );
  }
}
