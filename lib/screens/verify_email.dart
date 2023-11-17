//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:riverpod/riverpod.dart';

import 'package:deal_diligence/screens/company_screen.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  static const String id = 'verify_email_screen';

  const VerifyEmailScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _auth = FirebaseAuth.instance;
  User? user;
  late Timer timer;

  @override
  void initState() {
    user = _auth.currentUser;
    user!.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(child: Text('Deal Diligence')),
      ),
      body: SafeArea(
        child: Center(
            child: Text(
                'An email has been sent to ${user!.email}...please verify')),
        //'An email has been sent to...please verify')),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = _auth.currentUser;
    await user!.reload();
    if (user!.emailVerified) {
      ref.read(globalsNotifierProvider.notifier).updatecurrentUid(user!.uid);
      ref.read(globalsNotifierProvider.notifier).updatecurrentUserId(user!.uid);
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const UserProfileScreen()));
    }
  }
}
