//*********************************************
//  Deal Diligence was designed and created by
//  Nathan Kane
//  copyright 2023
//*********************************************

// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:deal_diligence/Providers/mortgage_company_provider.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:deal_diligence/components/rounded_button.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:cloud_firestore/cloud_firestore.dart';

final mortgageCompanyRef =
    FirebaseFirestore.instance.collection(('mortgageCompany'));
var maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')});

class MortgageCompanyScreen extends ConsumerStatefulWidget {
  static const String id = 'mortgage_company_screen';
  final bool? isNewMortgageCompany;

  const MortgageCompanyScreen(
      [this.isNewMortgageCompany, this.mortgageCompanyId]);
  final String? mortgageCompanyId;

  //AgencyScreen([this.agency]);

  @override
  ConsumerState<MortgageCompanyScreen> createState() =>
      _MortgageCompanyScreenState();
}

class _MortgageCompanyScreenState extends ConsumerState<MortgageCompanyScreen> {
  final _db = FirebaseFirestore.instance;

  final mortgageCompanyNameController = TextEditingController();
  final primaryContactController = TextEditingController();
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
    mortgageCompanyNameController.dispose();
    primaryContactController.dispose();
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
  String? mortgageCompany;
  String? primaryContact;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? zip;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;
  String? _currentMortgageCompanyState;
  String? _currentMortgageCompanyName;

  getCurrentMortgageCompanyProfile() async {
    if (ref.read(globalsNotifierProvider).companyId == null ||
        ref.read(globalsNotifierProvider).companyId == "") {
      ref.read(globalsNotifierProvider.notifier).updatenewMortgageCompany(true);
      mortgageCompanyNameController.text = "";
      primaryContactController.text = "";
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
      final DocumentSnapshot currentMortgageCompanyProfile =
          await mortgageCompanyRef
              .doc(ref.read(globalsNotifierProvider).companyId)
              .get();

      // existing record
      // Updates Controllers
      mortgageCompanyNameController.text =
          currentMortgageCompanyProfile["mortgageCompanyName"] ?? "";
      primaryContactController.text =
          currentMortgageCompanyProfile['primaryContact'];
      address1Controller.text = currentMortgageCompanyProfile['address1'] ?? "";
      address2Controller.text = currentMortgageCompanyProfile['address2'] ?? "";
      cityController.text = currentMortgageCompanyProfile['city'] ?? "";
      stateController.text = currentMortgageCompanyProfile['state'] ?? "";
      _currentMortgageCompanyState =
          currentMortgageCompanyProfile['state'] ?? "";
      zipController.text = currentMortgageCompanyProfile['zipCode'].toString();
      cellPhoneController.text =
          currentMortgageCompanyProfile['cellPhone'] ?? "";
      officePhoneController.text =
          currentMortgageCompanyProfile['officePhone'] ?? "";
      emailController.text = currentMortgageCompanyProfile['email'] ?? "";
      websiteController.text = currentMortgageCompanyProfile['website'] ?? "";
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
      _currentMortgageCompanyState = selectedState;
      // ref
      //     .read(globalsNotifierProvider.notifier)
      //     .updatecurrentCompanyState(selectedState!);
      // ref
      //     .read(globalsNotifierProvider.notifier)
      //     .updateselectedState(selectedState);
      ref
          .read(mortgageCompanyNotifierProvider.notifier)
          .updatestate(selectedState!);
    });
  }

  void changedDropDownCompany(String? selectedCompany) {
    setState(() {
      _currentMortgageCompanyName = selectedCompany;
      ref
          .read(globalsNotifierProvider.notifier)
          .updatecurrentCompanyName(selectedCompany!);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isNewMortgageCompany!) {
        getCurrentMortgageCompanyProfile();
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
    final _firestoreService = FirestoreService();

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
                  'Mortgage Company Profile',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                TextField(
                  controller: mortgageCompanyNameController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(mortgageCompanyNotifierProvider.notifier)
                        .updateMortgageCompanyName(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Mortgage Company Name',
                      labelText: 'Mortgage Company Name'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: primaryContactController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(mortgageCompanyNotifierProvider.notifier)
                        .updatePrimaryContact(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Primary Contact',
                      labelText: 'Primary Contact'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: address1Controller,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(mortgageCompanyNotifierProvider.notifier)
                        .updateaddress1(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Address 1', labelText: 'Address 1'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: address2Controller,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(mortgageCompanyNotifierProvider.notifier)
                        .updateaddress2(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Address 2', labelText: 'Address 2'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: cityController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(mortgageCompanyNotifierProvider.notifier)
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
                  value: _currentMortgageCompanyState,
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
                        .read(mortgageCompanyNotifierProvider.notifier)
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
                        .read(mortgageCompanyNotifierProvider.notifier)
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
                        .read(mortgageCompanyNotifierProvider.notifier)
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
                        .read(mortgageCompanyNotifierProvider.notifier)
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
                        .read(mortgageCompanyNotifierProvider.notifier)
                        .updatewebsite(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Website', labelText: 'Website'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                RoundedButton(
                  title: 'Save Mortgage Company',
                  colour: Colors.blueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      ref
                          .read(globalsNotifierProvider.notifier)
                          .updatenewMortgageCompany(true);

                      //  This is a new company record but it will already
                      //  have a document ID that should be used.
                      //agencyProvider.saveCompany();
                      ref
                          .read(mortgageCompanyNotifierProvider.notifier)
                          .saveMortgageCompany(
                              ref.read(mortgageCompanyNotifierProvider));
                      Navigator.pop(context);

                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      // todo: add better error handling
                      // print(e);
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
                            //print(e);
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
