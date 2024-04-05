//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppraiserCompany {
  //String? appraiserCompanyId;
  String? appraiserCompanyName;
  String? primaryContact;
  String? address1;
  String? address2;
  String? city;
  String? appraiserCompanyState;
  String? zipCode;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;

  AppraiserCompany(
      { //this.appraiserCompanyId,
      this.appraiserCompanyName,
      this.primaryContact,
      this.address1,
      this.address2,
      this.city,
      this.appraiserCompanyState,
      this.zipCode,
      this.cellPhone,
      this.officePhone,
      this.email,
      this.website});

  AppraiserCompany copyWith({
    //String? appraiserId,
    String? appraiserCompanyName,
    String? primaryContact,
    String? address1,
    String? address2,
    String? city,
    String? appraiserCompanyState,
    String? zipCode,
    String? cellPhone,
    String? officePhone,
    String? email,
    String? website,
  }) {
    return AppraiserCompany(
      //appraiserCompanyId: appraiserCompanyId ?? this.appraiserCompanyId,
      appraiserCompanyName: appraiserCompanyName ?? this.appraiserCompanyName,
      primaryContact: primaryContact ?? this.primaryContact,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      appraiserCompanyState:
          appraiserCompanyState ?? this.appraiserCompanyState,
      zipCode: zipCode ?? this.zipCode,
      cellPhone: cellPhone ?? this.cellPhone,
      officePhone: officePhone ?? this.officePhone,
      email: email ?? this.email,
      website: website ?? this.website,
    );
  }
}

class AppraiserCompanyNotifier extends Notifier<AppraiserCompany> {
  final firestoreService = FirestoreService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  AppraiserCompanyNotifier(); // un-named constructor

  @override
  AppraiserCompany build() {
    return AppraiserCompany(
      //appraiserCompanyId: '',
      appraiserCompanyName: '',
      primaryContact: '',
      address1: '',
      address2: '',
      city: '',
      appraiserCompanyState: '',
      zipCode: '',
      cellPhone: '',
      officePhone: '',
      email: '',
      website: '',
    );
  }

  //String? appraiserId;
  String? appraiserCompanyName;
  String? primaryContact;
  String? address1;
  String? address2;
  String? city;
  String? appraiserCompanyState;
  String? zipCode;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;

  // Update functions
  // void updateAppraiserId(String newappraiserId) {
  //   state = state.copyWith(appraiserId: newappraiserId);
  // }

  void updateAppraiserCompanyName(String newAppraiserCompanyName) {
    state = state.copyWith(appraiserCompanyName: newAppraiserCompanyName);
  }

  void updatePrimaryContact(String newPrimaryContact) {
    state = state.copyWith(primaryContact: newPrimaryContact);
  }

  void updateAddress1(String newAddress1) {
    state = state.copyWith(address1: newAddress1);
  }

  void updateAddress2(String newAddress2) {
    state = state.copyWith(address2: newAddress2);
  }

  void updateCity(String newCity) {
    state = state.copyWith(city: newCity);
  }

  void updateAppraiserCompanyState(String newAppraiserCompanyState) {
    state = state.copyWith(appraiserCompanyState: newAppraiserCompanyState);
  }

  void updateZipcode(String newZipcode) {
    state = state.copyWith(zipCode: newZipcode);
  }

  void updateCellPhone(String newCellPhone) {
    state = state.copyWith(cellPhone: newCellPhone);
  }

  void updateOfficePhone(String newOfficePhone) {
    state = state.copyWith(officePhone: newOfficePhone);
  }

  void updateEmail(String newEmail) {
    state = state.copyWith(email: newEmail);
  }

  void updateWebsite(String newWebsite) {
    state = state.copyWith(website: newWebsite);
  }

  AppraiserCompanyNotifier.fromFirestore(Map<String, dynamic> firestore)
      : //appraiserId = firestore['appraiserId'],
        appraiserCompanyName = firestore['appraiserCompanyName'],
        primaryContact = firestore['primaryContact'],
        address1 = firestore['address1'],
        address2 = firestore['address2'],
        city = firestore['city'],
        appraiserCompanyState = firestore['appraiserCompanytate'],
        zipCode = firestore['zipCode'],
        cellPhone = firestore['cellPhone'],
        officePhone = firestore['officePhone'],
        email = firestore['email'],
        website = firestore['website'];

  Map<String, dynamic> toMap(AppraiserCompany appraiser) {
    return {
      //'appraiserId': appraiser.appraiserCompanyId,
      'appraiserCompanyName': appraiser.appraiserCompanyName,
      'primaryContact': appraiser.primaryContact,
      'address1': appraiser.address1,
      'address2': appraiser.address2,
      'city': appraiser.city,
      'appraiserCompanyState': appraiser.appraiserCompanyState,
      'zipCode': appraiser.zipCode,
      'cellPhone': appraiser.cellPhone,
      'officePhone': appraiser.officePhone,
      'email': appraiser.email,
      'website': appraiser.website
    };
  }

  saveAppraiserCompany(appraiserCompany, [appraiserCompanyId]) {
    //globals.agencyId = name;
    //ref.read(globalsNotifierProvider.notifier).updateappraiserId(name);
    //final AppraiserVals = ref.watch(appraiserCompanyNotifierProvider);

    var newAppraiserCompany = AppraiserCompany(
        // appraiserCompanyId:
        //     ref.read(appraiserCompanyNotifierProvider).appraiserCompanyId,
        appraiserCompanyName: appraiserCompany.appraiserCompanyName,
        primaryContact: appraiserCompany.primaryContact,
        address1: appraiserCompany.address1,
        address2: appraiserCompany.address2,
        city: appraiserCompany.city,
        appraiserCompanyState: appraiserCompany.appraiserCompanyState,
        zipCode: appraiserCompany.zipCode,
        cellPhone: appraiserCompany.cellPhone,
        officePhone: appraiserCompany.officePhone,
        email: appraiserCompany.email,
        website: appraiserCompany.website);

    // If the agency is a new agency retrieve the agency
    // document ID and save it to a new agent document
    if (appraiserCompanyId == "" || appraiserCompanyId == null) {
      firestoreService.saveNewAppraiserCompany(toMap(newAppraiserCompany));

      //ref.read(globalsNotifierProvider.notifier).updateappraiserId(id);
      ref
          .read(globalsNotifierProvider.notifier)
          .updateIsNewAppraiserCompany(false);
    } else {
      firestoreService.saveAppraiserCompany(
          toMap(newAppraiserCompany), appraiserCompanyId!);
    }
  }
}

final appraiserCompanyNotifierProvider =
    NotifierProvider<AppraiserCompanyNotifier, AppraiserCompany>(() {
  return AppraiserCompanyNotifier();
});
