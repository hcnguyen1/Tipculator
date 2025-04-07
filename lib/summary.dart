import 'package:flutter/material.dart';

class TipSummary extends StatelessWidget {
  const TipSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'Scanned Total: None',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
