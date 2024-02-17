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

class Client {
  String? clientId;
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
  String? agentCompanyId;

  Client(
      {this.clientId,
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
      this.agentCompanyId});

  Client copyWith(
      {String? clientId,
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
      String? agentCompanyId}) {
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
      agentCompanyId: agentCompanyId ?? this.agentCompanyId,
    );
  }
}

class ClientNotifier extends Notifier<Client> {
  final firestoreService = FirestoreService();
  //final companyRef = FirebaseFirestore.instance.collection(('Company'));
  final clientDB = FirebaseFirestore.instance.collection(('client'));
  ClientNotifier(); // un-named constructor

// **************************************************

  String clientId = '';
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
  String agentCompanyId = '';

  @override
  Client build() {
    return Client(
      // Return the initial state
      clientId: '',
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
      agentCompanyId: '',
    );
  }

  // functions to update class members
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

  void updateAgentCompanyId(String newAgentCompanyId) {
    state = state.copyWith(agentCompanyId: newAgentCompanyId);
  }

  Map<String, dynamic> toMap(Client client) {
    return {
      'cellPhone': client.cellPhone,
      'address1': client.address1,
      'address2': client.address2,
      'clientId': client.clientId,
      'city': client.city,
      'fName': client.fName,
      'lName': client.lName,
      'homePhone': client.homePhone,
      'clientState': client.clientState,
      'zipCode': client.zipCode,
      'email': client.email,
      'agentCompanyId': client.agentCompanyId,
    };
  }

  ClientNotifier.fromFirestore(Map<String, dynamic> firestore)
      : cellPhone = firestore['cellPhone'],
        address1 = firestore['address1'],
        address2 = firestore['address2'],
        clientId = firestore['clientId'],
        city = firestore['city'],
        fName = firestore['fName'],
        lName = firestore['lName'],
        homePhone = firestore['homePhone'],
        clientState = firestore['clientState'],
        zipCode = firestore['zipCode'],
        email = firestore['email'],
        agentCompanyId = firestore['agentCompanyId'];

// **************************************************

  // saveFcmToken(String userId, String userName) {
  //   //firestoreService.saveUserFcmTokenId(userId, fcmTokenId);
  //   firestoreService.saveDeviceToken(userId, userName);
  // }

  saveClient(globals, client) async {
    if (ref.watch(globalsNotifierProvider).newUser == true) {
      // final DocumentSnapshot currentCompanyProfile =
      final newClient = Client(
        clientId: client.clientId,
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
        agentCompanyId: client.agentCompanyId,
      );
      firestoreService.saveNewClient(toMap(newClient));
      ref.read(globalsNotifierProvider.notifier).updatenewClient(false);
    } else {
      final DocumentSnapshot currentClientProfile =
          await clientDB.doc(client.ClientId).get();

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
          clientState: (clientState != null && clientState != "")
              ? clientState
              : currentClientProfile.get('clientState'),
          /*state: (globals.selectedState != null)
              ? globals.selectedState
              : globals.currentuserState,*/
          zipCode: (state.zipCode != null && state.zipCode != "")
              ? state.zipCode
              : currentClientProfile.get('zipCode'),
          cellPhone: (state.cellPhone != null && state.cellPhone != "")
              ? state.cellPhone
              : currentClientProfile.get('cellPhone'),
          agentCompanyId:
              (state.agentCompanyId != null && state.agentCompanyId != "")
                  ? state.agentCompanyId
                  : currentClientProfile.get('agentCompanyId'),
          homePhone: (state.homePhone != null && state.homePhone != "")
              ? state.homePhone
              : currentClientProfile.get('homePhone'));

      firestoreService.saveClient(newClient, clientId);
    }
  }

  deleteClient(String? clientId) {
    firestoreService.deleteUser(clientId);
  }
}

final clientNotifierProvider = NotifierProvider<ClientNotifier, Client>(() {
  return ClientNotifier();
});
