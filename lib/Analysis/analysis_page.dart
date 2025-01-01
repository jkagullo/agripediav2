import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnalysisPage extends StatefulWidget {
  final String cropId;
  const AnalysisPage({Key? key, required this.cropId}) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  String? cropName;
  String selectedRange = 'daily'; // Default range
  Map<String, List<FlSpot>> mockData = {
    'daily': [
      FlSpot(1, 10),
      FlSpot(2, 12),
      FlSpot(3, 9),
      FlSpot(4, 14),
      FlSpot(5, 13),
      FlSpot(6, 10),
      FlSpot(7, 15),
    ],
    'weekly': [
      FlSpot(1, 50),
      FlSpot(2, 65),
      FlSpot(3, 70),
      FlSpot(4, 55),
      FlSpot(5, 60),
      FlSpot(6, 75),
      FlSpot(7, 80),
    ],
    'monthly': [
      FlSpot(1, 200),
      FlSpot(5, 300),
      FlSpot(10, 250),
      FlSpot(15, 400),
      FlSpot(20, 350),
      FlSpot(25, 300),
      FlSpot(30, 450),
    ],
  };

  @override
  void initState() {
    super.initState();
    fetchCropName();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Analysis for ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen[900],
                    ),
                  ),
                  Text(
                    cropName ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen[900],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: DropdownButton<String>(
                  value: selectedRange,
                  onChanged: (value) {
                    setState(() {
                      selectedRange = value!;
                    });
                  },
                  items: ['daily', 'weekly', 'monthly']
                      .map((range) => DropdownMenuItem(
                    value: range,
                    child: Text(range.toUpperCase()),
                  ))
                      .toList(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        axisNameWidget: Text("Temperature"),
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toInt().toString());
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: mockData[selectedRange] ?? [],
                        isCurved: true,
                        barWidth: 2,
                        color: Colors.green,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.green.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Daily Overall Status'),
                            Text('16.66'),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Weekly Overall Status'),
                            Text('NaN'),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Monthly Overall Status'),
                            Text('NaN'),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Overall Status'),
                            Text('16.66'),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Soil Moisture 1",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Daily Mean'),
                                SizedBox(height: 20),
                                Text("75"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Daily Rate Change'),
                                SizedBox(height: 20),
                                Text("0.59"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Daily Status'),
                                SizedBox(height: 20),
                                Text("Bad"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Monthly Mean'),
                                SizedBox(height: 20),
                                Text("NaN"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Monthly Rate Change'),
                                SizedBox(height: 20),
                                Text("NaN"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Monthly Status'),
                                SizedBox(height: 20),
                                Text("NaN"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Monthly Std'),
                                SizedBox(height: 20),
                                Text("NaN"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Weekly Mean'),
                                SizedBox(height: 20),
                                Text("NaN"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Weekly Rate Change'),
                                SizedBox(height: 20),
                                Text("NaN"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Weekly Status'),
                                SizedBox(height: 20),
                                Text("NaN"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Weekly Std'),
                                SizedBox(height: 20),
                                Text("NaN"),
                              ],
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}