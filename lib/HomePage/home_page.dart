import 'dart:io';
import 'package:agripediav3/Dashboard/dashboard_select.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agripediav3/Weather/weather_widget.dart';
import 'package:agripediav3/Profile/profile_widget.dart';
import 'package:agripediav3/CropSummary/summary_widget.dart';
import 'package:agripediav3/TasksList/tasks_widget.dart';
import 'package:agripediav3/Components/add_crop_button.dart';
import 'package:agripediav3/Analysis/analysis_page.dart';
import 'package:agripediav3/Profile/profile_page.dart';
import 'package:image_picker/image_picker.dart';
import '../Cropedia/cropedia.dart';
import '../DatabaseService/add_crop_dialog.dart';
import 'package:agripediav3/Detection/detection_page.dart';
import 'package:agripediav3/Analysis/analysis_select.dart';
import '../DatabaseService/add_crop_qr.dart';
import '../Detection/detection_model.dart';
import '../Settings/settings_page.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  final List<Widget> widgetList = [
    HomePageContent(),
    AnalysisSelect(),
    DashboardSelect(),
    DetectionPage(),
    Cropedia(),
    SettingsPage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<List<Map<String, dynamic>>> fetchUserCrops() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return [];
    }

    final cropsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('crops')
        .get();

    return cropsSnapshot.docs.map((doc) {
      return {
        "cropName": doc['cropName'],
        "hardwareID": doc['hardwareID'],
        "imageUrl": doc['imageUrl'],
      };
    }).toList();
  }

  final picker = ImagePicker();

  void _selectCropForDetection(
      List<Map<String, dynamic>> crops, String detectionMethod) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.lightGreen[50],
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Crop for Disease Detection",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen[900],
                  ),
                ),
                const SizedBox(height: 10),
                ...crops.map(
                      (crop) => ListTile(
                    leading: crop['imageUrl'] != null
                        ? Image.network(crop['imageUrl'], height: 50, width: 50)
                        : Icon(Icons.agriculture, color: Colors.lightGreen[900]),
                    title: Text(
                      crop['cropName'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.lightGreen[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text("Hardware ID: ${crop['hardwareID']}", style: TextStyle(color: Colors.lightGreen[900]),),
                    onTap: () {
                      Navigator.pop(context);
                      _startDetection(crop, detectionMethod);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _startDetection(Map<String, dynamic> crop, String detectionMethod) {
    if (detectionMethod == 'camera') {
      _detectUsingCamera(crop['hardwareID']);
    } else if (detectionMethod == 'gallery') {
      _detectFromGallery(crop['hardwareID']);
    }
  }

  void _detectUsingCamera(String hardwareID) async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxHeight: 256,
      maxWidth: 256,
    );
    if (pickedFile != null) {
      _processImage(File(pickedFile.path), hardwareID);
    }
  }

  void _detectFromGallery(String hardwareID) async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 256,
      maxWidth: 256,
    );
    if (pickedFile != null) {
      _processImage(File(pickedFile.path), hardwareID);
    }
  }

  void _processImage(File imageFile, String hardwareID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetectionScreen(imageFile: imageFile, hardwareID: hardwareID),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[100],
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/splash_icon.png",
              height: 50,
            ),
          ],
        ),
      ),
      body: widgetList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lightGreen[900],
        unselectedItemColor: Colors.lightGreen[900],
        backgroundColor: Colors.grey[700],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.lightGreen[50],
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Analysis',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.energy_savings_leaf_rounded),
            label: 'Detection',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: 'Cropedia',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
        backgroundColor: Colors.lightGreen[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () async {
          final crops = await fetchUserCrops();

          if (crops.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("No crops found to detect"),
              ),
            );
            return;
          }
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.lightGreen[50],
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _selectCropForDetection(crops, "camera");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Detect using camera",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.lightGreen[900],
                            ),
                          ),
                          Icon(Icons.camera,
                              color: Colors.lightGreen[900]),
                        ],
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _selectCropForDetection(crops, "gallery");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Choose from gallery",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.lightGreen[900],
                            ),
                          ),
                          Icon(Icons.image,
                              color: Colors.lightGreen[900]),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.camera_alt, color: Colors.lightGreen[900],),
      )
          : null,
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero, // Remove any default padding
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            WeatherWidget(),
            const SizedBox(height: 15),
            ProfileWidget(),
            const SizedBox(height: 15),
            SummaryWidget(),
            const SizedBox(height: 15),
            TasksWidget(),
            const SizedBox(height: 15),
            AddCropButton(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.lightGreen[50],
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(20),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    AddCropDialog(),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Add Manually",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.lightGreen[900],
                                  ),
                                ),
                                Icon(Icons.add,
                                    color: Colors.lightGreen[900]),
                              ],
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(20),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    AddCropQR(),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Add using QR Code",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.lightGreen[900],
                                  ),
                                ),
                                Icon(Icons.qr_code,
                                    color: Colors.lightGreen[900]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              text: 'Add Crop',
            ),
          ],
        ),
      ),
    );
  }
}
