//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                        *
//*********************************************

//import 'dart:async';

// ignore_for_file: non_constant_identifier_names

import 'package:deal_diligence/Providers/title_company_provider.dart';
import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:deal_diligence/screens/title_company_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:get/get.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/global_provider.dart';

final FirestoreService firestoreService = FirestoreService();

class ListOfTitleCompaniesScreen extends ConsumerStatefulWidget {
  //static const String id = 'user_dashboard_screen';

  const ListOfTitleCompaniesScreen({super.key});

  @override
  ConsumerState<ListOfTitleCompaniesScreen> createState() =>
      _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState
    extends ConsumerState<ListOfTitleCompaniesScreen> {
  bool showSpinner = false;
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
              future:
                  FirebaseFirestore.instance.collection('titleCompany').get(),
              // .doc(ref.read(globalsNotifierProvider).companyId)
              // .collection('trxns')
              // .where("trxnStatus", isNotEqualTo: "Archived")
              // .get(),
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
                                    '${snapshot.data?.docs[index]['titleCompanyName'] ?? 'n/a'}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                              subtitle: Text.rich(
                                TextSpan(
                                  text:
                                      //'${snapshot.data?.docs[index]['propertyAddress'] ?? 'n/a'}, '
                                      '${snapshot.data?.docs[index]['city'] ?? 'n/a'}, '
                                      '${snapshot.data?.docs[index]['titleCompanyState'] ?? 'n/a'}',
                                  // children: <TextSpan>[
                                  //   TextSpan(
                                  //     text:
                                  //         '\nPrice: ${snapshot.data?.docs[index]['contractPrice'] ?? 'n/a'}\nStatus: ${snapshot.data?.docs[index]['trxnStatus'] ?? 'n/a'}',
                                  //     style: const TextStyle(
                                  //         fontWeight: FontWeight.w900,
                                  //         color: Colors.blueGrey),
                                  //   )
                                  // ],
                                ),
                              ),
                              trailing: Text(
                                  'Primary Contact: ${snapshot.data?.docs[index]['primaryContact'] ?? 'n/a'}'),
                              onTap: () {
                                //MainScreen.of(context)?.setIndex(2);  // Added this for BottomNavigationBar sync
                                String? titleCompanyId =
                                    snapshot.data?.docs[index].id;
                                //setGlobals(snapshot.data?.docs[index].id);
                                // ref
                                //     .read(globalsNotifierProvider.notifier)
                                //     .updatecurrentTrxnId(
                                //         snapshot.data?.docs[index].id);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TitleCompanyScreen(
                                        false, titleCompanyId),
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
