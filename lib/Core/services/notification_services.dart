import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {
    debugPrint("NotificationService initialized");
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Create a notification for appointment booking (sent to doctor)
  Future<void> createAppointmentBookingNotification({
    required String doctorId,
    required String patientId,
    required String patientName,
    required DateTime appointmentDate,
    required String appointmentTime,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': doctorId,
        'title': 'New Appointment',
        'body': 'patient $patientName booked an appointment for ${_formatDate(appointmentDate)} at $appointmentTime',
        'timestamp': Timestamp.now(),
        'isRead': false,
        'type': 'appointment_booking',
        'data': {
          'patientId': patientId,
          'patientName': patientName,
          'appointmentDate': Timestamp.fromDate(appointmentDate),
          'appointmentTime': appointmentTime,
        },
      });
      debugPrint('Appointment booking notification created for doctor: $doctorId');
    } catch (e) {
      debugPrint('Error creating appointment booking notification: $e');
    }
  }

  /// Create a notification for appointment confirmation (sent to patient)
  Future<void> createAppointmentConfirmationNotification({
    required String patientId,
    required String doctorName,
    required DateTime appointmentDate,
    required String appointmentTime,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': patientId,
        'title': 'Appointment Confirmed',
        'body': 'Your appointment with Dr. $doctorName on ${_formatDate(appointmentDate)} at $appointmentTime has been confirmed',
        'timestamp': Timestamp.now(),
        'isRead': false,
        'type': 'appointment_confirmation',
        'data': {
          'doctorName': doctorName,
          'appointmentDate': Timestamp.fromDate(appointmentDate),
          'appointmentTime': appointmentTime,
        },
      });
      debugPrint('Appointment confirmation notification created for patient: $patientId');
    } catch (e) {
      debugPrint('Error creating appointment confirmation notification: $e');
    }
  }

  /// Create a notification for appointment cancellation
  Future<void> createAppointmentCancellationNotification({
    required String userId,
    required String cancelledBy,
    required DateTime appointmentDate,
    required String appointmentTime,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'title': 'Appointment Cancelled',
        'body': 'Your appointment on ${_formatDate(appointmentDate)} at $appointmentTime was cancelled by $cancelledBy',
        'timestamp': Timestamp.now(),
        'isRead': false,
        'type': 'appointment_cancellation',
        'data': {
          'cancelledBy': cancelledBy,
          'appointmentDate': Timestamp.fromDate(appointmentDate),
          'appointmentTime': appointmentTime,
        },
      });
      debugPrint('Appointment cancellation notification created for user: $userId');
    } catch (e) {
      debugPrint('Error creating appointment cancellation notification: $e');
    }
  }

  /// Create a notification for payment reminder
  Future<void> createPaymentReminderNotification({
    required String patientId,
    required DateTime appointmentDate,
    required String appointmentTime,
    required String doctorName,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': patientId,
        'title': 'Payment Reminder',
        'body': 'Complete your payment for the appointment with Dr. $doctorName on ${_formatDate(appointmentDate)} at $appointmentTime',
        'timestamp': Timestamp.now(),
        'isRead': false,
        'type': 'payment_reminder',
        'data': {
          'doctorName': doctorName,
          'appointmentDate': Timestamp.fromDate(appointmentDate),
          'appointmentTime': appointmentTime,
        },
      });
      debugPrint('Payment reminder notification created for patient: $patientId');
    } catch (e) {
      debugPrint('Error creating payment reminder notification: $e');
    }
  }

  /// Create a custom notification
  Future<void> createCustomNotification({
    required String userId,
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'title': title,
        'body': body,
        'timestamp': Timestamp.now(),
        'isRead': false,
        'type': type,
        'data': data ?? {},
      });
      debugPrint('Custom notification created for user: $userId');
    } catch (e) {
      debugPrint('Error creating custom notification: $e');
    }
  }

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
        'readAt': Timestamp.now(),
      });
      debugPrint('Notification marked as read: $notificationId');
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  /// Mark all notifications as read for a user
  Future<void> markAllNotificationsAsRead(String userId) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      QuerySnapshot unreadNotifications = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();
      
      for (DocumentSnapshot doc in unreadNotifications.docs) {
        batch.update(doc.reference, {
          'isRead': true,
          'readAt': Timestamp.now(),
        });
      }
      
      await batch.commit();
      debugPrint('All notifications marked as read for user: $userId');
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
    }
  }

  /// Get unread notifications count for a user
  Stream<int> getUnreadNotificationsCount(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Get notifications stream for a user
  Stream<QuerySnapshot> getUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
      debugPrint('Notification deleted: $notificationId');
    } catch (e) {
      debugPrint('Error deleting notification: $e');
    }
  }

  /// Clear all notifications for a user
  Future<void> clearAllNotifications(String userId) async {
    try {
      QuerySnapshot userNotifications = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .get();
      
      WriteBatch batch = _firestore.batch();
      for (DocumentSnapshot doc in userNotifications.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      debugPrint('All notifications cleared for user: $userId');
    } catch (e) {
      debugPrint('Error clearing all notifications: $e');
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Get current user ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// Check if current user is authenticated
  bool isCurrentUserAuthenticated() {
    return _auth.currentUser != null;
  }
}
