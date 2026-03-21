import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uyir_maruthuvam_new/features/appointments/screens/notification_screen.dart';

import 'package:uyir_maruthuvam_new/core/services/notification_services.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return const SizedBox();

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NotificationScreen(),
              ),
            );
          },
        ),

        /// 🔴 Unread badge
        StreamBuilder<int>(
          stream: NotificationService()
              .getUnreadNotificationsCount(user.uid),
          builder: (context, snapshot) {
            int count = snapshot.data ?? 0;

            if (count == 0) return const SizedBox();

            return Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
