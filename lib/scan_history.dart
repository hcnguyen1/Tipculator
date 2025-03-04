import 'package:flutter/material.dart';

class ScanHistory extends StatelessWidget {
  final List<String> scanHistory;
  const ScanHistory(this.scanHistory, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: scanHistory.length,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(scanHistory[index]),
          ),
        );
      },
    );
  }
}