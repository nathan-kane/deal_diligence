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
import 'package:deal_diligence/Providers/inspector_provider.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:deal_diligence/components/rounded_button.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:cloud_firestore/cloud_firestore.dart';

final inspectorCompanyRef =
    FirebaseFirestore.instance.collection(('inspectorCompany'));
var maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')});

class InspectorCompanyScreen extends ConsumerStatefulWidget {
  static const String id = 'inspector_company_screen';
  final bool? isNewInspectorCompany;

  const InspectorCompanyScreen(
      [this.isNewInspectorCompany, this.inspectorCompany]);
  final InspectorCompany? inspectorCompany;

  //AgencyScreen([this.agency]);

  @override
  ConsumerState<InspectorCompanyScreen> createState() =>
      _InspectorCompanyScreenState();
}

class _InspectorCompanyScreenState
    extends ConsumerState<InspectorCompanyScreen> {
  final _db = FirebaseFirestore.instance;

  final inspectorCompanyNameController = TextEditingController();
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
    inspectorCompanyNameController.dispose();
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
  String? inspectorCompany;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? zip;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;
  String? _currentInspectorCompanyState;
  String? _currentInspectorCompanyName;

  getCurrentInspectorCompanyProfile() async {
    if (ref.read(globalsNotifierProvider).companyId == null ||
        ref.read(globalsNotifierProvider).companyId == "") {
      ref.read(globalsNotifierProvider.notifier).updatenewCompany(true);
      inspectorCompanyNameController.text = "";
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
      final DocumentSnapshot currentInspectorCompanyProfile =
          await inspectorCompanyRef
              .doc(ref.read(globalsNotifierProvider).companyId)
              .get();

      // existing record
      // Updates Controllers
      inspectorCompanyNameController.text =
          currentInspectorCompanyProfile["companyName"] ?? "";
      address1Controller.text =
          currentInspectorCompanyProfile['address1'] ?? "";
      address2Controller.text =
          currentInspectorCompanyProfile['address2'] ?? "";
      cityController.text = currentInspectorCompanyProfile['city'] ?? "";
      stateController.text =
          currentInspectorCompanyProfile['inspectorCompanyState'] ?? "";
      _currentInspectorCompanyState =
          currentInspectorCompanyProfile['inspectorCompanyState'] ?? "";
      zipController.text = currentInspectorCompanyProfile['zipCode'].toString();
      cellPhoneController.text =
          currentInspectorCompanyProfile['cellPhone'] ?? "";
      officePhoneController.text =
          currentInspectorCompanyProfile['officePhone'] ?? "";
      emailController.text = currentInspectorCompanyProfile['email'] ?? "";
      websiteController.text = currentInspectorCompanyProfile['website'] ?? "";
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
      _currentInspectorCompanyState = selectedState;
      ref
          .read(globalsNotifierProvider.notifier)
          .updatecurrentCompanyState(selectedState!);
      ref
          .read(globalsNotifierProvider.notifier)
          .updateselectedState(selectedState);
      ref
          .read(inspectorCompanyNotifierProvider.notifier)
          .updateInspectorCompanyState(selectedState);
    });
  }

  void changedDropDownCompany(String? selectedCompany) {
    setState(() {
      _currentInspectorCompanyName = selectedCompany;
      ref
          .read(globalsNotifierProvider.notifier)
          .updatecurrentCompanyName(selectedCompany!);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isNewInspectorCompany!) {
        getCurrentInspectorCompanyProfile();
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
                  'Inspector Company Profile',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                // const Text(
                //   'Select your company',
                //   style: TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.w700,
                //   ),
                // ),
                // const SizedBox(
                //   height: 8.0,
                // ),
                // StreamBuilder(
                //     stream: _db.collection('company').snapshots(),
                //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                //       if (snapshot.data == null) {
                //         return const Center(
                //           child: CircularProgressIndicator(),
                //         );
                //       } else {
                //         return DropdownButton<String>(
                //           hint: const Text("Select Company"),
                //           value: _currentCompanyName,
                //           onChanged: changedDropDownCompany,
                //           items: snapshot.data.docs
                //               .map<DropdownMenuItem<String>>((document) {
                //             return DropdownMenuItem<String>(
                //               value: document.id,
                //               child: Text(document.data()['name']),
                //             );
                //           }).toList(),
                //         );
                //       }
                //     }),
                // RoundedButton(
                //   title: 'Link to your company',
                //   colour: Colors.blueAccent,
                //   onPressed: () async {
                //     setState(() {
                //       showSpinner = true;
                //     });
                //     try {
                //       await _firestoreService.linkUserToExistingCompany(
                //           _currentCompanyName,
                //           ref.read(globalsNotifierProvider).currentUid!);
                //       ref
                //           .read(globalsNotifierProvider.notifier)
                //           .updatecompanyId(_currentCompanyName!);
                //       final DocumentSnapshot currentInspectorCompanyProfile =
                //           await inspectorCompanyRef
                //               .doc(_currentCompanyName)
                //               .get();
                //       ref
                //           .read(globalsNotifierProvider.notifier)
                //           .updatecurrentCompanyState(
                //               currentInspectorCompanyProfile.get('state'));
                //       Navigator.of(context).push(MaterialPageRoute(
                //           builder: (context) => const UserProfileScreen()));
                //       setState(() {
                //         showSpinner = false;
                //       });
                //     } catch (e) {
                //       // todo: add better error handling
                //       //print(e);
                //     }
                //   },
                // ),
                // const SizedBox(
                //   height: 20.0,
                // ),
                // const Text(
                //   'or add new company',
                //   style: TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.w700,
                //   ),
                // ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: inspectorCompanyNameController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(inspectorCompanyNotifierProvider.notifier)
                        .updateCompanyName(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Inspector Company Name',
                      labelText: 'Inspector Company Name'),
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
                        .read(inspectorCompanyNotifierProvider.notifier)
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
                        .read(inspectorCompanyNotifierProvider.notifier)
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
                        .read(inspectorCompanyNotifierProvider.notifier)
                        .updateCity(value);
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
                  value: _currentInspectorCompanyState,
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
                        .read(inspectorCompanyNotifierProvider.notifier)
                        .updateZipcode(value);
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
                        .read(inspectorCompanyNotifierProvider.notifier)
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
                        .read(inspectorCompanyNotifierProvider.notifier)
                        .updateOfficePhone(value);
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
                        .read(inspectorCompanyNotifierProvider.notifier)
                        .updateEmail(value);
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
                        .read(inspectorCompanyNotifierProvider.notifier)
                        .updateWebsite(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Website', labelText: 'Website'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                RoundedButton(
                  title: 'Save Inspector Company',
                  colour: Colors.blueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      ref
                          .read(globalsNotifierProvider.notifier)
                          .updatenewCompany(true);

                      //  This is a new company record but it will already
                      //  have a document ID that should be used.
                      //agencyProvider.saveCompany();
                      ref
                          .read(inspectorCompanyNotifierProvider.notifier)
                          .saveInspectorCompany(
                              ref.read(globalsNotifierProvider),
                              ref.read(inspectorCompanyNotifierProvider));
                      Navigator.pop;
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (context) => const UserProfileScreen()));

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
                        title: 'Delete Inspector Company',
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
