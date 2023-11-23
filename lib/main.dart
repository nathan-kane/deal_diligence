//*********************************************
//  Deal Diligence was designed and created by
//  Nathan Kane
//  copyright 2023
//*********************************************

import 'package:deal_diligence/firebase_options.dart';
//import 'package:deal_diligence/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:deal_diligence/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(
      child:
          DealDiligence())); // This allows the entire app to use River_Pod for state management
  //runApp(DealDiligence())));
}

class DealDiligence extends StatelessWidget {
  const DealDiligence({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
