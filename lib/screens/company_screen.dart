//*********************************************
//  Deal Diligence was designed and created by
//  Nathan Kane
//  copyright 2023
//*********************************************

// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/company_provider.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:deal_diligence/components/rounded_button.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:deal_diligence/screens/main_screen.dart';
import 'package:deal_diligence/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'company_dash_board.dart';
// import 'package:provider/provider.dart';
// import 'package:deal_diligence/Models/Company.dart';

final companyRef = FirebaseFirestore.instance.collection(('company'));
var maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')});

class CompanyScreen extends ConsumerStatefulWidget {
  static const String id = 'company_screen';
  final bool? isNewCompany;

  const CompanyScreen([this.isNewCompany, this.company]);
  final Company? company;

  //AgencyScreen([this.agency]);

  @override
  ConsumerState<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends ConsumerState<CompanyScreen> {
  final _db = FirebaseFirestore.instance;

  final companyNameController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final cellPhoneController = TextEditingController();
  final officePhoneController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();

  @override
  void dispose() {
    companyNameController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    cellPhoneController.dispose();
    officePhoneController.dispose();
    emailController.dispose();
    websiteController.dispose();

    super.dispose();
  }

  bool showSpinner = false;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? zip;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;
  String? _currentCompanyState;
  String? _currentCompanyName;

  getCurrentCompanyProfile() async {
    if (ref.read(globalsNotifierProvider).companyId == null ||
        ref.read(globalsNotifierProvider).companyId == "") {
      ref.read(globalsNotifierProvider.notifier).updatenewCompany(true);
      companyNameController.text = "";
      address1Controller.text = "";
      address2Controller.text = "";
      cityController.text = "";
      stateController.text = "";
      zipController.text = "";
      cellPhoneController.text = "";
      officePhoneController.text = "";
      emailController.text = "";
      websiteController.text = "";
    } else {
      final DocumentSnapshot currentCompanyProfile = await companyRef
          .doc(ref.read(globalsNotifierProvider).companyId)
          .get();

      // existing record
      // Updates Controllers
      companyNameController.text = currentCompanyProfile["name"] ?? "";
      address1Controller.text = currentCompanyProfile['address1'] ?? "";
      address2Controller.text = currentCompanyProfile['address2'] ?? "";
      cityController.text = currentCompanyProfile['city'] ?? "";
      stateController.text = currentCompanyProfile['state'] ?? "";
      _currentCompanyState = currentCompanyProfile['state'] ?? "";
      zipController.text = currentCompanyProfile['zipCode'].toString();
      cellPhoneController.text = currentCompanyProfile['cellPhone'] ?? "";
      officePhoneController.text = currentCompanyProfile['officePhone'] ?? "";
      emailController.text = currentCompanyProfile['email'] ?? "";
      websiteController.text = currentCompanyProfile['website'] ?? "";
    }
  }

  List<DropdownMenuItem<String>> _dropDownState = [];

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
      _currentCompanyState = selectedState;
      ref
          .read(globalsNotifierProvider.notifier)
          .updatecurrentCompanyState(selectedState!);
      ref
          .read(globalsNotifierProvider.notifier)
          .updateselectedState(selectedState);
      ref.read(companyNotifierProvider.notifier).updatestate(selectedState);
    });
  }

  void changedDropDownCompany(String? selectedCompany) {
    setState(() {
      _currentCompanyName = selectedCompany;
      ref
          .read(globalsNotifierProvider.notifier)
          .updatecurrentCompanyName(selectedCompany!);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(globalsNotifierProvider).newCompany == false) {
        getCurrentCompanyProfile();
      }
    });

    super.initState();

    _dropDownState = getDropDownState();
    //_currentCompanyState = _dropDownState[0].value;
  }

  @override
  Widget build(BuildContext context) {
    // Get the stream of agents created in main.dart
    // final agencyProvider = Provider.of<AgencyProvider>(context);
    final firestoreService = FirestoreService();

    return Scaffold(
      //appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Company Profile',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                const Text(
                  'Select your company',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                StreamBuilder(
                    stream: _db.collection('company').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return DropdownButton<String>(
                          hint: const Text("Select Company"),
                          value: _currentCompanyName,
                          onChanged: changedDropDownCompany,
                          items: snapshot.data.docs
                              .map<DropdownMenuItem<String>>((document) {
                            return DropdownMenuItem<String>(
                              value: document.id,
                              child: Text(document.data()['name']),
                            );
                          }).toList(),
                        );
                      }
                    }),
                RoundedButton(
                  title: 'Link to your company',
                  colour: Colors.blueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      await firestoreService.linkUserToExistingCompany(
                          _currentCompanyName,
                          ref.read(globalsNotifierProvider).currentUid!);
                      ref
                          .read(globalsNotifierProvider.notifier)
                          .updatecompanyId(_currentCompanyName!);
                      final DocumentSnapshot currentCompanyProfile =
                          await companyRef.doc(_currentCompanyName).get();
                      ref
                          .read(globalsNotifierProvider.notifier)
                          .updatecurrentCompanyState(
                              currentCompanyProfile.get('state'));
                      if (!context.mounted) return;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const UserProfileScreen()));
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      // todo: add better error handling
                      //debugPrint(e);
                    }
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'or add new company',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: companyNameController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(companyNotifierProvider.notifier)
                        .updateCompanyName(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Company Name', labelText: 'Company Name'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: address1Controller,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(companyNotifierProvider.notifier)
                        .updateaddress1(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Address 1', labelText: 'Address 1'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: address2Controller,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(companyNotifierProvider.notifier)
                        .updateaddress2(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Address 2', labelText: 'Address 2'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: cityController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(companyNotifierProvider.notifier)
                        .updatecity(value);
                    // if (ref
                    //         .watch(globalsNotifierProvider)
                    //         .currentCompanyState ==
                    //     "") {
                    //   _currentCompanyState = ref
                    //       .watch(globalsNotifierProvider)
                    //       .currentCompanyState;
                    // } else {
                    //   _currentCompanyState = ref
                    //       .watch(globalsNotifierProvider)
                    //       .currentCompanyState;
                    // }
                    // ;
                  },
                  decoration: const InputDecoration(
                      hintText: 'City', labelText: 'City'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                DropdownButton(
                  value: _currentCompanyState,
                  items: _dropDownState,
                  hint: const Text('Choose State'),
                  onChanged: changedDropDownState,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: zipController,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(companyNotifierProvider.notifier)
                        .updatezipcode(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Zip Code', labelText: 'Zip Code'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  inputFormatters: [maskFormatter],
                  controller: cellPhoneController,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(companyNotifierProvider.notifier)
                        .updateCellPhone(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Cell Phone', labelText: 'Cell Phone'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  inputFormatters: [maskFormatter],
                  controller: officePhoneController,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(companyNotifierProvider.notifier)
                        .updateofficePhone(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Office Phone', labelText: 'Office Phone'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(companyNotifierProvider.notifier)
                        .updateemail(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Email', labelText: 'Email'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: websiteController,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(companyNotifierProvider.notifier)
                        .updatewebsite(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Website', labelText: 'Website'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                RoundedButton(
                  title: 'Save new company',
                  colour: Colors.blueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      ref
                          .read(globalsNotifierProvider.notifier)
                          .updatenewCompany(true);

                      /// Save the new company and get the new company ID
                      /// We will also save the company ID to the user record
                      /// to link the user to the company
                      var docRef = await ref
                          .read(companyNotifierProvider.notifier)
                          .saveCompany(ref);

                      /// Link the new user with the new company by inserting the
                      /// new companyId into the new user provider
                      ref
                          .read(usersNotifierProvider.notifier)
                          .updateCompanyId(docRef!.id);

                      /// Add the company name to the user provider
                      ref
                          .read(usersNotifierProvider.notifier)
                          .updateCompanyName(companyNameController.value.text);

                      /// Add the new company id to the global provider for use in list_of_trxn.dart
                      ref
                          .read(globalsNotifierProvider.notifier)
                          .updatecompanyId(docRef.id);

                      /// Now save the updated user data to the user record
                      ref.read(usersNotifierProvider.notifier).saveUser(
                          ref.read(globalsNotifierProvider),
                          ref.read(usersNotifierProvider),
                          false);

                      /// Navigate to the main screen
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const MainScreen()));

                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      // todo: add better error handling
                      // debugPrint(e);
                    }
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                (widget != null)
                    ? RoundedButton(
                        title: 'Delete',
                        colour: Colors.red,
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            //agencyProvider.deleteCompany(globals.currentUid);
                            // Navigator.pushNamed(
                            //     context, UserDashboardScreen.id);

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
    );
  }
}
