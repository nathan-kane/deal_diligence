// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'dart:developer';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/user_provider.dart';
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
  ConsumerState<StripePaymentScreen> createState() => _StripePaymentScreenState();
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
                  await makePayment();

                  /// Register the new user
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: widget.email, password: widget.password);
                    if (newUser != null) {
                        ref
                            .read(usersNotifierProvider.notifier)
                            .updateuserID(newUser.user!.uid);
                      //   ref
                      //       .read(globalsNotifierProvider.notifier)
                      //       .updatecurrentUserId(newUser.user!.uid);
                        ref
                            .read(usersNotifierProvider.notifier)
                            .updateEmail(newUser.user!.email!);
                        ref
                            .read(globalsNotifierProvider.notifier)
                            .updatenewUser(true);
                        ref
                            .read(globalsNotifierProvider.notifier)
                            .updatenewCompany(true);

                        /// Send the email verification
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const VerifyEmailScreen()));
                    } else {
                      setState(() {
                        registrationFail = true;
                      });
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } on FirebaseAuthException catch (error) {
                    switch (error.code) {
                      case "ERROR_INVALID_EMAIL":
                      case "invalid-email":
                        errorMessage =
                            "Your email address appears to be malformed.";
                        break;
                      case "email-already-in-use":
                        errorMessage = "Email is already in use.";
                        break;
                      case "ERROR_WRONG_PASSWORD":
                      case "wrong-password":
                        errorMessage = "Your password is wrong.";
                        break;
                      case "weak-password":
                        errorMessage = "Weak password";
                        break;
                      case "ERROR_USER_NOT_FOUND":
                      case "user-not-found":
                        errorMessage = "User with this email doesn't exist.";
                        break;
                      case "ERROR_USER_DISABLED":
                      case "user-disabled":
                        errorMessage =
                            "User with this email has been disabled.";
                        break;
                      case "ERROR_TOO_MANY_REQUESTS":
                      case "too-many-requests":
                        errorMessage = "Too many requests. Try again later.";
                        break;
                      case "ERROR_OPERATION_NOT_ALLOWED":
                      case "operation-not-allowed":
                        errorMessage =
                            "Signing in with Email and Password is not enabled.";
                        break;
                      default:
                        errorMessage =
                            "An undefined Error happened. Please try again.";
                    }

                    if (errorMessage != "") {
                      ScaffoldMessenger.of(context).showSnackBar((SnackBar(
                        content: Center(
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height - 100,
                          left: 10,
                          right: 10,
                        ),
                        backgroundColor: Colors.redAccent,
                      )
                      )
                      ); 
                    }
                  }
                }
              ),
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
      var secretKey = 
          dotenv.env["STRIPE_SECRET"]; 
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
