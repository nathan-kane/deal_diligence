//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

//import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_messaging/firebase_messaging.dart";
//import 'package:firebase_auth/firebase_auth.dart';
// import 'package:deal_diligence/Models/users_model.dart';
// import 'package:deal_diligence/Models/Company.dart';
//import 'package:deal_diligence/Models/Trxns.dart' as TrxnModel;
import 'dart:io';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/event_provider.dart';
import 'package:deal_diligence/Providers/device_tokens.dart';
// import 'package:deal_diligence/Providers/user_provider.dart';
//import 'package:deal_diligence/Providers/trxn_provider.dart';
// import 'package:deal_diligence/Providers/event_provider.dart';
//import 'package:deal_diligence/Providers/company_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  //final _auth = FirebaseAuth.instance;

  //Save the Users or users to database
  Future<void> saveNewUser(users) {
    return _db.collection('users').add(users);
  }

  Future<void> saveUser(users, String currentUid) {
    return _db.collection('users').doc(currentUid).set(users);
  }

  // Save the Users or users to database
  // Future<void> saveCompany(Company Company, Ref ref) {
  //   return _db.collection('Company').doc(ref.read(globalsNotifierProvider).companyId).set(CompanyNotifier.toMap());
  // }

  Future<void> saveNewCompany(company, String companyId) async {
    await _db.collection('company').doc(companyId).set(company);
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
  Future<void> linkUserToExistingCompany(String? CompanyId, String currentUid) {
    return _db
        .collection('Users')
        .doc(currentUid)
        .set({'CompanyId': CompanyId});
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

  Stream<List<Device>> getDeviceToken(Ref ref) {
    return _db
        .collection('Users')
        .doc(ref.read(globalsNotifierProvider).currentUserId)
        .collection('device')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => Device.fromFirestore(document.data()))
            .toList());
  }

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

  Future<void> deleteUser(String? UserId) {
    return _db.collection('Users').doc(UserId).delete();
  }

  Future<void> deleteTrxn(String trxnId, Ref ref) {
    return _db
        .collection('Company')
        .doc(ref.read(globalsNotifierProvider).companyId)
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
  Future<void> saveDeviceToken(WidgetRef ref) async {
    // Get the current user
    String? uid = ref.read(globalsNotifierProvider).currentUid;
    //User user = await _auth.currentUser();

    // Get the token for this device
    String? fcmToken = await _firebaseMessaging.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .doc(ref.read(globalsNotifierProvider).currentUserId)
          .collection('device')
          .doc(uid);

      await tokens.set({
        'token': fcmToken,
        'userId': uid,
        'UserName': ref.read(globalsNotifierProvider).currentUserName,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }
}
