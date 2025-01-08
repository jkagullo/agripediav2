import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agripediav3/FuzzyLogic/fuzzy_logic.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({super.key});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late Future<List<Map<String, dynamic>>> cropsFuture;

  @override
  void initState() {
    super.initState();
    cropsFuture = fetchCropForTask();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: cropsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No crops available."));
          }

          final crops = snapshot.data!;

          return ListView.builder(
            shrinkWrap: true,
            itemCount: crops.length,
            itemBuilder: (context, index) {
              final crop = crops[index];
              return FutureBuilder<Map<String, dynamic>>(
                future: fetchLiveData(crop['hardwareID']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: Text('No live data available.'));
                  }

                  final liveData = snapshot.data!;
                  final soil = liveData['soilMoisture1'] ?? 0.0;
                  final temperature = liveData['temperature'] ?? 0.0;
                  final light = liveData['lightIntensity'] ?? 0.0;
                  final humidity = liveData['humidity'] ?? 0.0;

                  print("==========================================");
                  print("Task Verify for crop: ${crop['cropName']}");
                  print("Soil: $soil");
                  print("Temperature: $temperature");
                  print("Light: $light");
                  print("Humidity: $humidity");

                  final soilRecommendation = FuzzyLogic.getSoilMoistureRecommendation(soil);
                  final temperatureRecommendation = FuzzyLogic.getTemperatureRecommendation(temperature);
                  final lightRecommendation = FuzzyLogic.getLightRecommendation(light);
                  final humidityRecommendation = FuzzyLogic.getHumidityRecommendation(humidity);

                  final status = FuzzyLogic.getPlantCondition(
                    rawSoilMoisture: soil,
                    rawTemperature: temperature,
                    rawHumidity: humidity,
                    rawLight: light,
                  );

                  if (soilRecommendation.isNotEmpty ||
                      temperatureRecommendation.isNotEmpty ||
                      lightRecommendation.isNotEmpty ||
                      humidityRecommendation.isNotEmpty) {
                    return CropTaskCard(
                      cropName: crop['cropName'],
                      status: status,
                      task: [
                        if (soilRecommendation.isNotEmpty) "Soil: $soilRecommendation",
                        if (temperatureRecommendation.isNotEmpty) "Temperature: $temperatureRecommendation",
                        if (lightRecommendation.isNotEmpty) "Light: $lightRecommendation",
                        if (humidityRecommendation.isNotEmpty) "Humidity: $humidityRecommendation",
                      ].join("\n"),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }


  Future<List<Map<String, dynamic>>> fetchCropForTask() async {
    try {
      final cropsQuery = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('crops')
          .get();

      if (cropsQuery.docs.isEmpty) {
        debugPrint("No crops found for the user.");
        return [];
      }

      final crops = cropsQuery.docs.map((doc) {
        return {
          'cropID': doc.id,
          'cropName': doc['cropName'],
          'hardwareID': doc['hardwareID'],
        };
      }).toList();

      return crops;
    } catch (e) {
      debugPrint("Error fetching crops: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchLiveData(String hardwareID) async {
    try {
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      print("Today's date: $todayDate");

      QuerySnapshot dateSnapshot = await FirebaseFirestore.instance
          .collection(hardwareID) // Directly access the hardwareID collection
          .orderBy('createdAt', descending: true) // Sort by createdAt in descending order
          .limit(1) // Get the latest document
          .get();

      print("Data found for hardwareID: $hardwareID on date: $todayDate");

      if (dateSnapshot.docs.isEmpty) {
        print("No data found for hardwareID: $hardwareID on date: $todayDate");
        return {};
      }

      DocumentSnapshot latestDataDoc = dateSnapshot.docs.first;
      return latestDataDoc.data() as Map<String, dynamic>;
    } catch (e) {
      debugPrint("Error fetching live data: $e");
      return {};
    }
  }
}

class CropTaskCard extends StatelessWidget {
  final String cropName;
  final String status;
  final String task;

  const CropTaskCard({
    required this.cropName,
    required this.status,
    required this.task,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 0.01,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Card(
        color: Colors.lightGreen[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cropName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen[900],
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Status: $status',
                style: TextStyle(
                  color: Colors.lightGreen[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 12.0),
              if (task.isNotEmpty) ...[
                if (task.contains("Soil:")) _buildTaskRow(
                    Icons.grass, task.split("Soil:")[1].split("\n")[0].trim()),
                if (task.contains("Temperature:")) _buildTaskRow(Icons.thermostat, task.split("Temperature:")[1].split("\n")[0].trim()),
                if (task.contains("Light:")) _buildTaskRow(Icons.wb_sunny, task.split("Light:")[1].split("\n")[0].trim()),
                if (task.contains("Humidity:")) _buildTaskRow(Icons.water_drop, task.split("Humidity:")[1].split("\n")[0].trim()),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskRow(IconData icon, String recommendation) {
    return Row(
      children: [
        Icon(icon, color: Colors.lightGreen[900]),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            recommendation,
            style: TextStyle(
              color: Colors.lightGreen[900],
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

}

class FuzzyLogic {

  static String getSoilMoistureRecommendation(num rawSoilMoisture) {
    if (rawSoilMoisture < 30) {
      return "Crop needs water";
    } else if (rawSoilMoisture >= 30 && rawSoilMoisture < 40) {
      return "Water crop moderately";
    } else if (rawSoilMoisture >= 50 && rawSoilMoisture <= 70) {
      return "Maintain current watering habit";
    } else if (rawSoilMoisture >= 50 && rawSoilMoisture <= 80) {
      return "Reduce watering frequency";
    } else if (rawSoilMoisture > 80) {
      return "Stop watering to avoid water logging";
    } else {
      return "Moisture level unknown";
    }
  }

  static String getSoilMoistureStatus(rawSoilMoisture) {

    if (rawSoilMoisture < 30) {
      return "Soil moisture is very low (30%)";
    } else if (rawSoilMoisture >= 30 && rawSoilMoisture < 40) {
      return "Soil moisture is low (30% - 40%)";
    } else if (rawSoilMoisture >= 50 && rawSoilMoisture <= 70) {
      return "Soil moisture is optimal (50% - 70%)";
    } else if (rawSoilMoisture >= 70 && rawSoilMoisture <= 80) {
      return "Soil moisture is high (70% - 80%)";
    } else if (rawSoilMoisture > 80) {
      return "Soil moisture is very high (above 80%)";
    } else {
      return "Moisture level unknown";
    }
  }

  static String getTemperatureRecommendation(num temperature) {
    if (temperature < 15) {
      return "Increase temperature";
    } else if (temperature >= 15 && temperature <= 25) {
      return "Maintain current temperature";
    } else if (temperature > 25) {
      return "Reduce temperature";
    } else {
      return "Temperature level unknown";
    }
  }

  static getTemperatureStatus(rawTemperature) {

    if (rawTemperature < 10) {
      return "Temperature is very low 10%";
    } else if (rawTemperature >= 10 && rawTemperature < 18) {
      return "Temperature is low (10°C - 17°C).";
    } else if (rawTemperature >= 18 && rawTemperature <= 26) {
      return "Temperature is optimal (18°C - 26°C).";
    } else if (rawTemperature > 26 && rawTemperature <= 35) {
      return "Temperature is high (27°C - 35°C).";
    } else {
      return "Temperature is above 35°C.";
    }
  }

  static String getLightRecommendation(num light) {
    if (light < 300) {
      return "Increase light exposure";
    } else if (light >= 300 && light <= 1000) {
      return "Maintain light exposure";
    } else {
      return "Too much light exposure";
    }
  }

  static String getLightStatus(rawLight) {

    if (rawLight <= 150) {
      return "Light intensity is very low";
    } else if (rawLight <= 200) {
      return "Light intensity is moderate";
    } else if (rawLight >= 280 && rawLight <= 350) {
      return "Light intensity is optimal";
    } else if (rawLight >= 350 && rawLight <= 450) {
      return "Light intensity is high";
    }  else {
      return "Light intensity is very high";
    }
  }

  static String getHumidityRecommendation(num humidity) {
    if (humidity < 40) {
      return "Increase humidity";
    } else if (humidity >= 40 && humidity <= 60) {
      return "Maintain current humidity";
    } else {
      return "Decrease humidity";
    }
  }

  static String getHumidityStatus(rawHumidity) {

    if (rawHumidity < 50) {
      return "Humidity is very low 50%";
    } else if (rawHumidity >= 50 && rawHumidity <= 70) {
      return "Humidity is in its optimal range (50% - 70%)";
    } else {
      return "Humidity is above 70%";
    }
  }

  static String getPlantCondition({
    required num rawSoilMoisture,
    required num rawTemperature,
    required num rawHumidity,
    required num rawLight,
  }) {
    String soilMoistureStatus = getSoilMoistureStatus(rawSoilMoisture);
    String tempStatus = getTemperatureStatus(rawTemperature);
    String humidityStatus = getHumidityStatus(rawHumidity);
    String lightStatus = getLightStatus(rawLight);

    print('Statuses -> Soil: $soilMoistureStatus, Temp: $tempStatus, Humidity: $humidityStatus, Light: $lightStatus');

    // Simplify conditions
    if (soilMoistureStatus.contains('very low') ||
        tempStatus.contains('very low') ||
        humidityStatus.contains('very low') ||
        lightStatus.contains('very low')) {
      return 'Very Bad';
    }

    if (soilMoistureStatus.contains('low') ||
        tempStatus.contains('low') ||
        humidityStatus.contains('low') ||
        lightStatus.contains('moderate')) {
      return 'Bad';
    }

    if (soilMoistureStatus.contains('optimal') &&
        tempStatus.contains('optimal') &&
        humidityStatus.contains('optimal') &&
        lightStatus.contains('optimal')) {
      return 'Excellent';
    }

    if ((soilMoistureStatus.contains('high') ||
        tempStatus.contains('high') ||
        humidityStatus.contains('high') ||
        lightStatus.contains('high')) &&
        !soilMoistureStatus.contains('very high')) {
      return 'Fair';
    }

    if (soilMoistureStatus.contains('very high') ||
        tempStatus.contains('above') ||
        humidityStatus.contains('above') ||
        lightStatus.contains('very high')) {
      return 'Poor';
    }

    return 'Unknown';
  }


}
