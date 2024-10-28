import 'package:flutter/material.dart';
import 'package:agripediav3/Weather/weather_widget.dart';
import 'package:agripediav3/Profile/profile_widget.dart';
import 'package:agripediav3/CropSummary/summary_widget.dart';
import 'package:agripediav3/TasksList/tasks_widget.dart';
import 'package:agripediav3/Components/add_crop_button.dart';
import 'package:agripediav3/Analysis/analysis_page.dart';
import 'package:agripediav3/Profile/profile_page.dart';

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
    AnalysisPage(),
    ProfilePage(),
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Separate widget to hold the content of the home page
class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
              // Add your crop addition logic here
            },
            text: 'Add Crop',
          ),
        ],
      ),
    );
  }
}
