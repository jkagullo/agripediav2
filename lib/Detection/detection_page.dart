import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  final String dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[50],
        title: Text(
          'Disease Detection History',
          style: TextStyle(
            color: Colors.lightGreen[900],
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData) {
            return const Center(
              child: Text('No user is currently logged in.'),
            );
          }

          final String userID = userSnapshot.data!.uid;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userID)
                .collection('crops')
                .snapshots(),
            builder: (context, cropSnapshot) {
              if (cropSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!cropSnapshot.hasData || cropSnapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No crops available.'));
              }

              final crops = cropSnapshot.data!.docs;

              return ListView.builder(
                itemCount: crops.length,
                itemBuilder: (context, cropIndex) {
                  final cropData = crops[cropIndex].data() as Map<String, dynamic>;
                  final cropName = cropData['cropName'];
                  final hardwareID = cropData['hardwareID'];

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Detection')
                        .doc(hardwareID)
                        .collection('2025-01-01') // Fetch for today's date
                        .snapshots(),
                    builder: (context, detectionSnapshot) {
                      if (detectionSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!detectionSnapshot.hasData || detectionSnapshot.data!.docs.isEmpty) {
                        return SizedBox.shrink(); // Skip rendering if no detection data
                      }

                      final detections = detectionSnapshot.data!.docs;

                      return ExpansionTile(
                        title: Text(
                          cropName,
                          style: TextStyle(
                            color: Colors.lightGreen[900],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Detection Date: $dateNow",
                          style: TextStyle(
                            color: Colors.lightGreen[900],
                            fontSize: 14,
                          ),
                        ),
                        children: detections.map((detectionDoc) {
                          final detectionData = detectionDoc.data() as Map<String, dynamic>;
                          final cropBoxes = detectionData.entries
                              .where((entry) => entry.key.contains('crop_box'))
                              .toList();

                          return Column(
                            children: cropBoxes.map((entry) {
                              final boxData = entry.value as Map<String, dynamic>;
                              final imageUrl = boxData['croppedImageUrl1'] ?? boxData['croppedImageUrl2'];
                              final result = boxData['result'] ?? 'Unknown';

                              return ListTile(
                                leading: imageUrl != null
                                    ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                                    : Icon(Icons.image, color: Colors.grey),
                                title: Text(
                                  entry.key,
                                  style: TextStyle(
                                    color: Colors.lightGreen[900],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "Result: $result",
                                  style: TextStyle(
                                    color: Colors.lightGreen[900],
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: Text(
                                  detectionDoc.id,
                                  style: TextStyle(
                                    color: Colors.lightGreen[900],
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
