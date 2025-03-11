import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sms_mobile_api/splash/splash_screen.dart';
import 'firebase_options.dart';



void subscribeToTopic() {}

/// Initialise les notifications locales.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

/// Variables globales
late FlutterLocalNotificationsPlugin fltnotif;
late InitializationSettings initializationSettings;
bool peutNotifier = false; 

/// Thèmes
final ThemeData themeDatadark = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
);

final ThemeData themeDatalight = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
);

ThemeData themeData = themeDatalight;

/// Gestion des messages en arrière-plan
@pragma('vm:entry-point') // Correction importante
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  if (message.notification != null) {
    print('Notification reçue en arrière-plan: ${message.notification?.title}');
    showFlutterNotification(message);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  // Initialisation des notifications
  const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettingsIOS = DarwinInitializationSettings();
  initializationSettings = const InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  fltnotif = FlutterLocalNotificationsPlugin();
  peutNotifier = await fltnotif.initialize(initializationSettings) ?? false;

  // Abonnement aux notifications
  FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.instance.subscribeToTopic("allusers");
  FirebaseMessaging.onMessage.listen(showFlutterNotification);

  setupFlutterNotifications();

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

class MyAppBase extends StatefulWidget {
  const MyAppBase({super.key});

  @override
  _MyAppBaseState createState() => _MyAppBaseState();
}

class _MyAppBaseState extends State<MyAppBase> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = _onBrightnessChanged;
  }

  void _onBrightnessChanged() {
    setState(() {
      themeData = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark
          ? themeDatadark
          : themeDatalight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global( 
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), 
          Locale('fr'), 
        ],
        title: 'Église de Ville',
        debugShowCheckedModeBanner: false,
        darkTheme: themeDatadark,
        theme: themeData,
        home: const Scaffold(
          resizeToAvoidBottomInset: true,
          body: SplashScreenEDV(),  
        ),
      ),
    );
  }
}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', 
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
