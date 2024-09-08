//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:uuid/uuid.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Trxn {
  //String? trxnId;
  String? userId;
  String? companyId;
  String? clientId;
  String? clientType;
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
  String? inspectionDate;
  String? appraiserCompanyId;
  String? appraisalDate;
  String? closingDate;
  String? walkThroughDate;
  String? titleCompanyId;
  String? mortgageCompanyId;
  String? otherAgentCompanyId;
  String? otherAgentPhone;
  String? otherAgentEmail;
  String? otherPartyClient;
  String? otherPartyTitleCompanyId;
  String? trxnStatus;
  //var uuId = Uuid();

  Trxn({
    //this.trxnId,
    this.userId,
    this.companyId,
    this.clientId,
    this.clientType,
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
    this.inspectionDate,
    this.appraiserCompanyId,
    this.appraisalDate,
    this.closingDate,
    this.walkThroughDate,
    this.titleCompanyId,
    this.mortgageCompanyId,
    this.otherAgentCompanyId,
    this.otherAgentPhone,
    this.otherAgentEmail,
    this.otherPartyClient,
    this.otherPartyTitleCompanyId,
    this.trxnStatus,
    //this.uuId = Uuid(),
  });

  Trxn copyWith({
    //String? trxnId,
    String? userId,
    String? companyId,
    String? clientId,
    String? clientType,
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
    String? inspectionDate,
    String? appraiserCompanyId,
    String? appraisalDate,
    String? closingDate,
    String? walkThroughDate,
    String? titleCompanyId,
    String? mortgageCompanyId,
    String? otherAgentCompanyId,
    String? otherAgentPhone,
    String? otherAgentEmail,
    String? otherPartyClient,
    String? otherPartyTitleCompanyId,
    String? trxnStatus,
    //var uuId = Uuid(),
  }) {
    return Trxn(
      //trxnId: trxnId ?? this.trxnId,
      userId: userId ?? this.userId,
      companyId: companyId ?? this.companyId,
      clientId: clientId ?? this.clientId,
      clientType: clientType ?? this.clientType,
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
      inspectionDate: inspectionDate ?? this.inspectionDate,
      appraiserCompanyId: appraiserCompanyId ?? this.appraiserCompanyId,
      appraisalDate: appraisalDate ?? this.appraisalDate,
      closingDate: closingDate ?? this.closingDate,
      walkThroughDate: walkThroughDate ?? this.walkThroughDate,
      titleCompanyId: titleCompanyId ?? this.titleCompanyId,
      mortgageCompanyId: mortgageCompanyId ?? this.mortgageCompanyId,
      otherAgentCompanyId: otherAgentCompanyId ?? this.otherAgentCompanyId,
      otherAgentPhone: otherAgentPhone ?? this.otherAgentPhone,
      otherAgentEmail: otherAgentEmail ?? this.otherAgentEmail,
      otherPartyClient: otherPartyClient ?? this.otherPartyClient,
      otherPartyTitleCompanyId:
          otherPartyTitleCompanyId ?? this.otherPartyTitleCompanyId,
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
      clientType: '',
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
      inspectionDate: '',
      appraiserCompanyId: '',
      appraisalDate: '',
      closingDate: '',
      walkThroughDate: '',
      titleCompanyId: '',
      mortgageCompanyId: '',
      otherAgentCompanyId: '',
      otherAgentPhone: '',
      otherAgentEmail: '',
      otherPartyClient: '',
      otherPartyTitleCompanyId: '',
      trxnStatus: '',
    );
  }

  //String? trxnId;
  String? userId;
  String? companyId;
  String? clientId;
  String? clientType;
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
  String? inspectionDate;
  String? appraiserCompanyId;
  String? appraisalDate;
  String? closingDate;
  String? walkThroughDate;
  String? titleCompany;
  String? titlePhone;
  String? titleEmail;
  String? mortgageCompany;
  String? mortgagePhone;
  String? mortgageEmail;
  String? otherAgentCompanyId;
  String? otherAgentPhone;
  String? otherAgentEmail;
  String? otherPartyClient;
  String? otherPartyTitleCompanyId;
  String? trxnStatus;

  // functions to update class members
  void updateCompanyid(String newCompanyId) {
    state = state.copyWith(companyId: newCompanyId);
  }

  void updateUserId(String newUserId) {
    state = state.copyWith(userId: newUserId);
  }

  void updateClientId(String newClientId) {
    state = state.copyWith(clientId: newClientId);
  }

  void updateClientType(String newClientType) {
    state = state.copyWith(clientType: newClientType);
  }

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

  void updateInspectionDate(String newInspectionDate) {
    state = state.copyWith(inspectionDate: newInspectionDate);
  }

  void updateAppraiserCompanyId(String newAppraiserCompanyId) {
    state = state.copyWith(appraiserCompanyId: newAppraiserCompanyId);
  }

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

  void updateMortgageCompanyId(String newMortgageCompanyId) {
    state = state.copyWith(mortgageCompanyId: newMortgageCompanyId);
  }

  void updateOtherAgentCompanyId(String newOtherAgentCompanyId) {
    state = state.copyWith(otherAgentCompanyId: newOtherAgentCompanyId);
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

  void updateOtherPartyTitleCompanyId(String newOtherPartyTitleCompanyId) {
    state =
        state.copyWith(otherPartyTitleCompanyId: newOtherPartyTitleCompanyId);
  }

  void updateTrxnStatus(String? newTrxnStatus) {
    state = state.copyWith(trxnStatus: newTrxnStatus);
  }

  Map<String, dynamic> toMap(Trxn trxn) {
    return {
      //'trxnId': trxnId,
      'userId': trxn.userId,
      'companyId': trxn.companyId,
      'clientId': trxn.clientId,
      'clientType': trxn.clientType,
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
      'inspectionDate': trxn.inspectionDate,
      'appraiserCompanyId': trxn.appraiserCompanyId,
      'appraisalDate': trxn.appraisalDate,
      'closingDate': trxn.closingDate,
      'walkThroughDate': trxn.walkThroughDate,
      'titleCompanyId': trxn.titleCompanyId,
      'mortgageCompanyId': trxn.mortgageCompanyId,
      'otherAgentCompanyId': trxn.otherAgentCompanyId,
      'otherAgentPhone': trxn.otherAgentPhone,
      'otherAgentEmail': trxn.otherAgentEmail,
      'otherPartyClient': trxn.otherPartyClient,
      'otherPartyTitleCompanyId': trxn.otherPartyTitleCompanyId,
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
      ref
          .read(globalsNotifierProvider.notifier)
          .updatecurrentTrxnId(const Uuid().v4());
    }

    var newTrxn = Trxn(
        userId: ref.read(globalsNotifierProvider).currentUid,
        companyId: refTrxn.companyId,
        clientId: refTrxn.clientId,
        clientType: refTrxn.clientType,
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
        inspectionDate: refTrxn.inspectionDate,
        appraiserCompanyId: refTrxn.appraiserCompanyId,
        appraisalDate: refTrxn.appraisalDate,
        closingDate: refTrxn.closingDate,
        walkThroughDate: refTrxn.walkThroughDate,
        titleCompanyId: refTrxn.titleCompanyId,
        mortgageCompanyId: refTrxn.mortgageCompanyId,
        otherAgentCompanyId: refTrxn.otherAgentCompanyId,
        otherAgentPhone: refTrxn.otherAgentPhone,
        otherAgentEmail: refTrxn.otherAgentEmail,
        otherPartyTitleCompanyId: refTrxn.otherPartyTitleCompanyId,
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
