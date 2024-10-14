//*********************************************
//  Deal Diligence was designed and created by
//  Nathan Kane
//  copyright 2023
//*********************************************

// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/appraiser_company_provider.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
//import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:deal_diligence/components/rounded_button.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final appraiserCompanyRef =
    FirebaseFirestore.instance.collection(('appraiserCompany'));
var maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')});

class AppraiserCompanyScreen extends ConsumerStatefulWidget {
  const AppraiserCompanyScreen([
    this.isNewAppraiserCompany,
    this.appraiserCompanyId,
    Key? key,
  ]) : super(key: key);

  final bool? isNewAppraiserCompany;
  final String? appraiserCompanyId;

  @override
  ConsumerState<AppraiserCompanyScreen> createState() =>
      _AppraiserCompanyScreenState();
}

class _AppraiserCompanyScreenState
    extends ConsumerState<AppraiserCompanyScreen> {
  //final _db = FirebaseFirestore.instance;

  final appraiserCompanyNameController = TextEditingController();
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
    appraiserCompanyNameController.dispose();
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
  String? appraiserCompany;
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
  String? _currentAppraiserCompanyState;
  //String? _currentAppraiserCompanyName;

  getCurrentAppraiserCompanyProfile() async {
    if (ref.read(globalsNotifierProvider).companyId == null ||
        ref.read(globalsNotifierProvider).companyId == "") {
      ref.read(globalsNotifierProvider.notifier).updatenewCompany(true);
      appraiserCompanyNameController.text = "";
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
      final DocumentSnapshot currentAppraiserCompanyProfile =
          await appraiserCompanyRef.doc(widget.appraiserCompanyId).get();

      // existing record
      // Updates Controllers
      appraiserCompanyNameController.text =
          currentAppraiserCompanyProfile["appraiserCompanyName"] ?? "";
      primaryContactController.text =
          currentAppraiserCompanyProfile['primaryContact'];
      address1Controller.text =
          currentAppraiserCompanyProfile['address1'] ?? "";
      address2Controller.text =
          currentAppraiserCompanyProfile['address2'] ?? "";
      cityController.text = currentAppraiserCompanyProfile['city'] ?? "";
      stateController.text =
          currentAppraiserCompanyProfile['appraiserCompanyState'] ?? "";

      setState(() {
        _currentAppraiserCompanyState =
            currentAppraiserCompanyProfile['appraiserCompanyState'] ?? "";
      });

      zipController.text = currentAppraiserCompanyProfile['zipCode'].toString();
      cellPhoneController.text =
          currentAppraiserCompanyProfile['cellPhone'] ?? "";
      officePhoneController.text =
          currentAppraiserCompanyProfile['officePhone'] ?? "";
      emailController.text = currentAppraiserCompanyProfile['email'] ?? "";
      websiteController.text = currentAppraiserCompanyProfile['website'] ?? "";

      // Populate the state Notifier Provider with the current values
      AppraiserCompanyNotifier appraiserCompanyProvider =
          ref.read(appraiserCompanyNotifierProvider.notifier);
      appraiserCompanyProvider
          .updateAppraiserCompanyName(appraiserCompanyNameController.text);
      appraiserCompanyProvider
          .updatePrimaryContact(primaryContactController.text);
      appraiserCompanyProvider.updateAddress1(address1Controller.text);
      appraiserCompanyProvider.updateAddress2(address2Controller.text);
      appraiserCompanyProvider.updateCity(cityController.text);
      appraiserCompanyProvider
          .updateAppraiserCompanyState(stateController.text);
      appraiserCompanyProvider.updateZipcode(zipController.text);
      appraiserCompanyProvider.updateCellPhone(cellPhoneController.text);
      appraiserCompanyProvider.updateOfficePhone(officePhoneController.text);
      appraiserCompanyProvider.updateEmail(emailController.text);
      appraiserCompanyProvider.updateWebsite(websiteController.text);
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
      _currentAppraiserCompanyState = selectedState;
      ref
          .read(globalsNotifierProvider.notifier)
          .updatecurrentCompanyState(selectedState!);
      ref
          .read(globalsNotifierProvider.notifier)
          .updateselectedState(selectedState);
      ref
          .read(appraiserCompanyNotifierProvider.notifier)
          .updateAppraiserCompanyState(selectedState);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isNewAppraiserCompany!) {
        getCurrentAppraiserCompanyProfile();
      }
    });

    super.initState();

    _dropDownState = getDropDownState();
    //_currentAppraiserCompanyState = _dropDownState[0].value;
  }

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      ensureScreenSize: true,
      child: Scaffold(
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
                    'Appraiser Company Profile',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(14.r),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: appraiserCompanyNameController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      ref
                          .read(appraiserCompanyNotifierProvider.notifier)
                          .updateAppraiserCompanyName(value);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Appraiser Company Name',
                        labelText: 'Appraiser Company Name'),
                  ),
                  SizedBox(height: 8.h,),
                  TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: primaryContactController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      ref
                          .read(appraiserCompanyNotifierProvider.notifier)
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
                          .read(appraiserCompanyNotifierProvider.notifier)
                          .updateAddress1(value);
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
                          .read(appraiserCompanyNotifierProvider.notifier)
                          .updateAddress2(value);
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
                          .read(appraiserCompanyNotifierProvider.notifier)
                          .updateCity(value);
                    },
                    decoration: const InputDecoration(
                        hintText: 'City', labelText: 'City'),
                  ),
                  SizedBox(height: 8.h,),
                  DropdownButton(
                    value: _currentAppraiserCompanyState,
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
                          .read(appraiserCompanyNotifierProvider.notifier)
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
                          .read(appraiserCompanyNotifierProvider.notifier)
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
                          .read(appraiserCompanyNotifierProvider.notifier)
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
                          .read(appraiserCompanyNotifierProvider.notifier)
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
                          .read(appraiserCompanyNotifierProvider.notifier)
                          .updateWebsite(value);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Website', labelText: 'Website'),
                  ),
                  SizedBox(height: 8.h,),
                  RoundedButton(
                    title: 'Save Appraiser Company',
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
                        if (widget.appraiserCompanyId == "" ||
                            widget.appraiserCompanyId == null) {
                          ref
                              .read(appraiserCompanyNotifierProvider.notifier)
                              .saveAppraiserCompany(
                                  ref.read(appraiserCompanyNotifierProvider));
                        } else {
                          ref
                              .read(appraiserCompanyNotifierProvider.notifier)
                              .saveAppraiserCompany(
                                  ref.read(appraiserCompanyNotifierProvider),
                                  widget.appraiserCompanyId);
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
                          title: 'Delete Appraiser Company',
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
      ),
    );
  }
}
