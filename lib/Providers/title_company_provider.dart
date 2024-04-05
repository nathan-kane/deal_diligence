//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TitleCompany {
  //String? titleCompanyId;
  String? titleCompanyName;
  String? primaryContact;
  String? address1;
  String? address2;
  String? city;
  String? titleCompanyState;
  String? zipCode;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;

  TitleCompany(
      { //this.titleCompanyId,
      this.titleCompanyName,
      this.primaryContact,
      this.address1,
      this.address2,
      this.city,
      this.titleCompanyState,
      this.zipCode,
      this.cellPhone,
      this.officePhone,
      this.email,
      this.website});

  TitleCompany copyWith({
    //String? titleId,
    String? titleCompanyName,
    String? primaryContact,
    String? address1,
    String? address2,
    String? city,
    String? titleCompanyState,
    String? zipCode,
    String? cellPhone,
    String? officePhone,
    String? email,
    String? website,
  }) {
    return TitleCompany(
      //titleCompanyId: titleCompanyId ?? this.titleCompanyId,
      titleCompanyName: titleCompanyName ?? this.titleCompanyName,
      primaryContact: primaryContact ?? this.primaryContact,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      titleCompanyState: titleCompanyState ?? this.titleCompanyState,
      zipCode: zipCode ?? this.zipCode,
      cellPhone: cellPhone ?? this.cellPhone,
      officePhone: officePhone ?? this.officePhone,
      email: email ?? this.email,
      website: website ?? this.website,
    );
  }
}

class TitleCompanyNotifier extends Notifier<TitleCompany> {
  final firestoreService = FirestoreService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  TitleCompanyNotifier(); // un-named constructor

  @override
  TitleCompany build() {
    return TitleCompany(
      //titleCompanyId: '',
      titleCompanyName: '',
      primaryContact: '',
      address1: '',
      address2: '',
      city: '',
      titleCompanyState: '',
      zipCode: '',
      cellPhone: '',
      officePhone: '',
      email: '',
      website: '',
    );
  }

  //String? titleId;
  String? titleCompanyName;
  String? primaryContact;
  String? address1;
  String? address2;
  String? city;
  String? titleCompanyState;
  String? zipCode;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;

  // Update functions
  // void updateTitleId(String newtitleId) {
  //   state = state.copyWith(titleId: newtitleId);
  // }

  void updateTitleCompanyName(String newtitleCompanyName) {
    state = state.copyWith(titleCompanyName: newtitleCompanyName);
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

  void updateTitleCompanyState(String newTitleCompanyState) {
    state = state.copyWith(titleCompanyState: newTitleCompanyState);
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

  TitleCompanyNotifier.fromFirestore(Map<String, dynamic> firestore)
      : //titleId = firestore['titleId'],
        titleCompanyName = firestore['titleCompanyName'],
        primaryContact = firestore['primaryContact'],
        address1 = firestore['address1'],
        address2 = firestore['address2'],
        city = firestore['city'],
        titleCompanyState = firestore['titleCompanyState'],
        zipCode = firestore['zipCode'],
        cellPhone = firestore['cellPhone'],
        officePhone = firestore['officePhone'],
        email = firestore['email'],
        website = firestore['website'];

  Map<String, dynamic> toMap(TitleCompany title) {
    return {
      //'titleId': title.titleCompanyId,
      'titleCompanyName': title.titleCompanyName,
      'primaryContact': title.primaryContact,
      'address1': title.address1,
      'address2': title.address2,
      'city': title.city,
      'titleCompanyState': title.titleCompanyState,
      'zipCode': title.zipCode,
      'cellPhone': title.cellPhone,
      'officePhone': title.officePhone,
      'email': title.email,
      'website': title.website
    };
  }

  saveTitleCompany(TitleCompany titleCompany, [titleCompanyId]) {
    //globals.agencyId = name;
    //ref.read(globalsNotifierProvider.notifier).updatetitleId(name);
    //final TitleVals = ref.watch(titleCompanyNotifierProvider);

    var newTitleCompany = TitleCompany(
        //titleCompanyId: titleCompany.titleCompanyId,
        titleCompanyName: titleCompany.titleCompanyName,
        primaryContact: titleCompany.primaryContact,
        address1: titleCompany.address1,
        address2: titleCompany.address2,
        city: titleCompany.city,
        titleCompanyState: titleCompany.titleCompanyState,
        zipCode: titleCompany.zipCode,
        cellPhone: titleCompany.cellPhone,
        officePhone: titleCompany.officePhone,
        email: titleCompany.email,
        website: titleCompany.website);

    // If the agency is a new agency retrieve the agency
    // document ID and save it to a new agent document
    if (titleCompanyId == "" || titleCompanyId == null) {
      firestoreService.saveNewTitleCompany(toMap(newTitleCompany));

      //ref.read(globalsNotifierProvider.notifier).updatetitleId(id);
      ref.read(globalsNotifierProvider.notifier).updateIsNewTitleCompany(false);
    } else {
      firestoreService.saveTitleCompany(
          toMap(newTitleCompany), titleCompanyId!);
    }
  }
}

final titleCompanyNotifierProvider =
    NotifierProvider<TitleCompanyNotifier, TitleCompany>(() {
  return TitleCompanyNotifier();
});
