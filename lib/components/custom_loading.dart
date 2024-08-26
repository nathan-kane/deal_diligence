import 'dart:async';
import 'package:deal_diligence/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// final loadingStateProvider = StateProvider<bool>((ref) => false);

class LoadingScreenOL {
  static final LoadingScreenOL _instance = LoadingScreenOL._internal();
  factory LoadingScreenOL() {
    return _instance;
  }
  LoadingScreenOL._internal();

  // static final GlobalKey<NavigatorState> navigatorKey =
  //     GlobalKey<NavigatorState>();

  OverlayEntry? _overlayEntry;
  Timer? _timer;
   int _loadingCount = 0; // Reference counter
  show() {
    _loadingCount++;
     if (_loadingCount == 1 && _overlayEntry == null) {
    _overlayEntry = OverlayEntry(
      builder: (context) => const Material(
        color: Colors.transparent,
        child: Center(
          child: Column(
            children: [
              LinearProgressIndicator(
                // valueColor: AlwaysStoppedAnimation<Color>(AppColor.black),
                // backgroundColor: AppColor.appColor,
              ),
              Expanded(
                  child: Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  color: Colors.white,
                ),
              ))
            ],
          ),
        ),
      ),
    );

rootNavigatorKey.currentState?.overlay?.insert(_overlayEntry!);

    // Schedule hiding after 10 minutes
    // _timer = Timer(const Duration(seconds: 60), () {
    //   hide();
    // });
     }
  }

  // void hide() {
  //   _timer?.cancel();
  //   _overlayEntry?.remove();
  //   _overlayEntry = null;    
  // }

  void hide() {
  if (_loadingCount > 0) {
    _loadingCount--;
  }

  if (_loadingCount == 0) {
    Future.delayed(const Duration(milliseconds: 300), () {
      // Delay the hide call to prevent flickering
      _timer?.cancel();
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }
}

  void reset() {
    _loadingCount = 0;
    hide();
  }
}