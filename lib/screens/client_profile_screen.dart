//*********************************************
//  Deal Diligence was designed and created by
//  Nathan Kane
//  copyright 2023
//*********************************************

// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/client_provider.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
//import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:deal_diligence/components/rounded_button.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final appraiserCompanyRef = FirebaseFirestore.instance.collection(('client'));
var maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')});

class ClientProfileScreen extends ConsumerStatefulWidget {
  const ClientProfileScreen([
    this.isNewClient,
    this.clientId,
    Key? key,
  ]) : super(key: key);

  final bool? isNewClient;
  final String? clientId;

  @override
  ConsumerState<ClientProfileScreen> createState() =>
      _ClientProfileScreenState();
}

class _ClientProfileScreenState extends ConsumerState<ClientProfileScreen> {
  //final _db = FirebaseFirestore.instance;

  final clientFNameController = TextEditingController();
  final clientLNameController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final clientStateController = TextEditingController();
  final zipController = TextEditingController();
  final cellPhoneController = TextEditingController();
  final homePhoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    clientFNameController.dispose();
    clientLNameController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    clientStateController.dispose();
    zipController.dispose();
    cellPhoneController.dispose();
    homePhoneController.dispose();
    emailController.dispose();

    super.dispose();
  }

  bool showSpinner = false;
  String? fName;
  String? lName;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? zip;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;
  String? _currentClientState;
  // String? _currentAppraiserCompanyName;

  getCurrentClientProfile() async {
    if (ref.read(globalsNotifierProvider).companyId == null ||
        ref.read(globalsNotifierProvider).companyId == "") {
      ref.read(globalsNotifierProvider.notifier).updatenewCompany(true);
      clientFNameController.text = "";
      clientLNameController.text = "";
      address1Controller.text = "";
      address2Controller.text = "";
      cityController.text = "";
      clientStateController.text = "";
      zipController.text = "";
      cellPhoneController.text = "";
      homePhoneController.text = "";
      emailController.text = "";
    } else {
      final DocumentSnapshot currentClientProfile =
          await appraiserCompanyRef.doc(widget.clientId).get();

      // existing record
      // Updates Controllers
      clientFNameController.text = currentClientProfile["fName"] ?? "";
      clientLNameController.text = currentClientProfile['lName'] ?? "";
      address1Controller.text = currentClientProfile['address1'] ?? "";
      address2Controller.text = currentClientProfile['address2'] ?? "";
      cityController.text = currentClientProfile['city'] ?? "";
      clientStateController.text = currentClientProfile['clientState'] ?? "";

      setState(() {
        _currentClientState = currentClientProfile['clientState'] ?? "";
      });

      zipController.text = currentClientProfile['zipCode'].toString();
      cellPhoneController.text = currentClientProfile['cellPhone'] ?? "";
      homePhoneController.text = currentClientProfile['homePhone'] ?? "";
      emailController.text = currentClientProfile['email'] ?? "";

      // Populate the state Notifier Provider with the current values
      ClientNotifier clientProvider = ref.read(clientNotifierProvider.notifier);
      clientProvider.updateFName(clientFNameController.text);
      clientProvider.updateLName(clientLNameController.text);
      clientProvider.updateAddress1(address1Controller.text);
      clientProvider.updateAddress2(address2Controller.text);
      clientProvider.updateCity(cityController.text);
      clientProvider.updateClientState(clientStateController.text);
      clientProvider.updateZipCode(zipController.text);
      clientProvider.updateCellPhone(cellPhoneController.text);
      clientProvider.updateHomePhone(homePhoneController.text);
      clientProvider.updateEmail(emailController.text);
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
      _currentClientState = selectedState;
      ref
          .read(globalsNotifierProvider.notifier)
          .updatecurrentCompanyState(selectedState!);
      ref
          .read(globalsNotifierProvider.notifier)
          .updateselectedState(selectedState);
      ref
          .read(clientNotifierProvider.notifier)
          .updateClientState(selectedState);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isNewClient!) {
        getCurrentClientProfile();
      }
    });

    super.initState();

    _dropDownState = getDropDownState();
    //_currentAppraiserCompanyState = _dropDownState[0].value;
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
                  'Client Profile',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 30.sp,
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: clientFNameController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(clientNotifierProvider.notifier)
                        .updateFName(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'First Name', labelText: 'First Name'),
                ),
                SizedBox(height: 8.sp,),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: clientLNameController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(clientNotifierProvider.notifier)
                        .updateLName(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Last Name', labelText: 'Last Name'),
                ),
                SizedBox(height: 8.sp,),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: address1Controller,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(clientNotifierProvider.notifier)
                        .updateAddress1(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Address 1', labelText: 'Address 1'),
                ),
                SizedBox(height: 8.sp,),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: address2Controller,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(clientNotifierProvider.notifier)
                        .updateAddress2(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Address 2', labelText: 'Address 2'),
                ),
                SizedBox(height: 8.sp,),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: cityController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref.read(clientNotifierProvider.notifier).updateCity(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'City', labelText: 'City'),
                ),
                SizedBox(height: 8.sp,),
                DropdownButton(
                  value: _currentClientState,
                  items: _dropDownState,
                  hint: const Text('Choose State'),
                  onChanged: changedDropDownState,
                ),
                SizedBox(height: 8.sp,),
                TextField(
                  controller: zipController,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(clientNotifierProvider.notifier)
                        .updateZipCode(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Zip Code', labelText: 'Zip Code'),
                ),
                SizedBox(height: 8.sp,),
                TextField(
                  inputFormatters: [maskFormatter],
                  controller: cellPhoneController,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(clientNotifierProvider.notifier)
                        .updateCellPhone(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Cell Phone', labelText: 'Cell Phone'),
                ),
                SizedBox(height: 8.sp,),
                TextField(
                  inputFormatters: [maskFormatter],
                  controller: homePhoneController,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(clientNotifierProvider.notifier)
                        .updateHomePhone(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Office Phone', labelText: 'Office Phone'),
                ),
                SizedBox(height: 8.sp,),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(clientNotifierProvider.notifier)
                        .updateEmail(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Email', labelText: 'Email'),
                ),
                SizedBox(height: 8.sp,),
                // TextField(
                //   controller: websiteController,
                //   textAlign: TextAlign.center,
                //   onChanged: (value) {
                //     ref.read(clientProvider.notifier).updateWebsite(value);
                //   },
                //   decoration: const InputDecoration(
                //       hintText: 'Website', labelText: 'Website'),
                // ),
                // const SizedBox(
                //   height: 8.0,
                // ),
                RoundedButton(
                  title: 'Save Client',
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
                      if (widget.clientId == "" || widget.clientId == null) {
                        ref
                            .read(clientNotifierProvider.notifier)
                            .saveClient(ref.read(clientNotifierProvider), true);
                      } else {
                        ref.read(clientNotifierProvider.notifier).saveClient(
                            ref.read(clientNotifierProvider),
                            false,
                            widget.clientId);
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
                SizedBox(height: 8.sp,),
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
    );
  }
}
