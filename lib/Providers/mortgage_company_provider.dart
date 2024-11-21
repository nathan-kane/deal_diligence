//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MortgageCompany {
  //String? mortgageCompanyId;
  String? mortgageCompanyName;
  String? primaryContact;
  String? address1;
  String? address2;
  String? city;
  String? mortgageCompanyState;
  String? zipCode;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;

  MortgageCompany(
      { //this.mortgageCompanyId,
      this.mortgageCompanyName,
      this.primaryContact,
      this.address1,
      this.address2,
      this.city,
      this.mortgageCompanyState,
      this.zipCode,
      this.cellPhone,
      this.officePhone,
      this.email,
      this.website});

  MortgageCompany copyWith({
    //String? mortgageId,
    String? mortgageCompanyName,
    String? primaryContact,
    String? address1,
    String? address2,
    String? city,
    String? mortgageCompanyState,
    String? zipCode,
    String? cellPhone,
    String? officePhone,
    String? email,
    String? website,
  }) {
    return MortgageCompany(
      //mortgageCompanyId: mortgageCompanyId ?? this.mortgageCompanyId,
      mortgageCompanyName: mortgageCompanyName ?? this.mortgageCompanyName,
      primaryContact: primaryContact ?? this.primaryContact,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      mortgageCompanyState: mortgageCompanyState ?? this.mortgageCompanyState,
      zipCode: zipCode ?? this.zipCode,
      cellPhone: cellPhone ?? this.cellPhone,
      officePhone: officePhone ?? this.officePhone,
      email: email ?? this.email,
      website: website ?? this.website,
    );
  }
}

class MortgageCompanyNotifier extends Notifier<MortgageCompany> {
  final firestoreService = FirestoreService();
  //final FirebaseFirestore _db = FirebaseFirestore.instance;
  MortgageCompanyNotifier(); // un-named constructor

  @override
  MortgageCompany build() {
    return MortgageCompany(
      //mortgageCompanyId: '',
      mortgageCompanyName: '',
      primaryContact: '',
      address1: '',
      address2: '',
      city: '',
      mortgageCompanyState: '',
      zipCode: '',
      cellPhone: '',
      officePhone: '',
      email: '',
      website: '',
    );
  }

  //String? mortgageId;
  String? mortgageCompanyName;
  String? primaryContact;
  String? address1;
  String? address2;
  String? city;
  String? mortgageCompanyState;
  String? zipCode;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;

  // Update functions
  // void updateMortgageId(String newmortgageId) {
  //   state = state.copyWith(mortgageId: newmortgageId);
  // }

  void updateMortgageCompanyName(String newmortgageCompanyName) {
    state = state.copyWith(mortgageCompanyName: newmortgageCompanyName);
  }

  void updatePrimaryContact(String newPrimaryContact) {
    state = state.copyWith(primaryContact: newPrimaryContact);
  }

  void updateaddress1(String newaddress1) {
    state = state.copyWith(address1: newaddress1);
  }

  void updateaddress2(String newaddress2) {
    state = state.copyWith(address2: newaddress2);
  }

  void updatecity(String newcity) {
    state = state.copyWith(city: newcity);
  }

  void updatestate(String newMortgageCompanyState) {
    state = state.copyWith(mortgageCompanyState: newMortgageCompanyState);
  }

  void updatezipcode(String newzipcode) {
    state = state.copyWith(zipCode: newzipcode);
  }

  void updateCellPhone(String newcellPhone) {
    state = state.copyWith(cellPhone: newcellPhone);
  }

  void updateofficePhone(String newofficePhone) {
    state = state.copyWith(officePhone: newofficePhone);
  }

  void updateemail(String newemail) {
    state = state.copyWith(email: newemail);
  }

  void updatewebsite(String newwebsite) {
    state = state.copyWith(website: newwebsite);
  }

  MortgageCompanyNotifier.fromFirestore(Map<String, dynamic> firestore)
      : //mortgageId = firestore['mortgageId'],
        mortgageCompanyName = firestore['mortgageCompanyName'],
        primaryContact = firestore['primaryContact'],
        address1 = firestore['address1'],
        address2 = firestore['address2'],
        city = firestore['city'],
        mortgageCompanyState = firestore['mortgageCompanytate'],
        zipCode = firestore['zipCode'],
        cellPhone = firestore['cellPhone'],
        officePhone = firestore['officePhone'],
        email = firestore['email'],
        website = firestore['website'];

  Map<String, dynamic> toMap(MortgageCompany mortgage) {
    return {
      //'mortgageId': mortgage.mortgageCompanyId,
      'mortgageCompanyName': mortgage.mortgageCompanyName,
      'primaryContact': mortgage.primaryContact,
      'address1': mortgage.address1,
      'address2': mortgage.address2,
      'city': mortgage.city,
      'mortgageCompanyState': mortgage.mortgageCompanyState,
      'zipCode': mortgage.zipCode,
      'cellPhone': mortgage.cellPhone,
      'officePhone': mortgage.officePhone,
      'email': mortgage.email,
      'website': mortgage.website
    };
  }

  saveMortgageCompany(mortgageCompany, [mortgageCompanyId]) {
    //globals.agencyId = name;
    //ref.read(globalsNotifierProvider.notifier).updatemortgageId(name);
    //final MortgageVals = ref.watch(mortgageCompanyNotifierProvider);

    var newMortgageCompany = MortgageCompany(
        // mortgageCompanyId:
        //     ref.read(mortgageCompanyNotifierProvider).mortgageCompanyId,
        mortgageCompanyName: mortgageCompany.mortgageCompanyName,
        primaryContact: mortgageCompany.primaryContact,
        address1: mortgageCompany.address1,
        address2: mortgageCompany.address2,
        city: mortgageCompany.city,
        mortgageCompanyState: mortgageCompany.mortgageCompanyState,
        zipCode: mortgageCompany.zipCode,
        cellPhone: mortgageCompany.cellPhone,
        officePhone: mortgageCompany.officePhone,
        email: mortgageCompany.email,
        website: mortgageCompany.website);

    // If the agency is a new agency retrieve the agency
    // document ID and save it to a new agent document
    if (mortgageCompanyId == "" || mortgageCompanyId == null) {
      firestoreService.saveNewMortgageCompany(toMap(newMortgageCompany));

      //ref.read(globalsNotifierProvider.notifier).updatemortgageId(id);
      ref
          .read(globalsNotifierProvider.notifier)
          .updatenewMortgageCompany(false);
    } else {
      firestoreService.saveMortgageCompany(
          toMap(newMortgageCompany), mortgageCompanyId!);
    }
  }
}

final mortgageCompanyNotifierProvider =
    NotifierProvider<MortgageCompanyNotifier, MortgageCompany>(() {
  return MortgageCompanyNotifier();
});
