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

class Users {
  String? userId;
  String? fName;
  String? lName;
  String? address1;
  String? address2;
  String? city;
  String? userState;
  String? zipCode;
  String? cellPhone;
  String? officePhone;
  String? email;
  String? companyId;
  String? companyName;
  String? mlsId;
  String? mls;
  String? businessType;
  String? deviceToken;

  Users(
      {this.userId,
      this.fName,
      this.lName,
      this.address1,
      this.address2,
      this.city,
      this.userState,
      this.zipCode,
      this.cellPhone,
      this.officePhone,
      this.email,
      this.companyId,
      this.companyName,
      this.mlsId,
      this.mls,
      this.businessType,
      this.deviceToken});

  Users copyWith({
    String? userId,
    String? fName,
    String? lName,
    String? address1,
    String? address2,
    String? city,
    String? userState,
    String? zipCode,
    String? cellPhone,
    String? officePhone,
    String? email,
    String? companyId,
    String? companyName,
    String? mlsId,
    String? mls,
    String? businessType,
    String? deviceToken,
  }) {
    return Users(
      userId: userId ?? this.userId,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      userState: userState ?? this.userState,
      zipCode: zipCode ?? this.zipCode,
      cellPhone: cellPhone ?? this.cellPhone,
      officePhone: officePhone ?? this.officePhone,
      email: email ?? this.email,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      mlsId: mlsId ?? this.mlsId,
      mls: mls ?? this.mls,
      businessType: businessType ?? this.businessType,
      deviceToken: deviceToken ?? this.deviceToken,
    );
  }
}

class UsersNotifier extends Notifier<Users> {
  final firestoreService = FirestoreService();
  final companyRef = FirebaseFirestore.instance.collection(('Company'));
  final userDB = FirebaseFirestore.instance.collection(('users'));
  UsersNotifier(); // un-named constructor

// **************************************************

  String userId = '';
  String fName = '';
  String lName = '';
  String address1 = '';
  String address2 = '';
  String city = '';
  String userState = '';
  String zipCode = '';
  String cellPhone = '';
  String officePhone = '';
  String email = '';
  String companyId = '';
  String companyName = '';
  String mlsId = '';
  String mls = '';
  String businessType = '';
  String deviceToken = '';

  @override
  Users build() {
    return Users(
      // Return the initial state
      userId: '',
      fName: '',
      lName: '',
      address1: '',
      address2: '',
      city: '',
      userState: '',
      zipCode: '',
      cellPhone: '',
      officePhone: '',
      email: '',
      companyId: '',
      companyName: '',
      mlsId: '',
      mls: '',
      businessType: '',
      deviceToken: '',
    );
  }

  // functions to update class members
  void updateuserID(String newuserID) {
    state = state.copyWith(userId: newuserID);
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

  void updateState(String newUserState) {
    state = state.copyWith(userState: newUserState);
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

  void updateCompanyId(String newCompanyId) {
    state = state.copyWith(companyId: newCompanyId);
  }

  void updateCompanyName(String newCompanyName) {
    state = state.copyWith(companyName: newCompanyName);
  }

  void updateMls(String newMls) {
    state = state.copyWith(mls: newMls);
  }

  void updateMlsId(String newMlsId) {
    state = state.copyWith(mlsId: newMlsId);
  }

  void updateBusinessType(String newBusinessType) {
    state = state.copyWith(businessType: newBusinessType);
  }

  void updateDeviceToken(String newDeviceToken) {
    state = state.copyWith(deviceToken: newDeviceToken);
  }

  Map<String, dynamic> toMap(Users user) {
    return {
      'userId': user.userId,
      'cellPhone': user.cellPhone,
      'address1': user.address1,
      'address2': user.address2,
      'company': user.companyName,
      'companyId': user.companyId,
      'city': user.city,
      'fName': user.fName,
      'lName': user.lName,
      'officePhone': user.officePhone,
      'state': user.userState,
      'zipCode': user.zipCode,
      'mls': user.mls,
      'mlsId': user.mlsId,
      'email': user.email,
      'businessType': user.businessType,
      'deviceToken': user.deviceToken
    };
  }

  UsersNotifier.fromFirestore(Map<String, dynamic> firestore)
      : cellPhone = firestore['cellPhone'],
        address1 = firestore['address1'],
        address2 = firestore['address2'],
        companyName = firestore['company'],
        companyId = firestore['companyId'],
        userId = firestore['userId'],
        city = firestore['city'],
        fName = firestore['fName'],
        lName = firestore['lName'],
        officePhone = firestore['officePhone'],
        userState = firestore['state'],
        zipCode = firestore['zipCode'],
        mls = firestore['mls'],
        mlsId = firestore['mlsId'],
        email = firestore['email'],
        businessType = firestore['businessType'],
        deviceToken = firestore['deviceToken'];

// **************************************************

  saveFcmToken(String userId, String userName) {
    //firestoreService.saveUserFcmTokenId(userId, fcmTokenId);
    firestoreService.saveDeviceToken(userId, userName);
  }

  saveUser(globals, user, bool newUser) async {
    if (newUser == true) {
      // final DocumentSnapshot currentCompanyProfile =
      final newUser = Users(
        userId: user.userId,
        fName: user.fName,
        lName: user.lName,
        mls: user.mls,
        mlsId: user.mlsId,
        address1: user.address1,
        address2: user.address2,
        city: user.city,
        userState: user.userState,
        zipCode: user.zipCode,
        cellPhone: user.cellPhone,
        officePhone: user.officePhone,
        companyId: globals.companyId,
        companyName: user.companyName,
        email: user.email,
        businessType: user.businessType,
        deviceToken: user.deviceToken,
      );
      firestoreService.saveNewUser(
          toMap(newUser), ref.read(globalsNotifierProvider).currentUserId!);
    } else {
      /// This is an existing user
      final DocumentSnapshot currentuserProfile =
          await userDB.doc(user.userId).get();

      final newUser = Users(
          userId: ref.read(globalsNotifierProvider).currentUid,
          fName: (state.fName != null && state.fName != "")
              ? state.fName
              : currentuserProfile.get('fName'),
          lName: (state.lName != null && state.lName != "")
              ? state.lName
              : currentuserProfile.get('lName'),
          address1: (state.address1 != null && state.address1 != "")
              ? state.address1
              : currentuserProfile.get('address1'),
          address2: (state.address2 != null && state.address2 != "")
              ? state.address2
              : currentuserProfile.get('address2'),
          city: (state.city != null && state.city != "")
              ? state.city
              : currentuserProfile.get('city'),
          userState: (userState != null && userState != "")
              ? userState
              : currentuserProfile.get('state'),
          zipCode: (state.zipCode != null && state.zipCode != "")
              ? state.zipCode
              : currentuserProfile.get('zipCode'),
          cellPhone: (state.cellPhone != null && state.cellPhone != "")
              ? state.cellPhone
              : currentuserProfile.get('cellPhone'),
          officePhone: (state.officePhone != null && state.officePhone != "")
              ? state.officePhone
              : currentuserProfile.get('officePhone'),
          companyId: (state.companyId != null && state.companyId != "")
              ? state.companyId
              : currentuserProfile.get('companyId'),
          companyName: (state.companyName != null && state.companyName != "")
              ? state.companyName
              : currentuserProfile.get('company'),
          email: (state.email != null && state.email != "")
              ? state.email
              : currentuserProfile.get('email'),
          mlsId: ref.read(globalsNotifierProvider).mlsId,
          mls: (state.mls != null && state.mls != "")
              ? state.mls
              : currentuserProfile.get('mls'),
          deviceToken: (state.deviceToken != null && state.deviceToken != "")
              ? state.deviceToken
              : currentuserProfile.get('deviceToken'));
      businessType:
      ref.read(globalsNotifierProvider).userBusinessType;

      firestoreService.saveUser(
          toMap(newUser), ref.read(globalsNotifierProvider).currentUserId!);

      return null;
    }
  }

  deleteUser(String? userId) {
    firestoreService.deleteUser(userId);
  }
}

final usersNotifierProvider = NotifierProvider<UsersNotifier, Users>(() {
  return UsersNotifier();
});
