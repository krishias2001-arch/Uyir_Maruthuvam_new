import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/features/doctor/bottomnavigationbar/doctor_schedule_screen.dart';

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
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const DoctorScheduleScreen(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today Summary",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _summaryItem("Total", total.toString(), Colors.blue),
                  _summaryItem("Pending", pending.toString(), Colors.orange),
                  _summaryItem("Confirmed", confirmed.toString(), Colors.green),
                ],
              ),
            ],
          ),
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
        Text(
          title,
          style: const TextStyle(fontSize: 13, color: Colors.white),
        ),
      ],
    );
  }
}
