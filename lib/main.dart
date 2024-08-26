//*********************************************
//  Deal Diligence was designed and created by
//  Nathan Kane
//  copyright 2023
//*********************************************

import 'package:deal_diligence/firebase_options.dart';
import 'package:deal_diligence/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Stripe API
  // Assign publishable key to flutter_stripe
   Stripe.publishableKey =
       "pk_test_51OOkCzLLjsDD7g7b0sBcRBgQvaimzoiBHdg3NK7UOqXvbml1WwnaZC4OdF5ncpwyStO1CFpWmUuwHAxhwM95O5G000Qp2heWf9";

  //Load the .env file that contains the Stripe Secret key
  await dotenv.load(fileName: "lib/assets/.env");

  runApp(const ProviderScope(
      child:
          DealDiligence())); // This allows the entire app to use River_Pod for state management
}
   final rootNavigatorKey = GlobalKey<NavigatorState>();

class DealDiligence extends StatelessWidget {
  const DealDiligence({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
                  navigatorKey: rootNavigatorKey,

    );
  }
}
