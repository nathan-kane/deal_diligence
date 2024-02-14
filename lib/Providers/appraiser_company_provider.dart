//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

// ignore_for_file: unused_label, unnecessary_null_comparison, unused_local_variable, unused_import

import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deal_diligence/Providers/company_provider.dart';

class AppraiserCompany {
  String? appraiserCompanyId;
  String? apraiserCompanyName;
  String? fName;
  String? lName;
  String? address1;
  String? address2;
  String? city;
  String? appraiserState;
  String? zipCode;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;

  AppraiserCompany(
      {this.appraiserCompanyId,
      this.apraiserCompanyName,
      this.fName,
      this.lName,
      this.address1,
      this.address2,
      this.city,
      this.appraiserState,
      this.zipCode,
      this.cellPhone,
      this.officePhone,
      this.email,
      this.website});

  AppraiserCompany copyWith({
    String? appraiserId,
    String? appraiserCompanyName,
    String? fName,
    String? lName,
    String? address1,
    String? address2,
    String? city,
    String? appraiserState,
    String? zipCode,
    String? cellPhone,
    String? officePhone,
    String? email,
    String? website,
  }) {
    return AppraiserCompany(
      apraiserCompanyName: apraiserCompanyName ?? appraiserCompanyName,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      appraiserState: appraiserState ?? this.appraiserState,
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
  //final companyRef = FirebaseFirestore.instance.collection(('Company'));
  final appraiserCompanyDB =
      FirebaseFirestore.instance.collection(('appraiserCompany'));
  AppraiserCompanyNotifier(); // un-named constructor

// **************************************************

  String appraiserCompanyId = '';
  String appraiserCompanyName = '';
  String fName = '';
  String lName = '';
  String address1 = '';
  String address2 = '';
  String city = '';
  String appraiserState = '';
  String zipCode = '';
  String cellPhone = '';
  String officePhone = '';
  String email = '';
  String website = '';

  @override
  AppraiserCompany build() {
    return AppraiserCompany(
      // Return the initial state
      appraiserCompanyId: '',
      apraiserCompanyName: '',
      fName: '',
      lName: '',
      address1: '',
      address2: '',
      city: '',
      appraiserState: '',
      zipCode: '',
      cellPhone: '',
      officePhone: '',
      email: '',
      website: '',
    );
  }

  // functions to update class members
  void updateAppraiserCompanyName(String newAppraiserCompanyName) {
    state = state.copyWith(appraiserCompanyName: newAppraiserCompanyName);
  }

  void updatefName(String newfName) {
    state = state.copyWith(fName: newfName);
  }

  void updatelName(String newlName) {
    state = state.copyWith(lName: newlName);
  }

  void updateaddress1(String newaddress1) {
    state = state.copyWith(address1: newaddress1);
  }

  void updateaddress2(String newaddress2) {
    state = state.copyWith(address2: newaddress2);
  }

  void updateCity(String newCity) {
    state = state.copyWith(city: newCity);
  }

  void updateAppraiserState(String newAppraiserState) {
    state = state.copyWith(appraiserState: newAppraiserState);
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

  Map<String, dynamic> toMap(AppraiserCompany appraiserCompany) {
    return {
      'cellPhone': appraiserCompany.cellPhone,
      'address1': appraiserCompany.address1,
      'address2': appraiserCompany.address2,
      'appraiserId': appraiserCompany.appraiserCompanyId,
      'city': appraiserCompany.city,
      'fName': appraiserCompany.fName,
      'lName': appraiserCompany.lName,
      'officePhone': appraiserCompany.officePhone,
      'appraiserState': appraiserCompany.appraiserState,
      'zipCode': appraiserCompany.zipCode,
      'email': appraiserCompany.email,
    };
  }

  AppraiserCompanyNotifier.fromFirestore(Map<String, dynamic> firestore)
      : cellPhone = firestore['cellPhone'],
        address1 = firestore['address1'],
        address2 = firestore['address2'],
        appraiserCompanyId = firestore['appraiserCompanyId'],
        city = firestore['city'],
        fName = firestore['fName'],
        lName = firestore['lName'],
        officePhone = firestore['officePhone'],
        appraiserState = firestore['appraiserState'],
        zipCode = firestore['zipCode'],
        email = firestore['email'];

// **************************************************

  // saveFcmToken(String userId, String userName) {
  //   //firestoreService.saveUserFcmTokenId(userId, fcmTokenId);
  //   firestoreService.saveDeviceToken(userId, userName);
  // }

  saveAppraiserCompany(globals, appraiserCompany) async {
    if (ref.watch(globalsNotifierProvider).isNewAppraiserCompany == true) {
      // final DocumentSnapshot currentCompanyProfile =
      final newAppraiser = AppraiserCompany(
        appraiserCompanyId: appraiserCompany.appraiserCompanyId,
        fName: appraiserCompany.fName,
        lName: appraiserCompany.lName,
        address1: appraiserCompany.address1,
        address2: appraiserCompany.address2,
        city: appraiserCompany.city,
        appraiserState: appraiserCompany.appraiserState,
        zipCode: appraiserCompany.zipCode,
        cellPhone: appraiserCompany.cellPhone,
        officePhone: appraiserCompany.officePhone,
        email: appraiserCompany.email,
      );
      firestoreService.saveNewAppraiserCompany(toMap(newAppraiser));
      ref
          .read(globalsNotifierProvider.notifier)
          .updateIsNewAppraiserCompany(false);
    } else {
      final DocumentSnapshot currentAppraiserProfile = await appraiserCompanyDB
          .doc(appraiserCompany.AppraiserCompanyId)
          .get();

      var newAppraiser = AppraiserCompany(
          fName: (state.fName != null && state.fName != "")
              ? state.fName
              : currentAppraiserProfile.get('fName'),
          lName: (state.lName != null && state.lName != "")
              ? state.lName
              : currentAppraiserProfile.get('lName'),
          address1: (state.address1 != null && state.address1 != "")
              ? state.address1
              : currentAppraiserProfile.get('address1'),
          address2: (state.address2 != null && state.address2 != "")
              ? state.address2
              : currentAppraiserProfile.get('address2'),
          city: (state.city != null && state.city != "")
              ? state.city
              : currentAppraiserProfile.get('city'),
          appraiserState: (appraiserState != null && appraiserState != "")
              ? appraiserState
              : currentAppraiserProfile.get('appraiserState'),
          /*state: (globals.selectedState != null)
              ? globals.selectedState
              : globals.currentuserState,*/
          zipCode: (state.zipCode != null && state.zipCode != "")
              ? state.zipCode
              : currentAppraiserProfile.get('zipCode'),
          cellPhone: (state.cellPhone != null && state.cellPhone != "")
              ? state.cellPhone
              : currentAppraiserProfile.get('cellPhone'),
          officePhone: (state.officePhone != null && state.officePhone != "")
              ? state.officePhone
              : currentAppraiserProfile.get('officePhone'));
      // businessType:
      // ref.read(globalsNotifierProvider).userBusinessType;

      firestoreService.saveAppraiserCompany(
          AppraiserCompany, appraiserCompanyId);
    }
  }

  deleteAppraiserCompany(String? appraiserCompanyId) {
    firestoreService.deleteAppraiserCompany(appraiserCompanyId);
  }
}

final appraiserCompanyNotifierProvider =
    NotifierProvider<AppraiserCompanyNotifier, AppraiserCompany>(() {
  return AppraiserCompanyNotifier();
});
