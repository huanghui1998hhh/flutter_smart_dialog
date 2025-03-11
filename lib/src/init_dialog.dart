import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_smart_dialog/src/helper/navigator_observer.dart';
import 'package:flutter_smart_dialog/src/kit/view_utils.dart';
import 'package:flutter_smart_dialog/src/widget/default/notify_alter.dart';
import 'package:flutter_smart_dialog/src/widget/default/notify_error.dart';
import 'package:flutter_smart_dialog/src/widget/default/notify_failure.dart';

import 'helper/dialog_proxy.dart';
import 'helper/pop_monitor/boost_route_monitor.dart';
import 'helper/pop_monitor/monitor_pop_route.dart';
import 'widget/default/loading_widget.dart';
import 'widget/default/notify_success.dart';
import 'widget/default/notify_warning.dart';
import 'widget/default/toast_widget.dart';

typedef FlutterSmartToastBuilder = Widget Function(
    String msg, TextAlign? textAlign);
typedef FlutterSmartLoadingBuilder = Widget Function(
    String msg, TextAlign? textAlign);
typedef FlutterSmartStyleBuilder = Widget Function(Widget child);

class FlutterSmartDialog extends StatefulWidget {
  const FlutterSmartDialog({
    Key? key,
    required this.child,
    this.toastBuilder,
    this.loadingBuilder,
    this.notifyStyle,
    this.styleBuilder,
    this.initType,
  }) : super(key: key);

  final Widget? child;

  ///set default toast widget
  final FlutterSmartToastBuilder? toastBuilder;

  ///set default loading widget
  final FlutterSmartLoadingBuilder? loadingBuilder;

  ///set default notify style
  final FlutterSmartNotifyStyle? notifyStyle;

  ///Compatible with cupertino style
  final FlutterSmartStyleBuilder? styleBuilder;

  ///inti type
  final Set<SmartInitType>? initType;

  @override
  State<FlutterSmartDialog> createState() => _FlutterSmartDialogState();

  static SmartNavigatorObserver get observer => SmartNavigatorObserver();

  ///Compatible with flutter_boost
  static Route<dynamic>? boostMonitor(Route<dynamic>? route) =>
      BoostRouteMonitor.instance.push(route);

  ///recommend the way of init
  static TransitionBuilder init({
    TransitionBuilder? builder,
    //set default toast widget
    FlutterSmartToastBuilder? toastBuilder,
    //set default loading widget
    FlutterSmartLoadingBuilder? loadingBuilder,
    //set default notify style
    FlutterSmartNotifyStyle? notifyStyle,
    //Compatible with cupertino style
    FlutterSmartStyleBuilder? styleBuilder,
    //init type
    Set<SmartInitType>? initType,
  }) {
    MonitorPopRoute.instance;

    return (BuildContext context, Widget? child) {
      return builder == null
          ? FlutterSmartDialog(
              toastBuilder: toastBuilder,
              loadingBuilder: loadingBuilder,
              notifyStyle: notifyStyle,
              styleBuilder: styleBuilder,
              initType: initType,
              child: child,
            )
          : builder(
              context,
              FlutterSmartDialog(
                toastBuilder: toastBuilder,
                loadingBuilder: loadingBuilder,
                notifyStyle: notifyStyle,
                styleBuilder: styleBuilder,
                initType: initType,
                child: child,
              ),
            );
    };
  }
}

class _FlutterSmartDialogState extends State<FlutterSmartDialog> {
  late FlutterSmartStyleBuilder styleBuilder;
  late Set<SmartInitType> initType;

  @override
  void initState() {
    ViewUtils.addSafeUse(() {
      try {
        BuildContext? context;
        if (widget.child is Navigator) {
          context = getNavigatorContext(widget.child as Navigator);
        } else if (widget.child is FocusScope) {
          var focusScope = widget.child as FocusScope;
          if (focusScope.child is Navigator) {
            context = getNavigatorContext(focusScope.child as Navigator);
          }
        }
        DialogProxy.contextNavigator = context;
      } catch (_) {}
    });

    // init param
    styleBuilder = widget.styleBuilder ??
        (Widget child) => Material(color: Colors.transparent, child: child);
    initType = widget.initType ??
        {
          SmartInitType.custom,
          SmartInitType.attach,
          SmartInitType.loading,
          SmartInitType.toast,
          SmartInitType.notify,
        };

    // solve Flutter Inspector -> select widget mode function failure problem
    DialogProxy.instance.initialize(initType);

    // default toast / loading / notify
    if (initType.contains(SmartInitType.toast)) {
      DialogProxy.instance.toastBuilder = widget.toastBuilder ??
          (String msg, TextAlign? textAlign) =>
              ToastWidget(msg: msg, textAlign: textAlign);
    }
    if (initType.contains(SmartInitType.loading)) {
      DialogProxy.instance.loadingBuilder = widget.loadingBuilder ??
          (String msg, TextAlign? textAlign) =>
              LoadingWidget(msg: msg, textAlign: textAlign);
    }
    if (initType.contains(SmartInitType.notify)) {
      var notify = widget.notifyStyle;
      DialogProxy.instance.notifyStyle = FlutterSmartNotifyStyle(
        successBuilder: notify?.successBuilder ??
            (msg, textAlign) => NotifySuccess(msg: msg, textAlign: textAlign),
        failureBuilder: notify?.failureBuilder ??
            (msg, textAlign) => NotifyFailure(msg: msg, textAlign: textAlign),
        warningBuilder: notify?.warningBuilder ??
            (msg, textAlign) => NotifyWarning(msg: msg, textAlign: textAlign),
        alertBuilder: notify?.alertBuilder ??
            (msg, textAlign) => NotifyAlter(msg: msg, textAlign: textAlign),
        errorBuilder: notify?.errorBuilder ??
            (msg, textAlign) => NotifyError(msg: msg, textAlign: textAlign),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return styleBuilder(
      Overlay(initialEntries: [
        //main layout
        OverlayEntry(
          builder: (BuildContext context) {
            if (initType.contains(SmartInitType.custom)) {
              DialogProxy.contextCustom = context;
            }

            if (initType.contains(SmartInitType.attach)) {
              DialogProxy.contextAttach = context;
            }

            if (initType.contains(SmartInitType.notify)) {
              DialogProxy.contextNotify = context;
            }

            if (initType.contains(SmartInitType.toast)) {
              DialogProxy.contextToast = context;
            }

            return widget.child ?? Container();
          },
        ),

        // if (initType.contains(SmartInitType.notify))
        //   DialogProxy.instance.entryNotify,

        //provided separately for loading
        if (initType.contains(SmartInitType.loading))
          DialogProxy.instance.entryLoading,
      ]),
    );
  }

  BuildContext? getNavigatorContext(Navigator navigator) {
    BuildContext? context;
    if (navigator.key is GlobalKey) {
      context = (navigator.key as GlobalKey).currentContext;
    }
    return context;
  }
}
