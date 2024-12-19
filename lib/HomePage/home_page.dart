import 'dart:io';
import 'package:agripediav3/Dashboard/dashboard_select.dart';
import 'package:flutter/material.dart';
import 'package:agripediav3/Weather/weather_widget.dart';
import 'package:agripediav3/Profile/profile_widget.dart';
import 'package:agripediav3/CropSummary/summary_widget.dart';
import 'package:agripediav3/TasksList/tasks_widget.dart';
import 'package:agripediav3/Components/add_crop_button.dart';
import 'package:agripediav3/Analysis/analysis_page.dart';
import 'package:agripediav3/Profile/profile_page.dart';
import '../DatabaseService/add_crop_dialog.dart';
import 'package:agripediav3/Detection/detection_page.dart';
import 'package:agripediav3/Analysis/analysis_select.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  // Initialize widgetList directly
  final List<Widget> widgetList = [
    HomePageContent(),
    AnalysisSelect(),
    DashboardSelect(),
    DetectionPage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[50],
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
      body: widgetList[selectedIndex], // Use widgetList here safely
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lightGreen[900],
        unselectedItemColor: Colors.lightGreen[900],
        backgroundColor: Colors.lightGreen[50],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.energy_savings_leaf_rounded),
            label: 'Detection',
          ),
        ],
      ),
      floatingActionButton: selectedIndex == 0
        ? FloatingActionButton(
        backgroundColor: Colors.lightGreen[50],
        onPressed: () {
          // define the FAB action here
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
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AddCropDialog(),
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
                          Icon(
                            Icons.add,
                            color: Colors.lightGreen[900],
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AddCropDialog(),
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
                          Icon(
                            Icons.qr_code,
                            color: Colors.lightGreen[900],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}

// Separate widget to hold the content of the home page
class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            WeatherWidget(),
            const SizedBox(height: 10),
            ProfileWidget(),
            const SizedBox(height: 10),
            SummaryWidget(),
            const SizedBox(height: 10),
            TasksWidget(),
            const SizedBox(height: 10),
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
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                          ),
                      ),
                            onPressed: () {
                              Navigator.pop(context); // Close bottom sheet
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AddCropDialog(),
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
                                Icon(
                                    Icons.add,
                                    color: Colors.lightGreen[900],
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context); // Close bottom sheet
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AddCropDialog(),
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
                                Icon(
                                    Icons.qr_code,
                                    color: Colors.lightGreen[900],
                                ),
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
