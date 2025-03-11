import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../utils/sms_sender.dart';

class MyFirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Demande la permission de recevoir des notifications
    await _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message reçu: ${message.data}");
      String? number = message.data['number'];
      String? text = message.data['message'];
      if (number != null && text != null) {
        SmsSender.sendSMS(number, text);
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Message reçu en arrière-plan: ${message.data}");
    String? number = message.data['number'];
    String? text = message.data['message'];
    if (number != null && text != null) {
      SmsSender.sendSMS(number, text);
    }
  }
}
