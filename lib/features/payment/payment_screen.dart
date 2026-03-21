import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final String selectedTime;
  
  const PaymentScreen({super.key, required this.selectedTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            /// Amount Card
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [
                  Text("Total Amount", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(
                    "₹500",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// Payment Methods
            ListTile(
              leading: Icon(Icons.qr_code),
              title: Text("UPI Payment"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),

            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text("Debit / Credit Card"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),

            ListTile(
              leading: Icon(Icons.money),
              title: Text("Cash"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),

            const Spacer(),

            /// Pay Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text("Pay Now", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
