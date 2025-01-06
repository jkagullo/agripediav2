import 'package:agripediav3/Analysis/analysis_page.dart';
import 'package:agripediav3/Analysis/analysis_select.dart';
import 'package:flutter/material.dart';
import 'package:agripediav3/DatabaseService/crop_summary_db.dart';

class SummaryWidget extends StatefulWidget {
  const SummaryWidget({super.key});

  @override
  State<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  late Future<List<Map<String, dynamic>>> _cropDataFuture;

  @override
  void initState() {
    super.initState();
    _cropDataFuture = fetchCropSummaries();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _cropDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading crop data'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No crops found'));
        }

        final cropData = snapshot.data!;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: cropData.map((crop) {
                  final cropName = crop['cropName'] ?? 'Unknown';
                  final imageUrl = crop['imageUrl'];

                  return Container(
                    padding: EdgeInsets.all(10.0),
                    height: 200,
                    width: 320,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[600],
                      borderRadius: BorderRadius.circular(20.0),
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
                              Image.asset(
                                'assets/images/crop_icon.png',
                                height: 30,
                              ),
                              Text(
                                cropName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Last crop analysis was 8 days ago.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AnalysisSelect(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.lightGreen[600],
                                  side: BorderSide(color: Colors.white),
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                ),
                                child: Text(
                                  'Analysis',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 190,
                            width: 170,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: imageUrl != null
                                  ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              )
                                  : Image.asset(
                                'assets/images/placeholder.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
