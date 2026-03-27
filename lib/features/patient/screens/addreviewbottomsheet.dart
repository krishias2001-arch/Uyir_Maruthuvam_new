
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddReviewBottomSheet extends StatefulWidget {
  final String doctorId;

  const AddReviewBottomSheet({super.key, required this.doctorId});

  @override
  State<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
  double rating = 0;
  TextEditingController commentController = TextEditingController();

  Future<void> submitReview() async {
    if (rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select rating")),
      );
      return;
    }
    if (commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please write a review")),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.doctorId) // ✅ correct
        .collection('reviews')
        .add({
      'patientName': "Anonymous",
      'rating': rating, // ✅ correct
      'comment': commentController.text, // ✅ correct
      'timestamp': FieldValue.serverTimestamp(),
    });
    final reviewsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.doctorId)
        .collection('reviews');

// get all reviews
    final snapshot = await reviewsRef.get();

    double total = 0;
    for (var doc in snapshot.docs) {
      total += (doc['rating'] as num).toDouble();
    }

    double avg = snapshot.docs.isEmpty ? 0 : total / snapshot.docs.length;

// update doctor document
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.doctorId)
        .update({
      'rating': avg,
      'reviewCount': snapshot.docs.length,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add Review", style: TextStyle(fontSize: 18)),

            SizedBox(height: 10),

            // ⭐ Simple Rating UI
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < rating ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => rating = index + 1.0);
                  },
                );
              }),
            ),

            TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: "Write your review...",
              ),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: submitReview,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}