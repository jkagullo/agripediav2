import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  final String dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.network(imageUrl),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[100],
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
                return Center(
                  child: Column(
                    children: [
                      LottieBuilder.asset(
                        'assets/lottie/cattu.json',
                        height: 150,
                        width: 150,
                      ),
                      Text(
                        "No crops found, add a crop to view crop detection history!",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.lightGreen[900],
                        ),
                      ),
                    ],
                  ),
                );
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
                        .collection('dates') // Get all dates documents
                        .snapshots(),
                    builder: (context, dateSnapshot) {
                      if (dateSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!dateSnapshot.hasData || dateSnapshot.data!.docs.isEmpty) {
                        return SizedBox.shrink(); // No detection data
                      }

                      final dateDocs = dateSnapshot.data!.docs;

                      return Column(
                        children: dateDocs.map((dateDoc) {
                          final dateData = dateDoc.data() as Map<String, dynamic>;
                          final date = dateDoc.id; // The date document ID

                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Detection')
                                .doc(hardwareID)
                                .collection('dates')
                                .doc(dateDoc.id) // Use the current date doc ID
                                .collection('hours') // Fetch all hour documents for this date
                                .orderBy('createdAt', descending: true) // Sort by time (optional)
                                .snapshots(),
                            builder: (context, hourSnapshot) {
                              if (hourSnapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (!hourSnapshot.hasData || hourSnapshot.data!.docs.isEmpty) {
                                return const SizedBox.shrink(); // No hours data for this date
                              }

                              final hourDocs = hourSnapshot.data!.docs;

                              return ExpansionTile(
                                title: Text(
                                  '$cropName - Date: $date', // Display crop name with date
                                  style: TextStyle(
                                    color: Colors.lightGreen[900],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                children: hourDocs.map((hourDoc) {
                                  final detectionData = hourDoc.data() as Map<String, dynamic>;

                                  // Handle the hardware format (image, result, etc.)
                                  final imageUrl = detectionData['image'] ?? '';
                                  final result = detectionData['result'] ?? 'Unknown';

                                  return ListTile(
                                    leading: GestureDetector(
                                      onTap: () {
                                        _showImageDialog(imageUrl);
                                      },
                                      child: imageUrl.isNotEmpty
                                          ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                                          : Icon(Icons.image, color: Colors.lightGreen[900]),
                                    ),
                                    title: Text(
                                      'Result: $result',
                                      style: TextStyle(
                                        color: Colors.lightGreen[900],
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Detected at: ${detectionData['createdAt'] != null ? DateFormat('h:mm a').format((detectionData['createdAt'] as Timestamp).toDate()) : 'N/A'}',
                                      style: TextStyle(
                                        color: Colors.lightGreen[900],
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
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
