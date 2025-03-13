import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionWidget extends StatefulWidget {
  const NotificationPermissionWidget({super.key});

  @override
  State<NotificationPermissionWidget> createState() =>
      _NotificationPermissionWidgetState();
}

class _NotificationPermissionWidgetState
    extends State<NotificationPermissionWidget> {
  bool _isNotificationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  // Verifica a permissão de notificação
  Future<void> _checkNotificationPermission() async {
    final permissionStatus = await Permission.notification.status;
    setState(() {
      _isNotificationPermissionGranted = permissionStatus.isGranted;
    });
  }

  // Solicita permissão para notificação
  Future<void> _requestNotificationPermission() async {
    final permissionStatus = await Permission.notification.request();
    if (permissionStatus.isGranted) {
      setState(() {
        _isNotificationPermissionGranted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (!_isNotificationPermissionGranted) {
          _requestNotificationPermission();
        }
      },
      icon: Icon(
        _isNotificationPermissionGranted
            ? Icons.notifications
            : Icons.notifications_off, // Exibe ícone diferente quando sem permissão
        size: 20,
      ),
    );
  }
}