// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'dart:developer';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:deal_diligence/screens/stripe_payment_module/add_payment_via_card.dart';
import 'package:deal_diligence/screens/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePaymentScreen extends ConsumerStatefulWidget {
  final String email;
  final String password;

  const StripePaymentScreen(this.email, this.password, {super.key});

  @override
  ConsumerState<StripePaymentScreen> createState() =>
      _StripePaymentScreenState();
}

class _StripePaymentScreenState extends ConsumerState<StripePaymentScreen> {
  Map<String, dynamic>? paymentIntent;
  bool showSpinner = false;
  bool registrationFail = false;
  String errorMessage = "";
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Monthly subscription is 15.00 USD'),
            TextButton(
                child: const Text('Subscribe Now!'),
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          AddPaymentViaCard(widget.email, widget.password)));
                  // await makePayment();

                  /// Register the new user
                }),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      // Create payment intent data
      paymentIntent = await createPaymentIntent('15', 'USD');
      // initialise the payment sheet setup
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Client secret key from payment data
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          googlePay: const PaymentSheetGooglePay(
              // Currency and country code is accourding to India
              testEnv: true,
              currencyCode: "USD",
              merchantCountryCode: "US"),
          // Merchant Name
          merchantDisplayName: 'Deal Diligence',
          // return URl if you want to add
          // returnURL: 'flutterstripe://redirect',
        ),
      );
      // Display payment sheet
      displayPaymentSheet();
    } catch (e) {
      print("exception $e");

      if (e is StripeConfigException) {
        print("Stripe exception ${e.message}");
      } else {
        print("exception $e");
      }
    }
  }

  displayPaymentSheet() async {
    try {
      // "Display payment sheet";
      await Stripe.instance.presentPaymentSheet();
      // Show when payment is done
      // Displaying snackbar for it
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Paid successfully")),
      );
      paymentIntent = null;
    } on StripeException catch (e) {
      // If any error comes during payment
      // so payment will be cancelled
      print('Error: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(" Payment Cancelled")),
      );
    } catch (e) {
      print("Error in displaying");
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((int.parse(amount)) * 100).toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var secretKey = dotenv.env["STRIPE_SECRET"];
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('Payment Intent Body: ${response.body.toString()}');
      return jsonDecode(response.body.toString());
    } catch (err) {
      print('Error charging user: ${err.toString()}');
    }
  }
}
