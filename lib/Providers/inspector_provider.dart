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

class InspectorCompany {
  //String? inspectorCompanyId;
  String? inspectorCompanyName;
  String? primaryContact;
  String? address1;
  String? address2;
  String? city;
  String? inspectorCompanyState;
  String? zipCode;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;

  InspectorCompany(
      { //this.inspectorCompanyId,
      this.inspectorCompanyName,
      this.primaryContact,
      this.address1,
      this.address2,
      this.city,
      this.inspectorCompanyState,
      this.zipCode,
      this.cellPhone,
      this.officePhone,
      this.website,
      this.email});

  InspectorCompany copyWith({
    //String? inspectorCompanyId,
    String? inspectorCompanyName,
    String? primaryContact,
    String? address1,
    String? address2,
    String? city,
    String? inspectorCompanyState,
    String? zipCode,
    String? cellPhone,
    String? officePhone,
    String? email,
    String? website,
  }) {
    return InspectorCompany(
      inspectorCompanyName: inspectorCompanyName ?? this.inspectorCompanyName,
      primaryContact: primaryContact ?? this.primaryContact,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      inspectorCompanyState:
          inspectorCompanyState ?? this.inspectorCompanyState,
      zipCode: zipCode ?? this.zipCode,
      cellPhone: cellPhone ?? this.cellPhone,
      officePhone: officePhone ?? this.officePhone,
      email: email ?? this.email,
      website: website ?? this.website,
    );
  }
}

class InspectorCompanyNotifier extends Notifier<InspectorCompany> {
  final firestoreService = FirestoreService();
  //final companyRef = FirebaseFirestore.instance.collection(('Company'));
  final inspectorDB = FirebaseFirestore.instance.collection(('inspector'));
  InspectorCompanyNotifier(); // un-named constructor

// **************************************************

  //String inspectorCompanyId = '';
  String inspectorCompanyName = '';
  String primaryContact = '';
  String address1 = '';
  String address2 = '';
  String city = '';
  String inspectorCompanyState = '';
  String zipCode = '';
  String officePhone = '';
  String cellPhone = '';
  String email = '';
  String website = '';

  @override
  InspectorCompany build() {
    return InspectorCompany(
      // Return the initial state
      //inspectorCompanyId: '',
      inspectorCompanyName: '',
      primaryContact: '',
      address1: '',
      address2: '',
      city: '',
      inspectorCompanyState: '',
      zipCode: '',
      cellPhone: '',
      officePhone: '',
      email: '',
      website: '',
    );
  }

  // functions to update class members
  void updateInspectorCompanyName(String newInspectorCompanyName) {
    state = state.copyWith(inspectorCompanyName: newInspectorCompanyName);
  }

  void updatePrimaryContact(String newprimaryContact) {
    state = state.copyWith(primaryContact: newprimaryContact);
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

  void updateInspectorCompanyState(String newInspectorCompanyState) {
    state = state.copyWith(inspectorCompanyState: newInspectorCompanyState);
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

  Map<String, dynamic> toMap(InspectorCompany inspectorCompany) {
    return {
      'inspectorCompanyName': inspectorCompany.inspectorCompanyName,
      'cellPhone': inspectorCompany.cellPhone,
      'address1': inspectorCompany.address1,
      'address2': inspectorCompany.address2,
      //'inspectorCompanyId': inspectorCompany.inspectorCompanyId,
      'city': inspectorCompany.city,
      'primaryContact': inspectorCompany.primaryContact,
      'officePhone': inspectorCompany.officePhone,
      'inspectorCompanyState': inspectorCompany.inspectorCompanyState,
      'zipCode': inspectorCompany.zipCode,
      'email': inspectorCompany.email,
      'website': inspectorCompany.website,
    };
  }

  InspectorCompanyNotifier.fromFirestore(Map<String, dynamic> firestore)
      : cellPhone = firestore['cellPhone'],
        address1 = firestore['address1'],
        address2 = firestore['address2'],
        //inspectorCompanyId = firestore['inspectorCompanyId'],
        inspectorCompanyName = firestore['inspectorCompanyName'],
        city = firestore['city'],
        primaryContact = firestore['primaryContact'],
        officePhone = firestore['officePhone'],
        inspectorCompanyState = firestore['inspectorCompanyState'],
        zipCode = firestore['zipCode'],
        email = firestore['email'],
        website = firestore['website'];

// **************************************************

  // saveFcmToken(String userId, String userName) {
  //   //firestoreService.saveUserFcmTokenId(userId, fcmTokenId);
  //   firestoreService.saveDeviceToken(userId, userName);
  // }

  saveInspectorCompany(inspectorCompany, [inspectorCompanyId]) async {
    if (ref.watch(globalsNotifierProvider).newInspector == true) {
      // final DocumentSnapshot currentCompanyProfile =
      final newInspectorCompany = InspectorCompany(
        //inspectorCompanyId: inspectorCompany.inspectorCompanyId,
        inspectorCompanyName: inspectorCompany.inspectorCompanyName,
        primaryContact: inspectorCompany.primaryContact,
        address1: inspectorCompany.address1,
        address2: inspectorCompany.address2,
        city: inspectorCompany.city,
        inspectorCompanyState: inspectorCompany.inspectorCompanyState,
        zipCode: inspectorCompany.zipCode,
        cellPhone: inspectorCompany.cellPhone,
        officePhone: inspectorCompany.officePhone,
        email: inspectorCompany.email,
        website: inspectorCompany.website,
      );
      firestoreService.saveNewInspectorCompany(toMap(newInspectorCompany));
      // ref
      //     .read(globalsNotifierProvider.notifier)
      //     .updatenewInspectorCompany(false);
    } else {
      final DocumentSnapshot currentInspectorCompanyProfile =
          await inspectorDB.doc(inspectorCompany.InspectorCompanyId).get();

      var newInspectorCompany = InspectorCompany(
        inspectorCompanyName: (state.inspectorCompanyName != null &&
                state.inspectorCompanyName != "")
            ? state.inspectorCompanyName
            : currentInspectorCompanyProfile.get('inspectorCompanyName'),
        primaryContact:
            (state.primaryContact != null && state.primaryContact != "")
                ? state.primaryContact
                : currentInspectorCompanyProfile.get('primaryContact'),
        address1: (state.address1 != null && state.address1 != "")
            ? state.address1
            : currentInspectorCompanyProfile.get('address1'),
        address2: (state.address2 != null && state.address2 != "")
            ? state.address2
            : currentInspectorCompanyProfile.get('address2'),
        city: (state.city != null && state.city != "")
            ? state.city
            : currentInspectorCompanyProfile.get('city'),
        inspectorCompanyState:
            (inspectorCompanyState != null && inspectorCompanyState != "")
                ? inspectorCompanyState
                : currentInspectorCompanyProfile.get('inspectorCompanyState'),
        zipCode: (state.zipCode != null && state.zipCode != "")
            ? state.zipCode
            : currentInspectorCompanyProfile.get('zipCode'),
        cellPhone: (state.cellPhone != null && state.cellPhone != "")
            ? state.cellPhone
            : currentInspectorCompanyProfile.get('cellPhone'),
        officePhone: (state.officePhone != null && state.officePhone != "")
            ? state.officePhone
            : currentInspectorCompanyProfile.get('officePhone'),
        website: (state.website != null && state.website != "")
            ? state.website
            : currentInspectorCompanyProfile.get('website'),
      );
      // businessType:
      // ref.read(globalsNotifierProvider).userBusinessType;

      firestoreService.saveInspectorCompany(
          newInspectorCompany, inspectorCompanyId);
    }
  }

  deleteInspectorCompany(String? inspectorCompanyId) {
    firestoreService.deleteInspectorCompany(inspectorCompanyId);
  }
}

final inspectorCompanyNotifierProvider =
    NotifierProvider<InspectorCompanyNotifier, InspectorCompany>(() {
  return InspectorCompanyNotifier();
});
