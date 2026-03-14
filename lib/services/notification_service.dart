import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background message received: ${message.messageId}");
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
}

class NotificationService {

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  /// Initialize notification service
  Future<void> init() async {

    /// Background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    /// Request notification permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Notification permission: ${settings.authorizationStatus}");

    /// Get FCM Token
    String? token = await _messaging.getToken();
    print("FCM Token: $token");

    /// Initialize Local Notifications
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        print("Notification clicked with payload: ${details.payload}");
      },
    );

    /// Foreground notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground notification received");

      if (message.notification != null) {
        _showNotification(message);
      }
    });

    /// Notification clicked when app in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification opened from background");
      _handleNotificationClick(message);
    });

    /// App opened from terminated state
    final RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("Notification opened from terminated state");
      _handleNotificationClick(initialMessage);
    }
  }

  /// Show local notification when app is open
  void _showNotification(RemoteMessage message) {

    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? "Notification",
      message.notification?.body ?? "",
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  /// Handle notification click
  void _handleNotificationClick(RemoteMessage message) {
    print("Notification clicked with data: ${message.data}");

    // Example navigation logic
    // if (message.data['type'] == 'appointment') {
    //   Navigator.push(context,
    //     MaterialPageRoute(builder: (_) => AppointmentScreen()));
    // }
  }
}