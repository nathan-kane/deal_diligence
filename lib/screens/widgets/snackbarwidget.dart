//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String snackMessage;
  final Color snackColor;

  const CustomSnackBar(
      {super.key, required this.snackMessage, required this.snackColor});

  @override
  Widget build(BuildContext context) => SnackBar(
        content: Center(
          child: Text(
            snackMessage,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w900),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          left: 10,
          right: 10,
        ),
        backgroundColor: snackColor,
      );
}
