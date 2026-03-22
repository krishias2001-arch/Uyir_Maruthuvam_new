import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  final String doctorId;
  
  const AppointmentScreen({super.key, required this.doctorId});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? _selectedTime;
  String _selectedSlot = '';
  bool _isLoading = false;

  Map<String, dynamic>? doctorData;
  List<String> _availableSlots = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadDoctorData();
  }

  Future<void> _loadDoctorData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.doctorId)
        .get();
    
    if (doc.exists) {
      setState(() {
        doctorData = doc.data() as Map<String, dynamic>;
        _generateSlotsForSelectedDay();
      });
    }
  }

  void _generateSlotsForSelectedDay() {
    if (doctorData == null || _selectedDay == null) return;

    final timingType = doctorData!['timingType'] ?? 'standard';
    List<Map<String, String>> activeSlots = [];

    if (timingType == 'standard') {
      final standard = doctorData!['standardTiming'];
      if (standard != null && standard['start'] != null && standard['end'] != null) {
        activeSlots.add({
          "start": standard['start'],
          "end": standard['end'],
        });
      }
    } else {
      final dayName = DateFormat('EEEE').format(_selectedDay!).toLowerCase();
      final schedule = doctorData!['weeklySchedule'];
      if (schedule != null && schedule[dayName] != null) {
        activeSlots = List<Map<String, String>>.from(
          (schedule[dayName] as List).map((item) => Map<String, String>.from(item))
        );
      }
    }

    List<String> generatedSlots = [];
    for (var slotRange in activeSlots) {
      generatedSlots.addAll(_splitIntoSlots(slotRange['start']!, slotRange['end']!));
    }

    setState(() {
      _availableSlots = generatedSlots;
      _selectedSlot = '';
      _selectedTime = null;
    });
  }

  List<String> _splitIntoSlots(String startStr, String endStr) {
    List<String> slots = [];
    try {
      final startParts = startStr.split(":");
      final endParts = endStr.split(":");
      
      TimeOfDay start = TimeOfDay(hour: int.parse(startParts[0]), minute: int.parse(startParts[1]));
      TimeOfDay end = TimeOfDay(hour: int.parse(endParts[0]), minute: int.parse(endParts[1]));

      DateTime startTime = DateTime(2024, 1, 1, start.hour, start.minute);
      DateTime endTime = DateTime(2024, 1, 1, end.hour, end.minute);

      while (startTime.isBefore(endTime)) {
        slots.add(DateFormat.jm().format(startTime));
        startTime = startTime.add(const Duration(minutes: 30));
      }
    } catch (e) {
      print("Error splitting slots: $e");
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    if (doctorData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final doctorName = doctorData!['name'] ?? 'Unknown Doctor';
    final specialization = doctorData!['specialization'] ?? 'General';
    final fee = doctorData!['fee'] ?? 0;
    final imageUrl = doctorData!['imageUrl'] ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Info Card
            Card(
              elevation: 0,
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : null,
                      child: imageUrl.isEmpty
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. $doctorName',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(specialization),
                          const SizedBox(height: 4),
                          Text(
                            'Consultation Fee: ₹$fee',
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Calendar
            const Text(
              'Select Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 30)),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _generateSlotsForSelectedDay();
              },
              onFormatChanged: (format) {
                setState(() => _calendarFormat = format);
              },
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                todayDecoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle, ),
              ),
            ),

            const SizedBox(height: 24),

            // Time Slots
            const Text(
              'Available Time Slots',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (_availableSlots.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("No slots available for this day", style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _availableSlots.length,
                itemBuilder: (context, index) {
                  final slot = _availableSlots[index];
                  final isSelected = _selectedSlot == slot;
                  
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedSlot = slot;
                        _selectedTime = _parseTime(slot);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.redAccent : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? Colors.redAccent : Colors.grey[300]!,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          slot,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 32),

            // Book Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: (_selectedDay != null && _selectedTime != null) && !_isLoading
                    ? _bookAppointment
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Confirm Appointment',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  TimeOfDay _parseTime(String timeString) {
    final format = DateFormat.jm();
    final dateTime = format.parse(timeString);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  Future<void> _bookAppointment() async {
    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('User not logged in');

      final appointmentDateTime = DateTime(
        _selectedDay!.year,
        _selectedDay!.month,
        _selectedDay!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      await FirebaseFirestore.instance.collection('appointments').add({
        'doctorId': widget.doctorId,
        'patientId': currentUser.uid,
        'appointmentDateTime': appointmentDateTime,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'timeSlot': _selectedSlot,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDay!),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment booked successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error booking appointment: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
