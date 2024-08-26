//*********************************************
//  Deal Diligence was designed and created by
//  Nathan Kane
//  copyright 2023
//*********************************************

// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:deal_diligence/screens/verify_email.dart';
import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:deal_diligence/screens/stripe_payment_screen.dart';

class UserRegisterScreen extends ConsumerStatefulWidget {
  static const String id = 'registration_screen';

  const UserRegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends ConsumerState<UserRegisterScreen> {
  // final _auth = FirebaseAuth.instance;
  String? _currentUserState;

  List<DropdownMenuItem<String>>? _dropDownState;

  List<DropdownMenuItem<String>> getDropDownState() {
    List<DropdownMenuItem<String>> items = [];
    for (String state in constants.kStates) {
      items.add(DropdownMenuItem(
          value: state,
          child: Text(
            state,
          )));
    }
    return items;
  }

  void changedDropDownState(String? selectedState) {
    setState(() {
      _currentUserState = selectedState;
      ref.read(usersNotifierProvider.notifier).updateState(selectedState!);

      // Remove the globals
      ref
          .read(globalsNotifierProvider.notifier)
          .updateselectedUserState(selectedState);
      ref
          .read(globalsNotifierProvider.notifier)
          .updatecurrentUserState(selectedState);
    });
  }

  @override
  void initState() {
    super.initState();
    _dropDownState = getDropDownState(); // Get the list of states
  }

  bool showSpinner = false;
  bool registrationFail = false;
  String errorMessage = "";
  late String fName;
  late String lName;
  late String email;
  late String password;
  //String _chosenAgency = "Create New Agency";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //appBar: CustomAppBar(),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            // Set the logo below
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Center(
                    child: Text(
                  'User Registration',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 30.0,
                  ),
                )),
                const SizedBox(
                  height: 48.0,
                ),
                const SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    fName = value; // Capture the value entered by the user
                  },
                  decoration:
                      const InputDecoration(hintText: 'First Name'),
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    lName = value; // Capture the value entered by the user
                  },
                  decoration:
                      const InputDecoration(hintText: 'Last Name'),
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value; // Capture the value entered by the user
                  },
                  decoration:
                      const InputDecoration(hintText: 'Enter your email'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value; // Capture the value entered by the user
                  },
                  decoration:
                      const InputDecoration(hintText: 'Enter a new password'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Center(
                  child: DropdownButton(
                    value: _currentUserState,
                    items: _dropDownState,
                    hint: const Text('Choose State'),
                    onChanged: changedDropDownState,
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                TextButton(
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {

                      /// The actual registration takes place in the StripePaymentScreen file
                      
                      ref.read(usersNotifierProvider.notifier).updatefName(fName);
                      ref.read(usersNotifierProvider.notifier).updatelName(lName);

                      // Setup payments
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => StripePaymentScreen(email, password)));

                      // final newUser =
                      //     await _auth.createUserWithEmailAndPassword(
                      //         email: email, password: password);
                      // if (newUser != null) {
                      //   ref
                      //       .read(globalsNotifierProvider.notifier)
                      //       .updatecurrentUid(newUser.user!.uid);
                      //   ref
                      //       .read(globalsNotifierProvider.notifier)
                      //       .updatecurrentUserId(newUser.user!.uid);
                      //   ref
                      //       .read(globalsNotifierProvider.notifier)
                      //       .updatecurrentUEmail(newUser.user!.email);
                      //   ref
                      //       .read(globalsNotifierProvider.notifier)
                      //       .updatenewUser(true);
                      //   ref
                      //       .read(globalsNotifierProvider.notifier)
                      //       .updatenewCompany(true);

                      //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //       builder: (context) => const VerifyEmailScreen()));
                      // } else {
                      //   setState(() {
                      //     registrationFail = true;
                      //   });
                      // }
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
                        )));
                      }
                    }
                  },
                  // onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => VerifyEmailScreen())),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}
