//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                        *
//*********************************************

//import 'dart:async';

// ignore_for_file: non_constant_identifier_names

import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:deal_diligence/screens/transaction_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
  bool isLoaded = false;
  final moneyFormat = NumberFormat("#,##0.00", "en_US");

  setGlobals(String? Id) {
    ref.read(globalsNotifierProvider.notifier).updatenewTrxn(false);
    ref.read(globalsNotifierProvider.notifier).updatecurrentTrxnId(Id);
    ref
        .read(globalsNotifierProvider.notifier)
        .updatemlsId(ref.read(usersNotifierProvider).mlsId!);
  }

  Future<String?> GetClientName(String clientId) async {
    final DocumentSnapshot clientData = await FirebaseFirestore.instance
        .collection('client')
        .doc(clientId)
        .get();

    String clientName =
        '${clientData["fName"]} ${clientData["lName"]}'; // Removed quotes
    return clientName;
  }

  final NumberFormat currencyFormatter = NumberFormat.currency(symbol: '\$');

  String _formatCurrency(String textCurrency) {
    //String textContractPrice = contractPriceController.text;

    /// Format the contract price
    String numericCurrency = textCurrency.replaceAll(RegExp(r'[^\d]'), '');
    if (numericCurrency.isNotEmpty) {
      double value = double.parse(numericCurrency) / 100;
      String formattedText = currencyFormatter.format(value);
      if (formattedText != null) {
        return formattedText;
      } else {
        return "\$0.00";
      }
    } else {
      return "\$0.00";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: FutureBuilder<QuerySnapshot?>(
            future: FirebaseFirestore.instance
                .collection('company')
                .doc(ref.read(usersNotifierProvider).companyId)
                .collection('trxns')
                .where("trxnStatus", isNotEqualTo: "Archived")
                .get(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data?.size,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(10.sp),
                          child: FutureBuilder<String?>(
                            future: GetClientName(
                                snapshot.data?.docs[index]['clientId']),
                            builder: (context, clientSnapshot) {
                              if (clientSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (clientSnapshot.hasData) {
                                return ListTile(
                                  isThreeLine: true,
                                  title: Row(
                                    children: [
                                      Text(
                                        // Replace 'INSERT CLIENT NAME HERE' with retrieved client name
                                        clientSnapshot.data!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 4, 93, 248)),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text.rich(
                                    TextSpan(
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      text:
                                          '${snapshot.data?.docs[index]['propertyAddress'] ?? 'n/a'}, '
                                          '${snapshot.data?.docs[index]['propertyCity'] ?? 'n/a'}, '
                                          '${snapshot.data?.docs[index]['propertyState'] ?? 'n/a'}',
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              '\nPrice: ${_formatCurrency(snapshot.data?.docs[index]['contractPrice']) ?? 'n/a'}\nStatus: ${snapshot.data?.docs[index]['trxnStatus'] ?? 'n/a'}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                  trailing: Text(
                                    'MLS#: ${snapshot.data?.docs[index]['mlsNumber'] ?? 'n/a'}\n${snapshot.data?.docs[index]['clientType']}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                                  ),
                                  onTap: () {
                                    setGlobals(snapshot.data?.docs[index].id);

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TransactionDetailScreen(
                                                false, false),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const Text(
                                  'No Client Available',
                                  //style: TextStyle(fontSize: 7.sp),
                                );
                              }
                            },
                          ),
                        );
                      },
                    )
                  : const Text(
                      'No Transaction Data',
                      //style: TextStyle(fontSize: 7.sp),
                    );
            },
          ),
        ),
      ),
    );
  }
}
