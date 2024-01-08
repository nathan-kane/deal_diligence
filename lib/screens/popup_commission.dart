import 'package:flutter/material.dart';

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
  _CommissionCalculatorDialogState createState() =>
      _CommissionCalculatorDialogState();
}

class _CommissionCalculatorDialogState
    extends State<CommissionCalculatorDialog> {
  TextEditingController salePriceController = TextEditingController();
  TextEditingController commissionRateController = TextEditingController();
  double commission = 0.0;

  @override
  void initState() {
    super.initState();
    salePriceController.text = widget.salePrice.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Commission Calculator'),
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: calculateCommission,
            child: const Text('Calculate Commission'),
          ),
          const SizedBox(height: 20),
          Text(
            'Commission: \$${commission.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18),
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
      double salePrice = double.parse(salePriceController.text);
      double commissionRate = double.parse(commissionRateController.text);

      double commissionAmount = (salePrice * commissionRate) / 100;
      setState(() {
        commission = commissionAmount;
      });
    } else {
      // Handle empty fields
      // You can show an error message or take appropriate action
    }
  }
}
