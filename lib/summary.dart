import 'package:flutter/material.dart';

class TipSummary extends StatefulWidget {
  final String? amount;

  const TipSummary({super.key, this.amount});

  @override
  State<TipSummary> createState() => TipSummaryState();
}

class TipSummaryState extends State<TipSummary> {
  double tipPercent = 15; // Default tip percentage
  int numberOfPeople = 1; // Default number of people
  late TextEditingController controller;

  double? get billAmount {
    if (widget.amount == null) return null;
    final cleaned = widget.amount!.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned);
  }

  @override
  void initState() {
    super.initState();

    final cleaned = widget.amount?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '';
    controller = TextEditingController(text: cleaned);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double? subtotal = double.tryParse(
      controller.text.replaceAll(RegExp(r'[^0-9.]'), ''),
    );
    final double? tipAmount =
        subtotal != null ? subtotal * tipPercent / 100 : null;
    final double? total =
        (subtotal != null && tipAmount != null) ? subtotal + tipAmount : null;
    final double? perPerson =
        (total != null && numberOfPeople > 0) ? total / numberOfPeople : null;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Scanned Total:',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 16),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Slider remains the same
            Text('Tip Percentage: ${tipPercent.toStringAsFixed(0)}%'),
            Slider(
              value: tipPercent,
              min: 0,
              max: 200,
              divisions: 200,
              label: '${tipPercent.toStringAsFixed(0)}%',
              onChanged: (value) {
                setState(() {
                  tipPercent = value;
                });
              },
            ),

            Text('Number of People: $numberOfPeople'),
            Slider(
              value: numberOfPeople.toDouble(),
              min: 1,
              max: 50,
              divisions: 49,
              label: '$numberOfPeople',
              onChanged: (value) {
                setState(() {
                  numberOfPeople = value.toInt();
                });
              },
            ),

            const SizedBox(height: 20),

            // Tip Amount Card
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                color: Colors.lightBlue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Tip Amount: \$${(tipAmount ?? 0).toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Total with Tip Card
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                color: Colors.lightBlue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total with Tip: \$${(total ?? 0).toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Each Person Pays Card
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                color: Colors.lightBlue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Each Person Pays: \$${(perPerson ?? 0).toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
