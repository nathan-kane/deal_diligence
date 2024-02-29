//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

// ignore_for_file: unused_field, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison, unused_local_variable, unused_element

import 'dart:async';
import 'dart:core';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/trxn_provider.dart';
import 'package:deal_diligence/Providers/client_provider.dart';
import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:deal_diligence/Providers/event_provider.dart';
import 'package:deal_diligence/screens/list_of_trxns.dart';
import 'package:deal_diligence/screens/popup_commission.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:deal_diligence/components/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:deal_diligence/screens/property_webview_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:deal_diligence/screens/widgets/add_all_calendars.dart';

String? loggedInUid;
String? _trxnStatus;
String? _companyId;
String? _selectedCompany;
String? _selectedUser;
String? _selectedClientState;
String? _selectedInspectorCompany;
String? _selectedAppraiserCompany;
String? _selectedTitleCompany;
String? _selectedMortgageCompany;

// Variables telling if a date has been changed so it can be set on the calendar
bool bContractDate = false;
bool bTwofouraSellerDisclosureDeadline = false;
bool bTwofourbDueDiligenceDeadline = false;
bool bTwofourcFinancingAndAppraisalDeadline = false;
bool btwofourdSettlementDeadline = false;
bool bInspectionDate = false;
bool bAppraisalDate = false;
bool bClosingDate = false;
bool bFinalWalkThrough = false;

//var maskFormatter = new MaskTextInputFormatter(mask: '+# (###) ###-####', filter: { "#": RegExp(r'[0-9]') });
var maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')});

class TransactionDetailScreen extends ConsumerStatefulWidget {
  static const String id = 'transaction_detail_screen';
  // final String? trxnId;
  final bool? newTrxn;

  const TransactionDetailScreen(this.newTrxn, {super.key});

  @override
  ConsumerState<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState
    extends ConsumerState<TransactionDetailScreen> {
  StreamProvider<List<Trxn>>? streamProvider;
  final _db = FirebaseFirestore.instance;

  final mlsRef = FirebaseFirestore.instance.collection('mls');
  Future<void>? _launched;
  String? _clientCellPhoneNumber;
  String? _clientHomePhoneNumber;
  String? _propertyMLSNbr;
  bool _hasMLSNumber = false;
  bool _hasContractPrice = false;
  bool _hasCellNumber = false;
  bool _hasHomeNumber = false;
  String? _mlsSearchLink;
  String _clientType = 'Select Client Type';
  double commission = 0.0;
  late final StreamSubscription _trxnStream;
  DateTime eventDatePicked = DateTime.now();

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
  final propertyZipcodeController = TextEditingController();
  final mlsNumberController = TextEditingController();
  final contractDateController = TextEditingController();
  final contractPriceController = TextEditingController();
  final sellerDisclosure24aController = TextEditingController();
  final dueDiligence24bController = TextEditingController();
  final financing2cController = TextEditingController();
  final settlement24dController = TextEditingController();
  final inspectorCompanyController = TextEditingController();
  final inspectorPhoneController = TextEditingController();
  final inspectionDateController = TextEditingController();
  final appraiserController = TextEditingController();
  final appraiserPhoneController = TextEditingController();
  final appraisalDateController = TextEditingController();
  final closingDateController = TextEditingController();
  final walkThroughDateController = TextEditingController();
  final titleCompanyController = TextEditingController();
  final titlePhoneController = TextEditingController();
  final titleEmailController = TextEditingController();
  final mortgageCompanyController = TextEditingController();
  final mortgagePhoneController = TextEditingController();
  final mortgageEmailController = TextEditingController();
  final otherAgentController = TextEditingController();
  final otherAgentEmailController = TextEditingController();
  final otherAgentPhoneController = TextEditingController();
  final otherPartyClientController = TextEditingController();
  final otherPartyTitleCompanyController = TextEditingController();
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
    propertyZipcodeController.dispose();
    mlsNumberController.dispose();
    contractDateController.dispose();
    contractPriceController.dispose();
    sellerDisclosure24aController.dispose();
    dueDiligence24bController.dispose();
    financing2cController.dispose();
    settlement24dController.dispose();
    inspectorCompanyController.dispose();
    inspectorPhoneController.dispose();
    inspectionDateController.dispose();
    appraiserController.dispose();
    appraiserPhoneController.dispose();
    appraisalDateController.dispose();
    closingDateController.dispose();
    walkThroughDateController.dispose();
    titleCompanyController.dispose();
    titlePhoneController.dispose();
    titleEmailController.dispose();
    mortgageCompanyController.dispose();
    mortgagePhoneController.dispose();
    mortgageEmailController.dispose();
    otherAgentController.dispose();
    otherAgentEmailController.dispose();
    otherAgentPhoneController.dispose();
    otherPartyClientController.dispose();
    otherPartyTitleCompanyController.dispose();
    trxnStatusController.dispose();
    trxnIdController.dispose();
    //_trxnStream.cancel();
    super.dispose();
  }

  //var agent_id;
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
  int? propertyZipcode = 0;
  String? mlsNumber = "";
  String? contractDate = "";
  int? contractPrice = 0;
  String? sellerDisclosure24a = "";
  String? dueDiligence24b = "";
  String? financing24c = "";
  String? settlement24d = "";
  String? inspectorCompany = "";
  String? inspectorPhone = "";
  String? inspectionDate = "";
  String? appraiser = "";
  String? appraiserPhone = "";
  String? appraisalDate = "";
  String? closingDate = "";
  String? walkThroughDate = "";
  String? titleCompany = "";
  String? titlePhone = "";
  String? titleEmail = "";
  String? mortgageCompany = "";
  String? mortgagePhone = "";
  String? mortgageEmail = "";
  String? otherAgent = "";
  String? otherAgentEmail = "";
  String? otherAgentPhone = "";
  String? otherPartyClient = "";
  String? otherPartyTitleCompany = "";
  String? trxnStatus = "Select Status";

  bool showSpinner = false;

  String? _currentCompany = '';
  String? _currentUser = '';

  @override
  void initState() {
    //final GlobalProvider = ref.read(globalsNotifierProvider);
    _currentCompany = ref.read(globalsNotifierProvider).companyId;
    _currentUser = ref.read(globalsNotifierProvider).currentUserId;

    // final trxnData = FirebaseFirestore.instance
    //     .collection('company')
    //     .doc(ref.read(globalsNotifierProvider).companyId)
    //     .collection('trxns');

    getTrxn();
    super.initState();
    //final trxnProvider = Provider.of<TrxnProvider>(context);

    _dropDownState = getDropDownState();
    _currentState = _dropDownState![0].value;
    _currentClientState = _dropDownState![0].value;
  }

  String _currentStatus = "Select Status";

  List<DropdownMenuItem<String>>? _dropDownState;
  String? _currentState = "AL";
  String? _currentClientState = "";

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
      _currentState = selectedState;
    });
    ref
        .read(globalsNotifierProvider.notifier)
        .updateselectedTrxnState(selectedState!);
  }

  void changedClientDropDownState(String? selectedState) {
    setState(() {
      _currentClientState = selectedState;
    });
    ref.read(clientNotifierProvider.notifier).updateClientState(selectedState!);
  }

  void changedDropDownClientType(String selectedClientType) {
    setState(() {
      _clientType = selectedClientType;
    });
    //globals.selectedTrxnState = selectedClientType;
  }

  void changedDropDownAgency(String? selectedCompany) {
    setState(() {
      _currentCompany = selectedCompany;
    });
    ref
        .read(globalsNotifierProvider.notifier)
        .updateselectedCompany(selectedCompany!);
  }

  void changedDropDownUser(String? selectedUser) {
    setState(() {
      _currentUser = selectedUser;
    });
    ref
        .read(globalsNotifierProvider.notifier)
        .updateselectedUser(selectedUser!);
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
    //}
  }

  getTrxn() async {
    //if (widget.trxns == null) {
    if (widget.newTrxn!) {
      _companyId = ref.read(globalsNotifierProvider).companyId;
      //ref.read(globalsNotifierProvider.notifier).updatenewTrxn(false);

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
      propertyZipcodeController.text = "";
      mlsNumberController.text = "";
      contractDateController.text = "";
      contractPriceController.text = "";
      sellerDisclosure24aController.text = "";
      dueDiligence24bController.text = "";
      financing2cController.text = "";
      settlement24dController.text = "";
      inspectorCompanyController.text = "";
      inspectorPhoneController.text = "";
      inspectionDateController.text = "";
      appraiserController.text = "";
      appraiserPhoneController.text = "";
      appraisalDateController.text = "";
      closingDateController.text = "";
      walkThroughDateController.text = "";
      titleCompanyController.text = "";
      titlePhoneController.text = "";
      titleEmailController.text = "";
      mortgageCompanyController.text = "";
      mortgagePhoneController.text = "";
      mortgageEmailController.text = "";
      otherAgentController.text = "";
      otherAgentEmailController.text = "";
      otherAgentPhoneController.text = "";
      otherPartyClientController.text = "";
      otherPartyTitleCompanyController.text = "";
      trxnStatusController.text = "";
      trxnIdController.text = "";
      setState(() {
        _trxnStatus = 'Select Status';
      });
    } else {
      final DocumentSnapshot _mlsId =
          await mlsRef.doc(ref.read(usersNotifierProvider).mlsId).get();
      _mlsSearchLink = _mlsId.get('mlsNbrSearch');

      //final trxnProvider = ref.read(trxnNotifierProvider);
      _trxnStream = _db
          .collection('company')
          .doc(ref.read(globalsNotifierProvider).companyId)
          .collection('trxns')
          .doc(ref.read(globalsNotifierProvider).currentTrxnId)
          .snapshots()
          .listen((trxnSnapshot) {
        clientFNameController.text = trxnSnapshot.data()?['clientFName'] ?? "";
        clientLNameController.text = trxnSnapshot.data()?['clientLName'] ?? "";
        clientAddress1Controller.text =
            trxnSnapshot.data()?['clientAddress1'] ?? "";
        clientAddress2Controller.text =
            trxnSnapshot.data()?['clientAddress2'] ?? "";
        clientCityController.text = trxnSnapshot.data()?['clientCity'] ?? "";
        clientStateController.text = trxnSnapshot.data()?['clientState'] ?? "";
        clientTypeController.text = trxnSnapshot.data()?['clientType'] ?? "";
        _clientType = trxnSnapshot.data()?['clientType'] ?? "";
        clientCellPhoneController.text =
            trxnSnapshot.data()?['clientCellPhone'] ?? "";
        clientCellPhoneController.text != "" &&
                clientCellPhoneController.text != null
            ? _hasCellNumber = true
            : _hasCellNumber = false;
        _clientCellPhoneNumber = trxnSnapshot.data()?['clientCellPhone'] ?? "";
        clientHomePhoneController.text =
            trxnSnapshot.data()?['clientHomePhone'] ?? "";
        clientHomePhoneController.text != "" &&
                clientHomePhoneController.text != null
            ? _hasHomeNumber = true
            : _hasHomeNumber = false;
        _clientHomePhoneNumber = trxnSnapshot.data()?['clientHomePhone'] ?? "";
        clientEmailController.text = trxnSnapshot.data()?['clientEmail'] ?? "";

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
        propertyStateController.text =
            trxnSnapshot.data()?['propertyState'] ?? "";
        ref
            .read(trxnNotifierProvider.notifier)
            .updatePropertyState(propertyStateController.text);
        propertyZipcodeController.text =
            trxnSnapshot.data()?['propertyZipcode'] ?? "";
        ref
            .read(trxnNotifierProvider.notifier)
            .updatePropertyZipcode(propertyZipcodeController.text);
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
          var strCommission = trxnSnapshot.data()?['contractPrice'];
          commission = .03 * double.parse(strCommission);
        } else {
          _hasContractPrice = false;
        }
        contractPriceController.text =
            trxnSnapshot.data()?['contractPrice'] == null
                ? 'n/a'
                : trxnSnapshot.data()?['contractPrice'] ?? "";
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

        final String? dueDiligence24b = trxnSnapshot.data()?['dueDiligence24b'];
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

        inspectorCompanyController.text =
            trxnSnapshot.data()?['inspectorCompany'] ?? "";
        inspectorPhoneController.text =
            trxnSnapshot.data()?['inspectorPhone'] ?? "";

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

        appraiserController.text = trxnSnapshot.data()?['appraiser'] ?? "";
        appraiserPhoneController.text =
            trxnSnapshot.data()?['appraiserPhone'] ?? "";

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

        final String? walkThroughDate = trxnSnapshot.data()?['walkThroughDate'];
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

        titleCompanyController.text =
            trxnSnapshot.data()?['titleCompany'] ?? "";
        titlePhoneController.text = trxnSnapshot.data()?['titlePhone'] ?? "";
        titleEmailController.text = trxnSnapshot.data()?['titleEmail'] ?? "";
        mortgageCompanyController.text =
            trxnSnapshot.data()?['mortgageCompany'] ?? "";
        mortgagePhoneController.text =
            trxnSnapshot.data()?['mortgagePhone'] ?? "";
        mortgageEmailController.text =
            trxnSnapshot.data()?['mortgageEmail'] ?? "";
        otherAgentController.text = trxnSnapshot.data()?['otherAgent'] ?? "";
        ref
            .read(trxnNotifierProvider.notifier)
            .updateOtherAgent(otherAgentController.text);
        otherAgentEmailController.text =
            trxnSnapshot.data()?['otherAgentEmail'] ?? "";
        ref
            .read(trxnNotifierProvider.notifier)
            .updateOtherAgentEmail(otherAgentEmailController.text);
        otherAgentPhoneController.text =
            trxnSnapshot.data()?['otherAgentPhone'] ?? "";
        ref
            .read(trxnNotifierProvider.notifier)
            .updateOtherAgentPhone(otherAgentPhoneController.text);
        otherPartyClientController.text =
            trxnSnapshot.data()?['otherPartyClient'] ?? "";
        ref
            .read(trxnNotifierProvider.notifier)
            .updateOtherPartyClient(otherPartyClientController.text);
        otherPartyTitleCompanyController.text =
            trxnSnapshot.data()?['otherPartyTitleCompany'] ?? "";
        ref.read(trxnNotifierProvider.notifier).updateOtherPartyTitleCompany(
            otherPartyTitleCompanyController.text);
        trxnStatusController.text = trxnSnapshot.data()?['trxnStatus'] ?? "";
        ref
            .read(trxnNotifierProvider.notifier)
            .updateTrxnStatus(trxnStatusController.text);
        trxnIdController.text = trxnSnapshot.data()?['trxnId'] ?? "";

        setState(() {
          _trxnStatus = trxnSnapshot.data()?['trxnStatus'] ?? "Select Status";
          _clientType =
              trxnSnapshot.data()?['clientType'] ?? 'Select Client Type';
          _selectedCompany = trxnSnapshot.data()?['companyId'] ?? "";
          _selectedUser = trxnSnapshot.data()?['userId'] ?? "";
          _selectedClientState = trxnSnapshot.data()?['clientState'] ?? "";
          if (trxnSnapshot.data()?['propertyState'] == null ||
              trxnSnapshot.data()?['propertyState'] == "") {
            _currentState = "AL";
          } else {
            _currentState = trxnSnapshot.data()?['propertyState'];
          }
        });
      });
    }
  }

  populateClientProvider() {
    ref
        .read(clientNotifierProvider.notifier)
        .updatefName(clientFNameController.text);
    ref
        .read(clientNotifierProvider.notifier)
        .updatelName(clientLNameController.text);
    ref
        .read(clientNotifierProvider.notifier)
        .updateAddress1(clientAddress1Controller.text);
    ref
        .read(clientNotifierProvider.notifier)
        .updateCity(clientCityController.text);
    ref
        .read(clientNotifierProvider.notifier)
        .updateClientState(clientStateController.text);
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
    ref.read(trxnNotifierProvider.notifier).updateCompanyid(_selectedCompany!);
    ref
        .read(trxnNotifierProvider.notifier)
        .updatePropertyAddress(propertyAddressController.text);
    ref
        .read(trxnNotifierProvider.notifier)
        .updatePropertyCity(propertyCityController.text);
    ref
        .read(trxnNotifierProvider.notifier)
        .updatePropertyState(propertyStateController.text);
    ref
        .read(trxnNotifierProvider.notifier)
        .updatePropertyZipcode(propertyZipcodeController.text);
    ref
        .read(trxnNotifierProvider.notifier)
        .updateMlsNumber(mlsNumberController.text);
    ref
        .read(trxnNotifierProvider.notifier)
        .updateContractDate(contractDateController.text);
    ref
        .read(trxnNotifierProvider.notifier)
        .updateContractPrice(contractPriceController.text);
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
        .updateOtherAgent(otherAgentController.text);
    ref
        .read(trxnNotifierProvider.notifier)
        .updateOtherAgentEmail(otherAgentEmailController.text);
    ref
        .read(trxnNotifierProvider.notifier)
        .updateOtherAgentPhone(otherAgentPhoneController.text);
    ref
        .read(trxnNotifierProvider.notifier)
        .updateOtherPartyClient(otherPartyClientController.text);
    ref
        .read(trxnNotifierProvider.notifier)
        .updateOtherPartyTitleCompany(otherPartyTitleCompanyController.text);
    ref.read(trxnNotifierProvider.notifier).updateTrxnStatus(_trxnStatus);
  }

  @override
  Widget build(BuildContext context) {
    // Get the stream of transactions created in main.dart
    // final trxnProvider =
    //     ref.read(trxnNotifierProvider); //Provider.of<TrxnProvider>(context);

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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Transaction Details',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                const Text(
                  'Representing Company',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: _db.collection('company').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return DropdownButton<String>(
                        hint: const Text("Select Company"),
                        value: _selectedCompany,
                        onChanged: (companyValue) {
                          setState(() {
                            _selectedCompany = companyValue;
                          });
                        },
                        items: companyItems,
                      );
                    }),
                const SizedBox(
                  height: 8.0,
                ),
                const Text(
                  'Select User',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
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
                                      .updatecurrentUserId(userValue!);
                                });
                              },
                              items: userItems,
                            );
                          })
                      : const Text('No users yet'),
                ),
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ExpansionTile(
                        subtitle: const Text('John Seller'),
                        title: const Text(
                          'Client Information',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
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
                                  .updatefName(value);
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
                                  .updatelName(value);
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
                            },
                            decoration: const InputDecoration(
                                hintText: 'City', labelText: 'City'),
                          ),
                          DropdownButton(
                            value: _currentClientState,
                            items: _dropDownState,
                            hint: const Text('Choose State'),
                            onChanged: changedClientDropDownState,
                          ),
                          Row(
                            children: [
                              const Text('Client Type:   '),
                              DropdownButton<String>(
                                value: _clientType,
                                hint: const Text('Client Type'),
                                onChanged: (_value) {
                                  setState(() {
                                    _clientType = _value!;
                                  });
                                },
                                items: <String>[
                                  'Select Client Type',
                                  'Buyer',
                                  'Seller'
                                ].map<DropdownMenuItem<String>>(
                                    (String clientType) {
                                  return DropdownMenuItem<String>(
                                    value: clientType,
                                    child: Text(clientType),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            controller: clientCellPhoneController,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              ref
                                  .read(clientNotifierProvider.notifier)
                                  .updateCellPhone(value);
                            },
                            decoration: const InputDecoration(
                                hintText: 'Cell Phone',
                                labelText: 'Cell Phone'),
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            controller: clientHomePhoneController,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              ref
                                  .read(clientNotifierProvider.notifier)
                                  .updateHomePhone(value);
                            },
                            decoration: const InputDecoration(
                                hintText: 'Home Phone',
                                labelText: 'Home Phone'),
                          ),
                          Row(
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
                          // Row(
                          //   children: [
                          TextField(
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            controller: clientEmailController,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              ref
                                  .read(clientNotifierProvider.notifier)
                                  .updateEmail(value);
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
                  height: 8.0,
                ),
                TextField(
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
                DropdownButton(
                  value: _currentState,
                  items: _dropDownState,
                  hint: const Text('Choose State'),
                  onChanged: changedDropDownState,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: propertyZipcodeController,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updatePropertyZipcode(value); //, loggedInUid);
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
                    if (_date != null && _date != _datePicked) {
                      // Add time to the calendar event
                      TimeOfDay? _timePicked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      // if (_timePicked != null) {
                      //   _eventTime = _timePicked;
                      // }
                      setState(() {
                        contractDateController.text =
                            DateFormat("EE  MM-dd-yyyy").format(_datePicked!);
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateContractDate(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                      bContractDate = true;
                      eventDatePicked = DateTime(
                        _datePicked!.year,
                        _datePicked.month,
                        _datePicked.day,
                        _timePicked!.hour,
                        _timePicked.minute,
                      );
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
                              '3% Commission: \$${commission}',
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
                    TimeOfDay? _timePicked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (_date != null && _date != _datePicked) {
                      setState(() {
                        sellerDisclosure24aController.text =
                            DateFormat("EE  MM-dd-yyyy").format(_datePicked!);
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateSellerDisclosure24a(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                    }
                    bTwofouraSellerDisclosureDeadline = true;
                    eventDatePicked = DateTime(
                      _datePicked!.year,
                      _datePicked.month,
                      _datePicked.day,
                      _timePicked!.hour,
                      _timePicked.minute,
                    );
                  },
                  onChanged: (value) {
                    bTwofouraSellerDisclosureDeadline = true;
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
                    TimeOfDay? _timePicked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (_date != null && _date != _datePicked) {
                      setState(() {
                        dueDiligence24bController.text =
                            DateFormat("EE  MM-dd-yyyy").format(_datePicked!);
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateDueDiligence24b(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                    }
                    bTwofourbDueDiligenceDeadline = true;
                    eventDatePicked = DateTime(
                      _datePicked!.year,
                      _datePicked.month,
                      _datePicked.day,
                      _timePicked!.hour,
                      _timePicked.minute,
                    );
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
                    TimeOfDay? _timePicked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (_date != null && _date != _datePicked) {
                      setState(() {
                        financing2cController.text =
                            DateFormat("EE  MM-dd-yyyy").format(_datePicked!);
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateFinancing24c(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                    }
                    bTwofourcFinancingAndAppraisalDeadline = true;
                    eventDatePicked = DateTime(
                      _datePicked!.year,
                      _datePicked.month,
                      _datePicked.day,
                      _timePicked!.hour,
                      _timePicked.minute,
                    );
                  },
                  onChanged: (value) {
                    bTwofourbDueDiligenceDeadline = true;
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
                    TimeOfDay? _timePicked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (_date != null && _date != _datePicked) {
                      setState(() {
                        settlement24dController.text =
                            DateFormat("EE  MM-dd-yyyy").format(_datePicked!);
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateSettlement24d(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                    }
                    btwofourdSettlementDeadline = true;
                    eventDatePicked = DateTime(
                      _datePicked!.year,
                      _datePicked.month,
                      _datePicked.day,
                      _timePicked!.hour,
                      _timePicked.minute,
                    );
                  },
                  onChanged: (value) {
                    bTwofourcFinancingAndAppraisalDeadline = true;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Inspector Company:    ',
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: _db.collection('inspectorCompany').snapshots(),
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
                                    company['inspectorCompanyName'],
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
                            hint: const Text("Select Inspector"),
                            value: _selectedInspectorCompany,
                            onChanged: (companyValue) {
                              setState(() {
                                _selectedInspectorCompany = companyValue;
                              });
                            },
                            items: companyItems,
                          );
                        }),
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
                    TimeOfDay? _timePicked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (_date != null && _date != _datePicked) {
                      setState(() {
                        inspectionDateController.text =
                            DateFormat("EE  MM-dd-yyyy").format(_datePicked!);
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateInspectionDate(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                    }
                    bInspectionDate = true;
                    eventDatePicked = DateTime(
                      _datePicked!.year,
                      _datePicked.month,
                      _datePicked.day,
                      _timePicked!.hour,
                      _timePicked.minute,
                    ); /*
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Appraiser Company:    ',
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: _db.collection('appraiserCompany').snapshots(),
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
                                    company['appraiserCompanyName'],
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
                            hint: const Text("Select Appraiser"),
                            value: _selectedAppraiserCompany,
                            onChanged: (companyValue) {
                              setState(() {
                                _selectedAppraiserCompany = companyValue;
                              });
                            },
                            items: companyItems,
                          );
                        }),
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
                    TimeOfDay? _timePicked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (_date != null && _date != _datePicked) {
                      setState(() {
                        appraisalDateController.text =
                            DateFormat("EE  MM-dd-yyyy").format(_datePicked!);
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateAppraisalDate(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                    }
                    bAppraisalDate = true;
                    eventDatePicked = DateTime(
                      _datePicked!.year,
                      _datePicked.month,
                      _datePicked.day,
                      _timePicked!.hour,
                      _timePicked.minute,
                    );
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
                    TimeOfDay? _timePicked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (_date != null && _date != _datePicked) {
                      setState(() {
                        closingDateController.text =
                            DateFormat("EE  MM-dd-yyyy").format(_datePicked!);
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateClosingDate(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                    }
                    bClosingDate = true;
                    eventDatePicked = DateTime(
                      _datePicked!.year,
                      _datePicked.month,
                      _datePicked.day,
                      _timePicked!.hour,
                      _timePicked.minute,
                    );
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
                    TimeOfDay? _timePicked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (_date != null && _date != _datePicked) {
                      setState(() {
                        walkThroughDateController.text =
                            DateFormat("EE  MM-dd-yyyy").format(_datePicked!);
                        ref
                            .read(trxnNotifierProvider.notifier)
                            .updateWalkThroughDate(_datePicked.toString());
                        _selectedDate = _datePicked;
                      });
                    }
                    bFinalWalkThrough = true;
                    eventDatePicked = DateTime(
                      _datePicked!.year,
                      _datePicked.month,
                      _datePicked.day,
                      _timePicked!.hour,
                      _timePicked.minute,
                    );
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Title Company:    ',
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: _db.collection('titleCompany').snapshots(),
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
                                    company['titleCompanyName'],
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
                            value: _selectedTitleCompany,
                            onChanged: (companyValue) {
                              setState(() {
                                _selectedTitleCompany = companyValue;
                              });
                            },
                            items: companyItems,
                          );
                        }),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Mortgage Company:    ',
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: _db.collection('mortgageCompany').snapshots(),
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
                                    company['mortgageCompanyName'],
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
                            hint: const Text("Select Mortgage Company"),
                            value: _selectedMortgageCompany,
                            onChanged: (companyValue) {
                              setState(() {
                                _selectedMortgageCompany = companyValue;
                              });
                            },
                            items: companyItems,
                          );
                        }),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Other Agent Company:    ',
                    ),
                    StreamBuilder<QuerySnapshot>(
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
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return DropdownButton<String>(
                            hint: const Text("Select Other Agent"),
                            value: _selectedCompany,
                            onChanged: (companyValue) {
                              setState(() {
                                _selectedCompany = companyValue;
                                // ref
                                //     .read(globalsNotifierProvider.notifier)
                                //     .updatecompanyId(companyValue!);
                              });
                            },
                            items: companyItems,
                          );
                        }),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: otherPartyClientController,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(trxnNotifierProvider.notifier)
                        .updateOtherPartyClient(value); //, loggedInUid);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Other Party Client',
                      labelText: 'Other Party Client'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Other Title Company:    ',
                    ),
                    StreamBuilder<QuerySnapshot>(
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
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return DropdownButton<String>(
                            hint: const Text("Select Title Company"),
                            value: _selectedCompany,
                            onChanged: (companyValue) {
                              setState(() {
                                _selectedCompany = companyValue;
                              });
                            },
                            items: companyItems,
                          );
                        }),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                DropdownButton<String>(
                  hint: const Text('Please choose transaction status'),
                  value: _trxnStatus,
                  onChanged: (_value) {
                    setState(() {
                      _trxnStatus = _value;
                      ref
                          .read(trxnNotifierProvider.notifier)
                          .updateTrxnStatus(_value);
                    });
                  },
                  items: <String>[
                    'Select Status',
                    'Prospect',
                    'Listed',
                    'Under Contract',
                    'On Hold',
                    'Closed',
                    'Archived'
                  ].map<DropdownMenuItem<String>>((String _value) {
                    return DropdownMenuItem<String>(
                      value: _value,
                      child: Text(_value),
                    );
                  }).toList(),
                ),
                RoundedButton(
                  title: 'Save',
                  colour: Colors.blueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      // Save the client information first
                      populateClientProvider();
                      ref
                          .read(clientNotifierProvider.notifier)
                          .saveClient(ref.read(clientNotifierProvider));

                      // Save the Trxn
                      populateTrxnProvider();

                      ref.read(trxnNotifierProvider.notifier).saveTrxn(
                          ref.read(trxnNotifierProvider),
                          ref.read(globalsNotifierProvider).companyId!,
                          widget.newTrxn!);

                      // Add dates to calendar
                      if (bContractDate) {
                        bContractDate = false;
                        //FIX THIS
                        // String title =
                        //     'Contract Date for ${ref.read(trxnNotifierProvider).clientLName}';
                        //FIX THIS
                        // ref
                        //     .read(eventsNotifierProvider.notifier)
                        //     .updateEventname(title);
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
                        AddEventsToAllCalendars.addEvent(
                            ref.read(eventsNotifierProvider));
                      }

                      if (bTwofouraSellerDisclosureDeadline) {
                        bTwofouraSellerDisclosureDeadline = false;
                        //FIX THIS
                        // String title =
                        //     '24a Seller Disclosure Deadline for ${ref.read(trxnNotifierProvider).clientLName}';
                        //FIX THIS
                        // ref
                        //     .read(eventsNotifierProvider.notifier)
                        //     .updateEventname(title);
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
                        AddEventsToAllCalendars.addEvent(
                            ref.read(eventsNotifierProvider));
                      }
                      if (bTwofourbDueDiligenceDeadline) {
                        bTwofourbDueDiligenceDeadline = false;
                        //FIX THIS
                        // String title =
                        //     '24b Due Diligence Deadline for ${ref.read(trxnNotifierProvider).clientLName}';
                        //FIX THIS
                        // ref
                        //     .read(eventsNotifierProvider.notifier)
                        //     .updateEventname(title);
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
                        AddEventsToAllCalendars.addEvent(
                            ref.read(eventsNotifierProvider));
                      }
                      if (bTwofourcFinancingAndAppraisalDeadline) {
                        bTwofourcFinancingAndAppraisalDeadline = false;
                        // String title =
                        //     '24c Financing and Appraisal Deadline for ${ref.read(trxnNotifierProvider).clientLName}';
                        //FIX THIS
                        // ref
                        //     .read(eventsNotifierProvider.notifier)
                        //     .updateEventname(title);
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
                        AddEventsToAllCalendars.addEvent(
                            ref.read(eventsNotifierProvider));
                      }
                      if (btwofourdSettlementDeadline) {
                        btwofourdSettlementDeadline = false;
                        //FIX THIS
                        // String title =
                        //     '24d Settlement Deadline for ${ref.read(trxnNotifierProvider).clientLName}';
                        //FIX THIS
                        // ref
                        //     .read(eventsNotifierProvider.notifier)
                        //     .updateEventname(title);
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
                        AddEventsToAllCalendars.addEvent(
                            ref.read(eventsNotifierProvider));
                      }
                      if (bInspectionDate) {
                        bInspectionDate = false;
                        //FIX THIS
                        // String title =
                        //     'Inspection Date for ${ref.read(trxnNotifierProvider).clientLName}';
                        //FIX THIS
                        // ref
                        //     .read(eventsNotifierProvider.notifier)
                        //     .updateEventname(title);
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
                        AddEventsToAllCalendars.addEvent(
                            ref.read(eventsNotifierProvider));
                      }
                      if (bAppraisalDate) {
                        bAppraisalDate = false;
                        //FIX THIS
                        // String title =
                        //     'Appraisal Date for ${ref.read(trxnNotifierProvider).clientLName}';
                        //FIX THIS
                        // ref
                        //     .read(eventsNotifierProvider.notifier)
                        //     .updateEventname(title);
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
                        AddEventsToAllCalendars.addEvent(
                            ref.read(eventsNotifierProvider));
                      }
                      if (bClosingDate) {
                        bClosingDate = false;
                        //FIX THIS
                        // String title =
                        //     'Closing Date for ${ref.read(trxnNotifierProvider).clientLName}';
                        // ref
                        //     .read(eventsNotifierProvider.notifier)
                        //     .updateEventname(title);
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
                        AddEventsToAllCalendars.addEvent(
                            ref.read(eventsNotifierProvider));
                      }
                      if (bFinalWalkThrough) {
                        bFinalWalkThrough = false;
                        //FIX THIS
                        // String title =
                        //     'Final Walkthrough Date for ${ref.read(trxnNotifierProvider).clientLName}';
                        // ref
                        //     .read(eventsNotifierProvider.notifier)
                        //     .updateEventname(title);
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
                        AddEventsToAllCalendars.addEvent(
                            ref.read(eventsNotifierProvider));
                      }

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CompanyDashboardScreen(),
                        ),
                      );
                      //Navigator.pop(context);
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
                          .updatetargetScreen(0);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CompanyDashboardScreen(),
                        ),
                      );
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      // todo: add better error handling
                      //print(e);
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
                          .updatetargetScreen(0);
                      Navigator.pop(context);
                      /*
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => MainScreen(),
                          ),
                        );*/
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      // todo: add better error handling
                      //print(e);
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
//             ref.read(globalsNotifierProvider.notifier).updatetargetScreen(0);
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
//             //print(e);
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
