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
  String? titleCompanyId;
  String? titleCompanyName;
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
      {this.titleCompanyId,
      this.titleCompanyName,
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
    String? titleId,
    String? titleCompanyName,
    String? address1,
    String? address2,
    String? city,
    String? titleState,
    String? zipCode,
    String? cellPhone,
    String? officePhone,
    String? email,
    String? website,
  }) {
    return TitleCompany(
      titleCompanyId: titleCompanyId ?? this.titleCompanyId,
      titleCompanyName: titleCompanyName ?? this.titleCompanyName,
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
  FirebaseFirestore _db = FirebaseFirestore.instance;
  TitleCompanyNotifier(); // un-named constructor

  @override
  TitleCompany build() {
    return TitleCompany(
      titleCompanyId: '',
      titleCompanyName: '',
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

  String? titleId;
  String? titleCompanyName;
  String? address1;
  String? address2;
  String? city;
  String? titleState;
  String? zipCode;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? website;

  // Update functions
  void updateTitleId(String newtitleId) {
    state = state.copyWith(titleId: newtitleId);
  }

  void updateTitleCompanyName(String newtitleCompanyName) {
    state = state.copyWith(titleCompanyName: newtitleCompanyName);
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
    state = state.copyWith(titleState: newstate);
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
      : titleId = firestore['titleId'],
        titleCompanyName = firestore['name'],
        address1 = firestore['address1'],
        address2 = firestore['address2'],
        city = firestore['city'],
        titleState = firestore['state'],
        zipCode = firestore['zipCode'],
        cellPhone = firestore['cellPhone'],
        officePhone = firestore['officePhone'],
        email = firestore['email'],
        website = firestore['website'];

  Map<String, dynamic> toMap(TitleCompany title) {
    return {
      'titleId': title.titleCompanyId,
      'name': title.titleCompanyName,
      'address1': title.address1,
      'address2': title.address2,
      'city': title.city,
      'state': title.titleCompanyState,
      'zipCode': title.zipCode,
      'cellPhone': title.cellPhone,
      'officePhone': title.officePhone,
      'email': title.email,
      'website': title.website
    };
  }

  saveTitleCompany(WidgetRef ref) {
    //globals.agencyId = name;
    //ref.read(globalsNotifierProvider.notifier).updatetitleId(name);
    //final TitleVals = ref.watch(titleCompanyNotifierProvider);

    var newTitleCompany = TitleCompany(
        titleCompanyId: ref.read(titleCompanyNotifierProvider).titleCompanyId,
        titleCompanyName:
            ref.read(titleCompanyNotifierProvider).titleCompanyName,
        address1: ref.read(titleCompanyNotifierProvider).address1,
        address2: ref.read(titleCompanyNotifierProvider).address2,
        city: ref.read(titleCompanyNotifierProvider).city,
        titleCompanyState:
            ref.read(titleCompanyNotifierProvider).titleCompanyState,
        zipCode: ref.read(titleCompanyNotifierProvider).zipCode,
        cellPhone: ref.read(titleCompanyNotifierProvider).cellPhone,
        officePhone: ref.read(titleCompanyNotifierProvider).officePhone,
        email: ref.read(titleCompanyNotifierProvider).email,
        website: ref.read(titleCompanyNotifierProvider).website);

    // If the agency is a new agency retrieve the agency
    // document ID and save it to a new agent document
    if (ref.read(globalsNotifierProvider).isNewTitleCompany == true) {
      //String id = _db.collection('title').doc().id;
      //ref.read(globalsNotifierProvider.notifier).updateTitleId(id);
      // ref.read(globalsNotifierProvider.notifier).updatecurrentTitleState(
      //     ref.read(globalsNotifierProvider).selectedState!);

      firestoreService.saveNewTitleCompany(toMap(newTitleCompany));

      //ref.read(globalsNotifierProvider.notifier).updatetitleId(id);
      ref.read(globalsNotifierProvider.notifier).updateIsNewTitleCompany(false);
    } else {
      firestoreService.saveTitleCompany(toMap(newTitleCompany), titleId!);
    }
  }
}

final titleCompanyNotifierProvider =
    NotifierProvider<TitleCompanyNotifier, TitleCompany>(() {
  return TitleCompanyNotifier();
});
