import 'package:flutter/material.dart';

class SummaryWidget extends StatefulWidget {
  const SummaryWidget({super.key});

  @override
  State<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35.0),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(15.0),
                height: 200,
                width: 340,
                decoration: BoxDecoration(
                  color: Colors.lightGreen[600],
                  borderRadius: BorderRadius.circular(20.0),
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
                            'Tomato',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Last crop analysis was 8 days ago.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          OutlinedButton(
                            onPressed: (){

                            },
                            child: Text(
                                'Analysis',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.lightGreen[600],
                              side: BorderSide(color: Colors.white), // Outline color
                              padding: EdgeInsets.symmetric(horizontal: 30), // Decrease padding
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
                          child: Image.asset(
                              'assets/images/tomato_image1.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                height: 200,
                width: 340,
                decoration: BoxDecoration(
                  color: Colors.lightGreen[600],
                  borderRadius: BorderRadius.circular(20.0),
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
                            'Tomato',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Last crop analysis was 8 days ago.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          OutlinedButton(
                            onPressed: (){

                            },
                            child: Text(
                              'Analysis',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.lightGreen[600],
                              side: BorderSide(color: Colors.white), // Outline color
                              padding: EdgeInsets.symmetric(horizontal: 30), // Decrease padding
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
                          child: Image.asset(
                            'assets/images/tomato_image1.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
