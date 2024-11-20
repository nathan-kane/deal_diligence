//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CommissionCalculatorPopup {
  static void showCommissionCalculator(BuildContext context, double salePrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CommissionCalculatorDialog(salePrice: salePrice);
      },
    );
  }
}

class CommissionCalculatorDialog extends StatefulWidget {
  final double salePrice;

  const CommissionCalculatorDialog({required this.salePrice, super.key});

  @override
  State<CommissionCalculatorDialog> createState() =>
      _CommissionCalculatorDialogState();
}

class _CommissionCalculatorDialogState
    extends State<CommissionCalculatorDialog> {
  TextEditingController salePriceController = TextEditingController();
  TextEditingController commissionRateController = TextEditingController();
  String commission = "0.0";
  final NumberFormat currencyFormatter = NumberFormat.currency(symbol: '\$');

  String _formatCurrency(String textCurrency) {
    //String textContractPrice = contractPriceController.text;

    /// Format the contract price
    String numericCurrency = textCurrency.replaceAll(RegExp(r'[^\d]'), '');
    if (numericCurrency.isNotEmpty) {
      double value = double.parse(numericCurrency);
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
  void initState() {
    super.initState();
    salePriceController.text = _formatCurrency(widget.salePrice.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Commission Calculator',
        style: TextStyle(fontSize: 8.sp),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: salePriceController,
            decoration: const InputDecoration(labelText: 'Sale Price (\$)'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: commissionRateController,
            decoration: const InputDecoration(labelText: 'Commission Rate (%)'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20.sp),
          ElevatedButton(
            onPressed: calculateCommission,
            child: const Text('Calculate Commission'),
          ),
          SizedBox(height: 20.sp),
          Text(
            //'Commission: \$${commission.toStringAsFixed(2)}',
            'Commission: $commission',
            style: TextStyle(fontSize: 8.sp),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  void calculateCommission() {
    if (salePriceController.text.isNotEmpty &&
        commissionRateController.text.isNotEmpty) {
      try {
        var unformattedSalePrice = salePriceController.text;
        unformattedSalePrice = unformattedSalePrice.replaceAll(RegExp(r'[^\d]'), '');
        double salePrice = double.parse(unformattedSalePrice)/100;
        double commissionRate = double.parse(commissionRateController.text);

        double commissionAmount = (salePrice * commissionRate) / 100;
        setState(() {
          String strCommissionAmount = commissionAmount.toString();
          commission = _formatCurrency(strCommissionAmount);
        });
      } catch (e) {
        print({'Commission Calculation Error: $e'});
      }
    } else {
      // Handle empty fields
      // You can show an error message or take appropriate action
    }
  }
}
