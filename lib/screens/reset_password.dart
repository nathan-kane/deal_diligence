//*********************************************
//  Deal Diligence was designed and created by
//  Nathan Kane
//  copyright 2023
//*********************************************

// ignore_for_file: library_private_types_in_public_api, unused_field

import 'package:deal_diligence/components/rounded_button.dart';
import 'package:flutter/material.dart';
//import 'package:tonnah/Services/firestore_service.dart';
//import 'package:deal_diligence/components/rounded_button.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:deal_diligence/screens/agent_dash_board.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String id = 'reset_password_screen';

  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;

  late String _email;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ensureScreenSize: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          //appBar: CustomAppBar(),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: constants.kTitleTextFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 48.h,
                  ),
                  TextField(
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: constants.kTextFieldTextFontSize),
                    onChanged: (value) {
                      _email = value;
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter your email',
                        labelStyle: TextStyle(
                            fontSize: constants.kTextFieldHintFontSize)),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  RoundedButton(
                      title: 'Send Reset Password Request',
                      colour: Colors.lightBlueAccent,
                      onPressed: () {
                        _auth.sendPasswordResetEmail(email: _email);
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
