import 'package:flutter/material.dart';
import 'package:agripediav3/Weather/weather_widget.dart';
import 'package:agripediav3/Profile/profile_widget.dart';
import 'package:agripediav3/CropSummary/summary_widget.dart';
import 'package:agripediav3/TasksList/tasks_widget.dart';
import 'package:agripediav3/Components/add_crop_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[50],
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                  "assets/images/splash_icon.png",
                  height: 50,
              ),
            ),
          ],
        ),
      ),
      body: Center(
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
              onTap: (){
              },
              text: 'Add Crop',
            ),
          ],
        ),
      ),
    );
  }
}
