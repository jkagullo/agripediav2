import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisPage extends StatefulWidget {
  final String cropId;

  const AnalysisPage({required this.cropId, Key? key}) : super(key: key);

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  bool isLoading = true;
  String? hardwareId;
  List<Map<String, dynamic>> dateDocuments = [];
  Map<String, dynamic>? selectedDateData;
  String? cropName;
  String selectedChartType = 'Daily'; // Default to daily

  @override
  void initState() {
    super.initState();
    fetchCropName();
    fetchDateDocuments();
  }

  Future<void> fetchCropName() async {
    try {
      DocumentSnapshot cropDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('crops')
          .doc(widget.cropId)
          .get();

      setState(() {
        cropName = cropDoc['cropName'];
      });
    } catch (e) {
      print('Error fetching crop name: $e');
    }
  }

  Future<void> fetchDateDocuments() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Fetch hardwareID from crop document
      DocumentSnapshot cropSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('crops')
          .doc(widget.cropId)
          .get();

      if (!cropSnapshot.exists) throw Exception("Crop not found.");

      hardwareId = cropSnapshot['hardwareID'];

      if (hardwareId == null) throw Exception("HardwareID not found.");

      // Fetch all date documents sorted by date
      QuerySnapshot datesSnapshot = await FirebaseFirestore.instance
          .collection('Analysis2')
          .doc(hardwareId)
          .collection('dates')
          .orderBy('date') // Oldest first
          .get();

      setState(() {
        dateDocuments = datesSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        if (dateDocuments.isNotEmpty) {
          selectedDateData = dateDocuments.first; // Default to the oldest date
        }
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching date documents: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  List<FlSpot> getChartSpots() {
    List<FlSpot> spots = [];
    switch (selectedChartType) {
      case 'Daily':
        spots = List.generate(dateDocuments.length, (index) {
          final data = dateDocuments[index];
          return FlSpot(
            index.toDouble(),
            data['daily_overall_status'] ?? 0.0,
          );
        });
        break;

      case 'Weekly':
        for (int i = 0; i < dateDocuments.length; i += 7) {
          final weekDocs = dateDocuments.sublist(i, i + 7 > dateDocuments.length ? dateDocuments.length : i + 7);
          final lastDoc = weekDocs.last;
          spots.add(FlSpot(
            (i / 7).toDouble(),
            lastDoc['weekly_overall_status'] ?? _calculateAverage(weekDocs, 'daily_overall_status'),
          ));
        }
        break;

      case 'Monthly':
        Map<String, List<double>> monthlyData = {};
        for (var doc in dateDocuments) {
          final date = DateTime.parse(doc['date']);
          final monthKey = "${date.year}-${date.month}";
          if (!monthlyData.containsKey(monthKey)) {
            monthlyData[monthKey] = [];
          }
          monthlyData[monthKey]!.add(doc['daily_overall_status'] ?? 0.0);
        }

        int index = 0;
        monthlyData.forEach((key, values) {
          double average = values.reduce((a, b) => a + b) / values.length;
          spots.add(FlSpot(index.toDouble(), average));
          index++;
        });
        break;
    }
    return spots;
  }

  double _calculateAverage(List<Map<String, dynamic>> docs, String field) {
    double sum = 0;
    int count = 0;
    for (var doc in docs) {
      if (doc[field] != null) {
        sum += doc[field];
        count++;
      }
    }
    return count > 0 ? sum / count : 0.0;
  }

  void onSpotSelected(int index) {
    if (selectedChartType == 'Weekly') {
      // Map the index back to the last document of that week
      int start = index * 7;
      int end = start + 7 > dateDocuments.length ? dateDocuments.length : start + 7;
      setState(() {
        selectedDateData = dateDocuments[end - 1];
      });
    } else {
      setState(() {
        selectedDateData = dateDocuments[index];
        print("selected date data: $selectedDateData");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[50],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash_icon.png', height: 50),
            SizedBox(width: 60),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : dateDocuments.isEmpty
          ? Center(child: Text('No data available.'))
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: selectedChartType,
            items: ['Daily', 'Weekly', 'Monthly']
                .map((type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedChartType = value;
                });
              }
            },
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      axisNameWidget: Text("Overall Status"),
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: getChartSpots(),
                      isCurved: true,
                      color: Colors.lightGreen[600],
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.lightGreen[200]!.withOpacity(0.5),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                      if (event is FlTapUpEvent && response?.lineBarSpots != null) {
                        final spotIndex = response!.lineBarSpots!.first.spotIndex;
                        onSpotSelected(spotIndex);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: selectedDateData == null
                    ? Text('Select a data point to view details.')
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Analysis for $cropName",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      "Date: ${selectedDateData!['date'] ?? 'Unknown'}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Overall Status: ${selectedDateData!['overall_status'] ?? 'Not available yet.'}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                        ),
                        Tooltip(
                          message: "Overall status is calculated based on the daily, weekly, and monthly status.",
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.lightGreen[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily overall status: ${selectedDateData!['daily_overall_status'] ?? 'Not available yet.'}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Tooltip(
                          message: "Daily overall status is calculated based on the daily mean.",
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.lightGreen[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly overall status: ${selectedDateData!['weekly_overall_status'] ?? 'Not available yet.'}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Tooltip(
                          message: "Weekly overall status is calculated based on the weekly mean.",
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.lightGreen[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly overall status: ${selectedDateData!['monthly_overall_status'] ?? 'Not available yet.'}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Tooltip(
                          message: "Monthly overall status is calculated based on the monthly mean.",
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.lightGreen[600],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      "Soil Moisture 1",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture1_daily_mean'] != null
                              ? selectedDateData!['soilMoisture1_daily_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture1_rate_change'] != null
                              ? selectedDateData!['soilMoisture1_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture1_daily_status'] != null
                              ? selectedDateData!['soilMoisture1_daily_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture1_weekly_mean'] != null
                              ? selectedDateData!['soilMoisture1_weekly_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture1_weekly_rate_change'] != null
                              ? selectedDateData!['soilMoisture1_weekly_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture1_weekly_status'] != null
                              ? selectedDateData!['soilMoisture1_weekly_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly std",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture1_weekly_std'] != null
                              ? selectedDateData!['soilMoisture1_weekly_std'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture1_monthly_mean'] != null
                              ? selectedDateData!['soilMoisture1_monthly_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture1_monthly_rate_change'] != null
                              ? selectedDateData!['soilMoisture1_monthly_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture1_monthly_status'] != null
                              ? selectedDateData!['soilMoisture1_monthly_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly std",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture1_monthly_std'] != null
                              ? selectedDateData!['soilMoisture1_monthly_std'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      "Soil Moisture 2",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture2_daily_mean'] != null
                              ? selectedDateData!['soilMoisture2_daily_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture2_daily_rate_change'] != null
                              ? selectedDateData!['soilMoisture2_daily_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture2_daily_status'] != null
                              ? selectedDateData!['soilMoisture2_daily_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture2_weekly_mean'] != null
                              ? selectedDateData!['soilMoisture2_weekly_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture2_weekly_rate_change'] != null
                              ? selectedDateData!['soilMoisture2_weekly_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture2_weekly_status'] != null
                              ? selectedDateData!['soilMoisture2_weekly_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly std",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture2_weekly_std'] != null
                              ? selectedDateData!['soilMoisture2_weekly_std'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture2_monthly_mean'] != null
                              ? selectedDateData!['soilMoisture2_monthly_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture2_monthly_rate_change'] != null
                              ? selectedDateData!['soilMoisture2_monthly_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture2_monthly_status'] != null
                              ? selectedDateData!['soilMoisture2_monthly_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly std",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture2_monthly_std'] != null
                              ? selectedDateData!['soilMoisture2_monthly_std'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      "Soil Moisture 3",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture3_daily_mean'] != null
                              ? selectedDateData!['soilMoisture3_daily_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture3_daily_rate_change'] != null
                              ? selectedDateData!['soilMoisture3_daily_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture3_daily_status'] != null
                              ? selectedDateData!['soilMoisture3_daily_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture3_weekly_mean'] != null
                              ? selectedDateData!['soilMoisture3_weekly_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture3_weekly_rate_change'] != null
                              ? selectedDateData!['soilMoisture3_weekly_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture3_weekly_status'] != null
                              ? selectedDateData!['soilMoisture3_weekly_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly std",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture3_weekly_std'] != null
                              ? selectedDateData!['soilMoisture3_weekly_std'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture3_monthly_mean'] != null
                              ? selectedDateData!['soilMoisture3_monthly_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture3_monthly_rate_change'] != null
                              ? selectedDateData!['soilMoisture3_monthly_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture3_monthly_status'] != null
                              ? selectedDateData!['soilMoisture3_monthly_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly std",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['soilMoisture3_monthly_std'] != null
                              ? selectedDateData!['soilMoisture3_monthly_std'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      "Temperature",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['temperature_daily_mean'] != null
                              ? selectedDateData!['temperature_daily_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['temperature_daily_rate_change'] != null
                              ? selectedDateData!['temperature_daily_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['temperature_daily_status'] != null
                              ? selectedDateData!['temperature_daily_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['temperature_weekly_mean'] != null
                              ? selectedDateData!['temperature_weekly_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['temperature_weekly_rate_change'] != null
                              ? selectedDateData!['temperature_weekly_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['temperature_weekly_status'] != null
                              ? selectedDateData!['temperature_weekly_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly std",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['temperature_weekly_std'] != null
                              ? selectedDateData!['temperature_weekly_std'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['temperature_monthly_mean'] != null
                              ? selectedDateData!['temperature_monthly_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['temperature_monthly_rate_change'] != null
                              ? selectedDateData!['temperature_monthly_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['temperature_monthly_status'] != null
                              ? selectedDateData!['temperature_monthly_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly std",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['temperature_monthly_std'] != null
                              ? selectedDateData!['temperature_monthly_std'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      "Humidity",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['humidity_daily_mean'] != null
                              ? selectedDateData!['humidity_daily_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['humidity_daily_rate_change'] != null
                              ? selectedDateData!['humidity_daily_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['humidity_daily_status'] != null
                              ? selectedDateData!['humidity_daily_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['humidity_weekly_mean'] != null
                              ? selectedDateData!['humidity_weekly_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['humidity_weekly_rate_change'] != null
                              ? selectedDateData!['humidity_weekly_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['humidity_weekly_status'] != null
                              ? selectedDateData!['humidity_weekly_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly std",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['humidity_weekly_std'] != null
                              ? selectedDateData!['humidity_weekly_std'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['humidity_monthly_mean'] != null
                              ? selectedDateData!['humidity_monthly_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['humidity_monthly_rate_change'] != null
                              ? selectedDateData!['humidity_monthly_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['humidity_monthly_status'] != null
                              ? selectedDateData!['humidity_monthly_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly std",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['humidity_monthly_std'] != null
                              ? selectedDateData!['humidity_monthly_std'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      "Light Intensity",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['lightIntensity_daily_mean'] != null
                              ? selectedDateData!['lightIntensity_daily_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['lightIntensity_daily_rate_change'] != null
                              ? selectedDateData!['lightIntensity_daily_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['lightIntensity_daily_status'] != null
                              ? selectedDateData!['lightIntensity_daily_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['lightIntensity_weekly_mean'] != null
                              ? selectedDateData!['lightIntensity_weekly_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['lightIntensity_weekly_rate_change'] != null
                              ? selectedDateData!['lightIntensity_weekly_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['lightIntensity_weekly_status'] != null
                              ? selectedDateData!['lightIntensity_weekly_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly std",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['lightIntensity_weekly_std'] != null
                              ? selectedDateData!['lightIntensity_weekly_std'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly mean",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['lightIntensity_monthly_mean'] != null
                              ? selectedDateData!['lightIntensity_monthly_mean'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly rate change",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['lightIntensity_monthly_rate_change'] != null
                              ? selectedDateData!['lightIntensity_monthly_rate_change'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly status",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['lightIntensity_monthly_status'] != null
                              ? selectedDateData!['lightIntensity_monthly_status'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly std",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedDateData!['lightIntensity_monthly_std'] != null
                              ? selectedDateData!['lightIntensity_monthly_std'].toString()
                              : 'Not available yet.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
