import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/screens/payment services/payment_screen.dart';
import 'package:uyir_maruthuvam_new/services/notification_services.dart';
import 'package:uyir_maruthuvam_new/widget/weekly_calander.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AppointmentScreen extends StatefulWidget {
  final String doctorId;

  const AppointmentScreen({super.key, required this.doctorId});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final NotificationService _notificationService = NotificationService();

  List<String> timeSlots = [
    "10:00 AM",
    "10:20 AM",
    "10:40 AM",
    "11:00 AM",
    "11:20 AM",
    "11:40 AM",
    "12:00 PM",
    "12:20 PM",
    "12:40 PM",
    "1:00 PM",
    "1:20 PM",
    "1:40 PM",
  ];

  int selectedIndex = -1;
  DateTime? selectedDate;

  List<int> bookedSlots = [];

  Future<void> loadBookedSlots() async {

    if (selectedDate == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('date', isEqualTo: selectedDate)
        .get();

    List<int> slots = [];

    for (var doc in snapshot.docs) {

      String bookedTime = doc['time'];

      int index = timeSlots.indexOf(bookedTime);

      if (index != -1) {
        slots.add(index);
      }
    }

    setState(() {
      bookedSlots = slots;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 30),

              Text(
                "Booking Date",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              WeeklyCalendar(
                onDateSelected: (date) async {

                  setState(() {
                    selectedDate = date;
                  });

                  await loadBookedSlots();
                },
              ),

              const SizedBox(height: 30),

              Text(
                "Booking Time",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                height: 250,

                child: GridView.builder(

                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: timeSlots.length,

                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.5,
                  ),

                  itemBuilder: (context, index) {

                    bool isBooked = bookedSlots.contains(index);
                    bool isSelected = selectedIndex == index;

                    Color bgColor;

                    if (isBooked) {
                      bgColor = Colors.grey.shade400;
                    } else if (isSelected) {
                      bgColor = Colors.redAccent;
                    } else {
                      bgColor = Colors.green;
                    }

                    return InkWell(
                      onTap: isBooked
                          ? null
                          : () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },

                      child: Container(
                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: Text(
                          timeSlots[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(

        padding: const EdgeInsets.all(15),
        height: 90,

        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 4),
          ],
        ),

        child: InkWell(

          onTap: () async {

            if (selectedIndex == -1 || selectedDate == null) {

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select date and time")),
              );

              return;
            }

            String patientId = FirebaseAuth.instance.currentUser!.uid;

            String doctorId = widget.doctorId;

            await FirebaseFirestore.instance.collection('appointments').add({
              'doctorId': doctorId,
              'patientId': patientId,
              'date': selectedDate,
              'time': timeSlots[selectedIndex],
              'status': 'pending',
              'createdAt': FieldValue.serverTimestamp(),
            });
            // Get patient name for notification
            String patientName = FirebaseAuth.instance.currentUser?.displayName ?? 'Patient';

// Send notification to doctor
            await _notificationService.createAppointmentBookingNotification(
              doctorId: doctorId,
              patientId: patientId,
              patientName: patientName,
              appointmentDate: selectedDate!,
              appointmentTime: timeSlots[selectedIndex],
            );
// Also create notification for patient
            await _notificationService.createCustomNotification(
              userId: patientId,
              title: 'Appointment Booked',
              body: 'Your appointment has been booked for ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} at ${timeSlots[selectedIndex]}',
              type: 'appointment_booking',
              data: {
                'doctorId': doctorId,
                'appointmentDate': Timestamp.fromDate(selectedDate!),
                'appointmentTime': timeSlots[selectedIndex],
              },
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    PaymentScreen(selectedTime: timeSlots[selectedIndex]),
              ),
            );
          },

          child: Container(

            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 18),

            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
            ),

            child: const Center(
              child: Text(
                "Book Now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}