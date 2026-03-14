import 'package:flutter/material.dart';

class TodaySummaryCard extends StatelessWidget {
  final int total;
  final int pending;
  final int confirmed;

  const TodaySummaryCard({
    super.key,
    required this.total,
    required this.pending,
    required this.confirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.blueGrey,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today Summary",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _summaryItem("Total", "15", Colors.blue),
                _summaryItem("Pending", "3", Colors.orange),
                _summaryItem("Confirmed", "12", Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String title, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
