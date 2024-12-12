import 'package:flutter/material.dart';
import 'package:agripediav3/Analysis/analysis_page.dart';
import 'package:agripediav3/Analysis/analysis_db.dart';

class AnalysisSelect extends StatefulWidget {
  const AnalysisSelect({super.key});

  @override
  State<AnalysisSelect> createState() => _AnalysisSelectState();
}

class _AnalysisSelectState extends State<AnalysisSelect> {
  late Future<List<Map<String, dynamic>>> cropFuture;

  @override
  void initState() {
    super.initState();
    cropFuture = fetchCropAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[50],
        title: Text(
          'Select Analysis',
          style: TextStyle(
            color: Colors.lightGreen[900],
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: cropFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading crops'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No crops available'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to crop addition screen
                      },
                      child: Text('Add Crop'),
                    ),
                  ],
                ),
              );
            } else {
              List<Map<String, dynamic>> crops = snapshot.data!;
              return ListView.builder(
                itemCount: crops.length,
                itemBuilder: (context, index) {
                  final crop = crops[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnalysisPage(
                            cropId: crop['cropID'],
                          ),
                        ),
                      );
                    },
                    child: AnalysisContainer(crop: crop),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class AnalysisContainer extends StatelessWidget {
  final Map<String, dynamic> crop;

  const AnalysisContainer({required this.crop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 75,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.lightGreen[600],
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crop['cropName'] ?? 'CropName',
                    style: TextStyle(
                      color: Colors.lightGreen[50],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.analytics,
                color: Colors.lightGreen[50],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
