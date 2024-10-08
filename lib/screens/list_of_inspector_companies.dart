//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                        *
//*********************************************

//import 'dart:async';

// ignore_for_file: non_constant_identifier_names

// import 'package:deal_diligence/Providers/title_company_provider.dart';
// import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:get/get.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
//import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:deal_diligence/screens/inspector_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final FirestoreService firestoreService = FirestoreService();

class ListOfInspectorCompaniesScreen extends ConsumerStatefulWidget {
  //static const String id = 'user_dashboard_screen';

  const ListOfInspectorCompaniesScreen({super.key});

  @override
  ConsumerState<ListOfInspectorCompaniesScreen> createState() =>
      _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState
    extends ConsumerState<ListOfInspectorCompaniesScreen> {
  bool showSpinner = false;
  bool isLoaded = false;

  // setGlobals(String? Id) {
  //   ref.read(globalsNotifierProvider.notifier).updatenewTrxn(false);
  //   ref.read(globalsNotifierProvider.notifier).updatecurrentTrxnId(Id);
  //   ref
  //       .read(globalsNotifierProvider.notifier)
  //       .updatemlsId(ref.read(usersNotifierProvider).mlsId!);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //appBar: CustomAppBar(),
        body: SafeArea(
          child: FutureBuilder<QuerySnapshot?>(
              future: FirebaseFirestore.instance
                  .collection('inspectorCompany')
                  .get(),

              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data?.size,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.sp),
                            child: ListTile(
                              isThreeLine: true,
                              title: Row(
                                children: [
                                  Text(
                                    '${snapshot.data?.docs[index]['inspectorCompanyName'] ?? 'n/a'}',
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
                                      '${snapshot.data?.docs[index]['inspectorCompanyState'] ?? 'n/a'}',
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
                                String? inspectorCompanyId =
                                    snapshot.data?.docs[index].id;

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        InspectorCompanyScreen(
                                            false, inspectorCompanyId),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            setState(() {
              showSpinner = true;
            });
            try {
              // ref.read(trxnNotifierProvider.notifier).saveTrxn(
              //     ref.read(trxnNotifierProvider),
              //     ref.read(globalsNotifierProvider).companyId!,
              //     widget.newTrxn!);
              // ref.read(globalsNotifierProvider.notifier).updatetargetScreen(0);
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InspectorCompanyScreen(true),
                ),
              );
              setState(() {
                showSpinner = false;
              });
            } catch (e) {
              // todo: add better error handling
              //debugPrint(e);
            }
          },
          backgroundColor: constants.kPrimaryColor,
          child: const Icon(
            Icons.assignment_turned_in_outlined,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
