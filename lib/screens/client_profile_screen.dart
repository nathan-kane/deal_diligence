//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

// ignore_for_file: no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors

//import 'dart:io';
import 'package:deal_diligence/Providers/company_provider.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/client_provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:deal_diligence/components/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:deal_diligence/screens/main_screen.dart';
// import 'package:deal_diligence/screens/company_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deal_diligence/screens/widgets/snackbarwidget.dart';
import 'package:deal_diligence/Providers/client_provider.dart';

final clientsRef = FirebaseFirestore.instance.collection(('client'));
//final companyRef = FirebaseFirestore.instance.collection(('company'));
var maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')});

class ClientProfileScreen extends ConsumerStatefulWidget {
  static const String id = 'client_profile_screen';
  final String? clientId;
  final bool? isNewClient;

  const ClientProfileScreen([this.isNewClient, this.clientId]);

  @override
  ConsumerState<ClientProfileScreen> createState() =>
      _ClientProfileScreenState();
}

class _ClientProfileScreenState extends ConsumerState<ClientProfileScreen> {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool isChecked = false;
  Client newClient = Client();
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
  final homePhoneController = TextEditingController();
  //final companyController = TextEditingController();

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
    homePhoneController.dispose();
    // companyController.dispose();
    // mlsController.dispose();
    super.dispose();
  }

  bool showSpinner = false;

  String? _currentClientState = '';
  //String? currentBusinessType = '';

  //String? _currentMlsId;
  // String? _selectedCompany; // This is the company assigned to new client
  // String? _selectedMls;

  getCurrentClientProfile() async {
    String currentAgentCompanyId = ref.read(globalsNotifierProvider).companyId!;

    if (ref.read(globalsNotifierProvider).newClient == true) {
      emailController.text = "";
      fNameController.text = "";
      lNameController.text = "";
      address1Controller.text = "";
      address2Controller.text = "";
      cityController.text = "";
      zipController.text = "";
      cellPhoneController.text = "";
      homePhoneController.text = "";
      //companyController.text = ref.read(companyNotifierProvider).companyName!;
    } else {
      final DocumentSnapshot currentClientProfile =
          await clientsRef.doc(widget.clientId).get();

      // existing record
      // Updates Controllers
      emailController.text = currentClientProfile["email"] ?? "";
      fNameController.text = currentClientProfile['fName'] ?? "";
      lNameController.text = currentClientProfile['lName'] ?? "";
      address1Controller.text = currentClientProfile['address1'] ?? "";
      address2Controller.text = currentClientProfile['address2'] ?? "";
      cityController.text = currentClientProfile['city'] ?? "";
      //stateController.text = currentAgentProfile.data()['state'];
      _currentClientState = currentClientProfile['state'] ?? "";
      if (currentClientProfile.get('state') == "" ||
          currentClientProfile.get('state') == null) {
        //_currentCompanyState = globals.currentAgentState;
      } else {
        //_currentCompanyState = currentClientProfile['state'] ?? "";
      }

      zipController.text = currentClientProfile['zipCode'].toString();
      cellPhoneController.text = currentClientProfile['cellPhone'] ?? "";
      homePhoneController.text = currentClientProfile['homePhone'] ?? "";
      // companyController.text = currentClientProfile['company'] ?? "";
      // mlsController.text = currentClientProfile['mls'] ?? "";

      // populate the company provider with the retreived data

      ref
          .read(clientNotifierProvider.notifier)
          .updatefName(currentClientProfile['fName']);
      ref
          .read(clientNotifierProvider.notifier)
          .updatelName(currentClientProfile['lName']);
      ref
          .read(clientNotifierProvider.notifier)
          .updateaddress1(currentClientProfile['address1']);
      ref
          .read(clientNotifierProvider.notifier)
          .updateaddress2(currentClientProfile['address2']);
      ref
          .read(clientNotifierProvider.notifier)
          .updateCity(currentClientProfile['city']);
      ref
          .read(clientNotifierProvider.notifier)
          .updateClientState(currentClientProfile['clientState']);
      ref
          .read(clientNotifierProvider.notifier)
          .updateZipcode(currentClientProfile['zipCode']);
      ref
          .read(clientNotifierProvider.notifier)
          .updateCellPhone(currentClientProfile['cellPhone']);
      ref
          .read(clientNotifierProvider.notifier)
          .updateHomePhone(currentClientProfile['homePhone']);
      ref
          .read(clientNotifierProvider.notifier)
          .updateEmail(currentClientProfile['email']);
      ref
          .read(clientNotifierProvider.notifier)
          .updateAgentCompanyId(currentAgentCompanyId);
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
      _currentClientState = selectedState;
      newClient.clientState = selectedState;
      ref
          .read(clientNotifierProvider.notifier)
          .updateClientState(selectedState!);
    });
  }

  // void changedDropDownCompany(String? selectedCompany) {
  //   setState(() {
  //     //_currentCompany = selectedCompany;
  //     newClient.companyId = selectedCompany;
  //     ref
  //         .read(globalsNotifierProvider.notifier)
  //         .updateselectedCompany(selectedCompany!);
  //     ref
  //         .read(globalsNotifierProvider.notifier)
  //         .updatecurrentCompanyName(selectedCompany);
  //   });
  // }

  @override
  void initState() {
    if (ref.read(globalsNotifierProvider).newClient == false) {
      getCurrentClientProfile();
    }

    if (ref.read(clientNotifierProvider).clientState == "" ||
        ref.read(clientNotifierProvider).clientState == null) {
      _currentClientState = 'AZ';
    } else {
      _currentClientState = ref.read(clientNotifierProvider).clientState;
    }
    // if (ref.read(globalsNotifierProvider).companyId != "") {
    //   _selectedCompany = ref.read(globalsNotifierProvider).companyId;
    // }

    super.initState();

    _dropDownState = getDropDownState(); // Get the list of states
  }

  @override
  Widget build(BuildContext context) {
    //final _firestoreService = FirestoreService();

    return Scaffold(
      //appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Client Profile',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                // Email entry text field
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: fNameController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(clientNotifierProvider.notifier)
                        .updatefName(value);
                    newClient.fName = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'First Name', labelText: 'First Name'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: lNameController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(clientNotifierProvider.notifier)
                        .updatelName(value);
                    newClient.lName = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Last Name', labelText: 'Last Name'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                // StreamBuilder<QuerySnapshot>(
                //     // Get a list of available companies to assign the new client to a company
                //     stream: _db.collection('client').snapshots(),
                //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                //       List<DropdownMenuItem<String>> companyItems = [];
                //       if (snapshot.hasData) {
                //         final companyList = snapshot.data.docs;
                //         for (var company in companyList) {
                //           companyItems.add(
                //             DropdownMenuItem(
                //               value: company.id,
                //               child: Text(
                //                 company['name'],
                //               ),
                //             ),
                //           );
                //         }
                //       } else {
                //         return const CircularProgressIndicator();
                //       }
                //       // return DropdownButton<String>(
                //       //   hint: const Text("Select Company"),
                //       //   value: _selectedCompany,
                //       //   onChanged: (companyValue) {
                //       //     setState(() {
                //       //       _selectedCompany = companyValue;
                //       //       ref
                //       //           .read(globalsNotifierProvider.notifier)
                //       //           .updatecompanyId(companyValue!);
                //       //     });
                //       //     newClient.companyId = companyValue;
                //       //   },
                //       //   items: companyItems,
                //       // );
                //     }),
                const SizedBox(
                  height: 8.0,
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
                        .read(clientNotifierProvider.notifier)
                        .updateaddress1(value);
                    newClient.address1 = value;
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
                        .read(clientNotifierProvider.notifier)
                        .updateaddress2(value);
                    newClient.address2 = value;
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
                    ref.read(clientNotifierProvider.notifier).updateCity(value);
                    newClient.city = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'City', labelText: 'City'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                DropdownButton(
                  value: _currentClientState,
                  items: _dropDownState,
                  hint: const Text('Choose State'),
                  onChanged: changedDropDownState,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: zipController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(clientNotifierProvider.notifier)
                        .updateZipcode(value);
                    newClient.zipCode = value;
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
                        .read(clientNotifierProvider.notifier)
                        .updateCellPhone(value);
                    newClient.cellPhone = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Cell Phone', labelText: 'Cell Phone'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  inputFormatters: [maskFormatter],
                  controller: homePhoneController,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(clientNotifierProvider.notifier)
                        .updateHomePhone(value);
                    newClient.homePhone = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Home Phone', labelText: 'Home Phone'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value; // Capture the value entered by the client
                    ref
                        .read(clientNotifierProvider.notifier)
                        .updateEmail(value);
                    newClient.email = value;
                  },
                  decoration:
                      const InputDecoration(hintText: 'Enter Your Email'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                RoundedButton(
                  title: 'Save Client',
                  colour: Colors.blueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      ref.read(clientNotifierProvider.notifier).saveClient(
                            //ref.read(companyNotifierProvider),
                            ref.read(globalsNotifierProvider),
                            ref.read(clientNotifierProvider),
                          );
                      Navigator.pop(context);

                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      // todo: add better error handling
                      //print(e);
                    }
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),

                // ignore: unnecessary_null_comparison
                (widget != null)
                    ? RoundedButton(
                        title: 'Delete Client',
                        colour: Colors.red,
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            ref
                                .read(clientNotifierProvider.notifier)
                                .deleteClient(ref
                                    .watch(globalsNotifierProvider)
                                    .currentUid);
                            ref
                                .read(globalsNotifierProvider.notifier)
                                .updatetargetScreen(2);
                            Navigator.pop(context);

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
