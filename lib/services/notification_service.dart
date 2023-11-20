import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings("flutter_logo");

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  Future<NotificationDetails> notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails("channelId", "channelName",
          importance: Importance.max),
    );
  }

  Future showNotification({int id = 0, String? title, String? body, String? payload}) async {
    await initNotification();
    var notificationDetailsObj = await notificationDetails();
    return notificationsPlugin.show(id, title, body, notificationDetailsObj);
  }
}
