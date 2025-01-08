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
                        .collection(dateNow) // Fetch for today's date
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, detectionSnapshot) {
                      if (detectionSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!detectionSnapshot.hasData || detectionSnapshot.data!.docs.isEmpty) {
                        print("Date now: $dateNow");
                        print('No detection data available for $cropName');
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

                          // Handle hardware format
                          final cropBoxes = detectionData.entries
                              .where((entry) => entry.key.contains('crop_box'))
                              .toList();

                          if (cropBoxes.isNotEmpty) {
                            // Hardware format detected
                            return Column(
                              children: cropBoxes.map((entry) {
                                final boxData = entry.value as Map<String, dynamic>;
                                final imageUrl = boxData['croppedImageUrl1'] ?? boxData['croppedImageUrl2'];
                                final result = boxData['result'] ?? 'Unknown';

                                return ListTile(
                                  leading: GestureDetector(
                                    onTap: () {
                                      _showImageDialog(imageUrl);
                                    },
                                    child: imageUrl != null
                                        ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                                        : Icon(Icons.image, color: Colors.lightGreen[900]),
                                  ),
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
                                    detectionData['createdAt'] != null
                                        ? DateFormat('h:mm a').format((detectionData['createdAt'] as Timestamp).toDate())
                                        : 'N/A',
                                    style: TextStyle(
                                      color: Colors.lightGreen[900],
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            // App format detected
                            final imageUrl = detectionData['image'] ?? '';
                            final result = detectionData['result'] ?? 'Unknown';

                            return ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  _showImageDialog(imageUrl);
                                },
                                child: imageUrl != null
                                    ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                                    : Icon(Icons.image, color: Colors.lightGreen[900]),
                              ),
                              title: Text(
                                cropName,
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
                                detectionData['createdAt'] != null
                                    ? DateFormat('h:mm a').format((detectionData['createdAt'] as Timestamp).toDate())
                                    : 'N/A',
                                style: TextStyle(
                                  color: Colors.lightGreen[900],
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }
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
