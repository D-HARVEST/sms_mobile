import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sms_mobile_api/splash/splash_screen.dart';
import 'package:telephony/telephony.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;

/// Variables globales
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late AndroidNotificationChannel channel;
final Telephony telephony = Telephony.instance;
bool isFlutterLocalNotificationsInitialized = false;

/// Fonction exécutée en arrière-plan
@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  if (message.notification != null) {
    print(
      '🔔 Notification reçue en arrière-plan : ${message.notification?.title}',
    );
    handleReceivedMessage(message);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  // Configuration des notifications locales
  setupFlutterNotifications();

  // S'abonner au **topic** Laravel
  FirebaseMessaging.instance.subscribeToTopic("allusers");
  print("✅ Abonné au topic allusers");

  FirebaseMessaging.onMessage.listen(showFlutterNotification);

  // Gérer la réception des messages en premier plan
  FirebaseMessaging.onMessage.listen(handleReceivedMessage);

  runApp(const MyAppBase());
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  String? timestamp = message.data['timestamp'];

  print("Notification reçue à: $timestamp");
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// Fonction pour gérer les notifications reçues
void handleReceivedMessage(RemoteMessage message) {
  if (message.notification != null) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title ?? "Notification",
        notification.body ?? "Vous avez une nouvelle notification.",
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
          ),
        ),
      );
    }
  }

  // Récupération des données (numéro + message) pour l'envoi de SMS
  if (message.data.containsKey('number') &&
      message.data.containsKey('message') &&
      message.data.containsKey('id')) {
    String senderId = "YourSenderID";
    String phoneNumber = message.data['number'];
    String smsMessage = message.data['message'];
    String messageId = message.data['id'];

    String finalMessage = "$senderId : $smsMessage";

    sendSms(phoneNumber, smsMessage, messageId);
  }
}

/// Fonction pour envoyer un SMS
Future<void> sendSms(
  String phoneNumber,
  String smsMessage,
  String messageId,
) async {
  bool? permissionsGranted = await telephony.requestSmsPermissions;

  if (permissionsGranted == true) {
    telephony.sendSms(to: phoneNumber, message: smsMessage);
    print("📩 SMS envoyé à $phoneNumber : $smsMessage");
    updateMessageStatus(messageId);
  } else {
    print("❌ Permission SMS refusée !");
  }
}

/// Fonction pour mettre à jour le statut du message dans l'API
Future<void> updateMessageStatus(String messageId) async {
  final url = Uri.parse('http://192.168.1.70:8000/api/status/$messageId');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: '{"status": true}',
    );

    if (response.statusCode == 200) {
      print("✅ Statut du message mis à jour !");
    } else {
      print("❌ Erreur lors de la mise à jour du statut !");
    }
  } catch (e) {
    print("⚠️ Exception: $e");
  }
}

/// Configuration des notifications locales
Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) return;

  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'Notifications Importantes',
    description: 'Ce canal est utilisé pour les notifications importantes.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;
}

class MyAppBase extends StatelessWidget {
  const MyAppBase({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'SMS Web API',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
        ),
        home: const Scaffold(
          resizeToAvoidBottomInset: true,
          body: SplashScreenEDV(),
        ),
      ),
    );
  }
}
