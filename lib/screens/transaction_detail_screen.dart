//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

// ignore_for_file: unused_field, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison, unused_local_variable, unused_element

import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/client_provider.dart';
import 'package:deal_diligence/Providers/event_provider.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/trxn_provider.dart';
import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:deal_diligence/components/rounded_button.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:deal_diligence/screens/google_event_add.dart';
//import 'package:deal_diligence/screens/list_of_trxns.dart';
import 'package:deal_diligence/screens/main_screen.dart';
import 'package:deal_diligence/screens/popup_commission.dart';
import 'package:deal_diligence/screens/property_webview_screen.dart';
import 'package:deal_diligence/screens/widgets/add_all_calendars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

String? loggedInUid;
String? _trxnStatus;
String? _companyId;
String? _selectedCompany;
String? _selectedUser;
String? _selectedClientState;
String? _selectedClientType;
String? _selectedTrxnStatus;
String? _selectedInspectorCompany;
String? _selectedAppraiserCompany;
String? _selectedOtherAgentCompany;
String? _selectedTitleCompany;
String? _selectedMortgageCompany;
String? _selectedOtherTitleCompany;
String? _currentPropertyState;
String? _currentClientState;
String? _currentClientType;
String? _currentTrxnStatus;

// Variables telling if a date has been changed so it can be set on the calendar
bool bContractDate = false;
bool bTwoFourASellerDisclosureDeadline = false;
bool bTwoFourBDueDiligenceDeadline = false;
bool bTwoFourCFinancingAndAppraisalDeadline = false;
bool bTwoFourDSettlementDeadline = false;
bool bInspectionDate = false;
bool bAppraisalDate = false;
bool bClosingDate = false;
bool bFinalWalkThrough = false;
bool bClientChanged = false;

var maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')});

class TransactionDetailScreen extends ConsumerStatefulWidget {
  final bool? newTrxn;
  final bool? isNewClient;

  const TransactionDetailScreen(this.newTrxn, this.isNewClient, {super.key});

  @override
  ConsumerState<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState
    extends ConsumerState<TransactionDetailScreen> {
  StreamProvider<List<Trxn>>? streamProvider;
  final _db = FirebaseFirestore.instance;
  CalendarClient calendarClient = CalendarClient();

  String? _clientId;

  DocumentReference? docRef;

  final mlsRef = FirebaseFirestore.instance.collection('mls');
  Future<void>? _launched;
  String? _clientCellPhoneNumber;
  String? _clientHomePhoneNumber;
  String? _propertyMLSNbr;
  bool _hasMLSNumber = false;
  bool _dontShowOnWeb = false;
  bool _hasContractPrice = false;
  bool _hasCellNumber = false;
  bool _hasHomeNumber = false;
  String? _mlsSearchLink;
  //String _clientType = 'Select Client Type';
  String strCommission = "0.0";
  // String? textCommission; // This holds the formatted commission value
  StreamSubscription? _trxnStream;
  StreamSubscription? _clientStream;
  DateTime eventDatePicked = DateTime.now();
  final NumberFormat currencyFormatter = NumberFormat.currency(symbol: '\$');

  DateTime contractDatePicked = DateTime.now();
  DateTime sellerDisclosureDatePicked = DateTime.now();
  DateTime dueDilienceDatePicked = DateTime.now();
  DateTime financingAppraisalDatePicked = DateTime.now();
  DateTime settlementDatePicked = DateTime.now();
  DateTime inspectionDatePicked = DateTime.now();
  DateTime appraisalDatePicked = DateTime.now();
  DateTime closingDatePicked = DateTime.now();
  DateTime walkThroughDatePicked = DateTime.now();

  final clientFNameController = TextEditingController();
  final clientLNameController = TextEditingController();
  final clientAddress1Controller = TextEditingController();
  final clientAddress2Controller = TextEditingController();
  final clientCityController = TextEditingController();
  final clientStateController = TextEditingController();
  final clientTypeController = TextEditingController();
  final clientCellPhoneController = TextEditingController();
  final clientHomePhoneController = TextEditingController();
  final clientEmailController = TextEditingController();

  final propertyAddressController = TextEditingController();
  final propertyCityController = TextEditingController();
  final propertyStateController = TextEditingController();
  final propertyZipCodeController = TextEditingController();
  final mlsNumberController = TextEditingController();
  final contractDateController = TextEditingController();
  final contractPriceController = TextEditingController();
  final sellerDisclosure24aController = TextEditingController();
  final dueDiligence24bController = TextEditingController();
  final financing2cController = TextEditingController();
  final settlement24dController = TextEditingController();
  final inspectionDateController = TextEditingController();
  final appraisalDateController = TextEditingController();
  final closingDateController = TextEditingController();
  final walkThroughDateController = TextEditingController();
  final trxnStatusController = TextEditingController();
  final trxnIdController = TextEditingController();

  @override
  void dispose() {
    clientFNameController.dispose();
    clientLNameController.dispose();
    clientAddress1Controller.dispose();
    clientAddress2Controller.dispose();
    clientTypeController.dispose();
    clientCellPhoneController.dispose();
    clientHomePhoneController.dispose();
    clientEmailController.dispose();
    propertyAddressController.dispose();
    propertyCityController.dispose();
    propertyStateController.dispose();
    propertyZipCodeController.dispose();
    mlsNumberController.dispose();
    contractDateController.dispose();
    contractPriceController.dispose();
    sellerDisclosure24aController.dispose();
    dueDiligence24bController.dispose();
    financing2cController.dispose();
    settlement24dController.dispose();
    inspectionDateController.dispose();
    appraisalDateController.dispose();
    closingDateController.dispose();
    walkThroughDateController.dispose();
    trxnStatusController.dispose();
    trxnIdController.dispose();
    if (_clientStream != null) {
      _clientStream?.cancel();
    }
    if (_clientStream != null) {
      _trxnStream?.cancel();
    }
    super.dispose();
  }

  String? trxnId = "";
  String? clientFName = "";
  String? clientLName = "";
  String? clientAddress1 = "";
  String? clientAddress2 = "";
  String? clientType = "";
  String? clientCellPhone = "";
  String? clientHomePhone = "";
  String? clientEmail = "";
  String? propertyAddress = "";
  String? propertyCity = "";
  String? propertyState = "";
  int? propertyZipCode = 0;
  String? mlsNumber = "";
  String? contractDate = "";
  int? contractPrice = 0;
  String? sellerDisclosure24a = "";
  String? dueDiligence24b = "";
  String? financing24c = "";
  String? settlement24d = "";
  String? inspectionDate = "";
  String? appraisalDate = "";
  String? closingDate = "";
  String? walkThroughDate = "";
  String? otherPartyTitleCompany = "";
  String? trxnStatus = "Select Status";

  bool showSpinner = false;

  String? _currentCompany = '';
  String? _currentUser = '';

  @override
  void initState() {
    super.initState();
    _currentCompany = ref.read(globalsNotifierProvider).companyId;
    _currentUser = ref.read(globalsNotifierProvider).currentUserId;
    String textCurrency = contractPriceController.text;
    contractPriceController.text = _formatCurrency(textCurrency);

    getTrxn();

    _dropDownState = getDropDownState();
    _dropdownClientType = getDropDownClientType();
    _dropdownTrxnStatusList = getDropDownTrxnStatus();
    _selectedUser = 'Select User';
  }

  String _currentStatus = "Select Status";

  List<DropdownMenuItem<String>>? _dropDownState;
  List<DropdownMenuItem<String>>? _dropdownClientType;
  List<DropdownMenuItem<String>>? _dropdownTrxnStatusList;

  List<DropdownMenuItem<String>> getDropDownState() {
    List<DropdownMenuItem<String>> items = [];
    for (String state in constants.kStates /* as Iterable<String>*/) {
      items.add(DropdownMenuItem(
          value: state,
          child: Text(
            state,
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownClientType() {
    List<DropdownMenuItem<String>> items = [];
    for (String clientType in constants.kClientType /* as Iterable<String>*/) {
      items.add(DropdownMenuItem(
          value: clientType,
          child: Text(
            clientType,
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownTrxnStatus() {
    List<DropdownMenuItem<String>> items = [];
    for (String trxnStatus in constants.kTrxnStatus /* as Iterable<String>*/) {
      items.add(DropdownMenuItem(
          value: trxnStatus,
          child: Text(
            trxnStatus,
          )));
    }
    return items;
  }

  String _formatCurrency(String textCurrency) {
    //String textContractPrice = contractPriceController.text;

    /// Format the contract price
    String numericCurrency = textCurrency.replaceAll(RegExp(r'[^\d]'), '');
    if (numericCurrency.isNotEmpty) {
      double value = double.parse(numericCurrency) / 100;
      String formattedText = currencyFormatter.format(value);
      if (formattedText != null) {
        return formattedText;
      } else {
        return "\$0.00";
      }
    } else {
      return "\$0.00";
    }
  }

  Future<void> _launchURL(Uri url) async {
    //const url = 'https://flutterdevs.com/';
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makeCallOrSendText(String number) async {
    var url = Uri.parse(number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Update State
  void changedDropDownState(String? selectedState) {
    setState(() {
      _currentPropertyState = selectedState;
    });
    ref
        .read(trxnNotifierProvider.notifier)
        .updatePropertyState(_currentPropertyState!);
  }

  void changedClientDropDownState(String? selectedClientState) {
    setState(() {
      _currentClientState = selectedClientState;
    });
    bClientChanged = true;
    ref
        .read(clientNotifierProvider.notifier)
        .updateClientState(selectedClientState!);
  }

  void changedDropDownClientType(String? selectedClientType) {
    setState(() {
      _currentClientType = selectedClientType;
    });

    /// ClientType is part of the transaction, NOT client
    ref
        .read(trxnNotifierProvider.notifier)
        .updateClientType(selectedClientType!);
  }

  void changedDropDownTrxnStatus(String? selectedTrxnStatus) {
    setState(() {
      _currentTrxnStatus = selectedTrxnStatus;
    });
    ref
        .read(trxnNotifierProvider.notifier)
        .updateTrxnStatus(selectedTrxnStatus!);
  }

  void changedDropDownAgency(String? selectedCompany) {
    setState(() {
      _currentCompany = selectedCompany;
    });
    ref
        .read(globalsNotifierProvider.notifier)
        .updateSelectedCompany(selectedCompany!);
  }

  void changedDropDownUser(String? selectedUser) {
    setState(() {
      _currentUser = selectedUser;
    });
    ref
        .read(globalsNotifierProvider.notifier)
        .updateSelectedUser(selectedUser!);
  }

  void changedDropDownStatus(String selectedStatus) {
    setState(() {
      _currentStatus = selectedStatus;
    });
    //globals.selectedAgent = selectedStatus;
  }

  setVisibility() {
    /*if (widget.trxns == null) {
      _hasCellNumber = false;
      _hasHomeNumber = false;
      _hasMLSNumber= false;
    } else {*/
    final trxnProvider =
        ref.read(trxnNotifierProvider); // Provider.of<TrxnProvider>(context);

    // trxnProvider.clientCellPhone != "" && trxnProvider.clientCellPhone != null
    //     ? _hasCellNumber = true
    //     : _hasCellNumber = false;
    // trxnProvider.clientHomePhone != "" && trxnProvider.clientHomePhone != null
    //     ? _hasHomeNumber = true
    //     : _hasHomeNumber = false;

    if (trxnProvider.mlsNumber != null && trxnProvider.mlsNumber != "") {
      _propertyMLSNbr = trxnProvider.mlsNumber;
      _hasMLSNumber = true;
    } else {
      _propertyMLSNbr = null;
      _hasMLSNumber = false;
    }

    if (trxnProvider.contractPrice != null &&
        trxnProvider.contractPrice != "") {
      _hasContractPrice = true;
    } else {
      _hasContractPrice = false;
    }

    _dontShowOnWeb = !kIsWeb;
    //}
  }

  getTrxn() async {
    //if (widget.trxns == null) {
    if (widget.newTrxn!) {
      _companyId = ref.read(globalsNotifierProvider).companyId;

      // new record: Set the textFields to blank
      clientFNameController.text = "";
      clientLNameController.text = "";
      clientAddress1Controller.text = "";
      clientAddress2Controller.text = "";
      clientCityController.text = "";
      clientStateController.text = "";
      clientTypeController.text = "";
      clientCellPhoneController.text = "";
      clientHomePhoneController.text = "";
      clientEmailController.text = "";

      propertyAddressController.text = "";
      propertyCityController.text = "";
      propertyStateController.text = "";
      propertyZipCodeController.text = "";
      mlsNumberController.text = "";
      contractDateController.text = "";
      contractPriceController.text = "";
      sellerDisclosure24aController.text = "";
      dueDiligence24bController.text = "";
      financing2cController.text = "";
      settlement24dController.text = "";
      inspectionDateController.text = "";
      appraisalDateController.text = "";
      closingDateController.text = "";
      walkThroughDateController.text = "";
      trxnStatusController.text = "";
      trxnIdController.text = "";
      setState(() {
        _trxnStatus = 'Select Status';
        _selectedAppraiserCompany = null;
        _selectedInspectorCompany = null;
        _selectedMortgageCompany = null;
        _selectedTitleCompany = null;
        _selectedOtherAgentCompany = null;
        _selectedOtherTitleCompany = null;
        _currentClientState = null;
        _currentClientType = 'Choose Client Type';
        _currentTrxnStatus = null;
        _currentPropertyState = "Choose State";
      });
    } else {
      // Populate controllers when transaction exists
      final DocumentSnapshot _mlsId =
          await mlsRef.doc(ref.read(usersNotifierProvider).mlsId).get();
      _mlsSearchLink = _mlsId.get('mlsNbrSearch');

      try {
        _trxnStream = _db
            .collection('company')
            .doc(ref.read(globalsNotifierProvider).companyId)
            .collection('trxns')
            .doc(ref.read(globalsNotifierProvider).currentTrxnId)
            .snapshots()
            .listen((trxnSnapshot) {
          //clientTypeController.text = trxnSnapshot.data()?['clientType'] ?? "";

          _clientId = trxnSnapshot.data()?['clientId'] ?? "";
          ref.read(trxnNotifierProvider.notifier).updateClientId(_clientId!);

          propertyAddressController.text =
              trxnSnapshot.data()?['propertyAddress'] ?? "";
          ref
              .read(trxnNotifierProvider.notifier)
              .updatePropertyAddress(propertyAddressController.text);
          propertyCityController.text =
              trxnSnapshot.data()?['propertyCity'] ?? "";
          ref
              .read(trxnNotifierProvider.notifier)
              .updatePropertyCity(propertyCityController.text);
          if (trxnSnapshot.data()?['propertyState'] == "" ||
              trxnSnapshot.data()?['propertyState'] == null) {
            _currentPropertyState = "Choose State";
          } else {
            _currentPropertyState = trxnSnapshot.data()?['propertyState'];
          }
          ref
              .read(trxnNotifierProvider.notifier)
              .updatePropertyState(propertyStateController.text);
          propertyZipCodeController.text =
              trxnSnapshot.data()?['propertyZipcode'] ?? "";
          ref
              .read(trxnNotifierProvider.notifier)
              .updatePropertyZipCode(propertyZipCodeController.text);
          mlsNumberController.text = trxnSnapshot.data()?['mlsNumber'] ?? "";
          ref
              .read(trxnNotifierProvider.notifier)
              .updateMlsNumber(mlsNumberController.text);
          if (trxnSnapshot.data()?['mlsNumber'] != null &&
              trxnSnapshot.data()?['mlsNumber'] != "") {
            _propertyMLSNbr = trxnSnapshot.data()?['mlsNumber'];
            _hasMLSNumber = true;
          } else {
            _propertyMLSNbr = null;
            _hasMLSNumber = false;
          }

          final String? contractDate = trxnSnapshot.data()?['contractDate'];
          if (contractDate != null && contractDate != "") {
            //_dt = DateTime.parse(contractDate);
            contractDateController.text = contractDate;
            //DateFormat('EE,  MM-dd-yyyy').format(_dt) ?? "";
            ref
                .read(trxnNotifierProvider.notifier)
                .updateContractDate(contractDateController.text);
          } else {
            contractDateController.text = "";
          }

          if (trxnSnapshot.data()?['contractPrice'] != null &&
              trxnSnapshot.data()?['contractPrice'] != "") {
            _hasContractPrice = true;

            /// Get the commission from the contract price
            var textCommission = trxnSnapshot.data()?['contractPrice'];
            double dblCommission = .03 * double.parse(textCommission);
            strCommission = _formatCurrency(dblCommission.toString());
            // try {
            //   commission = double.parse(strCommission);
            // } catch (e) {
            //   print(e);
            // }
          } else {
            _hasContractPrice = false;
          }
          contractPriceController.text =
              trxnSnapshot.data()?['contractPrice'] == null
                  ? 'n/a'
                  : _formatCurrency(trxnSnapshot.data()!['contractPrice']) ??
                      "";
          ref
              .read(trxnNotifierProvider.notifier)
              .updateContractPrice(contractPriceController.text);

          final String? sellerDisclosure24a =
              trxnSnapshot.data()?['sellerDisclosure24a'];
          if (sellerDisclosure24a != null && sellerDisclosure24a != "") {
            //_dt = DateTime.parse(sellerDisclosure24a);
            sellerDisclosure24aController.text = sellerDisclosure24a;
            //DateFormat('EE,  MM-dd-yyyy').format(_dt) ?? "";
            ref
                .read(trxnNotifierProvider.notifier)
                .updateSellerDisclosure24a(sellerDisclosure24aController.text);
          } else {
            sellerDisclosure24aController.text = "";
          }

          final String? dueDiligence24b =
              trxnSnapshot.data()?['dueDiligence24b'];
          if (dueDiligence24b != null && dueDiligence24b != "") {
            //_dt = DateTime.parse(dueDiligence24b);
            dueDiligence24bController.text = dueDiligence24b;
            //DateFormat('EE,  MM-dd-yyyy').format(_dt) ?? "";
            ref
                .read(trxnNotifierProvider.notifier)
                .updateDueDiligence24b(dueDiligence24bController.text);
          } else {
            dueDiligence24bController.text = "";
          }

          final String? financing24c = trxnSnapshot.data()?['financing24c'];
          if (financing24c != null && financing24c != "") {
            //_dt = DateTime.parse(financing24c);
            financing2cController.text = financing24c;
            //DateFormat('EE,  MM-dd-yyyy').format(_dt) ?? "";
            ref
                .read(trxnNotifierProvider.notifier)
                .updateFinancing24c(financing2cController.text);
          } else {
            financing2cController.text = "";
          }

          final String? settlement24d = trxnSnapshot.data()?['settlement24d'];
          if (settlement24d != null && settlement24d != "") {
            //_dt = DateTime.parse(settlement24d);
            settlement24dController.text = settlement24d;
            //DateFormat('EE,  MM-dd-yyyy').format(_dt) ?? "";
            ref
                .read(trxnNotifierProvider.notifier)
                .updateSettlement24d(settlement24dController.text);
          } else {
            settlement24dController.text = "";
          }

          if (trxnSnapshot.data()?['inspectorCompanyId'] == "" ||
              trxnSnapshot.data()?['inspectorCompanyId'] == null) {
            _selectedInspectorCompany = "Select Inspector";
          } else {
            _selectedInspectorCompany =
                trxnSnapshot.data()?['inspectorCompanyId'];
          }

          final String? inspectionDate = trxnSnapshot.data()?['inspectionDate'];
          if (inspectionDate != null && inspectionDate != "") {
            //_dt = DateTime.parse(inspectionDate);
            inspectionDateController.text = inspectionDate;
            //DateFormat('EE,  MM-dd-yyyy').format(_dt) ?? "";
            ref
                .read(trxnNotifierProvider.notifier)
                .updateInspectionDate(inspectionDateController.text);
          } else {
            inspectionDateController.text = "";
          }

          /// Initialize the appraiser drop down button
          if (trxnSnapshot.data()?['appraiserCompanyId'] == "" ||
              trxnSnapshot.data()?['appraiserCompanyId'] == null) {
            _selectedAppraiserCompany = "Select Appraiser";
          } else {
            _selectedAppraiserCompany =
                trxnSnapshot.data()?['appraiserCompanyId'];
          }

          final String? appraisalDate = trxnSnapshot.data()?['appraisalDate'];
          if (appraisalDate != null && appraisalDate != "") {
            //_dt = DateTime.parse(appraisalDate);
            appraisalDateController.text = appraisalDate;
            //DateFormat('EE,  MM-dd-yyyy').format(_dt) ?? "";
            ref
                .read(trxnNotifierProvider.notifier)
                .updateAppraisalDate(appraisalDateController.text);
          } else {
            appraisalDateController.text = "";
          }

          final String? closingDate = trxnSnapshot.data()?['closingDate'];
          if (closingDate != null && closingDate != "") {
            //_dt = DateTime.parse(closingDate);
            closingDateController.text = closingDate;
            //DateFormat('EE,  MM-dd-yyyy').format(_dt) ?? "";
            ref
                .read(trxnNotifierProvider.notifier)
                .updateClosingDate(closingDateController.text);
          } else {
            closingDateController.text = "";
          }

          final String? walkThroughDate =
              trxnSnapshot.data()?['walkThroughDate'];
          if (walkThroughDate != null && walkThroughDate != "") {
            //_dt = DateTime.parse(walkThroughDate);
            walkThroughDateController.text = walkThroughDate;
            //DateFormat('EE,  MM-dd-yyyy').format(_dt) ?? "";
            ref
                .read(trxnNotifierProvider.notifier)
                .updateWalkThroughDate(walkThroughDateController.text);
          } else {
            walkThroughDateController.text = "";
          }

          setState(() {
            if (trxnSnapshot.data()?['titleCompanyId'] == "" ||
                trxnSnapshot.data()?['titleCompanyId'] == null) {
              _selectedTitleCompany = "Select Title Company";
            } else {
              _selectedTitleCompany = trxnSnapshot.data()?['titleCompanyId'];
            }

            if (trxnSnapshot.data()?['mortgageCompanyId'] == "" ||
                trxnSnapshot.data()?['mortgageCompanyId'] == null) {
              _selectedMortgageCompany = "Select Mortgage Company";
            } else {
              _selectedMortgageCompany =
                  trxnSnapshot.data()?['mortgageCompanyId'];
            }

            if (trxnSnapshot.data()?['otherAgentCompanyId'] == "" ||
                trxnSnapshot.data()?['otherAgentCompanyId'] == null) {
              _selectedOtherAgentCompany = "Select Other Agency";
            } else {
              _selectedOtherAgentCompany =
                  trxnSnapshot.data()?['otherAgentCompanyId'];
            }

            if (trxnSnapshot.data()?['otherPartyTitleCompanyId'] == "" ||
                trxnSnapshot.data()?['otherPartyTitleCompanyId'] == null) {
              _selectedOtherTitleCompany = "Select Other Title Company";
            } else {
              _selectedOtherTitleCompany =
                  trxnSnapshot.data()?['otherPartyTitleCompanyId'];
            }

            trxnIdController.text = trxnSnapshot.data()?['trxnId'] ?? "";

            _currentClientType =
                trxnSnapshot.data()?['clientType'] ?? 'Select Client Type';
            _selectedCompany = trxnSnapshot.data()?['companyId'] ?? "";
            _selectedUser = trxnSnapshot.data()?['userId'] ?? "Select User";
            _selectedClientState = trxnSnapshot.data()?['clientState'] ?? "";
            _currentTrxnStatus =
                trxnSnapshot.data()?['trxnStatus'] ?? "Select Status";
          });

          ref
              .read(trxnNotifierProvider.notifier)
              .updatePropertyState(_currentPropertyState!);
          ref
              .read(trxnNotifierProvider.notifier)
              .updateTrxnStatus(_currentTrxnStatus);

          //////////////////////////////////////////////////
          /// Get the client data
          try {
            _clientStream = _db
                .collection('client')
                .doc(_clientId)
                .snapshots()
                .listen((clientSnapshot) {
              clientFNameController.text =
                  clientSnapshot.data()?['fName'] ?? "";
              clientLNameController.text =
                  clientSnapshot.data()?['lName'] ?? "";
              clientAddress1Controller.text =
                  clientSnapshot.data()?['address1'] ?? "";
              clientAddress2Controller.text =
                  clientSnapshot.data()?['address2'] ?? "";
              clientCityController.text = clientSnapshot.data()?['city'] ?? "";

              setState(() {
                if (clientSnapshot.data()?['clientState'] == null ||
                    clientSnapshot.data()?['clientState'] == "") {
                  _currentClientState = "Choose Client State";
                } else {
                  _currentClientState = clientSnapshot.data()?['clientState'];
                }
              });

              clientCellPhoneController.text =
                  clientSnapshot.data()?['cellPhone'] ?? "";
              clientCellPhoneController.text != "" &&
                      clientCellPhoneController.text != null
                  ? _hasCellNumber = true
                  : _hasCellNumber = false;
              _clientCellPhoneNumber =
                  clientSnapshot.data()?['cellPhone'] ?? "";
              clientHomePhoneController.text =
                  clientSnapshot.data()?['homePhone'] ?? "";
              clientHomePhoneController.text != "" &&
                      clientHomePhoneController.text != null
                  ? _hasHomeNumber = true
                  : _hasHomeNumber = false;
              _clientHomePhoneNumber =
                  clientSnapshot.data()?['homePhone'] ?? "";
              clientEmailController.text =
                  clientSnapshot.data()?['email'] ?? "";
            });
          } catch (e) {
            debugPrint(e.toString());
          }
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  populateClientProvider() {
    ref
        .read(clientNotifierProvider.notifier)
        .updateFName(clientFNameController.text);
    ref
        .read(clientNotifierProvider.notifier)
        .updateLName(clientLNameController.text);
    ref
        .read(clientNotifierProvider.notifier)
        .updateAddress1(clientAddress1Controller.text);
    ref
        .read(clientNotifierProvider.notifier)
        .updateAddress2(clientAddress2Controller.text);
    ref
        .read(clientNotifierProvider.notifier)
        .updateCity(clientCityController.text);
    ref
        .read(clientNotifierProvider.notifier)
        .updateClientState(_currentClientState!);
    ref
        .read(clientNotifierProvider.notifier)
        .updateZipCode(propertyZipCodeController.text);
    ref
        .read(clientNotifierProvider.notifier)
        .updateCellPhone(clientCellPhoneController.text);
    ref
        .read(clientNotifierProvider.notifier)
        .updateHomePhone(clientHomePhoneController.text);
    ref
        .read(clientNotifierProvider.notifier)
        .updateEmail(clientEmailController.text);
  }

  populateTrxnProvider() {
    try {
      ref
          .read(trxnNotifierProvider.notifier)
          .updateCompanyId(ref.read(globalsNotifierProvider).companyId!);

      /// Only populate the clientID if it is blank
      if (ref.read(trxnNotifierProvider).clientId == null ||
          ref.read(trxnNotifierProvider).clientId == "") {
        ref
            .read(trxnNotifierProvider.notifier)
            .updateClientId(ref.read(clientNotifierProvider).clientId!);
      }
      ref
          .read(trxnNotifierProvider.notifier)
          .updateClientType(_currentClientType!);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateUserId(ref.read(usersNotifierProvider).userId!);
      ref
          .read(trxnNotifierProvider.notifier)
          .updatePropertyAddress(propertyAddressController.text);
      ref
          .read(trxnNotifierProvider.notifier)
          .updatePropertyCity(propertyCityController.text);
      ref
          .read(trxnNotifierProvider.notifier)
          .updatePropertyState(_currentPropertyState!);
      ref
          .read(trxnNotifierProvider.notifier)
          .updatePropertyZipCode(propertyZipCodeController.text);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateMlsNumber(mlsNumberController.text);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateContractDate(contractDateController.text);

      /// Get just the numbers from the contract price to save to db
      String contractPriceStr =
          contractPriceController.text.replaceAll(RegExp(r'[^0-9]'), '');
      ref
          .read(trxnNotifierProvider.notifier)
          .updateContractPrice(contractPriceStr);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateSellerDisclosure24a(sellerDisclosure24aController.text);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateDueDiligence24b(dueDiligence24bController.text);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateFinancing24c(financing2cController.text);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateSettlement24d(settlement24dController.text);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateInspectionDate(inspectionDateController.text);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateAppraisalDate(appraisalDateController.text);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateClosingDate(closingDateController.text);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateWalkThroughDate(walkThroughDateController.text);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateTrxnStatus(_currentTrxnStatus);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateOtherAgentCompanyId(_selectedOtherAgentCompany!);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateMortgageCompanyId(_selectedMortgageCompany!);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateTitleCompanyId(_selectedTitleCompany!);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateOtherPartyTitleCompanyId(_selectedOtherTitleCompany!);
      ref
          .read(trxnNotifierProvider.notifier)
          .updateAppraiserCompanyId(_selectedAppraiserCompany!);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the stream of transactions created in main.dart

    DateTime _date = DateTime.now();
    DateTime _selectedDate = DateTime.now();
    TimeOfDay _eventTime = TimeOfDay.now();

    setVisibility();

    return Scaffold(
      //appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // This fixes the keyboard white space
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.sp),
            child: Column(
              children: <Widget>[
                Text('Transaction Details', style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold,)),
                SizedBox(
                  height: 30.sp,
                ),
                const Text(
                  'Select User',
                  style: TextStyle(
                    
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 8.sp,
                ),
                Container(
                  /* Populate the Agent dropdown only if
                       there is an agency to associate the agent with.
                     */
                  child: _currentCompany != null && _currentCompany != ""
                      ? StreamBuilder(
                          stream: _db
                              .collection('users')
                              .where('companyId', isEqualTo: _currentCompany)
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            List<DropdownMenuItem<String>> userItems = [];
                            userItems.add(
                              const DropdownMenuItem<String>(
                                value: 'Select User',
                                child: Text('Select User'),
                              ),
                            );
                            if (snapshot.hasData) {
                              final userList = snapshot.data.docs;
                              for (var user in userList) {
                                userItems.add(
                                  DropdownMenuItem(
                                    value: user.id,
                                    child: Text(
                                      user['fName'] + '' + user['lName'],
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return const CircularProgressIndicator();
                            }
                            return DropdownButton<String>(
                              hint: const Text("Select User"),
                              value: _selectedUser,
                              onChanged: (userValue) {
                                setState(() {
                                  _selectedUser = userValue;
                                  ref
                                      .read(globalsNotifierProvider.notifier)
                                      .updateCurrentUserId(userValue!);
                                });
                              },
                              items: userItems,
                            );
                          })
                      : const Text('No users yet'),
                ),
                SizedBox(
                  height: 30.sp,
                ),

                /// Display the client information in a collapsible panel
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ExpansionTile(
                        subtitle: Text(
                            '${clientFNameController.text} ${clientLNameController.text}'),
                        title: const Text(
                          'Client Information',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        children: [
                          TextField(
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            controller: clientFNameController,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              ref
                                  .read(clientNotifierProvider.notifier)
                                  .updateFName(value);
                              bClientChanged = true;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Client First Name',
                                labelText: 'Client First Name'),
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            controller: clientLNameController,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              ref
                                  .read(clientNotifierProvider.notifier)
                                  .updateLName(value);
                              bClientChanged = true;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Client Last Name',
                                labelText: 'Client Last Name'),
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            controller: clientAddress1Controller,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              ref
                                  .read(clientNotifierProvider.notifier)
                                  .updateAddress1(value);
                              bClientChanged = true;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Address 1', labelText: 'Address 1'),
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            controller: clientAddress2Controller,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              ref
                                  .read(clientNotifierProvider.notifier)
                                  .updateAddress2(value);
                              bClientChanged = true;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Address 2', labelText: 'Address 2'),
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            controller: clientCityController,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              ref
                                  .read(clientNotifierProvider.notifier)
                                  .updateCity(value);
                              bClientChanged = true;
                            },
                            decoration: const InputDecoration(
                                hintText: 'City', labelText: 'City'),
                          ),
                          DropdownButton(
                            value: _currentClientState,
                            items: _dropDownState,
                            hint: const Text('Choose Client State'),
                            onChanged: changedClientDropDownState,
                          ),
                          TextField(
                            inputFormatters: [maskFormatter],
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            controller: clientCellPhoneController,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              ref
                                  .read(clientNotifierProvider.notifier)
                                  .updateCellPhone(value);
                              bClientChanged = true;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Cell Phone',
                                labelText: 'Cell Phone'),
                          ),
                          TextField(
                            inputFormatters: [maskFormatter],
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            controller: clientHomePhoneController,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              ref
                                  .read(clientNotifierProvider.notifier)
                                  .updateHomePhone(value);
                              bClientChanged = true;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Home Phone',
                                labelText: 'Home Phone'),
                          ),

                          /// Hide this row if on the web because they don't work on web
                          Visibility(
                            visible: _dontShowOnWeb,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.message),
                                      iconSize: 25,
                                      color: Colors.blueAccent,
                                      tooltip: 'Text Client',
                                      onPressed: () {
                                        setState(() {
                                          _launched = _makeCallOrSendText(
                                              'sms:$_clientCellPhoneNumber');
                                        });
                                      },
                                    ),
                                    const Text('Text'),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add_call),
                                      iconSize: 25,
                                      color: Colors.blueAccent,
                                      tooltip: 'Call Cell',
                                      onPressed: () {
                                        setState(() {
                                          _launched = _makeCallOrSendText(
                                              'tel:$_clientCellPhoneNumber');
                                        });
                                      },
                                    ),
                                    const Text('Call Cell'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add_call),
                                      iconSize: 25,
                                      color: Colors.blueAccent,
                                      tooltip: 'Call Home',
                                      onPressed: () {
                                        setState(() {
                                          _launched = _makeCallOrSendText(
                                              'tel:$_clientHomePhoneNumber');
                                        });
                                      },
                                    ),
                                    const Text('Call Home'),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          TextField(
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            controller: clientEmailController,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              ref
                                  .read(clientNotifierProvider.notifier)
                                  .updateEmail(value);
                              bClientChanged = true;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Email', labelText: 'Email'),
                          ),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                /// //////////////////////////////////////
                DropdownButton(
                  value: _currentClientType,
                  items: _dropdownClientType,
                  hint: const Text('Choose Client Type'),
                  onChanged: changedDropDownClientType,
                ),

                /// ////////////////////////////////////////
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  controller: propertyAddressController,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updatePropertyAddress(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Property Address',
                      labelText: 'Property Address'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  controller: propertyCityController,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updatePropertyCity(value); //, loggedInUid);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Property City', labelText: 'Property City'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                DropdownButton<String>(
                  //icon: const Icon(Icons.add_to_home_screen),
                  value: _currentPropertyState,
                  items: _dropDownState,
                  hint: const Text('Choose State'),
                  onChanged: changedDropDownState,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: propertyZipCodeController,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updatePropertyZipCode(value); //, loggedInUid);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Property Zip Code',
                      labelText: 'Property Zip Code'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: mlsNumberController,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updateMlsNumber(value); //, loggedInUid);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Property MLS #', labelText: 'Property MLS #'),
                ),
                Visibility(
                  visible: _hasMLSNumber,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.water_damage),
                            iconSize: 25,
                            color: Colors.blueAccent,
                            tooltip: 'View Property',
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PropertyWebViewScreenContainer(
                                            '$_mlsSearchLink$_propertyMLSNbr'),
                                    //PropertyWebViewScreenContainer('https://www.utahrealestate.com/$_propertyMLSNbr'),
                                  ),
                                );
                              });
                            },
                          ),
                          const Text('View Property'),
                          const SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.center,
                  controller: contractDateController,
                  onTap: () async {
                    DateTime? _datePicked = await (showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2040)));
                    if (!context.mounted) return;
                    if (_date != null &&
                        _datePicked != null &&
                        _date != _datePicked) {
                      // Add time to the calendar event
                      TimeOfDay? _timePicked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      DateTime tempTime = DateFormat("hh:mm").parse(
                          '${_timePicked!.hour.toString()}:${_timePicked.minute.toString()}');
                      var timeFormat = DateFormat("h:mm a");
                      setState(() {
                        contractDateController.text =
                            '${DateFormat("EE  MM-dd-yyyy").format(_datePicked)} ${timeFormat.format(tempTime)}';
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateContractDate(_datePicked.toString());
                        _selectedDate = _datePicked;

                        bContractDate = true;
                        eventDatePicked = DateTime(
                          _datePicked.year,
                          _datePicked.month,
                          _datePicked.day,
                          _timePicked.hour,
                          _timePicked.minute,
                        );
                        contractDatePicked = DateTime(
                          _datePicked.year,
                          _datePicked.month,
                          _datePicked.day,
                          _timePicked.hour,
                          _timePicked.minute,
                        );
                      });
                    }
                  },
                  onChanged: (value) {
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updateContractDate(value);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Contract Date',
                    labelText: 'Contract Date',
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: contractPriceController,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updateContractPrice(value); //, loggedInUid);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Contract Price', labelText: 'Contract Price'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Visibility(
                  visible: _hasContractPrice,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          TextButton(
                            child: Text(
                              '3% Commission: ${_formatCurrency(strCommission)}',
                              style: const TextStyle(fontSize: 15),
                            ),
                            onPressed: () {
                              CommissionCalculatorPopup
                                  .showCommissionCalculator(
                                      context,
                                      double.parse(
                                          contractPriceController.text));
                            },
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: sellerDisclosure24aController,
                  textAlign: TextAlign.center,
                  onTap: () async {
                    DateTime? _datePicked = await (showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2040)));
                    if (!context.mounted) return;

                    if (_date != null && _date != _datePicked) {
                      TimeOfDay? _timePicked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      DateTime tempTime = DateFormat("hh:mm").parse(
                          '${_timePicked!.hour.toString()}:${_timePicked.minute.toString()}');
                      var timeFormat = DateFormat("h:mm a");
                      setState(() {
                        sellerDisclosure24aController.text =
                            '${DateFormat("EE  MM-dd-yyyy").format(_datePicked!)} ${timeFormat.format(tempTime)}';
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateSellerDisclosure24a(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                      bTwoFourASellerDisclosureDeadline = true;
                      eventDatePicked = DateTime(
                        _datePicked!.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                      sellerDisclosureDatePicked = DateTime(
                        _datePicked.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                    }
                  },
                  onChanged: (value) {
                    bTwoFourASellerDisclosureDeadline = true;
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updateSellerDisclosure24a(value);
                  },
                  decoration: const InputDecoration(
                      hintText: '24a. Seller Disclosures Deadline',
                      labelText: '24a. Seller Disclosures Deadline'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: dueDiligence24bController,
                  textAlign: TextAlign.center,
                  onTap: () async {
                    DateTime? _datePicked = await (showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2040)));
                    if (!context.mounted) return;

                    if (_date != null && _date != _datePicked) {
                      TimeOfDay? _timePicked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      DateTime tempTime = DateFormat("hh:mm").parse(
                          '${_timePicked!.hour.toString()}:${_timePicked.minute.toString()}');
                      var timeFormat = DateFormat("h:mm a");
                      setState(() {
                        dueDiligence24bController.text =
                            '${DateFormat("EE  MM-dd-yyyy").format(_datePicked!)} ${timeFormat.format(tempTime)}';
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateDueDiligence24b(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                      bTwoFourBDueDiligenceDeadline = true;
                      eventDatePicked = DateTime(
                        _datePicked!.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                      dueDilienceDatePicked = DateTime(
                        _datePicked.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                    }
                  },
                  onChanged: (value) {
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updateDueDiligence24b(value);
                  },
                  decoration: const InputDecoration(
                      hintText: '24b. Due Diligence Deadline',
                      labelText: '24b. Due Diligence Deadline'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: financing2cController,
                  textAlign: TextAlign.center,
                  onTap: () async {
                    DateTime? _datePicked = await (showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2040)));
                    if (!context.mounted) return;

                    if (_date != null && _date != _datePicked) {
                      TimeOfDay? _timePicked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      DateTime tempTime = DateFormat("hh:mm").parse(
                          '${_timePicked!.hour.toString()}:${_timePicked.minute.toString()}');
                      var timeFormat = DateFormat("h:mm a");
                      setState(() {
                        financing2cController.text =
                            '${DateFormat("EE  MM-dd-yyyy").format(_datePicked!)} ${timeFormat.format(tempTime)}';
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateFinancing24c(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                      bTwoFourCFinancingAndAppraisalDeadline = true;
                      eventDatePicked = DateTime(
                        _datePicked!.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                      financingAppraisalDatePicked = DateTime(
                        _datePicked.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                    }
                  },
                  onChanged: (value) {
                    bTwoFourBDueDiligenceDeadline = true;
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updateFinancing24c(value);
                  },
                  decoration: const InputDecoration(
                      hintText: '24c. Financing & Appraisal Deadline',
                      labelText: '24c. Financing & Appraisal Deadline'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: settlement24dController,
                  textAlign: TextAlign.center,
                  onTap: () async {
                    DateTime? _datePicked = await (showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2040)));
                    if (!context.mounted) return;

                    if (_date != null && _date != _datePicked) {
                      TimeOfDay? _timePicked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      DateTime tempTime = DateFormat("hh:mm").parse(
                          '${_timePicked!.hour.toString()}:${_timePicked.minute.toString()}');
                      var timeFormat = DateFormat("h:mm a");
                      setState(() {
                        settlement24dController.text =
                            '${DateFormat("EE  MM-dd-yyyy").format(_datePicked!)} ${timeFormat.format(tempTime)}';
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateSettlement24d(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                      bTwoFourDSettlementDeadline = true;
                      eventDatePicked = DateTime(
                        _datePicked!.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                      settlementDatePicked = DateTime(
                        _datePicked.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                    }
                  },
                  onChanged: (value) {
                    bTwoFourCFinancingAndAppraisalDeadline = true;
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updateSettlement24d(value);
                  },
                  decoration: const InputDecoration(
                      hintText: '24d. Settlement Deadline',
                      labelText: '24d. Settlement Deadline'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Inspector Company'),
                  ],
                ),
                Row(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: _db.collection('inspectorCompany').snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        List<DropdownMenuItem<String>> inspectorCompanyItems =
                            [];
                        inspectorCompanyItems.add(
                            const DropdownMenuItem<String>(
                                value: 'Select Inspector',
                                child: Text('Select Inspector')));
                        if (snapshot.hasData) {
                          final inspectorCompanyList = snapshot.data!.docs;
                          for (var inspectorCompany in inspectorCompanyList) {
                            inspectorCompanyItems.add(
                              DropdownMenuItem<String>(
                                value: inspectorCompany.id,
                                child: Text(
                                  inspectorCompany['inspectorCompanyName'],
                                ),
                              ),
                            );
                          }
                          if (inspectorCompanyItems.isNotEmpty) {
                            return DropdownButton<String>(
                              hint: const Text("Select Inspector"),
                              value: _selectedInspectorCompany ??
                                  inspectorCompanyItems[0].value,
                              onChanged: (inspectorCompanyValue) {
                                setState(() {
                                  _selectedInspectorCompany =
                                      inspectorCompanyValue;
                                });
                                ref
                                    .read(trxnNotifierProvider.notifier)
                                    .updateInspectorCompanyId(
                                        _selectedInspectorCompany!);
                              },
                              items: inspectorCompanyItems,
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: inspectionDateController,
                  textAlign: TextAlign.center,
                  onTap: () async {
                    DateTime? _datePicked = await (showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2040)));
                    if (!context.mounted) return;

                    if (_date != null && _date != _datePicked) {
                      TimeOfDay? _timePicked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      DateTime tempTime = DateFormat("hh:mm").parse(
                          '${_timePicked!.hour.toString()}:${_timePicked.minute.toString()}');
                      var timeFormat = DateFormat("h:mm a");
                      setState(() {
                        inspectionDateController.text =
                            '${DateFormat("EE  MM-dd-yyyy").format(_datePicked!)} ${timeFormat.format(tempTime)}';
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateInspectionDate(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                      bInspectionDate = true;
                      eventDatePicked = DateTime(
                        _datePicked!.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                      inspectionDatePicked = DateTime(
                        _datePicked.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                    }
                    /*
                      var date = await (showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100)) as FutureOr<DateTime>);
                      inspectionDateController.text =
                          DateFormat("MM/dd/yyyy").format(date);
                      trxnProvider.changeinspectionDate(
                          DateFormat("MM/dd/yyyy").format(date));
                      */
                  },
                  onChanged: (value) {
                    bInspectionDate = true;
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updateInspectionDate(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Inspection Date',
                      labelText: 'Inspection Date'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const Row(
                  children: [
                    Text('Appraiser Company'),
                  ],
                ),
                Row(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: _db.collection('appraiserCompany').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Error loading data'),
                          );
                        }
                        final appraiserCompanyItems =
                            <DropdownMenuItem<String>>[];
                        appraiserCompanyItems.add(
                          const DropdownMenuItem<String>(
                            value: 'Select Appraiser',
                            child: Text('Select Appraiser'),
                          ),
                        );
                        snapshot.data!.docs.forEach((appraiserCompany) {
                          appraiserCompanyItems.add(
                            DropdownMenuItem<String>(
                              value: appraiserCompany.id,
                              child: Text(
                                  appraiserCompany['appraiserCompanyName']),
                            ),
                          );
                        });
                        return DropdownButton<String>(
                          hint: const Text("Select Appraiser"),
                          value: _selectedAppraiserCompany ??
                              appraiserCompanyItems[0].value,
                          onChanged: (appraiserCompanyValue) {
                            setState(() {
                              _selectedAppraiserCompany = appraiserCompanyValue;
                            });
                            ref
                                .read(trxnNotifierProvider.notifier)
                                .updateAppraiserCompanyId(
                                    _selectedAppraiserCompany!);
                          },
                          items: appraiserCompanyItems,
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: appraisalDateController,
                  textAlign: TextAlign.center,
                  onTap: () async {
                    DateTime? _datePicked = await (showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2040)));
                    if (!context.mounted) return;

                    if (_date != null && _date != _datePicked) {
                      TimeOfDay? _timePicked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      DateTime tempTime = DateFormat("hh:mm").parse(
                          '${_timePicked!.hour.toString()}:${_timePicked.minute.toString()}');
                      var timeFormat = DateFormat("h:mm a");
                      setState(() {
                        appraisalDateController.text =
                            '${DateFormat("EE  MM-dd-yyyy").format(_datePicked!)} ${timeFormat.format(tempTime)}';
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateAppraisalDate(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                      bAppraisalDate = true;
                      eventDatePicked = DateTime(
                        _datePicked!.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                      appraisalDatePicked = DateTime(
                        _datePicked.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                    }

                    /*
                      var date = await (showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100)) as FutureOr<DateTime>);
                      appraisalDateController.text =
                          DateFormat("MM/dd/yyyy").format(date);
                      trxnProvider.changeappraisalDate(
                          DateFormat("MM/dd/yyyy").format(date));
                      */
                  },
                  onChanged: (value) {
                    bAppraisalDate = true;
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updateAppraisalDate(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Appraisal Date', labelText: 'Appraisal Date'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: closingDateController,
                  textAlign: TextAlign.center,
                  onTap: () async {
                    DateTime? _datePicked = await (showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2040)));
                    if (!context.mounted) return;

                    if (_date != null && _date != _datePicked) {
                      TimeOfDay? _timePicked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      DateTime tempTime = DateFormat("hh:mm").parse(
                          '${_timePicked!.hour.toString()}:${_timePicked.minute.toString()}');
                      var timeFormat = DateFormat("h:mm a");
                      setState(() {
                        closingDateController.text =
                            '${DateFormat("EE  MM-dd-yyyy").format(_datePicked!)} ${timeFormat.format(tempTime)}';
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateClosingDate(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                      bClosingDate = true;
                      eventDatePicked = DateTime(
                        _datePicked!.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                      closingDatePicked = DateTime(
                        _datePicked.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                    }

                    /*
                      var date = await (showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100)) as FutureOr<DateTime>);
                      closingDateController.text =
                          DateFormat("MM/dd/yyyy").format(date);
                      trxnProvider.changeclosingDate(
                          DateFormat("MM/dd/yyyy").format(date));
                      */
                  },
                  onChanged: (value) {
                    bClosingDate = true;
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updateClosingDate(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Closing Date', labelText: 'Closing Date'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: walkThroughDateController,
                  textAlign: TextAlign.center,
                  onTap: () async {
                    DateTime? _datePicked = await (showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2040)));
                    if (!context.mounted) return;

                    if (_date != null && _date != _datePicked) {
                      TimeOfDay? _timePicked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      DateTime tempTime = DateFormat("hh:mm").parse(
                          '${_timePicked!.hour.toString()}:${_timePicked.minute.toString()}');
                      var timeFormat = DateFormat("h:mm a");
                      setState(() {
                        walkThroughDateController.text =
                            '${DateFormat("EE  MM-dd-yyyy").format(_datePicked!)} ${timeFormat.format(tempTime)}';
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateWalkThroughDate(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                      bFinalWalkThrough = true;
                      eventDatePicked = DateTime(
                        _datePicked!.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                      walkThroughDatePicked = DateTime(
                        _datePicked.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                    }
                  },
                  onChanged: (value) {
                    bFinalWalkThrough = true;
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updateWalkThroughDate(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Final Walk Through Date',
                      labelText: 'Final Walk Through Date'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Title Company',
                    ),
                  ],
                ),
                Row(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: _db.collection('titleCompany').snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          List<DropdownMenuItem<String>> titleCompanyItems = [];
                          titleCompanyItems.add(const DropdownMenuItem<String>(
                              value: 'Select Title Company',
                              child: Text('Select Title Company')));
                          if (snapshot.hasData) {
                            final titleCompanyList = snapshot.data.docs;
                            for (var titleCompany in titleCompanyList) {
                              titleCompanyItems.add(
                                DropdownMenuItem(
                                  value: titleCompany.id,
                                  child: Text(
                                    titleCompany['titleCompanyName'],
                                  ),
                                ),
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (titleCompanyItems.isNotEmpty) {
                            return DropdownButton<String>(
                              hint: const Text("Select Title Company"),
                              value: _selectedTitleCompany ??
                                  titleCompanyItems[0].value,
                              onChanged: (titleCompanyValue) {
                                setState(() {
                                  _selectedTitleCompany = titleCompanyValue;
                                });
                                ref
                                    .read(trxnNotifierProvider.notifier)
                                    .updateTitleCompanyId(
                                        _selectedTitleCompany!);
                              },
                              items: titleCompanyItems,
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const Row(
                  children: [
                    Text(
                      'Mortgage Company',
                    ),
                  ],
                ),
                Row(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: _db.collection('mortgageCompany').snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          List<DropdownMenuItem<String>> mortgageCompanyItems =
                              [];
                          mortgageCompanyItems.add(
                              const DropdownMenuItem<String>(
                                  value: 'Select Mortgage Company',
                                  child: Text('Select Mortgage Company')));
                          if (snapshot.hasData) {
                            final mortgageCompanyList = snapshot.data.docs;
                            for (var mortgageCompany in mortgageCompanyList) {
                              mortgageCompanyItems.add(
                                DropdownMenuItem(
                                  value: mortgageCompany.id,
                                  child: Text(
                                    mortgageCompany['mortgageCompanyName'],
                                  ),
                                ),
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (mortgageCompanyItems.isNotEmpty) {
                            return DropdownButton<String>(
                              hint: const Text("Select Mortgage Company"),
                              value: _selectedMortgageCompany ??
                                  mortgageCompanyItems[0].value,
                              onChanged: (mortgageCompanyValue) {
                                setState(() {
                                  _selectedMortgageCompany =
                                      mortgageCompanyValue;
                                });
                                ref
                                    .read(trxnNotifierProvider.notifier)
                                    .updateMortgageCompanyId(
                                        _selectedMortgageCompany!);
                              },
                              items: mortgageCompanyItems,
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const Row(
                  children: [
                    Text(
                      'Other Agent Company:    ',
                    ),
                  ],
                ),
                Row(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: _db.collection('company').snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          List<DropdownMenuItem<String>> otherCompanyItems = [];
                          otherCompanyItems.add(const DropdownMenuItem<String>(
                              value: 'Select Other Agency',
                              child: Text('Select Other Agency')));
                          if (snapshot.hasData) {
                            final otherCompanyList = snapshot.data.docs;
                            for (var otherCompany in otherCompanyList) {
                              otherCompanyItems.add(
                                DropdownMenuItem(
                                  value: otherCompany.id,
                                  child: Text(
                                    otherCompany['name'],
                                  ),
                                ),
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return DropdownButton<String>(
                            hint: const Text("Select Other Agency"),
                            value: _selectedOtherAgentCompany ??
                                otherCompanyItems[0].value,
                            onChanged: (otherCompanyValue) {
                              setState(() {
                                _selectedOtherAgentCompany = otherCompanyValue;
                              });
                              ref
                                  .read(trxnNotifierProvider.notifier)
                                  .updateOtherAgentCompanyId(
                                      _selectedOtherAgentCompany!);
                            },
                            items: otherCompanyItems,
                          );
                        }),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                // TextField(
                //   keyboardType: TextInputType.text,
                //   controller: otherPartyClientController,
                //   textAlign: TextAlign.center,
                //   onChanged: (value) {
                //     ref
                //         .read(trxnNotifierProvider.notifier)
                //         .updateOtherPartyClient(value); //, loggedInUid);
                //   },
                //   decoration: const InputDecoration(
                //       hintText: 'Other Party Client',
                //       labelText: 'Other Party Client'),
                // ),
                const SizedBox(
                  height: 8.0,
                ),
                const Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Other Title Company:    ',
                    ),
                  ],
                ),
                Row(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: _db.collection('titleCompany').snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          List<DropdownMenuItem<String>>
                              otherTitleCompanyItems = [];
                          otherTitleCompanyItems.add(
                              const DropdownMenuItem<String>(
                                  value: 'Select Other Title Company',
                                  child: Text('Select Other Title Company')));
                          if (snapshot.hasData) {
                            final otherTitleCompanyList = snapshot.data.docs;
                            for (var otherTitleCompany
                                in otherTitleCompanyList) {
                              otherTitleCompanyItems.add(
                                DropdownMenuItem(
                                  value: otherTitleCompany.id,
                                  child: Text(
                                    otherTitleCompany['titleCompanyName'],
                                  ),
                                ),
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return DropdownButton<String>(
                            hint: const Text("Select Title Company"),
                            value: _selectedOtherTitleCompany ??
                                otherTitleCompanyItems[0].value,
                            onChanged: (otherTitleCompanyValue) {
                              setState(() {
                                _selectedOtherTitleCompany =
                                    otherTitleCompanyValue;
                              });
                              ref
                                  .read(trxnNotifierProvider.notifier)
                                  .updateOtherPartyTitleCompanyId(
                                      _selectedOtherTitleCompany!);
                            },
                            items: otherTitleCompanyItems,
                          );
                        }),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                DropdownButton(
                  value: _currentTrxnStatus,
                  items: _dropdownTrxnStatusList,
                  hint: const Text('Select Status'),
                  onChanged: changedDropDownTrxnStatus,
                ),
                RoundedButton(
                  title: 'Save',
                  colour: Colors.blueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });

                    try {
                      /// ////////////////////////////////
                      /// Save the client data
                      if (bClientChanged == true) {
                        /// Gather the data from the client text controllers
                        populateClientProvider();

                        try {
                          /// Save the client information for the trxn
                          if (ref.read(clientNotifierProvider).clientId ==
                                  null ||
                              ref.read(clientNotifierProvider).clientId == "") {
                            /// Save the client record and get the client DocumentReference in return
                            var docRef = await ref
                                .read(clientNotifierProvider.notifier)
                                .saveClient(
                                    ref.read(clientNotifierProvider), true);

                            /// Add the new clientId to the client provider
                            ref
                                .read(clientNotifierProvider.notifier)
                                .updateClientId(docRef!.id);

                            /// Update the client record with the new clientId
                            ref
                                .read(clientNotifierProvider.notifier)
                                .saveClient(ref.read(clientNotifierProvider),
                                    false, docRef.id);

                            /// Add the new client ID to the trxn provider to be saved
                            ref
                                .read(trxnNotifierProvider.notifier)
                                .updateClientId(docRef.id);
                          } else {
                            /// Update the existing Transaction record
                            ref
                                .read(clientNotifierProvider.notifier)
                                .saveClient(
                                    ref.read(clientNotifierProvider), false);
                          }
                        } catch (e) {
                          debugPrint('Trxn Detail:  $e');
                        }
                      }

                      /// /////////////////////////
                      /// Save the Trxn
                      populateTrxnProvider();

                      ref.read(trxnNotifierProvider.notifier).saveTrxn(
                          ref.read(trxnNotifierProvider),
                          ref.read(globalsNotifierProvider).companyId!,
                          widget.newTrxn!);

                      // Add dates to calendar
                      if (bContractDate) {
                        bContractDate = false;
                        String title =
                            'Contract Date for ${ref.read(clientNotifierProvider).lName}';
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventName(title);
                        String? desc =
                            '${ref.read(trxnNotifierProvider).propertyAddress} ${ref.read(trxnNotifierProvider).propertyCity}';
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDescription(desc);
                        String eventDate = DateFormat("yyyy-MM-dd HH:mm")
                            .format(eventDatePicked);
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDate(DateTime.parse(eventDate));

                        AddEventsToAllCalendars.addMultipleEvent(Events(
                            eventName: title,
                            eventDate: contractDatePicked,
                            eventDescription: desc));
                      }

                      if (bTwoFourASellerDisclosureDeadline) {
                        bTwoFourASellerDisclosureDeadline = false;
                        String title = '24a Seller Disclosure Deadline';
                        String? desc =
                            '${ref.read(trxnNotifierProvider).propertyAddress} ${ref.read(trxnNotifierProvider).propertyCity}';
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDescription(desc);
                        String eventDate = DateFormat("yyyy-MM-dd HH:mm")
                            .format(eventDatePicked);
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDate(DateTime.parse(eventDate));
                        AddEventsToAllCalendars.addMultipleEvent(Events(
                            eventName: title,
                            eventDate: sellerDisclosureDatePicked,
                            eventDescription: desc));
                      }
                      if (bTwoFourBDueDiligenceDeadline) {
                        bTwoFourBDueDiligenceDeadline = false;
                        String title = '24b Due Diligence Deadline';
                        String? desc =
                            '${ref.read(trxnNotifierProvider).propertyAddress} ${ref.read(trxnNotifierProvider).propertyCity}';
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDescription(desc);
                        String eventDate = DateFormat("yyyy-MM-dd HH:mm")
                            .format(eventDatePicked);
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDate(DateTime.parse(eventDate));
                        AddEventsToAllCalendars.addMultipleEvent(Events(
                            eventName: title,
                            eventDate: dueDilienceDatePicked,
                            eventDescription: desc));
                      }
                      if (bTwoFourCFinancingAndAppraisalDeadline) {
                        bTwoFourCFinancingAndAppraisalDeadline = false;
                        String title = '24c Financing and Appraisal Deadline';
                        String? desc =
                            '${ref.read(trxnNotifierProvider).propertyAddress} ${ref.read(trxnNotifierProvider).propertyCity}';
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDescription(desc);
                        String eventDate = DateFormat("yyyy-MM-dd HH:mm")
                            .format(eventDatePicked);
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDate(DateTime.parse(eventDate));
                        AddEventsToAllCalendars.addMultipleEvent(Events(
                            eventName: title,
                            eventDate: financingAppraisalDatePicked,
                            eventDescription: desc));
                      }
                      if (bTwoFourDSettlementDeadline) {
                        bTwoFourDSettlementDeadline = false;
                        String title = '24d Settlement Deadline';
                        String? desc =
                            '${ref.read(trxnNotifierProvider).propertyAddress} ${ref.read(trxnNotifierProvider).propertyCity}';
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDescription(desc);
                        String eventDate = DateFormat("yyyy-MM-dd HH:mm")
                            .format(eventDatePicked);
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDate(DateTime.parse(eventDate));
                        AddEventsToAllCalendars.addMultipleEvent(Events(
                            eventName: title,
                            eventDate: settlementDatePicked,
                            eventDescription: desc));
                      }
                      if (bInspectionDate) {
                        bInspectionDate = false;
                        String title = 'Inspection Date';
                        String? desc =
                            '${ref.read(trxnNotifierProvider).propertyAddress} ${ref.read(trxnNotifierProvider).propertyCity}';
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDescription(desc);
                        String eventDate = DateFormat("yyyy-MM-dd HH:mm")
                            .format(eventDatePicked);
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDate(DateTime.parse(eventDate));
                        AddEventsToAllCalendars.addMultipleEvent(Events(
                            eventName: title,
                            eventDate: inspectionDatePicked,
                            eventDescription: desc));
                      }
                      if (bAppraisalDate) {
                        bAppraisalDate = false;
                        String title = 'Appraisal Date';
                        String? desc =
                            '${ref.read(trxnNotifierProvider).propertyAddress} ${ref.read(trxnNotifierProvider).propertyCity}';
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDescription(desc);
                        String eventDate = DateFormat("yyyy-MM-dd HH:mm")
                            .format(eventDatePicked);
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDate(DateTime.parse(eventDate));
                        AddEventsToAllCalendars.addMultipleEvent(Events(
                            eventName: title,
                            eventDate: appraisalDatePicked,
                            eventDescription: desc));
                      }
                      if (bClosingDate) {
                        bClosingDate = false;
                        String title = 'Closing Date';
                        String? desc =
                            '${ref.read(trxnNotifierProvider).propertyAddress} ${ref.read(trxnNotifierProvider).propertyCity}';
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDescription(desc);
                        String eventDate = DateFormat("yyyy-MM-dd HH:mm")
                            .format(eventDatePicked);
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDate(DateTime.parse(eventDate));
                        AddEventsToAllCalendars.addMultipleEvent(Events(
                            eventName: title,
                            eventDate: closingDatePicked,
                            eventDescription: desc));
                      }
                      if (bFinalWalkThrough) {
                        bFinalWalkThrough = false;
                        String title = 'Final Walkthrough';
                        String? desc =
                            '${ref.read(trxnNotifierProvider).propertyAddress} ${ref.read(trxnNotifierProvider).propertyCity}';
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDescription(desc);
                        String eventDate = DateFormat("yyyy-MM-dd HH:mm")
                            .format(eventDatePicked);
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDate(DateTime.parse(eventDate));
                        AddEventsToAllCalendars.addMultipleEvent(Events(
                            eventName: title,
                            eventDate: walkThroughDatePicked,
                            eventDescription: desc));
                      }

                      if (!context.mounted) return;

                      Navigator.pop(context);
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      //todo: add better error handling
                      debugPrint(e as String?);
                    }
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                RoundedButton(
                  title: 'Delete',
                  colour: Colors.red,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      ref.read(trxnNotifierProvider.notifier).deleteTrxn(
                          ref.read(globalsNotifierProvider).currentTrxnId!,
                          _selectedCompany!);
                      ref
                          .read(globalsNotifierProvider.notifier)
                          .updateTargetScreen(0);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      // todo: add better error handling
                      //debugPrint(e);
                    }
                  },
                ),
                RoundedButton(
                  title: 'Cancel',
                  colour: Colors.orange,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      ref
                          .read(globalsNotifierProvider.notifier)
                          .updateTargetScreen(0);
                      Navigator.pop(context);
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      // todo: add better error handling
                      //debugPrint(e);
                    }
                  },
                )
              ],
            ),
            //}
          ),
        ),
      ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           setState(() {
//             showSpinner = true;
//           });
//           try {
//             ref.read(trxnNotifierProvider.notifier).saveTrxn(
//                 ref.read(trxnNotifierProvider),
//                 ref.read(globalsNotifierProvider).companyId!,
//                 widget.newTrxn!);
//             ref.read(globalsNotifierProvider.notifier).updateTargetScreen(0);
//             Navigator.pop(context);
// /*
//             Navigator.push(
//               context,
//               new MaterialPageRoute(
//                 builder: (context) => MainScreen(),
//               ),
//             );*/
//             setState(() {
//               showSpinner = false;
//             });
//           } catch (e) {
//             // todo: add better error handling
//             //debugPrint(e);
//           }
//         },
//         backgroundColor: constants.kPrimaryColor,
//         child: const Icon(
//           Icons.assignment_turned_in_outlined,
//           color: Colors.blueAccent,
//         ),
//       ),
    );
  }
}
