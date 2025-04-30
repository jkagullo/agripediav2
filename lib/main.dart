import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:agripediav3/Authentication/login_screen.dart';
import 'package:agripediav3/HomePage/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'WorkManager/work_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  try{
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    Workmanager().registerPeriodicTask(
      "cropMonitorTask",
      "checkCropStatus",
      frequency: const Duration(minutes: 15),
    );
    print("Work manager initialized");
  } catch (e) {
    print("Work manager initialization failed $e");
  }

  await requestNotificationPermission();
  print("requested notification permission");

  await initializeNotifications();
  print("initialized notifications");

  runApp(const MyApp());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await createNotificationChannel();
}

Future<void> createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'Agripedia', // id
    'Crop Status Alerts', // name
    description: 'Notifications about your crop status.',
    importance: Importance.high,
  );

  final androidNotifications =
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  if (androidNotifications != null) {
    await androidNotifications.createNotificationChannel(channel);
  }
}

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied){
    await Permission.notification.request();
  }
}

Future<void> sendNotification(String cropName, String status) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'Agripedia', // id
    'Crop Status Alerts', // name
    channelDescription: 'You have crop notification!',
    importance: Importance.high,
    priority: Priority.high,
    showWhen: true,
  );

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  await flutterLocalNotificationsPlugin.show(
    notificationId, // Notification ID
    'Crop Status Alert',
    'Your crop "$cropName" has a status of $status!',
    platformChannelSpecifics,
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<User?> _checkAuthState() async {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _checkAuthState(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasData){
            return MyHomePage();
          }  else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
