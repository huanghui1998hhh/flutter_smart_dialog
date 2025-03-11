import 'package:flutter/material.dart';

import '../../kit/view_utils.dart';

class NotifyAlter extends StatelessWidget {
  const NotifyAlter({
    Key? key,
    required this.msg,
    this.textAlign,
  }) : super(key: key);

  final String msg;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ThemeStyle.backgroundColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          Icons.priority_high_outlined,
          size: 22,
          color: ThemeStyle.textColor,
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Text(
            msg,
            style: TextStyle(color: ThemeStyle.textColor),
            textAlign: textAlign,
          ),
        ),
      ]),
    );
  }
}
