//*********************************************
//  Deal Diligence was designed and created by
//  Nathan Kane
//  copyright 2023
//*********************************************

// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
//import 'package:deal_diligence/constants.dart' as constants;
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  //String? _currentUserState;

  //List<DropdownMenuItem<String>>? _dropDownState;

  // List<DropdownMenuItem<String>> getDropDownState() {
  //   List<DropdownMenuItem<String>> items = [];
  //   for (String state in constants.kStates) {
  //     items.add(DropdownMenuItem(
  //         value: state,
  //         child: Text(
  //           state,
  //         )));
  //   }
  //   return items;
  // }

  void changedDropDownState(String? selectedState) {
    setState(() {
      //_currentUserState = selectedState;
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
    //_dropDownState = getDropDownState(); // Get the list of states
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
            padding: EdgeInsets.symmetric(horizontal: 30.sp),
            // Set the logo below
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                    child: Text(
                  'User Registration',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                )),
                SizedBox(height: 96.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(child: TextField(
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        fName = value; // Capture the value entered by the user
                      },
                      decoration: const InputDecoration(hintText: 'First Name'),
                    ),),
                    Expanded(child: TextField(
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        lName = value; // Capture the value entered by the user
                      },
                      decoration: const InputDecoration(hintText: 'Last Name'),
                    ),)
                    
                  ],
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
                SizedBox(height: 8.h,),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value; // Capture the value entered by the user
                  },
                  decoration:
                      const InputDecoration(hintText: 'Enter a new password'),
                ),
                SizedBox(height: 8.h,),
                // Center(
                //   child: DropdownButton(
                //     value: _currentUserState,
                //     items: _dropDownState,
                //     hint: const Text('Choose State'),
                //     onChanged: changedDropDownState,
                //   ),
                // ),
                // const SizedBox(
                //   height: 24.0,
                // ),
                TextButton(
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 15.sp, color: Colors.blue),
                  ),
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });

                    /// The actual registration takes place in the StripePaymentScreen file

                    ref.read(usersNotifierProvider.notifier).updatefName(fName);
                    ref.read(usersNotifierProvider.notifier).updatelName(lName);
                    ref.read(usersNotifierProvider.notifier).updateEmail(email);

                    ref
                        .read(globalsNotifierProvider.notifier)
                        .updatenewUser(true);

                    // Setup payments
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            StripePaymentScreen(email, password)));
                    setState(() {
                      showSpinner = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
