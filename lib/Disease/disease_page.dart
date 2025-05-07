import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class DiseasePage extends StatefulWidget {
  const DiseasePage({super.key});

  @override
  State<DiseasePage> createState() => _DiseasePageState();
}

class _DiseasePageState extends State<DiseasePage> {
  final CarouselSliderController controller = CarouselSliderController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<String> bacterial_leaf_spot_img = [
    'assets/images/bacterial_leaf_spot1.jpg',
    'assets/images/bacterial_leaf_spot2.jpg',
    'assets/images/bacterial_leaf_spot3.jpg'
  ];

  final List<String> early_blight_img = [
    'assets/images/early_blight1.jpg',
    'assets/images/early_blight2.jpg',
    'assets/images/early_blight3.jpg'
  ];

  final List<String> healthy_img = [
    'assets/images/healthy1.jpg',
    'assets/images/healthy2.jpg',
    'assets/images/healthy3.jpg'
  ];

  final List<String> late_blight_img = [
    'assets/images/late_blight1.jpg',
    'assets/images/late_blight2.jpg',
    'assets/images/late_blight3.jpg'
  ];

  final List<String> leaf_mold_img = [
    'assets/images/leaf_mold1.jpg',
    'assets/images/leaf_mold2.jpg',
    'assets/images/leaf_mold3.jpg'
  ];

  final List<String> leaf_mosaic_img = [
    'assets/images/leaf_mosaic1.jpg',
    'assets/images/leaf_mosaic2.jpg',
    'assets/images/leaf_mosaic3.jpg'
  ];

  final List<String> septoria_leaf_spot_img = [
    'assets/images/septoria_leaf_spot1.jpg',
    'assets/images/septoria_leaf_spot2.jpg',
    'assets/images/septoria_leaf_spot3.jpg'
  ];

  final List<String> spider_mites_img = [
    'assets/images/spider_mites1.jpg',
    'assets/images/spider_mites2.jpg',
    'assets/images/spider_mites3.jpg'
  ];

  final List<String> target_spot_img = [
    'assets/images/target_spot1.jpg',
    'assets/images/target_spot2.jpg',
    'assets/images/target_spot3.jpg'
  ];

  final List<String> yellow_leaf_curl_img = [
    'assets/images/yellow_leaf_curl1.jpg',
    'assets/images/yellow_leaf_curl2.jpg',
    'assets/images/yellow_leaf_curl3.jpg'
  ];

  List<Widget> reshapeBacterialLeafSpot() {
    return bacterial_leaf_spot_img.map((element) =>
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(element, width: 345, fit: BoxFit.cover,),
        )).toList();
  }

  List<Widget> reshapeEarlyBlight() {
    return early_blight_img.map((element) =>
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(element, width: 345, fit: BoxFit.cover,),
        )).toList();
  }

  List<Widget> reshapeHealthy() {
    return healthy_img.map((element) =>
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(element, width: 345, fit: BoxFit.cover,),
        )).toList();
  }

  List<Widget> reshapeLateBlight() {
    return late_blight_img.map((element) =>
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(element, width: 345, fit: BoxFit.cover,),
        )).toList();
  }

  List<Widget> reshapeLeafMold() {
    return leaf_mold_img.map((element) =>
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(element, width: 345, fit: BoxFit.cover,),
        )).toList();
  }

  List<Widget> reshapeLeafMosaic() {
    return leaf_mosaic_img.map((element) =>
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(element, width: 345, fit: BoxFit.cover,),
        )).toList();
  }

  List<Widget> reshapeSeptoriaLeafSpot() {
    return septoria_leaf_spot_img.map((element) =>
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(element, width: 345, fit: BoxFit.cover,),
        )).toList();
  }

  List<Widget> reshapeSpiderMites() {
    return spider_mites_img.map((element) =>
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(element, width: 345, fit: BoxFit.cover,),
        )).toList();
  }

  List<Widget> reshapeTargetSpot() {
    return target_spot_img.map((element) =>
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(element, width: 345, fit: BoxFit.cover,),
        )).toList();
  }

  List<Widget> reshapeYellowLeafCurl() {
    return yellow_leaf_curl_img.map((element) =>
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(element, width: 345, fit: BoxFit.cover,),
        )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 10, // Number of tabs
        child: Scaffold(
        backgroundColor: Colors.lightGreen[50],
        appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightGreen[100],
        title: const Text(
        'Disease Information',
        style: TextStyle(
        fontSize: 24,
        fontFamily: 'Lato',
        fontWeight: FontWeight.w700,
        color: Color.fromRGBO(0, 105, 46, 1),
    ),
    ),
    bottom: PreferredSize(
    preferredSize: const Size.fromHeight(0), // Adjust the height as needed
    child: Align(
    alignment: Alignment.topLeft,
    child: Row(
    children:[
    const SizedBox(width: 16,),
    Container(
    height: 31,
    width: 194,
    padding: const EdgeInsets.all(4),
    alignment: Alignment.bottomLeft,
    // color: Colors.white,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: const Color.fromRGBO(217, 217, 217, 44)
    ),
    margin: const EdgeInsets.only(bottom: 15,),
    child: TabBar(
    isScrollable: true,
    tabAlignment: TabAlignment.start,
    indicator: BoxDecoration(

    borderRadius: BorderRadius.circular(20),
    color: const Color.fromRGBO(0, 105, 46, 1),
    ),
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: Colors.white,
    unselectedLabelColor: const Color.fromRGBO(69, 90, 100, 1), // Corrected color definition
    tabs: const [
    Tab(text: 'Bacterial Leaf Spot'),
    Tab(text: 'Early Blight'),
    Tab(text: 'Healthy'),
    Tab(text: 'Late Blight'),
      Tab(text: 'Leaf Mold'),
      Tab(text: 'Leaf Mosaic'),
      Tab(text: 'Septoria Leaf Spot'),
      Tab(text: 'Spider Mites'),
      Tab(text: 'Target Spot'),
      Tab(text: 'Yellow Leaf Curl'),
    ],
    labelPadding: const EdgeInsets.symmetric(horizontal: 20),
    ),
    ),
    ]
    )
    )
    ),
    ),
          body: TabBarView(
            children: [
              // Bacterial Leaf Spot
              SingleChildScrollView(
                child:  Column(
                  children: [
                    const SizedBox(height: 20,),
                    Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.zero,
                            height: 150, width: 345,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: CarouselSlider(items: reshapeBacterialLeafSpot(),
                              carouselController: controller,
                              options: CarouselOptions(
                                padEnds: true,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                //  aspectRatio: 0.85,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),),

                          ),

                          Positioned(
                            bottom: 8.0,
                            child: DotsIndicator(
                              dotsCount: bacterial_leaf_spot_img.length,
                              position: currentIndex,
                              onTap: (index) {
                                controller.animateToPage(index);
                              },
                              decorator: DotsDecorator(
                                color:  const Color.fromRGBO(255, 255, 255, 59),
                                activeColor:  const Color.fromRGBO(255, 255, 255, 59),
                                size: const Size.square(12.0),
                                activeSize: const Size(24.0, 12.0),
                                activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),),]
                    ),

                    const SizedBox(height:20),

                    Container(
                      padding: const EdgeInsets.only(left: 35, right: 35,),
                      height: 1000,
                      width: double.infinity,
                      color: const Color.fromRGBO(0, 105, 46, 1),
                      child:  SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                            children: [
                              const SizedBox(height: 20,),

                              //ABOUT
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Bacterial Leaf Spot',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'lato',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),),
                              ),
                              const SizedBox(height: 4,),
                                  Text('Bacterial leaf spot is a common disease in tomatoes caused by various bacteria. It leads to the formation of dark, water-soaked spots on leaves, which can eventually cause leaf drop. The disease can spread rapidly in warm, humid conditions and can significantly affect tomato yield.',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white
                                  )),

                              const SizedBox(height: 20,),

                              //How to cure
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text('How to prevent/cure',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'lato',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),),
                              ),
                              const SizedBox(height: 4,),
                                  Text('To prevent bacterial leaf spot, practice crop rotation, avoid overhead watering, and ensure good air circulation around plants. If the disease occurs, remove infected leaves and apply copper-based bactericides as a treatment. Maintaining plant health through proper fertilization and watering can also help reduce susceptibility.',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white
                                  )),
                            ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              SingleChildScrollView(
                child:  Column(
                  children: [
                    const SizedBox(height: 20,),
                    Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.zero,
                            height: 150, width: 345,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: CarouselSlider(items: reshapeEarlyBlight(),
                              carouselController: controller,
                              options: CarouselOptions(
                                padEnds: true,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                //  aspectRatio: 0.85,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),),

                          ),

                          Positioned(
                            bottom: 8.0,
                            child: DotsIndicator(
                              dotsCount: early_blight_img.length,
                              position: currentIndex,
                              onTap: (index) {
                                controller.animateToPage(index);
                              },
                              decorator: DotsDecorator(
                                color:  const Color.fromRGBO(255, 255, 255, 59),
                                activeColor:  const Color.fromRGBO(255, 255, 255, 59),
                                size: const Size.square(12.0),
                                activeSize: const Size(24.0, 12.0),
                                activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),),]
                    ),

                    const SizedBox(height:20),

                    Container(
                      padding: const EdgeInsets.only(left: 35, right: 35,),
                      height: 1000,
                      width: double.infinity,
                      color: const Color.fromRGBO(0, 105, 46, 1),
                      child:  SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),

                            //ABOUT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Early Blight',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                                Text('Characterized by dark, circular or irregular spots on older leaves, often with concentric rings resembling a target. These spots can enlarge, causing leaves to turn yellow and die.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),

                            const SizedBox(height: 20,),

                            //WHERE TO PLANT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('How to prevent/cure',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                                Text('To prevent early blight, practice crop rotation, avoid overhead watering, and ensure good air circulation around plants. If the disease occurs, remove infected leaves and apply fungicides containing.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SingleChildScrollView(
                child:  Column(
                  children: [
                    const SizedBox(height: 20,),
                    Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.zero,
                            height: 150, width: 345,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: CarouselSlider(items: reshapeHealthy(),
                              carouselController: controller,
                              options: CarouselOptions(
                                padEnds: true,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                //  aspectRatio: 0.85,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),),

                          ),

                          Positioned(
                            bottom: 8.0,
                            child: DotsIndicator(
                              dotsCount: healthy_img.length,
                              position: currentIndex,
                              onTap: (index) {
                                controller.animateToPage(index);
                              },
                              decorator: DotsDecorator(
                                color:  const Color.fromRGBO(255, 255, 255, 59),
                                activeColor:  const Color.fromRGBO(255, 255, 255, 59),
                                size: const Size.square(12.0),
                                activeSize: const Size(24.0, 12.0),
                                activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),),]
                    ),

                    const SizedBox(height:20),

                    Container(
                      padding: const EdgeInsets.only(left: 35, right: 35,),
                      height: 1000,
                      width: double.infinity,
                      color: const Color.fromRGBO(0, 105, 46, 1),
                      child:  SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),

                            //ABOUT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Healthy',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                                Text('Healthy tomato plants have vibrant green leaves, sturdy stems, and robust growth. They are free from any visible signs of disease or pest damage. Healthy plants are more resilient to environmental stressors and produce high-quality fruit.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),

                            const SizedBox(height: 20,),

                            //WHERE TO PLANT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('How to maintain/maximize yield',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                                Text('To maintain healthy tomato plants, provide adequate sunlight, water consistently, and use well-draining soil. Fertilize regularly with a balanced fertilizer and monitor for pests and diseases. Pruning and staking can also help improve air circulation and support plant growth.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SingleChildScrollView(
                child:  Column(
                  children: [
                    const SizedBox(height: 20,),
                    Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.zero,
                            height: 150, width: 345,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: CarouselSlider(items: reshapeLateBlight(),
                              carouselController: controller,
                              options: CarouselOptions(
                                padEnds: true,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                //  aspectRatio: 0.85,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),),

                          ),

                          Positioned(
                            bottom: 8.0,
                            child: DotsIndicator(
                              dotsCount: late_blight_img.length,
                              position: currentIndex,
                              onTap: (index) {
                                controller.animateToPage(index);
                              },
                              decorator: DotsDecorator(
                                color:  const Color.fromRGBO(255, 255, 255, 59),
                                activeColor:  const Color.fromRGBO(255, 255, 255, 59),
                                size: const Size.square(12.0),
                                activeSize: const Size(24.0, 12.0),
                                activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),),]
                    ),

                    const SizedBox(height:20),

                    Container(
                      padding: const EdgeInsets.only(left: 35, right: 35,),
                      height: 1000,
                      width: double.infinity,
                      color: const Color.fromRGBO(0, 105, 46, 1),
                      child:  SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),

                            //ABOUT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Late Blight',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                                Text('Appears as irregular, water-soaked lesions on leaves, often starting at the edges. In humid conditions, a white, cottony mold may be visible on the undersides of leaves. It can rapidly spread and affect stems and fruits/tubers.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),

                            const SizedBox(height: 20,),

                            //WHERE TO PLANT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('How to cure/prevent',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),

                            const SizedBox(height: 4,),
                                Text('To prevent late blight, practice crop rotation, avoid overhead watering, and ensure good air circulation around plants. If the disease occurs, remove infected leaves and apply fungicides containing chlorothalonil or mefenoxam. Early detection and prompt action are crucial to managing this disease.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SingleChildScrollView(
                child:  Column(
                  children: [
                    const SizedBox(height: 20,),
                    Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.zero,
                            height: 150, width: 345,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: CarouselSlider(items: reshapeLeafMold(),
                              carouselController: controller,
                              options: CarouselOptions(
                                padEnds: true,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                //  aspectRatio: 0.85,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),),

                          ),

                          Positioned(
                            bottom: 8.0,
                            child: DotsIndicator(
                              dotsCount: leaf_mold_img.length,
                              position: currentIndex,
                              onTap: (index) {
                                controller.animateToPage(index);
                              },
                              decorator: DotsDecorator(
                                color:  const Color.fromRGBO(255, 255, 255, 59),
                                activeColor:  const Color.fromRGBO(255, 255, 255, 59),
                                size: const Size.square(12.0),
                                activeSize: const Size(24.0, 12.0),
                                activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),),]
                    ),

                    const SizedBox(height:20),

                    Container(
                      padding: const EdgeInsets.only(left: 35, right: 35,),
                      height: 1000,
                      width: double.infinity,
                      color: const Color.fromRGBO(0, 105, 46, 1),
                      child:  SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),

                            //ABOUT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Leaf Mold',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                                Text('Leaf mold is a fungal disease that primarily affects the leaves of tomato plants. It is characterized by yellowing and wilting of leaves, often starting from the lower leaves and progressing upwards. In humid conditions, a grayish mold may develop on the undersides of leaves.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),

                            const SizedBox(height: 20,),

                            //WHERE TO PLANT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('How to prevent/cure',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),

                            const SizedBox(height: 4,),
                                Text('To prevent leaf mold, ensure good air circulation around plants, avoid overhead watering, and remove any infected leaves promptly. If the disease occurs, apply fungicides containing chlorothalonil or copper-based products. Maintaining proper plant spacing and avoiding excessive humidity can also help reduce the risk of leaf mold.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SingleChildScrollView(
                child:  Column(
                  children: [
                    const SizedBox(height: 20,),
                    Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.zero,
                            height: 150, width: 345,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: CarouselSlider(items: reshapeLeafMosaic(),
                              carouselController: controller,
                              options: CarouselOptions(
                                padEnds: true,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                //  aspectRatio: 0.85,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),),

                          ),

                          Positioned(
                            bottom: 8.0,
                            child: DotsIndicator(
                              dotsCount: leaf_mosaic_img.length,
                              position: currentIndex,
                              onTap: (index) {
                                controller.animateToPage(index);
                              },
                              decorator: DotsDecorator(
                                color:  const Color.fromRGBO(255, 255, 255, 59),
                                activeColor:  const Color.fromRGBO(255, 255, 255, 59),
                                size: const Size.square(12.0),
                                activeSize: const Size(24.0, 12.0),
                                activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),),]
                    ),

                    const SizedBox(height:20),

                    Container(
                      padding: const EdgeInsets.only(left: 35, right: 35,),
                      height: 1000,
                      width: double.infinity,
                      color: const Color.fromRGBO(0, 105, 46, 1),
                      child:  SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),

                            //ABOUT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Leaf Mosaic',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                                Text('Leaf mosaic is a viral disease that causes mottled or mosaic-like patterns on the leaves of tomato plants. Infected leaves may also exhibit yellowing and curling. The disease can lead to stunted growth and reduced fruit yield.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),

                            const SizedBox(height: 20,),

                            //WHERE TO PLANT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('How to prevent/cure',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                                Text('To prevent leaf mosaic, practice good sanitation by removing infected plants and controlling aphid populations, which can spread the virus. There is no cure for infected plants, so prevention is key. Use resistant tomato varieties when available.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SingleChildScrollView(
                child:  Column(
                  children: [
                    const SizedBox(height: 20,),
                    Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.zero,
                            height: 150, width: 345,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: CarouselSlider(items: reshapeSeptoriaLeafSpot(),
                              carouselController: controller,
                              options: CarouselOptions(
                                padEnds: true,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                //  aspectRatio: 0.85,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),),

                          ),

                          Positioned(
                            bottom: 8.0,
                            child: DotsIndicator(
                              dotsCount: septoria_leaf_spot_img.length,
                              position: currentIndex,
                              onTap: (index) {
                                controller.animateToPage(index);
                              },
                              decorator: DotsDecorator(
                                color:  const Color.fromRGBO(255, 255, 255, 59),
                                activeColor:  const Color.fromRGBO(255, 255, 255, 59),
                                size: const Size.square(12.0),
                                activeSize: const Size(24.0, 12.0),
                                activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),),]
                    ),

                    const SizedBox(height:20),

                    Container(
                      padding: const EdgeInsets.only(left: 35, right: 35,),
                      height: 1000,
                      width: double.infinity,
                      color: const Color.fromRGBO(0, 105, 46, 1),
                      child:  SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),

                            //ABOUT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Septoria Leaf Spot',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                                Text('Septoria leaf spot is a fungal disease characterized by small, dark spots with yellow halos on older leaves. As the disease progresses, the spots can merge, leading to leaf yellowing and premature leaf drop. It typically starts on lower leaves and can spread rapidly in humid conditions.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),

                            const SizedBox(height: 20,),

                            //WHERE TO PLANT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('How to prevent/cure',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),

                            const SizedBox(height: 4,),
                                Text('To prevent septoria leaf spot, practice crop rotation, avoid overhead watering, and ensure good air circulation around plants. If the disease occurs, remove infected leaves and apply fungicides containing chlorothalonil or copper-based products. Maintaining proper plant spacing and avoiding excessive humidity can also help reduce the risk of septoria leaf spot.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SingleChildScrollView(
                child:  Column(
                  children: [
                    const SizedBox(height: 20,),
                    Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.zero,
                            height: 150, width: 345,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: CarouselSlider(items: reshapeSpiderMites(),
                              carouselController: controller,
                              options: CarouselOptions(
                                padEnds: true,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                //  aspectRatio: 0.85,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),),

                          ),

                          Positioned(
                            bottom: 8.0,
                            child: DotsIndicator(
                              dotsCount: spider_mites_img.length,
                              position: currentIndex,
                              onTap: (index) {
                                controller.animateToPage(index);
                              },
                              decorator: DotsDecorator(
                                color:  const Color.fromRGBO(255, 255, 255, 59),
                                activeColor:  const Color.fromRGBO(255, 255, 255, 59),
                                size: const Size.square(12.0),
                                activeSize: const Size(24.0, 12.0),
                                activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),),]
                    ),

                    const SizedBox(height:20),

                    Container(
                      padding: const EdgeInsets.only(left: 35, right: 35,),
                      height: 1000,
                      width: double.infinity,
                      color: const Color.fromRGBO(0, 105, 46, 1),
                      child:  SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),

                            //ABOUT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Spider Mites',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                                Text('Spider mites are tiny arachnids that can infest tomato plants, causing damage by feeding on plant sap. Infested leaves may exhibit stippling, yellowing, and webbing on the undersides. Severe infestations can lead to leaf drop and reduced fruit quality.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),

                            const SizedBox(height: 20,),

                            //WHERE TO PLANT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('How to prevent/cure',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),

                            const SizedBox(height: 4,),
                                Text('To prevent spider mite infestations, maintain proper humidity levels, avoid overcrowding plants, and regularly inspect for signs of infestation. If spider mites are detected, use insecticidal soap or neem oil to control their populations. Regularly washing the undersides of leaves with water can also help reduce mite numbers.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SingleChildScrollView(
                child:  Column(
                  children: [
                    const SizedBox(height: 20,),
                    Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.zero,
                            height: 150, width: 345,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: CarouselSlider(items: reshapeTargetSpot(),
                              carouselController: controller,
                              options: CarouselOptions(
                                padEnds: true,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                //  aspectRatio: 0.85,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),),

                          ),

                          Positioned(
                            bottom: 8.0,
                            child: DotsIndicator(
                              dotsCount: target_spot_img.length,
                              position: currentIndex,
                              onTap: (index) {
                                controller.animateToPage(index);
                              },
                              decorator: DotsDecorator(
                                color:  const Color.fromRGBO(255, 255, 255, 59),
                                activeColor:  const Color.fromRGBO(255, 255, 255, 59),
                                size: const Size.square(12.0),
                                activeSize: const Size(24.0, 12.0),
                                activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),),]
                    ),

                    const SizedBox(height:20),

                    Container(
                      padding: const EdgeInsets.only(left: 35, right: 35,),
                      height: 1000,
                      width: double.infinity,
                      color: const Color.fromRGBO(0, 105, 46, 1),
                      child:  SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),

                            //ABOUT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Target Spot',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                                Text('Target spot is a fungal disease characterized by small, dark spots with concentric rings on leaves. Infected leaves may also exhibit yellowing and wilting. The disease can lead to reduced photosynthesis and overall plant vigor.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),

                            const SizedBox(height: 20,),

                            //WHERE TO PLANT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('How to prevent/cure',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),

                            const SizedBox(height: 4,),
                                Text('To prevent target spot, practice crop rotation, avoid overhead watering, and ensure good air circulation around plants. If the disease occurs, remove infected leaves and apply fungicides containing chlorothalonil or copper-based products. Maintaining proper plant spacing and avoiding excessive humidity can also help reduce the risk of target spot.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SingleChildScrollView(
                child:  Column(
                  children: [
                    const SizedBox(height: 20,),
                    Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.zero,
                            height: 150, width: 345,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: CarouselSlider(items: reshapeYellowLeafCurl(),
                              carouselController: controller,
                              options: CarouselOptions(
                                padEnds: true,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                //  aspectRatio: 0.85,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),),

                          ),

                          Positioned(
                            bottom: 8.0,
                            child: DotsIndicator(
                              dotsCount: yellow_leaf_curl_img.length,
                              position: currentIndex,
                              onTap: (index) {
                                controller.animateToPage(index);
                              },
                              decorator: DotsDecorator(
                                color:  const Color.fromRGBO(255, 255, 255, 59),
                                activeColor:  const Color.fromRGBO(255, 255, 255, 59),
                                size: const Size.square(12.0),
                                activeSize: const Size(24.0, 12.0),
                                activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),),]
                    ),

                    const SizedBox(height:20),

                    Container(
                      padding: const EdgeInsets.only(left: 35, right: 35,),
                      height: 1000,
                      width: double.infinity,
                      color: const Color.fromRGBO(0, 105, 46, 1),
                      child:  SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),

                            //ABOUT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Yellow Leaf Curl',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                                Text('Yellow leaf curl is a viral disease that causes yellowing and curling of leaves, often starting from the top of the plant. Infected plants may exhibit stunted growth and reduced fruit yield. The disease is typically spread by whiteflies.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),

                            const SizedBox(height: 20,),

                            //WHERE TO PLANT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('How to prevent/cure',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                                Text('To prevent yellow leaf curl, control whitefly populations and practice good sanitation by removing infected plants. There is no cure for infected plants, so prevention is key. Use resistant tomato varieties when available.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}
