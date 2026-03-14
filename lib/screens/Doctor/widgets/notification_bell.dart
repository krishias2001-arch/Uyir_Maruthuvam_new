import 'package:flutter/material.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          NotificationTile(
            title: "New appointment request",
            subtitle: "Patient: Arun • 10:30 AM",
          ),
          Divider(),

          NotificationTile(
            title: "Appointment Cancelled",
            subtitle: "Patient: Priya • 11:00 AM",
          ),
          Divider(),

          NotificationTile(
            title: "Lab report uploaded",
            subtitle: "Patient: Karthik",
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const NotificationTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
    );
  }
}
