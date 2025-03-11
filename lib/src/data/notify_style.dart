import 'package:flutter/material.dart';

class FlutterSmartNotifyStyle {
  const FlutterSmartNotifyStyle({
    this.successBuilder,
    this.failureBuilder,
    this.warningBuilder,
    this.alertBuilder,
    this.errorBuilder,
  });

  final Widget Function(String msg, TextAlign? textAlign)? successBuilder;
  final Widget Function(String msg, TextAlign? textAlign)? failureBuilder;
  final Widget Function(String msg, TextAlign? textAlign)? warningBuilder;
  final Widget Function(String msg, TextAlign? textAlign)? alertBuilder;
  final Widget Function(String msg, TextAlign? textAlign)? errorBuilder;
}
