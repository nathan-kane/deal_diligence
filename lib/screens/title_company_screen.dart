//*********************************************
//  Deal Diligence was designed and created by
//  Nathan Kane
//  copyright 2023
//*********************************************

// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/title_company_provider.dart';
//import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:deal_diligence/components/rounded_button.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final titleCompanyRef = FirebaseFirestore.instance.collection(('titleCompany'));
var maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')});

class TitleCompanyScreen extends ConsumerStatefulWidget {
  const TitleCompanyScreen([
    this.isNewTitleCompany,
    this.titleCompanyId,
    Key? key,
  ]) : super(key: key);

  final bool? isNewTitleCompany;
  final String? titleCompanyId;

  @override
  ConsumerState<TitleCompanyScreen> createState() => _TitleCompanyScreenState();
}

class _TitleCompanyScreenState extends ConsumerState<TitleCompanyScreen> {
  //final _db = FirebaseFirestore.instance;
  String? titleCompanyId;

  final titleCompanyNameController = TextEditingController();
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
    titleCompanyNameController.dispose();
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
  String? titleCompany;
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
  String? _currentTitleCompanyState;
  //String? _currentTitleCompanyName;

  getCurrentTitleCompanyProfile() async {
    if (widget.titleCompanyId == null || widget.titleCompanyId == "") {
      ref.read(globalsNotifierProvider.notifier).updateIsNewTitleCompany(true);
      titleCompanyNameController.text = "";
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
      final DocumentSnapshot currentTitleCompanyProfile =
          await titleCompanyRef.doc(widget.titleCompanyId).get();

      // existing record
      titleCompanyId = widget.titleCompanyId;

      // Updates Controllers
      titleCompanyNameController.text =
          currentTitleCompanyProfile["titleCompanyName"] ?? "";
      primaryContactController.text =
          currentTitleCompanyProfile['primaryContact'];
      address1Controller.text = currentTitleCompanyProfile['address1'] ?? "";
      address2Controller.text = currentTitleCompanyProfile['address2'] ?? "";
      cityController.text = currentTitleCompanyProfile['city'] ?? "";
      stateController.text =
          currentTitleCompanyProfile['titleCompanyState'] ?? "";
      setState(() {
        _currentTitleCompanyState =
            currentTitleCompanyProfile['titleCompanyState'] ?? "";
      });

      zipController.text = currentTitleCompanyProfile['zipCode'].toString();
      cellPhoneController.text = currentTitleCompanyProfile['cellPhone'] ?? "";
      officePhoneController.text =
          currentTitleCompanyProfile['officePhone'] ?? "";
      emailController.text = currentTitleCompanyProfile['email'] ?? "";
      websiteController.text = currentTitleCompanyProfile['website'] ?? "";

      // Populate the state Notifier Provider with the current values
      TitleCompanyNotifier titleCompanyProvider =
          ref.read(titleCompanyNotifierProvider.notifier);
      titleCompanyProvider
          .updateTitleCompanyName(titleCompanyNameController.text);
      titleCompanyProvider.updatePrimaryContact(primaryContactController.text);
      titleCompanyProvider.updateaddress1(address1Controller.text);
      titleCompanyProvider.updateaddress2(address2Controller.text);
      titleCompanyProvider.updatecity(cityController.text);
      titleCompanyProvider.updateTitleCompanyState(stateController.text);
      titleCompanyProvider.updatezipcode(zipController.text);
      titleCompanyProvider.updateCellPhone(cellPhoneController.text);
      titleCompanyProvider.updateofficePhone(officePhoneController.text);
      titleCompanyProvider.updateemail(emailController.text);
      titleCompanyProvider.updatewebsite(websiteController.text);
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
      _currentTitleCompanyState = selectedState;
      ref
          .read(titleCompanyNotifierProvider.notifier)
          .updateTitleCompanyState(selectedState!);
    });
  }

  // void changedDropDownCompany(String? selectedCompany) {
  //   setState(() {
  //     _currentTitleCompanyName = selectedCompany;
  //     ref
  //         .read(globalsNotifierProvider.notifier)
  //         .updatecurrentCompanyName(selectedCompany!);
  //   });
  // }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isNewTitleCompany!) {
        getCurrentTitleCompanyProfile();
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
            padding: EdgeInsets.symmetric(horizontal: 30.sp),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Title Company Profile',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 38.h,),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: titleCompanyNameController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(titleCompanyNotifierProvider.notifier)
                        .updateTitleCompanyName(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Title Company Name',
                      labelText: 'Title Company Name'),
                ),
                SizedBox(height: 8.h,),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: primaryContactController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(titleCompanyNotifierProvider.notifier)
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
                        .read(titleCompanyNotifierProvider.notifier)
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
                        .read(titleCompanyNotifierProvider.notifier)
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
                        .read(titleCompanyNotifierProvider.notifier)
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
                SizedBox(height: 8.h,),
                DropdownButton(
                  value: _currentTitleCompanyState,
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
                        .read(titleCompanyNotifierProvider.notifier)
                        .updatezipcode(value);
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
                        .read(titleCompanyNotifierProvider.notifier)
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
                        .read(titleCompanyNotifierProvider.notifier)
                        .updateofficePhone(value);
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
                        .read(titleCompanyNotifierProvider.notifier)
                        .updateemail(value);
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
                        .read(titleCompanyNotifierProvider.notifier)
                        .updatewebsite(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Website', labelText: 'Website'),
                ),
                SizedBox(height: 8.h,),
                RoundedButton(
                  title: 'Save Title company',
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

                      if (widget.titleCompanyId == "" ||
                          widget.titleCompanyId == null) {
                        ref
                            .read(titleCompanyNotifierProvider.notifier)
                            .saveTitleCompany(
                                ref.read(titleCompanyNotifierProvider));
                      } else {
                        ref
                            .read(titleCompanyNotifierProvider.notifier)
                            .saveTitleCompany(
                                ref.read(titleCompanyNotifierProvider),
                                widget.titleCompanyId);
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
                        title: 'Delete Title Company',
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
