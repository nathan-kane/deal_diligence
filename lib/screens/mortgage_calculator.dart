//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MortgageCalculatorScreen extends StatefulWidget {
  const MortgageCalculatorScreen({super.key});

  @override
  State<MortgageCalculatorScreen> createState() =>
      _MortgageCalculatorScreenState();
}

class _MortgageCalculatorScreenState extends State<MortgageCalculatorScreen> {
  double loanAmount = 100000;
  double interestRate = 5.0;
  int loanTerm = 30;
  double homeOwnersInsurance = 0.0;
  double taxesAndOtherFees = 0.0;
  double hOA = 0.0;
  double monthlyPayment = 0.0;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ensureScreenSize: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Mortgage Calculator'),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Loan Amount (\$)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        loanAmount = double.parse(value);
                      });
                    },
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Interest Rate (%)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        interestRate = double.parse(value);
                      });
                    },
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Loan Term (years)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        loanTerm = int.parse(value);
                      });
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        labelText: 'Homeowners Insurance'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        homeOwnersInsurance = double.parse(value);
                      });
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        labelText: 'Taxes and other fees'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        taxesAndOtherFees = double.parse(value);
                      });
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'HOA'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        hOA = double.parse(value);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: calculatePayment,
                    child: const Text('Calculate'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Monthly Payment: \$${monthlyPayment.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(14.r), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void calculatePayment() {
    double monthlyInterestRate = interestRate / 1200;
    int numberOfPayments = loanTerm * 12;

    //double denominator = (1 - (1 / (1 + monthlyInterestRate).pow(numberOfPayments)));
    double denominator =
        (1 - (1 / pow(1 + monthlyInterestRate, numberOfPayments)));

    monthlyPayment = ((loanAmount * monthlyInterestRate) / denominator) +
        homeOwnersInsurance +
        taxesAndOtherFees +
        hOA;

    setState(() {});
  }
}
