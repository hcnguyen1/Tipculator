import 'package:flutter/material.dart';

class TipSummary extends StatelessWidget {
  final String? amount;

  const TipSummary({super.key, this.amount});

  @override
  Widget build(BuildContext context) {
    print('Rendering TipSummary with amount: $amount');
    return Scaffold(
      body: Center(
        child: Text(
          'Scanned Total: ${amount ?? "None"}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}