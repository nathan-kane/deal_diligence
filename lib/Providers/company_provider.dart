//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

//import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
//import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Company {
  String? companyId;
  String? companyName;
  String? address1;
  String? address2;
  String? city;
  String? companyState;
  String? zipCode;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;

  Company(
      {this.companyId,
      this.companyName,
      this.address1,
      this.address2,
      this.city,
      this.companyState,
      this.zipCode,
      this.cellPhone,
      this.officePhone,
      this.email,
      this.website});

  Company copyWith({
    String? companyId,
    String? companyName,
    String? address1,
    String? address2,
    String? city,
    String? companyState,
    String? zipCode,
    String? cellPhone,
    String? officePhone,
    String? email,
    String? website,
  }) {
    return Company(
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      companyState: companyState ?? this.companyState,
      zipCode: zipCode ?? this.zipCode,
      cellPhone: cellPhone ?? this.cellPhone,
      officePhone: officePhone ?? this.officePhone,
      email: email ?? this.email,
      website: website ?? this.website,
    );
  }
}

class CompanyNotifier extends Notifier<Company> {
  final firestoreService = FirestoreService();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  CompanyNotifier(); // un-named constructor

  @override
  Company build() {
    return Company(
      companyId: '',
      companyName: '',
      address1: '',
      address2: '',
      city: '',
      companyState: '',
      zipCode: '',
      cellPhone: '',
      officePhone: '',
      email: '',
      website: '',
    );
  }

  String? companyId;
  String? companyName;
  String? address1;
  String? address2;
  String? city;
  String? companyState;
  String? zipCode;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;

  // Update functions
  void updateCompanyId(String newcompanyId) {
    state = state.copyWith(companyId: newcompanyId);
  }

  void updateCompanyName(String newcompanyName) {
    state = state.copyWith(companyName: newcompanyName);
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
    state = state.copyWith(companyState: newstate);
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

  CompanyNotifier.fromFirestore(Map<String, dynamic> firestore)
      : companyId = firestore['companyId'],
        companyName = firestore['name'],
        address1 = firestore['address1'],
        address2 = firestore['address2'],
        city = firestore['city'],
        companyState = firestore['state'],
        zipCode = firestore['zipCode'],
        cellPhone = firestore['cellPhone'],
        officePhone = firestore['officePhone'],
        email = firestore['email'],
        website = firestore['website'];

  Map<String, dynamic> toMap(Company company) {
    return {
      'companyId': company.companyId,
      'name': company.companyName,
      'address1': company.address1,
      'address2': company.address2,
      'city': company.city,
      'state': company.companyState,
      'zipCode': company.zipCode,
      'cellPhone': company.cellPhone,
      'officePhone': company.officePhone,
      'email': company.email,
      'website': company.website
    };
  }

  // loadValues(Agency agency) {
  //   //_agentId = agents.agentId;
  //   _name = agency.name;
  //   _address1 = agency.address1;
  //   _address2 = agency.address2;
  //   _city = agency.city;
  //   _state = agency.state;
  //   _zipCode = agency.zipcode;
  //   _cellPhone = agency.cellPhone;
  //   _officePhone = agency.officePhone;
  //   _email = agency.email;
  //   _website = agency.website;
  // }

  saveCompany(WidgetRef ref) {
    //globals.agencyId = name;
    //ref.read(globalsNotifierProvider.notifier).updatecompanyId(name);
    //final CompanyVals = ref.watch(companyNotifierProvider);

    var newCompany = Company(
        companyId: ref.read(companyNotifierProvider).companyId,
        companyName: ref.read(companyNotifierProvider).companyName,
        address1: ref.read(companyNotifierProvider).address1,
        address2: ref.read(companyNotifierProvider).address2,
        city: ref.read(companyNotifierProvider).city,
        companyState: ref.read(globalsNotifierProvider).currentCompanyState,
        zipCode: ref.read(companyNotifierProvider).zipCode,
        cellPhone: ref.read(companyNotifierProvider).cellPhone,
        officePhone: ref.read(companyNotifierProvider).officePhone,
        email: ref.read(companyNotifierProvider).email,
        website: ref.read(companyNotifierProvider).website);

    // If the agency is a new agency retrieve the agency
    // document ID and save it to a new agent document
    if (ref.read(globalsNotifierProvider).newCompany == true) {
      // String id = _db.collection('company').doc().id;
      // ref.read(globalsNotifierProvider.notifier).updatecompanyId(id);
      // ref.read(globalsNotifierProvider.notifier).updatecurrentCompanyState(
      //     ref.read(globalsNotifierProvider).selectedState!);

      firestoreService.saveNewCompany(toMap(newCompany));

      //ref.read(globalsNotifierProvider.notifier).updatecompanyId(id);
      ref.read(globalsNotifierProvider.notifier).updatenewCompany(false);
    } else {
      firestoreService.saveCompany(toMap(newCompany), companyId!);
    }
  }
}

final companyNotifierProvider = NotifierProvider<CompanyNotifier, Company>(() {
  return CompanyNotifier();
});
