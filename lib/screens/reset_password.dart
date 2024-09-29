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
// import 'package:deal_diligence/constants.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      //appBar: CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Reset Password',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 40.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _email = value;
                },
                decoration: const InputDecoration(hintText: 'Enter your email'),
              ),
              const SizedBox(
                height: 8.0,
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
    );
  }
}
