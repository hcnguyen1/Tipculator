import 'package:flutter/material.dart';

class TipSummary extends StatelessWidget {
  final String? amount;

  const TipSummary({super.key, this.amount});

  // Create a method that trims every symbols except numbers and dots from the string
  String? cleanAmount(String? amount) {
    if (amount == null) return null;
    final cleaned = amount.replaceAll(RegExp(r'[^0-9.]'), '');
    return cleaned.isEmpty ? null : '\$$cleaned';
  }

  @override
  Widget build(BuildContext context) {
    print('Rendering TipSummary with amount: $amount');
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ), // Add some padding for better spacing
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to the start (left)
          children: [
            Text(
              'Scanned Total: ${cleanAmount(amount) ?? "None"}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),              
            ),
          ],
        ),
      ),
    );
  }
}
