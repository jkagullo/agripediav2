import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agripediav3/FuzzyLogic/fuzzy_logic.dart';
import 'package:agripediav3/FuzzyLogic/fuzzy_db.dart';

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
              return CropTaskWidget(cropId: crop['cropID'], cropName: crop['cropName']);
            },
          );
        },
      ),
    );
  }
}

class CropTaskWidget extends StatelessWidget {
  final String cropId;
  final String cropName;

  const CropTaskWidget({super.key, required this.cropId, required this.cropName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('crops')
          .doc(cropId)
          .collection('liveData')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildTaskCard(
            cropName,
            "No live data available.",
            "N/A",
          );
        }

        final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
        final soil = data['soil'] ?? 0;
        final temperature = data['temperature'] ?? 0;
        final light = data['light'] ?? 0;
        final humidity = data['humidity'] ?? 0;

        final recommendation = FuzzyLogic.getSoilMoistureRecommendation(soil);
        final status = FuzzyLogic.getSoilMoistureStatus(soil);

        return _buildTaskCard(cropName, status, recommendation);
      },
    );
  }

  Widget _buildTaskCard(String name, String status, String task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.lightGreen[700],
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Status: $status",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            Text(
              "Task: $task",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
