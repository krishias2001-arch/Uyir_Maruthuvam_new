import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_services.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        actions: [
          // Clear all notifications button
          if (_notificationService.isCurrentUserAuthenticated())
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'clear_all') {
                  _showClearAllDialog();
                } else if (value == 'mark_all_read') {
                  _markAllAsRead();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'mark_all_read',
                  child: Row(
                    children: [
                      Icon(Icons.mark_email_read, size: 20),
                      SizedBox(width: 8),
                      Text('Mark all as read'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(Icons.clear_all, size: 20),
                      SizedBox(width: 8),
                      Text('Clear all'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _notificationService.getUserNotifications(
          _notificationService.getCurrentUserId() ?? '',
        ),
        builder: (context, snapshot) {
          debugPrint('Snapshot state: ${snapshot.connectionState}');
          debugPrint('Has data: ${snapshot.hasData}');
          if (snapshot.hasData) {
            debugPrint('Notifications count: ${snapshot.data!.docs.length}');
          }
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
              ),
            );
          }

          if (!_notificationService.isCurrentUserAuthenticated() || 
              !snapshot.hasData || 
              snapshot.data!.docs.isEmpty) {
            debugPrint('Showing empty state');
            return _buildEmptyState();
          }

          final notifications = snapshot.data!.docs;
          
          return RefreshIndicator(
            onRefresh: () async {
              // The stream will automatically refresh
              setState(() {});
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final doc = notifications[index];
                final data = doc.data() as Map<String, dynamic>;
                
                return NotificationTile(
                  notificationId: doc.id,
                  title: data['title'] ?? 'Notification',
                  body: data['body'] ?? 'No details',
                  timestamp: data['timestamp'] ?? Timestamp.now(),
                  isRead: data['isRead'] ?? false,
                  type: data['type'] ?? 'general',
                  data: data['data'] ?? {},
                  onTap: () => _handleNotificationTap(doc.id, data['isRead'] ?? false),
                  onLongPress: () => _showNotificationOptions(doc.id),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            "No notifications",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "You're all caught up!",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(String notificationId, bool isRead) async {
    // Don't automatically mark as read - let user do it manually
    // This prevents notifications from disappearing when tapped
    debugPrint('Notification tapped: $notificationId');
  }

  void _showNotificationOptions(String notificationId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.mark_email_read),
            title: const Text('Mark as read'),
            onTap: () {
              Navigator.pop(context);
              _notificationService.markNotificationAsRead(notificationId);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _notificationService.deleteNotification(notificationId);
            },
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text('Are you sure you want to clear all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _notificationService.clearAllNotifications(
                _notificationService.getCurrentUserId() ?? '',
              );
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    _notificationService.markAllNotificationsAsRead(
      _notificationService.getCurrentUserId() ?? '',
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String notificationId;
  final String title;
  final String body;
  final Timestamp timestamp;
  final bool isRead;
  final String type;
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const NotificationTile({
    super.key,
    required this.notificationId,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.isRead,
    required this.type,
    required this.data,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isRead ? 1 : 3,
      color: isRead ? Colors.white : Colors.red.shade50,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(8),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getNotificationColor(type).withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: _getNotificationColor(type).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              _getNotificationIcon(type),
              color: _getNotificationColor(type),
              size: 24,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
              color: isRead ? Colors.grey[700] : Colors.black87,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                body,
                style: TextStyle(
                  color: isRead ? Colors.grey[600] : Colors.black54,
                  fontSize: 14,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTimestamp(timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (!isRead) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          trailing: isRead
              ? null
              : Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
        ),
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'appointment_booking':
        return Colors.blue;
      case 'appointment_confirmation':
        return Colors.green;
      case 'appointment_cancellation':
        return Colors.orange;
      case 'payment_reminder':
        return Colors.purple;
      case 'general':
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'appointment_booking':
        return Icons.calendar_today;
      case 'appointment_confirmation':
        return Icons.check_circle;
      case 'appointment_cancellation':
        return Icons.cancel;
      case 'payment_reminder':
        return Icons.payment;
      case 'general':
      default:
        return Icons.notifications;
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
