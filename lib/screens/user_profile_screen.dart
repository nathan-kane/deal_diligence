//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

// ignore_for_file: no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:deal_diligence/components/rounded_button.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:deal_diligence/screens/company_screen.dart';
import 'package:deal_diligence/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final usersRef = FirebaseFirestore.instance.collection(('users'));
final companyRef = FirebaseFirestore.instance.collection(('company'));
var maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')});

class UserProfileScreen extends ConsumerStatefulWidget {
  static const String id = 'user_profile_screen';
  final Users? users;
  final bool? isNewUser;

  const UserProfileScreen([this.isNewUser, this.users]);

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool isChecked = false;
  Users newUser = Users();
  late String email;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final cellPhoneController = TextEditingController();
  final officePhoneController = TextEditingController();
  final companyController = TextEditingController();
  final mlsController = TextEditingController();

  // Dispose of all the TextControllers when done using them so they don't consume memory
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fNameController.dispose();
    lNameController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    cellPhoneController.dispose();
    officePhoneController.dispose();
    companyController.dispose();
    mlsController.dispose();
    super.dispose();
  }

  bool showSpinner = false;

  String? _currentUserState = '';
  String? currentBusinessType = '';

  String? _selectedCompany; // This is the company assigned to new user
  String? _selectedMls;

  getCurrentUserProfile() async {
    //String currentCompanyId = ref.read(globalsNotifierProvider).companyId!;

    //if (widget.isNewUser == true) {
    if (ref.read(globalsNotifierProvider).newUser == true) {
      /// This is a new user so you will only have access to their login info
      fNameController.text = ref.read(usersNotifierProvider).fName!;
      lNameController.text = ref.read(usersNotifierProvider).lName!;
      emailController.text = ref.read(usersNotifierProvider).email!;
    } else if (widget.isNewUser == true) {
      /// This is a current user trying to add a new user from the sidebar menu
      fNameController.text = "";
      lNameController.text = "";
      emailController.text = "";
    }
    else {
      /// This is an existing user so get the info from the db
      // final DocumentSnapshot currentUserProfile = await usersRef
      //     .doc(ref.read(globalsNotifierProvider).currentUserId)
      //     .get();

      // existing record
      // Updates Controllers
      emailController.text = ref.read(usersNotifierProvider).email ?? "";
      fNameController.text = ref.read(usersNotifierProvider).fName ?? "";
      lNameController.text = ref.read(usersNotifierProvider).lName ?? "";
      address1Controller.text = ref.read(usersNotifierProvider).address1 ?? "";
      address2Controller.text = ref.read(usersNotifierProvider).address2 ?? "";
      cityController.text = ref.read(usersNotifierProvider).city ?? "";
      _currentUserState = ref.read(usersNotifierProvider).userState ?? "";

      zipController.text = ref.read(usersNotifierProvider).zipCode.toString();
      cellPhoneController.text =
          ref.read(usersNotifierProvider).cellPhone ?? "";
      officePhoneController.text =
          ref.read(usersNotifierProvider).officePhone ?? "";
      companyController.text = ref.read(usersNotifierProvider).companyId ?? "";
      mlsController.text = ref.read(usersNotifierProvider).mls ?? "";
    }
  }

  List<DropdownMenuItem<String>>? dropDownBusiness;

  List<DropdownMenuItem<String>> getDropDownBusiness() {
    List<DropdownMenuItem<String>> itemsBusiness = [];
    for (String business in constants.kBusinessType) {
      itemsBusiness.add(DropdownMenuItem(
          value: business,
          child: Text(
            business,
          )));
    }
    return itemsBusiness;
  }

  void changedDropDownBusinessType(String? selectedBusinessType) {
    setState(() {
      currentBusinessType = selectedBusinessType;
      newUser.businessType = selectedBusinessType;
      ref
          .read(globalsNotifierProvider.notifier)
          .updateUserBusinessType(selectedBusinessType!);
      ref
          .read(usersNotifierProvider.notifier)
          .updateState(selectedBusinessType);
    });
  }

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
      newUser.userState = selectedState;
      ref
          .read(globalsNotifierProvider.notifier)
          .updateselectedUserState(selectedState!);
      ref
          .read(globalsNotifierProvider.notifier)
          .updatecurrentUserState(selectedState);
      ref.read(usersNotifierProvider.notifier).updateState(selectedState);
    });
  }

  void changedDropDownCompany(String? selectedCompany) {
    setState(() {
      //_currentCompany = selectedCompany;
      newUser.companyId = selectedCompany;
      ref
          .read(globalsNotifierProvider.notifier)
          .updateSelectedCompany(selectedCompany!);
      ref
          .read(globalsNotifierProvider.notifier)
          .updatecurrentCompanyName(selectedCompany);
    });
  }

  void changedDropDownMls(String? selectedMls) {
    setState(() {
      //_currentMlsId = selectedMls;
      newUser.mlsId = selectedMls;
      ref.read(globalsNotifierProvider.notifier).updatemlsId(selectedMls!);
    });
  }

  double tileText = 14.sp;

  @override
  void initState() {
    //if (widget.isNewUser == false) {

    if (kIsWeb == true) {
      tileText = 10.sp;
    } else {
      tileText = 14.sp;
    }

    getCurrentUserProfile();
    //}

    if (ref.read(globalsNotifierProvider).currentUserState == "" ||
        ref.read(globalsNotifierProvider).currentUserState == null) {
      _currentUserState = 'AZ';
    } else {
      _currentUserState = ref.read(globalsNotifierProvider).currentUserState;
    }
    if (ref.read(usersNotifierProvider).companyId != "") {
      _selectedCompany = ref.read(usersNotifierProvider).companyId;
    }

    // _currentCompanyState =
    //     ref.read(globalsNotifierProvider).currentCompanyState;

    if (ref.read(usersNotifierProvider).mlsId != null &&
        ref.read(usersNotifierProvider).mlsId != "") {
      _selectedMls = ref.read(usersNotifierProvider).mlsId;
    }

    super.initState();

    _dropDownState = getDropDownState(); // Get the list of states
  }

  // Future sendNewUserEmail() async {
  //   //final api = GoogleAuthApi();
  //   //final googleUser = await api.signIn();
  //   const accessToken = '';

  //   final smtpServer = gmailSaslXoauth2('nkane1234@gmail.com', accessToken);
  //   final message = Message()
  //     ..from = const Address("nkane1234@gmail.com", "Deal Diligence")
  //     ..recipients = ['nkane1234@gmail.com']
  //     ..subject = "Welcome to Deal Diligence"
  //     ..text = "Welcome to Deal Diligence. Your password is D3@lDiligence";

  //   try {
  //     await send(message, smtpServer);

  //     //showSnackBar('Invitation email successfully sent');
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar((const SnackBar(
  //         content: CustomSnackBar(
  //             snackColor: Colors.red,
  //             snackMessage: 'Email was sent successfully'))));
  //   } on MailerException catch (e) {
  //     debugPrint(e.toString());
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar((SnackBar(
  //         content: CustomSnackBar(
  //             snackColor: Colors.red,
  //             snackMessage: 'Email did not sent, $e'))));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //final _firestoreService = FirestoreService();

    return ScreenUtilInit(
      ensureScreenSize: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          //appBar: CustomAppBar(),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.sp),
                child: Column(
                  children: <Widget>[
                    Text(
                      'User Profile',
                      style: TextStyle(
                        fontSize: tileText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    // Email entry text field
                    TextField(
                      textCapitalization: TextCapitalization.words,
                      controller: fNameController,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        // ref.read(usersNotifierProvider.notifier).updatefName(value);
                        newUser.fName = value;
                      },
                      decoration: const InputDecoration(
                          hintText: 'First Name', labelText: 'First Name'),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    TextField(
                      textCapitalization: TextCapitalization.words,
                      controller: lNameController,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        // ref.read(usersNotifierProvider.notifier).updatelName(value);
                        newUser.lName = value;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Last Name', labelText: 'Last Name'),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        // Get a list of available companies to assign the new user to a company
                        stream: _db.collection('company').snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          List<DropdownMenuItem<String>> companyItems = [];
                          if (snapshot.hasData) {
                            final companyList = snapshot.data.docs;
                            for (var company in companyList) {
                              companyItems.add(
                                DropdownMenuItem(
                                  value: company.id,
                                  child: Text(
                                    company['name'],
                                  ),
                                ),
                              );
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                          return DropdownButton<String>(
                            hint: const Text("Select Company"),
                            value: _selectedCompany,
                            onChanged: (companyValue) {
                              setState(() {
                                _selectedCompany = companyValue;
                                ref
                                    .read(globalsNotifierProvider.notifier)
                                    .updatecompanyId(companyValue!);

                                /// Put the selected company ID into the new user provider
                                ref
                                    .read(usersNotifierProvider.notifier)
                                    .updateCompanyId(_selectedCompany!);
                              });
                              newUser.companyId = companyValue;
                            },
                            items: companyItems,
                          );
                        }),
                    SizedBox(
                      height: 8.h,
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(20.sp),
                                child: const Text(
                                  'Add a Company? ',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(20.sp),
                                child: Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    TextField(
                      textCapitalization: TextCapitalization.words,
                      controller: address1Controller,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        ref
                            .read(usersNotifierProvider.notifier)
                            .updateaddress1(value);
                        newUser.address1 = value;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Address 1', labelText: 'Address 1'),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    TextField(
                      textCapitalization: TextCapitalization.words,
                      controller: address2Controller,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        ref
                            .read(usersNotifierProvider.notifier)
                            .updateaddress2(value);
                        newUser.address2 = value;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Address 2', labelText: 'Address 2'),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    TextField(
                      textCapitalization: TextCapitalization.words,
                      controller: cityController,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        // ref.read(usersNotifierProvider.notifier).updateCity(value);
                        newUser.city = value;
                      },
                      decoration: const InputDecoration(
                          hintText: 'City', labelText: 'City'),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    DropdownButton(
                      value: _currentUserState,
                      items: _dropDownState,
                      hint: const Text('Choose State'),
                      onChanged: changedDropDownState,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    TextField(
                      controller: zipController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        ref
                            .read(usersNotifierProvider.notifier)
                            .updateZipcode(value);
                        newUser.zipCode = value;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Zip Code', labelText: 'Zip Code'),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    TextField(
                      inputFormatters: [maskFormatter],
                      controller: cellPhoneController,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        ref
                            .read(usersNotifierProvider.notifier)
                            .updateCellPhone(value);
                        newUser.cellPhone = value;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Cell Phone', labelText: 'Cell Phone'),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    TextField(
                      inputFormatters: [maskFormatter],
                      controller: officePhoneController,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        ref
                            .read(usersNotifierProvider.notifier)
                            .updateOfficePhone(value);
                        newUser.officePhone = value;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Office Phone', labelText: 'Office Phone'),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value; // Capture the value entered by the user
                        newUser.email = value;
                      },
                      decoration:
                          const InputDecoration(hintText: 'Enter your email'),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    StreamBuilder(
                        stream: _db
                            .collection('mls')
                            .where('mlsState',
                                isEqualTo: ref
                                    .read(globalsNotifierProvider)
                                    .currentUserState)
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          List<DropdownMenuItem<String>> mlsItems = [];
                          if (snapshot.hasData) {
                            final mlsList = snapshot.data.docs;
                            for (var mls in mlsList) {
                              mlsItems.add(
                                DropdownMenuItem(
                                  value: mls.id,
                                  child: Text(
                                    mls['mlsName'],
                                  ),
                                ),
                              );
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                          return DropdownButton<String>(
                            hint: const Text("Select MLS"),
                            value: _selectedMls,
                            onChanged: (mlsValue) {
                              newUser.mls = mlsValue;
                              setState(() {
                                _selectedMls = mlsValue;
                                ref
                                    .read(globalsNotifierProvider.notifier)
                                    .updatemlsId(mlsValue!);

                                /// Put the MLS ID in the user provider
                                ref
                                    .read(usersNotifierProvider.notifier)
                                    .updateMlsId(mlsValue);

                                /// Put the MLS name into the user provider
                                ref
                                    .read(usersNotifierProvider.notifier)
                                    .updateMls(mlsValue);
                              });
                            },
                            items: mlsItems,
                          );
                        }),
                    SizedBox(
                      height: 8.h,
                    ),
                    RoundedButton(
                      title: 'Save Agent',
                      colour: Colors.blueAccent,
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          /// Populate the provider with data entered in the page
                          ref
                              .read(usersNotifierProvider.notifier)
                              .updatefName(fNameController.value.text);
                          ref
                              .read(usersNotifierProvider.notifier)
                              .updatelName(lNameController.value.text);
                          ref
                              .read(usersNotifierProvider.notifier)
                              .updateaddress1(address1Controller.value.text);
                          ref
                              .read(usersNotifierProvider.notifier)
                              .updateaddress2(address2Controller.value.text);
                          ref
                              .read(usersNotifierProvider.notifier)
                              .updateCity(cityController.value.text);
                          ref
                              .read(usersNotifierProvider.notifier)
                              .updateZipcode(zipController.value.text);
                          ref
                              .read(usersNotifierProvider.notifier)
                              .updateCellPhone(cellPhoneController.value.text);
                          ref
                              .read(usersNotifierProvider.notifier)
                              .updateOfficePhone(
                                  officePhoneController.value.text);
                          ref
                              .read(usersNotifierProvider.notifier)
                              .updateEmail(emailController.value.text);

                          /// If the user is NOT a new user then save all the data
                          /// on the screen to the database
                          if (ref.read(globalsNotifierProvider).newUser ==
                              false) {
                            // Add new user account to Cloud Firestore
                            try {
                              /// Send welcome email to new user
                              UserCredential result =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: "D3@lDiligence");

                              if (result.user != null) {
                                final User user = result.user!;
                                newUser.userId = user.uid;
                                //return user;

                                ref
                                    .read(usersNotifierProvider.notifier)
                                    .saveUser(ref.read(globalsNotifierProvider),
                                        newUser, false);

                                // Send email to new user with their default password
                                /// sendNewUserEmail();
                              }
                            } catch (error) {
                              var e = error as FirebaseAuthException;
                              debugPrint(e.message!);
                            }

                            /// The user has selected an existing company so add it to the provider
                            ref
                                .read(usersNotifierProvider.notifier)
                                .updateCompanyId(_selectedCompany!);

                            /// Save the existing user information to the DB
                            ref.read(usersNotifierProvider.notifier).saveUser(
                                ref.read(globalsNotifierProvider),
                                ref.read(usersNotifierProvider),
                                false);
                          } else {
                            /// The user wants to create a new company and be associated with it
                            ref.read(usersNotifierProvider.notifier).saveUser(
                                //ref.read(companyNotifierProvider),
                                ref.read(globalsNotifierProvider),
                                ref.read(usersNotifierProvider),
                                true);
                          }

                          /// check if the user wants to create a new company
                          if (isChecked) {
                            /// If the user wants to create a new company then execute this
                            ref
                                .read(globalsNotifierProvider.notifier)
                                .updatenewCompany(true);

                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CompanyScreen()));
                          } else {
                            /// The user has selected an existing company so add it to the provider
                            ref
                                .read(usersNotifierProvider.notifier)
                                .updateCompanyId(_selectedCompany!);

                            /// User is linking to an existing company
                            ref.read(usersNotifierProvider.notifier).saveUser(
                                ref.read(globalsNotifierProvider),
                                ref.read(usersNotifierProvider),
                                false);
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen()));
                          }

                          /// iOS does not support push notifications so this code is not needed for now
                          // ref.read(usersNotifierProvider.notifier).saveFcmToken(
                          //     ref.read(globalsNotifierProvider).currentUserId!,
                          //     '${ref.read(usersNotifierProvider).fName} ${ref.read(usersNotifierProvider).lName!}');

                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          // todo: add better error handling
                          //debugPrint(e);
                        }
                      },
                    ),
                    SizedBox(
                      height: 8.h,
                    ),

                    // ignore: unnecessary_null_comparison
                    (widget != null)
                        ? RoundedButton(
                            title: 'Delete Agent',
                            colour: Colors.red,
                            onPressed: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                ref
                                    .read(usersNotifierProvider.notifier)
                                    .deleteUser(ref
                                        .watch(globalsNotifierProvider)
                                        .currentUid);
                                ref
                                    .read(globalsNotifierProvider.notifier)
                                    .updateTargetScreen(2);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainScreen()));
                                //Navigator.pushNamed(
                                //    context, AgentDashboardScreen.id);

                                setState(() {
                                  showSpinner = false;
                                });
                              } catch (e) {
                                // todo: add better error handling
                                //debugPrint(e);
                              }
                            },
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     setState(() {
          //       showSpinner = true;
          //     });
          //     try {
          //       ref.read(usersNotifierProvider.notifier).saveUser(
          //           //ref.read(companyNotifierProvider),
          //           ref.read(globalsNotifierProvider).companyId,
          //           ref.read(usersNotifierProvider).userId);
          //       ref.read(globalsNotifierProvider.notifier).updatetargetScreen(0);
          //       ref.read(usersNotifierProvider.notifier).saveFcmToken(
          //           ref.read(globalsNotifierProvider).currentUserId!,
          //           '${ref.read(usersNotifierProvider).fName} ${ref.read(usersNotifierProvider).lName!}');

          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const MainScreen(),
          //         ),
          //       );
          //       setState(() {
          //         showSpinner = false;
          //       });
          //     } catch (e) {
          //       // todo: add better error handling
          //       //debugPrint(e);
          //     }
          //   },
          //   backgroundColor: constants.kPrimaryColor,
          //   child: const Icon(
          //     Icons.assignment_turned_in_outlined,
          //     color: Colors.blueAccent,
          //   ),
          // ),
        ),
      ),
    );
  }
}

class GoogleAuthApi {
  final _googleSignIn = GoogleSignIn();

  Future<GoogleSignInAccount?> signIn() async {
    final bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      return _googleSignIn.currentUser;
    } else {
      try {
        return await _googleSignIn.signIn();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return null;
  }
}
