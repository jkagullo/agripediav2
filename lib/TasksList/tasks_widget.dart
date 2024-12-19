import 'package:agripediav3/FuzzyLogic/fuzzy_db.dart';
import 'package:flutter/material.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({super.key});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late Future<List<Map<String, dynamic>>> cropFuture;

  @override
  void initState() {
    super.initState();
    cropFuture = fetchCropForTask();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          height: 200,
          width: 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.lightGreen[600],
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                getTaskTemp(),
              ],
            ),
          ),
        )
    );
  }

  Widget getTaskTemp(){
    return Container(
      padding: EdgeInsets.all(10.0),
      height: 85,
      width: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.lightGreen[700],
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crop name',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Status: Temperature is below 10%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Text(
            'Task: Move crop to a warmer location',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
