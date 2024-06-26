//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

// ignore_for_file: dead_code, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison, use_build_context_synchronously

import 'package:deal_diligence/Providers/company_provider.dart';
import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deal_diligence/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/screens/reset_password.dart';
import 'package:deal_diligence/screens/user_register_screen.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deal_diligence/screens/widgets/my_appbar.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final companyRef = FirebaseFirestore.instance.collection('company');
final mlsRef = FirebaseFirestore.instance.collection('mls');
final _db = FirebaseFirestore.instance;

class LoginScreen extends ConsumerStatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  bool passwordVisible = false;

/* =========================================================== */

// Use this YouTube video for guidance: https://www.youtube.com/watch?v=k0zGEbiDJcQ
// and this YouTube video: https://www.youtube.com/watch?v=-XSLZgWEAzE

  //void initNotifications() async {
  // final _firebaseMessaging = FirebaseMessaging.instance;

  // await _firebaseMessaging.requestPermission();
  // final deviceToken = await _firebaseMessaging.getToken();

  // // Update the device token if it has changed.
  // if (deviceToken != ref.read(usersNotifierProvider).deviceToken) {
  //   ref.read(usersNotifierProvider.notifier).updateDeviceToken(deviceToken!);
  // }

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Message received when the app is in the foreground:');
  //   print('Title: ${message.notification?.title}');
  //   print('Body: ${message.notification?.body}');

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;

  //     // If `onMessage` is triggered with a notification, we display a dialog with the notification details.
  //     if (notification != null && android != null) {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text(notification.title ?? ''),
  //             content: SingleChildScrollView(
  //               child: ListBody(
  //                 children: [Text(notification.body ?? '')],
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 child: const Text('OK'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   });
  // });
  // // When the user taps on a notification and the app is opened.
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   // print('Message opened from system tray:');
  //   // print('Title: ${message.notification?.title}');
  //   // print('Body: ${message.notification?.body}');

  //   // Add any additional logic for handling the opened notification.
  // });
  //}

/* =========================================================== */

  @override
  void initState() {
    super.initState();
    passwordVisible = true;

    //initNotifications();
  }

  late String email;
  late String password;

  getCurrentUserName() async {
    final globals = ref.watch(globalsNotifierProvider);

    ref.read(globalsNotifierProvider.notifier).updatenewUser(false);

    final DocumentSnapshot _currentUserProfile =
        await usersRef.doc(globals.currentUid).get();

    if (_currentUserProfile != null) {
      ref
          .read(globalsNotifierProvider.notifier)
          .updatecompanyId(_currentUserProfile.get('companyId'));

      ref
          .read(globalsNotifierProvider.notifier)
          .updatecurrentCompanyState(_currentUserProfile.get('state'));
      ref
          .read(globalsNotifierProvider.notifier)
          .updatemlsId(_currentUserProfile.get('mlsId'));
      ref
          .read(globalsNotifierProvider.notifier)
          .updatecurrentUserState(_currentUserProfile.get('state'));

      // Update user notifier
      ref
          .read(usersNotifierProvider.notifier)
          .updateCellPhone(_currentUserProfile.get('cellPhone'));
      ref
          .read(usersNotifierProvider.notifier)
          .updateaddress1(_currentUserProfile.get('address1'));
      ref
          .read(usersNotifierProvider.notifier)
          .updateaddress2(_currentUserProfile.get('address2'));
      ref
          .read(usersNotifierProvider.notifier)
          .updateCompanyName(_currentUserProfile.get('company'));
      ref
          .read(usersNotifierProvider.notifier)
          .updateCompanyId(_currentUserProfile.get('companyId'));
      ref
          .read(usersNotifierProvider.notifier)
          .updateCity(_currentUserProfile.get('city'));
      ref
          .read(usersNotifierProvider.notifier)
          .updatelName(_currentUserProfile.get('lName'));
      ref
          .read(usersNotifierProvider.notifier)
          .updatefName(_currentUserProfile.get('fName'));
      ref
          .read(usersNotifierProvider.notifier)
          .updateOfficePhone(_currentUserProfile.get('officePhone'));
      ref
          .read(usersNotifierProvider.notifier)
          .updateState(_currentUserProfile.get('state'));
      ref
          .read(usersNotifierProvider.notifier)
          .updateZipcode(_currentUserProfile.get('zipCode'));
      ref
          .read(usersNotifierProvider.notifier)
          .updateMls(_currentUserProfile.get('mls'));
      ref
          .read(usersNotifierProvider.notifier)
          .updateMlsId(_currentUserProfile.get('mlsId'));
      ref
          .read(usersNotifierProvider.notifier)
          .updateEmail(_currentUserProfile.get('email'));
      ref
          .read(usersNotifierProvider.notifier)
          .updateDeviceToken(_currentUserProfile.get('token'));
    }

    // Save the device token just in case the user is using a different device
    ref.read(usersNotifierProvider.notifier).saveFcmToken(
        ref.read(globalsNotifierProvider).currentUserId!,
        '${ref.read(usersNotifierProvider).fName} ${ref.read(usersNotifierProvider).lName!}');

    final DocumentSnapshot _currentCompanyProfile =
        await companyRef.doc(ref.read(globalsNotifierProvider).companyId).get();

    if (_currentCompanyProfile != null) {
      ref
          .read(companyNotifierProvider.notifier)
          .updatestate(_currentCompanyProfile.get('state'));
      ref
          .read(companyNotifierProvider.notifier)
          .updateCompanyName(_currentCompanyProfile.get('name'));
      ref
          .read(companyNotifierProvider.notifier)
          .updateaddress1(_currentCompanyProfile.get('address1'));
      ref
          .read(companyNotifierProvider.notifier)
          .updateaddress2(_currentCompanyProfile.get('address2'));
      ref
          .read(companyNotifierProvider.notifier)
          .updatecity(_currentCompanyProfile.get('city'));
      ref
          .read(companyNotifierProvider.notifier)
          .updatestate(_currentCompanyProfile.get('state'));
      ref
          .read(companyNotifierProvider.notifier)
          .updatezipcode(_currentCompanyProfile.get('zipCode'));
      ref
          .read(companyNotifierProvider.notifier)
          .updateCellPhone(_currentCompanyProfile.get('cellPhone'));
      ref
          .read(companyNotifierProvider.notifier)
          .updateofficePhone(_currentCompanyProfile.get('officePhone'));
      ref
          .read(companyNotifierProvider.notifier)
          .updateemail(_currentCompanyProfile.get('email'));
      ref
          .read(companyNotifierProvider.notifier)
          .updatewebsite(_currentCompanyProfile.get('website'));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool loginFail = false;
    String errorMessage = "";
    //final globalVars = ref.watch(globalsNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      resizeToAvoidBottomInset: false, // This fixes the keyboard white space
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Login',
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
                  email = value;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: loginFail ? 'incorrect email' : null,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: passwordVisible,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: loginFail ? 'incorrect passwowrd' : null,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(
                        () {
                          passwordVisible = !passwordVisible;
                        },
                      );
                    },
                    icon: Icon(passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      UserCredential userCredential =
                          await _auth.signInWithEmailAndPassword(
                              email: email, password: password);

                      if (userCredential != null) {
                        // Set the global state
                        ref
                            .read(globalsNotifierProvider.notifier)
                            .updatecurrentUid(_auth.currentUser!.uid);
                        ref
                            .read(globalsNotifierProvider.notifier)
                            .updatecurrentUserId(_auth.currentUser!.uid);
                        ref
                            .read(globalsNotifierProvider.notifier)
                            .updatecurrentUEmail(_auth.currentUser!.email);
                        ref
                            .read(globalsNotifierProvider.notifier)
                            .updatetargetScreen(0);

                        await getCurrentUserName();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
                        );
                      } else {
                        setState(() {
                          loginFail = true;
                        });
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (error) {
                      if (error is FirebaseAuthException) {
                        //} on FirebaseAuthException catch (error) {
                        switch (error.code) {
                          case "ERROR_INVALID_EMAIL":
                          case "invalid-email":
                            errorMessage =
                                "Your email address appears to be malformed.";
                            break;
                          case "invalid-credential":
                            errorMessage =
                                "Wrong email or password. Please try again";
                            break;
                          case "email-already-in-use":
                            errorMessage = "Email is already in use.";
                            break;
                          case "ERROR_WRONG_PASSWORD":
                          case "wrong-password":
                            errorMessage = "Your password is wrong.";
                            break;
                          case "ERROR_USER_NOT_FOUND":
                          case "user-not-found":
                            errorMessage =
                                "User with this email doesn't exist.";
                            break;
                          case "ERROR_USER_DISABLED":
                          case "user-disabled":
                            errorMessage =
                                "User with this email has been disabled.";
                            break;
                          case "ERROR_TOO_MANY_REQUESTS":
                          case "too-many-requests":
                            errorMessage =
                                "Too many requests. Try again later.";
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
                      } else {
                        errorMessage = error.toString();
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        fontSize: 15),
                  )),
              TextButton(
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ResetPasswordScreen())),
              ),
              const SizedBox(
                height: 100.0,
              ),
              TextButton(
                child: const Text(
                  'New User?  Create Account',
                  style: TextStyle(fontSize: 15, color: Colors.blue),
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UserRegisterScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
