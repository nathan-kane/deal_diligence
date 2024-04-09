//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

// ignore_for_file: unused_label, unnecessary_null_comparison, unused_local_variable, unused_import

import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/trxn_provider.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deal_diligence/Providers/company_provider.dart';

class Client {
  //String? clientId;
  String? fName;
  String? lName;
  String? address1;
  String? address2;
  String? city;
  String? clientState;
  String? zipCode;
  String? cellPhone;
  String? homePhone;
  String? email;
  String? userCompanyId;
  String? userId;
  String? clientId; // This is needed when a new client is added from a new Trxn

  Client(
      { //this.clientId,
      this.fName,
      this.lName,
      this.address1,
      this.address2,
      this.city,
      this.clientState,
      this.zipCode,
      this.cellPhone,
      this.homePhone,
      this.email,
      this.userCompanyId,
      this.userId,
      this.clientId});

  Client copyWith(
      { //String? clientId,
      String? fName,
      String? lName,
      String? address1,
      String? address2,
      String? city,
      String? clientState,
      String? zipCode,
      String? cellPhone,
      String? homePhone,
      String? email,
      String? userCompanyId,
      String? userId,
      String? clientId}) {
    return Client(
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      clientState: clientState ?? this.clientState,
      zipCode: zipCode ?? this.zipCode,
      cellPhone: cellPhone ?? this.cellPhone,
      homePhone: homePhone ?? this.homePhone,
      email: email ?? this.email,
      userCompanyId: userCompanyId ?? this.userCompanyId,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
    );
  }
}

class ClientNotifier extends Notifier<Client> {
  final firestoreService = FirestoreService();
  //final companyRef = FirebaseFirestore.instance.collection(('Company'));
  final clientDB = FirebaseFirestore.instance.collection(('client'));
  ClientNotifier(); // un-named constructor

// **************************************************

  //String clientId = '';
  String fName = '';
  String lName = '';
  String address1 = '';
  String address2 = '';
  String city = '';
  String clientState = '';
  String zipCode = '';
  String cellPhone = '';
  String homePhone = '';
  String email = '';
  String userCompanyId = '';
  String userId = '';
  String clientId = '';

  @override
  Client build() {
    return Client(
      // Return the initial state
      fName: '',
      lName: '',
      address1: '',
      address2: '',
      city: '',
      clientState: '',
      zipCode: '',
      cellPhone: '',
      homePhone: '',
      email: '',
      userCompanyId: '',
      userId: '',
      clientId: '',
    );
  }

  // functions to update class members
  void updatefName(String newfName) {
    state = state.copyWith(fName: newfName);
  }

  void updatelName(String newlName) {
    state = state.copyWith(lName: newlName);
  }

  void updateAddress1(String newaddress1) {
    state = state.copyWith(address1: newaddress1);
  }

  void updateAddress2(String newaddress2) {
    state = state.copyWith(address2: newaddress2);
  }

  void updateCity(String newCity) {
    state = state.copyWith(city: newCity);
  }

  void updateClientState(String newClientState) {
    state = state.copyWith(clientState: newClientState);
  }

  void updateZipcode(String newZipcode) {
    state = state.copyWith(zipCode: newZipcode);
  }

  void updateCellPhone(String newCellPhone) {
    state = state.copyWith(cellPhone: newCellPhone);
  }

  void updateHomePhone(String newHomePhone) {
    state = state.copyWith(homePhone: newHomePhone);
  }

  void updateEmail(String newEmail) {
    state = state.copyWith(email: newEmail);
  }

  void updateUserCompanyId(String newUserCompanyId) {
    state = state.copyWith(userCompanyId: newUserCompanyId);
  }

  void updateUserId(String newUserId) {
    state = state.copyWith(userId: newUserId);
  }

  void updateClientId(String newClientId) {
    state = state.copyWith(clientId: newClientId);
  }

  Map<String, dynamic> toMap(Client client) {
    return {
      'cellPhone': client.cellPhone,
      'address1': client.address1,
      'address2': client.address2,
      'city': client.city,
      'fName': client.fName,
      'lName': client.lName,
      'homePhone': client.homePhone,
      'clientState': client.clientState,
      'zipCode': client.zipCode,
      'email': client.email,
      'agentCompanyId': client.userCompanyId,
      'userId': client.userId,
      'clientId': client.clientId,
    };
  }

  ClientNotifier.fromFirestore(Map<String, dynamic> firestore)
      : cellPhone = firestore['cellPhone'],
        address1 = firestore['address1'],
        address2 = firestore['address2'],
        city = firestore['city'],
        fName = firestore['fName'],
        lName = firestore['lName'],
        homePhone = firestore['homePhone'],
        clientState = firestore['clientState'],
        zipCode = firestore['zipCode'],
        email = firestore['email'],
        clientId = firestore['clientId'];
  // userCompanyId = firestore['userCompanyId'];
  // userId = firestore['userId'];

// **************************************************

  Future<DocumentReference?> saveClient(client, isNewClient, [clientId]) async {
    if (isNewClient == true) {
      // final DocumentSnapshot currentCompanyProfile =
      final newClient = Client(
        //clientId: client.clientId,
        fName: client.fName,
        lName: client.lName,
        address1: client.address1,
        address2: client.address2,
        city: client.city,
        clientState: client.clientState,
        zipCode: client.zipCode,
        cellPhone: client.cellPhone,
        homePhone: client.homePhone,
        email: client.email,
        userCompanyId: ref.read(globalsNotifierProvider).companyId,
        userId: ref.read(globalsNotifierProvider).currentUserId,
        clientId: client.clientId,
      );

      try {
        DocumentReference? newDocRef =
            await firestoreService.saveNewClient(toMap(newClient));
        return newDocRef;
        //ref.read(trxnNotifierProvider.notifier).updateClientId(newDocRef!.id);
      } catch (e) {
        print(e);
        return null;
      }

      //ref.read(globalsNotifierProvider.notifier).updatenewClient(false);
    } else {
      final DocumentSnapshot currentClientProfile =
          await clientDB.doc(client.clientId).get();

      var newClient = Client(
          fName: (state.fName != null && state.fName != "")
              ? state.fName
              : currentClientProfile.get('fName'),
          lName: (state.lName != null && state.lName != "")
              ? state.lName
              : currentClientProfile.get('lName'),
          address1: (state.address1 != null && state.address1 != "")
              ? state.address1
              : currentClientProfile.get('address1'),
          address2: (state.address2 != null && state.address2 != "")
              ? state.address2
              : currentClientProfile.get('address2'),
          city: (state.city != null && state.city != "")
              ? state.city
              : currentClientProfile.get('city'),
          clientState: (state.clientState != null && state.clientState != "")
              ? state.clientState
              : currentClientProfile.get('clientState'),
          zipCode: (state.zipCode != null && state.zipCode != "")
              ? state.zipCode
              : currentClientProfile.get('zipCode'),
          cellPhone: (state.cellPhone != null && state.cellPhone != "")
              ? state.cellPhone
              : currentClientProfile.get('cellPhone'),
          // userCompanyId:
          //     (state.userCompanyId != null && state.userCompanyId != "")
          //         ? state.userCompanyId
          //         : currentClientProfile.get('userCompanyId'),
          userId: (state.userId != null && state.userId != "")
              ? state.userId
              : currentClientProfile.get('userId'),
          clientId: (state.clientId != null && state.clientId != "")
              ? state.clientId
              : currentClientProfile.get('clientId'),
          homePhone: (state.homePhone != null && state.homePhone != "")
              ? state.homePhone
              : currentClientProfile.get('homePhone'));

      firestoreService.saveClient(toMap(newClient), state.clientId!);
    }
    return null;
  }

  deleteClient(String? clientId) {
    firestoreService.deleteUser(clientId);
  }
}

final clientNotifierProvider = NotifierProvider<ClientNotifier, Client>(() {
  return ClientNotifier();
});
