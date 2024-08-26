import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  AppToast._();
  static toastMessage(String message) {
    Fluttertoast.showToast(
      webPosition: "center",
      timeInSecForIosWeb: 3,
      webBgColor: "linear-gradient(to right, #FFC100, #FC4A00)",
      toastLength: Toast.LENGTH_SHORT,
      msg: message,
      webShowClose: true,
      // backgroundColor: AppColor.dark2.withOpacity(0.5),
      // textColor: AppColor.whiteColor,
    );
  }

  // we will utilise this for showing errors or success messages
  static snackBar(
    String message,
    BuildContext context,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // closeIconColor: AppColor.subTitleColor,
        duration: const Duration(seconds: 8),
        margin: const EdgeInsets.only(bottom: 120),
        // backgroundColor: AppColor.subTitleColor.withOpacity(0.5),
        content: Text(
          message,
          // style: Typo.w40014PoppinsLight.copyWith(color: AppColor.whiteColor),
          textAlign: TextAlign.center,
        )));
  }
}
