import 'package:flutter/material.dart';

import '../../kit/view_utils.dart';

class NotifyError extends StatelessWidget {
  const NotifyError({
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
        Icon(Icons.error_outline, size: 22, color: ThemeStyle.textColor),
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
