# Appointment Screen Integration Example

## How to Add Notification Creation to Appointment Booking

In your `appointment_screen.dart`, after the appointment creation code (around line 233), add this:

```dart
// AFTER THIS CODE:
await FirebaseFirestore.instance.collection('appointments').add({
  'doctorId': doctorId,
  'patientId': patientId,
  'date': selectedDate,
  'time': timeSlots[selectedIndex],
  'status': 'pending',
  'createdAt': FieldValue.serverTimestamp(),
});

// ADD THIS CODE:
// Create notification for doctor
final notificationService = NotificationService();

// Get patient name for notification
DocumentSnapshot patientDoc = await FirebaseFirestore.instance
    .collection('users')
    .doc(patientId)
    .get();
String patientName = patientDoc.get('name') ?? 'A patient';

await notificationService.createAppointmentBookingNotification(
  doctorId: doctorId,
  patientId: patientId,
  patientName: patientName,
  appointmentDate: selectedDate!,
  appointmentTime: timeSlots[selectedIndex],
);
```

## For Doctor Appointment Confirmation

When a doctor confirms an appointment, add this:

```dart
final notificationService = NotificationService();

await notificationService.createAppointmentConfirmationNotification(
  patientId: appointmentData['patientId'],
  doctorName: doctorName,
  appointmentDate: appointmentData['date'].toDate(),
  appointmentTime: appointmentData['time'],
);
```

## Current Status

✅ **notification_services.dart** - Complete service with all methods
✅ **patient_notification_bell.dart** - Enhanced notification screen
✅ **patient_home_screen.dart** - Updated with notification bell
✅ **main.dart** - Fixed imports and init() call
✅ **appointment_screen.dart** - Import fixed, ready for integration

## All Files Are Ready

Your notification system is now complete and ready to use! Just add the notification creation code to your appointment booking flow.
