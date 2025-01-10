import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../TasksList/tasks_widget.dart';
import '../main.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Fetch crops
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cropsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('crops')
          .get();

      for (var cropDoc in cropsSnapshot.docs) {
        final cropData = cropDoc.data();
        final hardwareID = cropData['hardwareID'];
        final cropName = cropData['cropName'];

        // Fetch latest live data
        final liveData = await fetchLiveData(hardwareID);
        if (liveData.isNotEmpty) {
          print("notification has live data");
          final soil = liveData['soilMoisture1'] ?? 0.0;
          final temperature = liveData['temperature'] ?? 0.0;
          final light = liveData['lightIntensity'] ?? 0.0;
          final humidity = liveData['humidity'] ?? 0.0;

          // Evaluate crop status
          final status = FuzzyLogic.getPlantCondition(
            rawSoilMoisture: soil,
            rawTemperature: temperature,
            rawHumidity: humidity,
            rawLight: light,
          );

          if (status == "Very Bad" || status == "Bad") {
            // Send notification
            sendNotification(cropName, status);
          }
        }
      }
    }
    return Future.value(true);
  });
}

// Fetch live data function (same as in TasksWidget)
Future<Map<String, dynamic>> fetchLiveData(String hardwareID) async {
  try {
    QuerySnapshot dateSnapshot = await FirebaseFirestore.instance
        .collection(hardwareID)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (dateSnapshot.docs.isNotEmpty) {
      return dateSnapshot.docs.first.data() as Map<String, dynamic>;
    }
  } catch (e) {
    print("Error fetching live data: $e");
  }
  return {};
}
