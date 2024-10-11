//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

// import "package:firebase_messaging/firebase_messaging.dart";

//import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/event_provider.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  //final _auth = FirebaseAuth.instance;

  /// Create a new user record using the userID obtained from the Google 
  /// registration process
  saveNewUser(users, String currentUid) async {
    try {
      _db.collection('users').doc(currentUid).set(users);
      // DocumentReference docRef = await _db.collection('users').add(users);
      // return docRef;
    } catch (e) {
      return null;
    }
     
  }

  Future<void> saveUser(users, String currentUid) {
    return _db.collection('users').doc(currentUid).set(users);
  }

  Future<DocumentReference?> saveNewClient(client) async {
    try {
      DocumentReference docRef = await _db.collection('client').add(client);
      /// Return the new DocumentReference for the new client
      return docRef;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveClient(client, String currentClientId) async {
    try {
      //Map<String, dynamic> clientMap = client.toMap(client);
      await _db.collection('client').doc(currentClientId).set(client);
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(null);
    }
  }

  Future<void> saveNewInspectorCompany(inspectorCompany) {
    return _db.collection('inspectorCompany').add(inspectorCompany);
  }

  Future<void> saveInspectorCompany(
      inspectorCompany, String inspectorCompanyId) {
    return _db
        .collection('inspectorCompany')
        .doc(inspectorCompanyId)
        .set(inspectorCompany);
  }

  Future<void> saveNewAppraiserCompany(appraiserCompany) {
    return _db.collection('appraiserCompany').add(appraiserCompany);
  }

  Future<void> saveAppraiserCompany(
      appraiserCompany, String appraiserCompanyId) {
    return _db
        .collection('appraiserCompany')
        .doc(appraiserCompanyId)
        .set(appraiserCompany);
  }

  Future<void> saveNewMortgageCompany(mortgageCompany) {
    return _db.collection('mortgageCompany').add(mortgageCompany);
  }

  Future<void> saveMortgageCompany(mortgageCompany, String mortgageCompanyId) {
    return _db
        .collection('mortgageCompany')
        .doc(mortgageCompanyId)
        .set(mortgageCompany);
  }

  Future<void> saveNewTitleCompany(titleCompany) {
    return _db.collection('titleCompany').add(titleCompany);
  }

  Future<void> saveTitleCompany(titleCompany, String titleCompanyId) {
    return _db.collection('titleCompany').doc(titleCompanyId).set(titleCompany);
  }

  // Save the Users or users to database
  // Future<void> saveCompany(Company Company, Ref ref) {
  //   return _db.collection('Company').doc(ref.read(globalsNotifierProvider).companyId).set(CompanyNotifier.toMap());
  // }

  Future<void> saveCompany(company, String companyId) async {
    await _db.collection('company').doc(companyId).set(company);
  }

  Future<DocumentReference?> saveNewCompany(company) async {
    try {
      DocumentReference docRef = await _db.collection('company').add(company);
      return docRef;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUserFcmTokenId(String userId, String fcmTokenId) async {
    await _db.collection('users').doc(userId).update({"token": fcmTokenId});
  }

  // Save transaction data to database
  Future<void> saveTrxn(trxns, String companyId, String trxnId) {
    return _db
        .collection('company')
        .doc(companyId)
        .collection('trxns') 
        .doc(trxnId)
        .set(trxns);
  }

  Future<void> saveNewTrxn(trxns, String companyId) {
    return _db
        .collection('company')
        .doc(companyId)
        .collection('trxns')
        .add(trxns);
  }

  // Save an event
  Future<void> saveEvent(Events event, Ref ref, [String? eventId]) {
    if (eventId != null) {
      return _db
          .collection('users')
          .doc(ref.read(globalsNotifierProvider).currentUserId)
          .collection('events')
          .doc(eventId)
          .set(event.toMap());
    } else {
      return _db
          .collection('users')
          .doc(ref.read(globalsNotifierProvider).currentUserId)
          .collection('events')
          .add(event.toMap());
    }
    //return _db.collection('Company').doc(globals.CompanyId).collection('event').doc().set(event.toMap());
  }

// Link a new User to an existing Company
  Future<void> linkUserToExistingCompany(String? companyId, String currentUid) {
    return _db
        .collection('Users')
        .doc(currentUid)
        .set({'CompanyId': companyId});
  }

  // Stream<List<Users>> getUsers() {
  //   return _db.collection('Users').snapshots().map((snapshot) => snapshot.docs
  //       .map((document) => UsersNotifier.fromFirestore(document.data()))
  //       .toList());
  // }

  // Stream<List<Company>> getCompany() {
  //   return _db.collection('Company').snapshots().map((snapshot) => snapshot.docs
  //       .map((document) => CompanyNotifier.fromFirestore(document.data()))
  //       .toList());
  // }

  // Stream<List<Trxn>> getTrxns(Ref ref) {
  //   return _db.collection('Company').doc(ref.read(globalsNotifierProvider).companyId)
  //       .collection('trxns').snapshots().map((snapshot) => snapshot.docs
  //       .map((document) => TrxnNotifier.fromFirestore(document.data()))
  //       .toList());
  // }

  // Stream<List<Device>> getDeviceToken(Ref ref) {
  //   return _db
  //       .collection('users')
  //       .doc(ref.read(globalsNotifierProvider).currentUserId)
  //       .collection('device')
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //           .map((document) => Device.fromFirestore(document.data()))
  //           .toList());
  // }

  Stream<QuerySnapshot> getCompanyTrxns(String companyId) async* {
    yield* FirebaseFirestore.instance
        .collection('Company')
        .doc(companyId)
        .collection('trxns')
        .where('trxnStatus', isNotEqualTo: 'Closed')
        .snapshots();
  }

  // Stream<List<Trxn>> getSingleCompanyTrxns(String? trxnId, Ref ref) {
  //   return _db.collection('Company').doc(ref.read(globalsNotifierProvider).companyId)
  //       .collection('trxns').where('trxnId', isEqualTo: trxnId)
  //       .snapshots().map((snapshot) => snapshot.docs
  //       .map((document) => TrxnNotifier.fromFirestore(document.data())).toList());
  // }

  // Stream<List<Events>> getEventStream(DateTime dateTime, Ref ref) {
  //   return _db.collection('Users').doc(ref.read(globalsNotifierProvider).currentUserId)
  //       .collection('event')
  //       .where('eventDate', isGreaterThanOrEqualTo: dateTime).snapshots().map((snapshot) => snapshot.docs
  //       .map((document) => EventsNotifier.fromFirestore(document.data()))
  //       .toList());
  // }

  Future<void> deleteUser(String? userId) {
    return _db.collection('Users').doc(userId).delete();
  }

  Future<void> deleteInspectorCompany(String? inspectorCompanyId) {
    return _db.collection('InspectorCompany').doc(inspectorCompanyId).delete();
  }

  Future<void> deleteAppraiserCompany(String? appraiserCompanyId) {
    return _db.collection('AppraiserCompany').doc(appraiserCompanyId).delete();
  }

  Future<void> deleteTrxn(String trxnId, String companyId) async {
    await _db
        .collection('Company')
        .doc(companyId)
        .collection('trxns')
        .doc(trxnId)
        .delete();
  }

  Future<void> deleteEvent(String? eventId, Ref ref) {
    return _db
        .collection('Users')
        .doc(ref.read(globalsNotifierProvider).currentUserId)
        .collection('event')
        .doc(eventId)
        .delete();
  }

  /// Get the token, save it to the database for current user
  //Future<void> saveDeviceToken(String uId, String userName) async {
    // Get the current user
    //String? uid = ref.read(globalsNotifierProvider).currentUid;
    //User user = await _auth.currentUser();

    // Get the token for this device
    // TODO(any): Push notifications do not currently work on Safari iOS (see: https://caniuse.com/push-api). Implement this feature some other way.
    // String? fcmToken = await _firebaseMessaging.getToken();

    // Save it to Firestore
    //var tokens = _db.collection('users').doc(uId);

    // await tokens.update({
    //   // 'token': fcmToken,
    //   'userId': uId,
    //   'UserName': userName,
    //   'createdAt': FieldValue.serverTimestamp(), // optional
    //   'platform': Platform.operatingSystem // optional
    // });
  //}
}
