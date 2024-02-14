//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MortgageCompany {
  String? mortgageCompanyId;
  String? mortgageCompanyName;
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
      {this.mortgageCompanyId,
      this.mortgageCompanyName,
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
    String? mortgageId,
    String? mortgageCompanyName,
    String? address1,
    String? address2,
    String? city,
    String? mortgageState,
    String? zipCode,
    String? cellPhone,
    String? officePhone,
    String? email,
    String? website,
  }) {
    return MortgageCompany(
      mortgageCompanyId: mortgageCompanyId ?? this.mortgageCompanyId,
      mortgageCompanyName: mortgageCompanyName ?? this.mortgageCompanyName,
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
  FirebaseFirestore _db = FirebaseFirestore.instance;
  MortgageCompanyNotifier(); // un-named constructor

  @override
  MortgageCompany build() {
    return MortgageCompany(
      mortgageCompanyId: '',
      mortgageCompanyName: '',
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

  String? mortgageId;
  String? mortgageCompanyName;
  String? address1;
  String? address2;
  String? city;
  String? mortgageState;
  String? zipCode;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;

  // Update functions
  void updateMortgageId(String newmortgageId) {
    state = state.copyWith(mortgageId: newmortgageId);
  }

  void updateMortgageCompanyName(String newmortgageCompanyName) {
    state = state.copyWith(mortgageCompanyName: newmortgageCompanyName);
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

  void updatestate(String newstate) {
    state = state.copyWith(mortgageState: newstate);
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
      : mortgageId = firestore['mortgageId'],
        mortgageCompanyName = firestore['name'],
        address1 = firestore['address1'],
        address2 = firestore['address2'],
        city = firestore['city'],
        mortgageState = firestore['state'],
        zipCode = firestore['zipCode'],
        cellPhone = firestore['cellPhone'],
        officePhone = firestore['officePhone'],
        email = firestore['email'],
        website = firestore['website'];

  Map<String, dynamic> toMap(MortgageCompany mortgage) {
    return {
      'mortgageId': mortgage.mortgageCompanyId,
      'name': mortgage.mortgageCompanyName,
      'address1': mortgage.address1,
      'address2': mortgage.address2,
      'city': mortgage.city,
      'state': mortgage.mortgageCompanyState,
      'zipCode': mortgage.zipCode,
      'cellPhone': mortgage.cellPhone,
      'officePhone': mortgage.officePhone,
      'email': mortgage.email,
      'website': mortgage.website
    };
  }

  saveMortgageCompany(WidgetRef ref) {
    //globals.agencyId = name;
    //ref.read(globalsNotifierProvider.notifier).updatemortgageId(name);
    //final MortgageVals = ref.watch(mortgageCompanyNotifierProvider);

    var newMortgageCompany = MortgageCompany(
        mortgageCompanyId:
            ref.read(mortgageCompanyNotifierProvider).mortgageCompanyId,
        mortgageCompanyName:
            ref.read(mortgageCompanyNotifierProvider).mortgageCompanyName,
        address1: ref.read(mortgageCompanyNotifierProvider).address1,
        address2: ref.read(mortgageCompanyNotifierProvider).address2,
        city: ref.read(mortgageCompanyNotifierProvider).city,
        mortgageCompanyState:
            ref.read(mortgageCompanyNotifierProvider).mortgageCompanyState,
        zipCode: ref.read(mortgageCompanyNotifierProvider).zipCode,
        cellPhone: ref.read(mortgageCompanyNotifierProvider).cellPhone,
        officePhone: ref.read(mortgageCompanyNotifierProvider).officePhone,
        email: ref.read(mortgageCompanyNotifierProvider).email,
        website: ref.read(mortgageCompanyNotifierProvider).website);

    // If the agency is a new agency retrieve the agency
    // document ID and save it to a new agent document
    if (ref.read(globalsNotifierProvider).newMortgageCompany == true) {
      //String id = _db.collection('mortgage').doc().id;
      //ref.read(globalsNotifierProvider.notifier).updateMortgageId(id);
      // ref.read(globalsNotifierProvider.notifier).updatecurrentMortgageState(
      //     ref.read(globalsNotifierProvider).selectedState!);

      firestoreService.saveNewMortgageCompany(toMap(newMortgageCompany));

      //ref.read(globalsNotifierProvider.notifier).updatemortgageId(id);
      ref
          .read(globalsNotifierProvider.notifier)
          .updatenewMortgageCompany(false);
    } else {
      firestoreService.saveMortgageCompany(
          toMap(newMortgageCompany), mortgageId!);
    }
  }
}

final mortgageCompanyNotifierProvider =
    NotifierProvider<MortgageCompanyNotifier, MortgageCompany>(() {
  return MortgageCompanyNotifier();
});
