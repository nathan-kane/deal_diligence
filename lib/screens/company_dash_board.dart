//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                        *
//*********************************************

//import 'dart:async';

// ignore_for_file: non_constant_identifier_names

import 'package:deal_diligence/Providers/user_provider.dart';
//import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:deal_diligence/screens/transaction_detail_screen.dart';
//import 'package:tonnah/screens/trxn_home.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:get/get.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
//import 'package:deal_diligence/Providers/trxn_provider.dart';

final FirestoreService firestoreService = FirestoreService();

class CompanyDashboardScreen extends ConsumerStatefulWidget {
  static const String id = 'user_dashboard_screen';

  const CompanyDashboardScreen({super.key});

  @override
  ConsumerState<CompanyDashboardScreen> createState() =>
      _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState
    extends ConsumerState<CompanyDashboardScreen> {
  bool showSpinner = false;

  //late List<Map<String, dynamic>> itemsTrxn;
  bool isLoaded = false;

  setGlobals(String? Id) {
    ref.read(globalsNotifierProvider.notifier).updatenewTrxn(false);
    ref.read(globalsNotifierProvider.notifier).updatecurrentTrxnId(Id);
    ref
        .read(globalsNotifierProvider.notifier)
        .updatemlsId(ref.read(usersNotifierProvider).mlsId!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //appBar: CustomAppBar(),
        body: SafeArea(
          child: FutureBuilder<QuerySnapshot?>(
              future: FirebaseFirestore.instance
                  .collection('company')
                  .doc(ref.read(globalsNotifierProvider).companyId)
                  .collection('trxns')
                  .get(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data?.size,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              isThreeLine: true,
                              title: Row(
                                children: [
                                  Text(
                                    'Client: ${snapshot.data?.docs[index]['clientFName'] ?? 'n/a'} ${snapshot.data?.docs[index]['clientLName'] ?? 'n/a'}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                              subtitle: Text.rich(
                                TextSpan(
                                  text:
                                      '${snapshot.data?.docs[index]['propertyAddress'] ?? 'n/a'}, '
                                      '${snapshot.data?.docs[index]['propertyCity'] ?? 'n/a'}, '
                                      '${snapshot.data?.docs[index]['propertyState'] ?? 'n/a'}',
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          '\nPrice: ${snapshot.data?.docs[index]['contractPrice'] ?? 'n/a'}\nStatus: ${snapshot.data?.docs[index]['trxnStatus'] ?? 'n/a'}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.blueGrey),
                                    )
                                  ],
                                ),
                              ),
                              trailing: Text(
                                  'MLS#: ${snapshot.data?.docs[index]['mlsNumber'] ?? 'n/a'}\n${snapshot.data?.docs[index]['clientType']}'),
                              onTap: () {
                                //MainScreen.of(context)?.setIndex(2);  // Added this for BottomNavigationBar sync
                                setGlobals(snapshot.data?.docs[index].id);
                                // ref
                                //     .read(globalsNotifierProvider.notifier)
                                //     .updatecurrentTrxnId(
                                //         snapshot.data?.docs[index].id);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TransactionDetailScreen(false),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
                    : const Text('No Date');
              }),
        ),
      ),
    );
  }
}
