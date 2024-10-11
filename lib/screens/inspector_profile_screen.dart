//*********************************************
//  Deal Diligence was designed and created by
//  Nathan Kane
//  copyright 2023
//*********************************************

// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/inspector_provider.dart';
//import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:deal_diligence/components/rounded_button.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final inspectorCompanyRef =
    FirebaseFirestore.instance.collection(('inspectorCompany'));
var maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')});

class InspectorCompanyScreen extends ConsumerStatefulWidget {
  const InspectorCompanyScreen([
    this.isNewInspectorCompany,
    this.inspectorCompanyId,
    Key? key,
  ]) : super(key: key);

  final bool? isNewInspectorCompany;
  final String? inspectorCompanyId;

  @override
  ConsumerState<InspectorCompanyScreen> createState() =>
      _InspectorCompanyScreenState();
}

class _InspectorCompanyScreenState
    extends ConsumerState<InspectorCompanyScreen> {
  //final _db = FirebaseFirestore.instance;

  final inspectorCompanyNameController = TextEditingController();
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
    inspectorCompanyNameController.dispose();
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
  String? inspectorCompany;
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
  String? _currentInspectorCompanyState;
  //String? _currentInspectorCompanyName;

  getCurrentInspectorCompanyProfile() async {
    if (ref.read(globalsNotifierProvider).companyId == null ||
        ref.read(globalsNotifierProvider).companyId == "") {
      ref.read(globalsNotifierProvider.notifier).updatenewCompany(true);
      inspectorCompanyNameController.text = "";
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
      final DocumentSnapshot currentInspectorCompanyProfile =
          await inspectorCompanyRef.doc(widget.inspectorCompanyId).get();

      // existing record
      // Updates Controllers
      inspectorCompanyNameController.text =
          currentInspectorCompanyProfile["inspectorCompanyName"] ?? "";
      primaryContactController.text =
          currentInspectorCompanyProfile['primaryContact'];
      address1Controller.text =
          currentInspectorCompanyProfile['address1'] ?? "";
      address2Controller.text =
          currentInspectorCompanyProfile['address2'] ?? "";
      cityController.text = currentInspectorCompanyProfile['city'] ?? "";

      setState(() {
        stateController.text =
            currentInspectorCompanyProfile['inspectorCompanyState'] ?? "";
      });

      _currentInspectorCompanyState =
          currentInspectorCompanyProfile['inspectorCompanyState'] ?? "";
      zipController.text = currentInspectorCompanyProfile['zipCode'].toString();
      cellPhoneController.text =
          currentInspectorCompanyProfile['cellPhone'] ?? "";
      officePhoneController.text =
          currentInspectorCompanyProfile['officePhone'] ?? "";
      emailController.text = currentInspectorCompanyProfile['email'] ?? "";
      websiteController.text = currentInspectorCompanyProfile['website'] ?? "";

      // Populate the state Notifier Provider with the current values
      InspectorCompanyNotifier inspectorCompanyProvider =
          ref.read(inspectorCompanyNotifierProvider.notifier);
      inspectorCompanyProvider
          .updateInspectorCompanyName(inspectorCompanyNameController.text);
      inspectorCompanyProvider
          .updatePrimaryContact(primaryContactController.text);
      inspectorCompanyProvider.updateaddress1(address1Controller.text);
      inspectorCompanyProvider.updateaddress2(address2Controller.text);
      inspectorCompanyProvider.updateCity(cityController.text);
      inspectorCompanyProvider
          .updateInspectorCompanyState(stateController.text);
      inspectorCompanyProvider.updateZipcode(zipController.text);
      inspectorCompanyProvider.updateCellPhone(cellPhoneController.text);
      inspectorCompanyProvider.updateOfficePhone(officePhoneController.text);
      inspectorCompanyProvider.updateEmail(emailController.text);
      inspectorCompanyProvider.updateWebsite(websiteController.text);
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

  // void changedDropDownCompany(String? selectedCompany) {
  //   setState(() {
  //     _currentInspectorCompanyName = selectedCompany;
  //     ref
  //         .read(globalsNotifierProvider.notifier)
  //         .updatecurrentCompanyName(selectedCompany!);
  //   });
  // }

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
    //final firestoreService = FirestoreService();

    return Scaffold(
      //appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.sp),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Inspector Company Profile',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.h,),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: inspectorCompanyNameController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(inspectorCompanyNotifierProvider.notifier)
                        .updateInspectorCompanyName(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Inspector Company Name',
                      labelText: 'Inspector Company Name'),
                ),
                SizedBox(height: 8.h,),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: primaryContactController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(inspectorCompanyNotifierProvider.notifier)
                        .updatePrimaryContact(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Primary Contact',
                      labelText: 'Primary Contact'),
                ),
                SizedBox(height: 8.h,),
                TextField(
                  textCapitalization: TextCapitalization.words,
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
                SizedBox(height: 8.h,),
                TextField(
                  textCapitalization: TextCapitalization.words,
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
                SizedBox(height: 8.h,),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: cityController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(inspectorCompanyNotifierProvider.notifier)
                        .updateCity(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'City', labelText: 'City'),
                ),
                SizedBox(height: 8.h,),
                DropdownButton(
                  value: _currentInspectorCompanyState,
                  items: _dropDownState,
                  hint: const Text('Choose State'),
                  onChanged: changedDropDownState,
                ),
                SizedBox(height: 8.h,),
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
                SizedBox(height: 8.h,),
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
                SizedBox(height: 8.h,),
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
                SizedBox(height: 8.h,),
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
                SizedBox(height: 8.h,),
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
                SizedBox(height: 8.h,),
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
                      if (widget.inspectorCompanyId == "" ||
                          widget.inspectorCompanyId == null) {
                        ref
                            .read(inspectorCompanyNotifierProvider.notifier)
                            .saveInspectorCompany(
                                ref.read(inspectorCompanyNotifierProvider));
                      } else {
                        ref
                            .read(inspectorCompanyNotifierProvider.notifier)
                            .saveInspectorCompany(
                                ref.read(inspectorCompanyNotifierProvider),
                                widget.inspectorCompanyId);
                      }

                      Navigator.pop(context);

                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      // todo: add better error handling
                      // debugPrint(e);
                    }
                  },
                ),
                SizedBox(height: 8.h,),
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
