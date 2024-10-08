//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

//import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Use this YouTube video for guidance: https://www.youtube.com/watch?v=k0zGEbiDJcQ
// and this YouTube video: https://www.youtube.com/watch?v=-XSLZgWEAzE

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
// if (kDebugMode) {
//   debugPrint('Title: ${message.notification?.title}');
// }
// if (kDebugMode) {
//   debugPrint('Body: ${message.notification?.body}');
// }
// if (kDebugMode) {
//   debugPrint('Payload: ${message.data}');
// }
// }

class FirebaseApi {
  // final firebaseMessaging = FirebaseMessaging.instance;

  final androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High_Importance_Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );
  final localNotifications = FlutterLocalNotificationsPlugin();

  // void handleMessage(RemoteMessage? message) {
  //   if (message == null) return;
  // }

  Future initLocalNotification() async {
    // TODO(any): Push notifications do not currently work on Safari iOS (see: https://caniuse.com/push-api). Implement this feature some other way.
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    // const settings = InitializationSettings(android: android);

    // await localNotifications.initialize(
    //   settings,
    //   onDidReceiveNotificationResponse: (payload) {
    //     final message = RemoteMessage.fromMap(jsonDecode(payload as String));
    //     handleMessage(message);
    //   },
    // );

    final platform = localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(androidChannel);
  }

  Future initPushNotifications() async {
    // TODO(any): Push notifications do not currently work on Safari iOS (see: https://caniuse.com/push-api). Implement this feature some other way.
    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    // FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    // FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    // FirebaseMessaging.onMessage.listen(
    //   (message) {
    //     final notification = message.notification;
    //     if (notification == null) return;

    //     localNotifications.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //             androidChannel.id, androidChannel.name,
    //             channelDescription: androidChannel.description,
    //             icon: '@drawable/ic_launcher'),
    //       ),
    //       payload: jsonEncode(message.toMap()),
    //     );
    //   },
    // );
  }

  Future<void> initNotifications() async {
    // TODO(any): Push notifications do not currently work on Safari iOS (see: https://caniuse.com/push-api). Implement this feature some other way.
    // await firebaseMessaging.requestPermission();
    // if (!kIsWeb) {
    //   firebaseMessaging.subscribeToTopic('chat');
    // }
    // initPushNotifications();
    // initLocalNotification();
  }
}
