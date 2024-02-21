//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:deal_diligence/Models/Trxns.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uuid/uuid.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Trxn {
  //String? trxnId;
  String? userId;
  String? companyId;
  String? clientId;
  // String? clientFName;
  // String? clientLName;
  // String? clientType;
  // String? clientEmail;
  // String? clientCellPhone;
  // String? clientHomePhone;
  String? propertyAddress;
  String? propertyCity;
  String? propertyState;
  String? propertyZipcode;
  String? mlsNumber;
  String? contractDate;
  String? contractPrice;
  String? sellerDisclosure24a;
  String? dueDiligence24b;
  String? financing24c;
  String? settlement24d;
  String? inspectorCompanyId;
  // String? inspectorCompany;
  // String? inspectorPhone;
  String? inspectionDate;
  String? appraiserCompanyId;
  // String? appraiser;
  // String? appraiserPhone;
  String? appraisalDate;
  String? closingDate;
  String? walkThroughDate;
  String? titleCompanyId;
  // String? titleCompany;
  // String? titlePhone;
  // String? titleEmail;
  String? mortgageCompanyId;
  // String? mortgageCompany;
  // String? mortgagePhone;
  // String? mortgageEmail;
  String? otherAgent;
  String? otherAgentPhone;
  String? otherAgentEmail;
  String? otherPartyClient;
  String? otherPartyTitleCompany;
  String? trxnStatus;
  //var uuId = Uuid();

  Trxn({
    //this.trxnId,
    this.userId,
    this.companyId,
    this.clientId,
    // this.clientFName,
    // this.clientLName,
    // this.clientType,
    // this.clientEmail,
    // this.clientCellPhone,
    // this.clientHomePhone,
    this.propertyAddress,
    this.propertyCity,
    this.propertyState,
    this.propertyZipcode,
    this.mlsNumber,
    this.contractDate,
    this.contractPrice,
    this.sellerDisclosure24a,
    this.dueDiligence24b,
    this.financing24c,
    this.settlement24d,
    this.inspectorCompanyId,
    // this.inspectorCompany,
    // this.inspectorPhone,
    this.inspectionDate,
    this.appraiserCompanyId,
    // this.appraiser,
    // this.appraiserPhone,
    this.appraisalDate,
    this.closingDate,
    this.walkThroughDate,
    this.titleCompanyId,
    // this.titleCompany,
    // this.titlePhone,
    // this.titleEmail,
    this.mortgageCompanyId,
    // this.mortgageCompany,
    // this.mortgagePhone,
    // this.mortgageEmail,
    this.otherAgent,
    this.otherAgentPhone,
    this.otherAgentEmail,
    this.otherPartyClient,
    this.otherPartyTitleCompany,
    this.trxnStatus,
    //this.uuId = Uuid(),
  });

  Trxn copyWith({
    //String? trxnId,
    String? userId,
    String? companyId,
    String? clientId,
    // String? clientFName,
    // String? clientLName,
    // String? clientType,
    // String? clientEmail,
    // String? clientCellPhone,
    // String? clientHomePhone,
    String? propertyAddress,
    String? propertyCity,
    String? propertyState,
    String? propertyZipcode,
    String? mlsNumber,
    String? contractDate,
    String? contractPrice,
    String? sellerDisclosure24a,
    String? dueDiligence24b,
    String? financing24c,
    String? settlement24d,
    String? inspectorCompanyId,
    // String? inspectorCompany,
    // String? inspectorPhone,
    String? inspectionDate,
    String? appraiserCompanyId,
    // String? appraiser,
    // String? appraiserPhone,
    String? appraisalDate,
    String? closingDate,
    String? walkThroughDate,
    String? titleCompanyId,
    // String? titleCompany,
    // String? titlePhone,
    // String? titleEmail,
    String? mortgageCompanyId,
    // String? mortgageCompany,
    // String? mortgagePhone,
    // String? mortgageEmail,
    String? otherAgent,
    String? otherAgentPhone,
    String? otherAgentEmail,
    String? otherPartyClient,
    String? otherPartyTitleCompany,
    String? trxnStatus,
    //var uuId = Uuid(),
  }) {
    return Trxn(
      //trxnId: trxnId ?? this.trxnId,
      userId: userId ?? this.userId,
      companyId: companyId ?? this.companyId,
      clientId: clientId ?? this.clientId,
      // clientFName: clientFName ?? this.clientFName,
      // clientLName: clientLName ?? this.clientLName,
      // clientType: clientType ?? this.clientType,
      // clientEmail: clientEmail ?? this.clientEmail,
      // clientCellPhone: clientCellPhone ?? this.clientCellPhone,
      // clientHomePhone: clientHomePhone ?? this.clientHomePhone,
      propertyAddress: propertyAddress ?? this.propertyAddress,
      propertyCity: propertyCity ?? this.propertyCity,
      propertyState: propertyState ?? this.propertyState,
      propertyZipcode: propertyZipcode ?? this.propertyZipcode,
      mlsNumber: mlsNumber ?? this.mlsNumber,
      contractDate: contractDate ?? this.contractDate,
      contractPrice: contractPrice ?? this.contractPrice,
      sellerDisclosure24a: sellerDisclosure24a ?? this.sellerDisclosure24a,
      dueDiligence24b: dueDiligence24b ?? this.dueDiligence24b,
      financing24c: financing24c ?? this.financing24c,
      settlement24d: settlement24d ?? this.settlement24d,
      inspectorCompanyId: inspectorCompanyId ?? this.inspectorCompanyId,
      // inspectorCompany: inspectorCompany ?? this.inspectorCompany,
      // inspectorPhone: inspectorPhone ?? this.inspectorPhone,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      appraiserCompanyId: appraiserCompanyId ?? this.appraiserCompanyId,
      // appraiser: appraiser ?? this.appraiser,
      // appraiserPhone: appraiserPhone ?? this.appraiserPhone,
      appraisalDate: appraisalDate ?? this.appraisalDate,
      closingDate: closingDate ?? this.closingDate,
      walkThroughDate: walkThroughDate ?? this.walkThroughDate,
      titleCompanyId: titleCompanyId ?? this.titleCompanyId,
      // titleCompany: titleCompany ?? this.titleCompany,
      // titlePhone: titlePhone ?? this.titlePhone,
      // titleEmail: titleEmail ?? this.titleEmail,
      mortgageCompanyId: mortgageCompanyId ?? this.mortgageCompanyId,
      // mortgageCompany: mortgageCompany ?? this.mortgageCompany,
      // mortgagePhone: mortgagePhone ?? this.mortgagePhone,
      // mortgageEmail: mortgageEmail ?? this.mortgageEmail,
      otherAgent: otherAgent ?? this.otherAgent,
      otherAgentPhone: otherAgentPhone ?? this.otherAgentPhone,
      otherAgentEmail: otherAgentEmail ?? this.otherAgentEmail,
      otherPartyClient: otherPartyClient ?? this.otherPartyClient,
      otherPartyTitleCompany:
          otherPartyTitleCompany ?? this.otherPartyTitleCompany,
      trxnStatus: trxnStatus ?? this.trxnStatus,
    );
  }
}

class TrxnNotifier extends Notifier<Trxn> {
  final firestoreService = FirestoreService();
  TrxnNotifier(); // un-named constructor

  // fromFirestore(Map<String, dynamic> firestore)
  //     : trxnId = firestore['trxnId'],
  //       userId = firestore['userId'],
  //       companyId = firestore['companyId'],
  //       clientFName = firestore['clientFName'],
  //       clientLName = firestore['clientLName'],
  //       clientType = firestore['clientType'] ?? "",
  //       clientEmail = firestore['clientEmail'],
  //       clientCellPhone = firestore['clientCellPhone'],
  //       clientHomePhone = firestore['clientHomePhone'],
  //       propertyAddress = firestore['propertyAddress'],
  //       propertyCity = firestore['propertyCity'],
  //       propertyState = firestore['propertyState'],
  //       propertyZipcode = firestore['propertyZipcode'],
  //       mlsNumber = firestore['mlsNumber'],
  //       contractDate = firestore['contractDate'],
  //       contractPrice = firestore['contractPrice'],
  //       sellerDisclosure24a = firestore['sellerDisclosure24a'],
  //       dueDiligence24b = firestore['dueDiligence24b'],
  //       financing24c = firestore['financing24c'],
  //       settlement24d = firestore['settlement24d'],
  //       inspectorCompany = firestore['inspectorCompany'],
  //       inspectorPhone = firestore['inspectorPhone'],
  //       inspectionDate = firestore['inspectionDate'],
  //       appraiser = firestore['appraiser'],
  //       appraiserPhone = firestore['appraiserPhone'],
  //       appraisalDate = firestore['appraisalDate'],
  //       closingDate = firestore['closingDate'],
  //       walkThroughDate = firestore['walkThroughDate'],
  //       titleCompany = firestore['titleCompany'],
  //       titlePhone = firestore['titlePhone'],
  //       titleEmail = firestore['titleEmail'],
  //       mortgageCompany = firestore['mortgageCompany'],
  //       mortgagePhone = firestore['mortgagePhone'],
  //       mortgageEmail = firestore['mortgageEmail'],
  //       otherAgent = firestore['otherAgent'],
  //       otherAgentPhone = firestore['otherAgentPhone'],
  //       otherAgentEmail = firestore['otherAgentEmail'],
  //       otherPartyClient = firestore['otherPartyClient'],
  //       otherPartyTitleCompany = firestore['otherPartyTitleCompany'],
  //       trxnStatus = firestore['trxnStatus'];

  @override
  Trxn build() {
    return Trxn(
      //trxnId: '',
      userId: '',
      companyId: '',
      clientId: '',
      // clientFName: '',
      // clientLName: '',
      // clientType: '',
      // clientEmail: '',
      // clientCellPhone: '',
      // clientHomePhone: '',
      propertyAddress: '',
      propertyCity: '',
      propertyState: '',
      propertyZipcode: '',
      mlsNumber: '',
      contractDate: '',
      contractPrice: '',
      sellerDisclosure24a: '',
      dueDiligence24b: '',
      financing24c: '',
      settlement24d: '',
      inspectorCompanyId: '',
      // inspectorCompany: '',
      // inspectorPhone: '',
      inspectionDate: '',
      appraiserCompanyId: '',
      // appraiser: '',
      // appraiserPhone: '',
      appraisalDate: '',
      closingDate: '',
      walkThroughDate: '',
      titleCompanyId: '',
      // titleCompany: '',
      // titlePhone: '',
      // titleEmail: '',
      mortgageCompanyId: '',
      // mortgageCompany: '',
      // mortgagePhone: '',
      // mortgageEmail: '',
      otherAgent: '',
      otherAgentPhone: '',
      otherAgentEmail: '',
      otherPartyClient: '',
      otherPartyTitleCompany: '',
      trxnStatus: '',
    );
  }

  //String? trxnId;
  String? userId;
  String? companyId;
  String? clientId;
  // String? clientFName;
  // String? clientLName;
  // String? clientType;
  // //String? tHomePhone;
  // String? clientEmail;
  // String? clientCellPhone;
  // String? clientHomePhone;
  String? propertyAddress;
  String? propertyCity;
  String? propertyState;
  String? propertyZipcode;
  String? mlsNumber;
  String? contractDate;
  String? contractPrice;
  String? sellerDisclosure24a;
  String? dueDiligence24b;
  String? financing24c;
  String? settlement24d;
  String? inpspectorCompanyId;
  // String? inspectorCompany;
  // String? inspectorPhone;
  String? inspectionDate;
  String? appraiserCompanyId;
  // String? appraiser;
  // String? appraiserPhone;
  String? appraisalDate;
  String? closingDate;
  String? walkThroughDate;
  String? titleCompany;
  String? titlePhone;
  String? titleEmail;
  String? mortgageCompany;
  String? mortgagePhone;
  String? mortgageEmail;
  String? otherAgent;
  String? otherAgentPhone;
  String? otherAgentEmail;
  String? otherPartyClient;
  String? otherPartyTitleCompany;
  String? trxnStatus;

  // functions to update class members
  void updateCompanyid(String newCompanyId) {
    state = state.copyWith(companyId: newCompanyId);
  }

  void updateClientId(String newClientId) {
    state = state.copyWith(clientId: newClientId);
  }

  // void updateClientFName(String newClientFName) {
  //   state = state.copyWith(clientFName: newClientFName);
  // }

  // void updateClientLName(String newClientLName) {
  //   state = state.copyWith(clientLName: newClientLName);
  // }

  // void updateClientEmail(String newClientEmail) {
  //   state = state.copyWith(clientEmail: newClientEmail);
  // }

  // void updateClientType(String? newClientType) {
  //   state = state.copyWith(clientType: newClientType);
  // }

  // void updateClientCellPhone(String newClientCellPhone) {
  //   state = state.copyWith(clientCellPhone: newClientCellPhone);
  // }

  // void updateClientHomePhone(String newClientHomePhone) {
  //   state = state.copyWith(clientHomePhone: newClientHomePhone);
  // }

  void updatePropertyAddress(String newPropertyAddress) {
    state = state.copyWith(propertyAddress: newPropertyAddress);
  }

  void updatePropertyCity(String newPropertyCity) {
    state = state.copyWith(propertyCity: newPropertyCity);
  }

  void updatePropertyState(String newPropertyState) {
    state = state.copyWith(propertyState: newPropertyState);
  }

  // Convert String to int
  void updatePropertyZipcode(String newPropertyZipcode) {
    state = state.copyWith(propertyZipcode: newPropertyZipcode);
  }

  void updateMlsNumber(String newMlsNumber) {
    state = state.copyWith(mlsNumber: newMlsNumber);
  }

  void updateContractDate(String newContractDate) {
    state = state.copyWith(contractDate: newContractDate);
  }

  void updateContractPrice(String newContractPrice) {
    state = state.copyWith(contractPrice: newContractPrice);
  }

  void updateSellerDisclosure24a(String newSellerDisclosure24a) {
    state = state.copyWith(sellerDisclosure24a: newSellerDisclosure24a);
  }

  void updateDueDiligence24b(String newDueDiligence24b) {
    state = state.copyWith(dueDiligence24b: newDueDiligence24b);
  } // Convert String to int

  void updateFinancing24c(String newFinancing24c) {
    state = state.copyWith(financing24c: newFinancing24c);
  } // Convert String to int

  void updateSettlement24d(String newSettlement24d) {
    state = state.copyWith(settlement24d: newSettlement24d);
  }

  void updateInspectorCompanyId(String newInspectorCompanyId) {
    state = state.copyWith(inspectorCompanyId: newInspectorCompanyId);
  }

  // void updateInspectorCompany(String newInspectorCompany) {
  //   state = state.copyWith(inspectorCompany: newInspectorCompany);
  // }

  // void updateInspectorPhone(String newInspectorPhone) {
  //   state = state.copyWith(inspectorPhone: newInspectorPhone);
  // }

  void updateInspectionDate(String newInspectionDate) {
    state = state.copyWith(inspectionDate: newInspectionDate);
  }

  void updateAppraiserCompanyId(String newAppraiserCompanyId) {
    state = state.copyWith(appraiserCompanyId: newAppraiserCompanyId);
  }

  // void updateAppraiser(String newAppraiser) {
  //   state = state.copyWith(appraiser: newAppraiser);
  // }

  // void updateAppraiserPhone(String newAppraiserPhone) {
  //   state = state.copyWith(appraiserPhone: newAppraiserPhone);
  // } // Convert String to int

  void updateAppraisalDate(String newAppraisalDate) {
    state = state.copyWith(appraisalDate: newAppraisalDate);
  }

  void updateClosingDate(String newClosingDate) {
    state = state.copyWith(closingDate: newClosingDate);
  }

  void updateWalkThroughDate(String newWalkThroughDate) {
    state = state.copyWith(walkThroughDate: newWalkThroughDate);
  }

  void updateTitleCompanyId(String newTitleCompanyId) {
    state = state.copyWith(titleCompanyId: newTitleCompanyId);
  }

  // void updateTitleCompany(String newTitleCompany) {
  //   state = state.copyWith(titleCompany: newTitleCompany);
  // }

  // void updateTitlePhone(String newTitlePhone) {
  //   state = state.copyWith(titlePhone: newTitlePhone);
  // }

  // void updateTitleEmail(String newTitleEmail) {
  //   state = state.copyWith(titleEmail: newTitleEmail);
  // }

  void updateMortgageCompanyId(String newMortgageCompanyId) {
    state = state.copyWith(mortgageCompanyId: newMortgageCompanyId);
  }

  // void updateMortgageCompany(String newMortgageCompany) {
  //   state = state.copyWith(mortgageCompany: newMortgageCompany);
  // }

  // void updateMortgagePhone(String newMortgagePhone) {
  //   state = state.copyWith(mortgagePhone: newMortgagePhone);
  // }

  // void updateMortgageEmail(String newMortgageEmail) {
  //   state = state.copyWith(mortgageEmail: newMortgageEmail);
  // }

  void updateOtherAgent(String newOtherAgent) {
    state = state.copyWith(otherAgent: newOtherAgent);
  }

  void updateOtherAgentPhone(String newOtherAgentPhone) {
    state = state.copyWith(otherAgentPhone: newOtherAgentPhone);
  }

  void updateOtherAgentEmail(String newOtherAgentEmail) {
    state = state.copyWith(otherAgentEmail: newOtherAgentEmail);
  }

  void updateOtherPartyClient(String newOtherPartyClient) {
    state = state.copyWith(otherPartyClient: newOtherPartyClient);
  }

  void updateOtherPartyTitleCompany(String newOtherPartyTitleCompany) {
    state = state.copyWith(otherPartyTitleCompany: newOtherPartyTitleCompany);
  }

  void updateTrxnStatus(String? newTrxnStatus) {
    state = state.copyWith(trxnStatus: newTrxnStatus);
  }

  Map<String, dynamic> toMap(Trxn trxn) {
    return {
      //'trxnId': trxnId,
      'userId': trxn.userId,
      'companyId': trxn.companyId,
      'clientCompanyId': trxn.clientId,
      // 'clientFName': trxn.clientFName,
      // 'clientLName': trxn.clientLName,
      // 'clientType': trxn.clientType,
      // 'clientEmail': trxn.clientEmail,
      // 'clientCellPhone': trxn.clientCellPhone,
      // 'clientHomePhone': trxn.clientHomePhone,
      'propertyAddress': trxn.propertyAddress,
      'propertyCity': trxn.propertyCity,
      'propertyState': trxn.propertyState,
      'propertyZipcode': trxn.propertyZipcode,
      'mlsNumber': trxn.mlsNumber,
      'contractDate': trxn.contractDate,
      'contractPrice': trxn.contractPrice,
      'sellerDisclosure24a': trxn.sellerDisclosure24a,
      'dueDiligence24b': trxn.dueDiligence24b,
      'financing24c': trxn.financing24c,
      'settlement24d': trxn.settlement24d,
      'inspectorCompanyId': trxn.inspectorCompanyId,
      // 'inspectorCompany': trxn.inspectorCompany,
      // 'inspectorPhone': trxn.inspectorPhone,
      'inspectionDate': trxn.inspectionDate,
      'appraiserCompanyId': trxn.appraiserCompanyId,
      // 'appraiser': trxn.appraiser,
      // 'appraiserPhone': trxn.appraiserPhone,
      'appraisalDate': trxn.appraisalDate,
      'closingDate': trxn.closingDate,
      'walkThroughDate': trxn.walkThroughDate,
      'titleCompanyId': trxn.titleCompanyId,
      // 'titleCompany': trxn.titleCompany,
      // 'titlePhone': trxn.titlePhone,
      // 'titleEmail': trxn.titleEmail,
      'mortgageCompanyId': trxn.mortgageCompanyId,
      // 'mortgageCompany': trxn.mortgageCompany,
      // 'mortgagePhone': trxn.mortgagePhone,
      // 'mortgageEmail': trxn.mortgageEmail,
      'otherAgent': trxn.otherAgent,
      'otherAgentPhone': trxn.otherAgentPhone,
      'otherAgentEmail': trxn.otherAgentEmail,
      'otherPartyClient': trxn.otherPartyClient,
      'otherPartyTitleCompany': trxn.otherPartyTitleCompany,
      'trxnStatus': trxn.trxnStatus
    };
  }

  getCompanyTrxn() {
    return firestoreService
        .getCompanyTrxns(ref.read(globalsNotifierProvider).companyId!);
  }

  // The variables below come from the Getters except for _agentId and _uuId
  saveTrxn(Trxn refTrxn, String companyId, bool isNewTrxn) {
    if (isNewTrxn == true) {
      //trxnId = uuid.v4();
      ref
          .read(globalsNotifierProvider.notifier)
          .updatecurrentTrxnId(const Uuid().v4());
    }

    //final refTrxn = ref.read(trxnNotifierProvider);

    var newTrxn = Trxn(
        userId: ref.read(globalsNotifierProvider).currentUid,
        companyId: refTrxn.companyId,
        //trxnId: refTrxn.trxnId,
        clientId: refTrxn.clientId,
        // clientFName: refTrxn.clientFName,
        // clientLName: refTrxn.clientLName,
        // clientType: refTrxn.clientType,
        // clientEmail: refTrxn.clientEmail,
        // clientCellPhone: refTrxn.clientCellPhone,
        // clientHomePhone: refTrxn.clientHomePhone,
        propertyAddress: refTrxn.propertyAddress,
        propertyCity: refTrxn.propertyCity,
        propertyState: ref.read(globalsNotifierProvider).selectedTrxnState,
        propertyZipcode: refTrxn.propertyZipcode,
        mlsNumber: refTrxn.mlsNumber,
        contractDate: refTrxn.contractDate,
        contractPrice: refTrxn.contractPrice,
        sellerDisclosure24a: refTrxn.sellerDisclosure24a,
        dueDiligence24b: refTrxn.dueDiligence24b,
        financing24c: refTrxn.financing24c,
        settlement24d: refTrxn.settlement24d,
        inspectorCompanyId: refTrxn.inspectorCompanyId,
        // inspectorCompany: refTrxn.inspectorCompany,
        inspectionDate: refTrxn.inspectionDate,
        // inspectorPhone: refTrxn.inspectorPhone,
        appraiserCompanyId: refTrxn.appraiserCompanyId,
        // appraiser: refTrxn.appraiser,
        // appraiserPhone: refTrxn.appraiserPhone,
        appraisalDate: refTrxn.appraisalDate,
        closingDate: refTrxn.closingDate,
        walkThroughDate: refTrxn.walkThroughDate,
        titleCompanyId: refTrxn.titleCompanyId,
        // titleCompany: refTrxn.titleCompany,
        // titlePhone: refTrxn.titlePhone,
        // titleEmail: refTrxn.titleEmail,
        mortgageCompanyId: refTrxn.mortgageCompanyId,
        // mortgageCompany: refTrxn.mortgageCompany,
        // mortgagePhone: refTrxn.mortgagePhone,
        // mortgageEmail: refTrxn.mortgageEmail,
        otherAgent: refTrxn.otherAgent,
        otherAgentPhone: refTrxn.otherAgentPhone,
        otherAgentEmail: refTrxn.otherAgentEmail,
        otherPartyTitleCompany: refTrxn.otherPartyTitleCompany,
        otherPartyClient: refTrxn.otherPartyClient,
        trxnStatus: refTrxn.trxnStatus);

    if (isNewTrxn == true) {
      firestoreService.saveNewTrxn(toMap(newTrxn), companyId);
      ref.read(globalsNotifierProvider.notifier).updatenewTrxn(false);
    } else {
      firestoreService.saveTrxn(toMap(newTrxn), companyId,
          ref.read(globalsNotifierProvider).currentTrxnId!);
    }
  }

  deleteTrxn(String trxnId, String companyId) {
    firestoreService.deleteTrxn(trxnId, companyId);
  }
}

final trxnNotifierProvider = NotifierProvider<TrxnNotifier, Trxn>(() {
  return TrxnNotifier();
});
