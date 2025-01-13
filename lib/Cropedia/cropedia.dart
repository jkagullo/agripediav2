import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class Cropedia extends StatefulWidget {
  const Cropedia({super.key});

  @override
  State<Cropedia> createState() => _CropediaState();
}

class _CropediaState extends State<Cropedia> {
  final CarouselSliderController controller = CarouselSliderController(); // Declare the CarouselController
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<String> tomatoImg = [ // tomato
    'assets/images/Cropedia-Tomato1.png',
    'assets/images/Cropedia-Tomato2.png',
    'assets/images/Cropedia-Tomato3.png',
  ];

  final List<String> pepperImg = [ // pepper
    'assets/images/Cropedia-Sili1.png',
    'assets/images/Cropedia-Sili2.png',
    'assets/images/Cropedia-Sili3.png',
  ];

  final List<String> potatoImg = [ // potato
    'assets/images/potato1.jpg',
    'assets/images/potato2.jpg',
    'assets/images/potato3.jpg',
  ];

  final List<String> cucumberImg = [ // cucumber
    'assets/images/cucumber1.jpg',
    'assets/images/cucumber2.jpg',
    'assets/images/cucumber3.jpg',
  ];


  List<Widget> reshapeTomato(){
    return tomatoImg.map((element)=> ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(element, width: 345, fit: BoxFit.cover,),
    )).toList();
  }

  List<Widget> reshapePepper(){
    return pepperImg.map((element)=> ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(element, width: 345, fit: BoxFit.cover,),
    )).toList();
  }

  List<Widget> reshapePotato(){
    return potatoImg.map((element)=> ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(element, width: 345, fit: BoxFit.cover,),
    )).toList();
  }

  List<Widget> reshapeCucumber(){
    return cucumberImg.map((element)=> ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(element, width: 345, fit: BoxFit.cover,),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        backgroundColor: Colors.lightGreen[50],
        appBar: AppBar(
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.lightGreen[100],
          title: const Text(
            'Crop Information',
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
                              Tab(text: 'Tomato'),
                              Tab(text: 'Pepper'),
                              Tab(text: 'Potato'),
                              Tab(text: 'Cucumber'),
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
            // Content of Tab 1
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
                            child: CarouselSlider(items: reshapeTomato(),
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
                              dotsCount: tomatoImg.length,
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
                              child: Text('About',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                            const Text('Tomatoes (Solanum lycopersicum) are popular and versatile fruits that are often treated as vegetables in culinary contexts. They come in various shapes, sizes, and colors, from small cherry tomatoes to large beefsteak varieties. Tomatoes are rich in vitamins A and C, as well as antioxidants like lycopene, which may have health benefits.',
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
                              child: Text('Where',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                            const Text('Tomatoes require plenty of sunlight, so choose a location in your garden that receives at least 6-8 hours of direct sunlight per day. They also need well-drained soil with good organic matter content. Avoid planting tomatoes in areas where other members of the nightshade family (like peppers, eggplants, or potatoes) have been grown recently to reduce the risk of disease.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),
                            const SizedBox(height: 20,),

                            //WHEN TO PLANT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('When',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                            const Text('The timing for planting tomatoes depends on your location and climate. In general, tomatoes thrive in warm weather, so they are typically planted after the threat of frost has passed and the soil has warmed up. This is usually in the spring, but it can vary based on your region. You can start seeds indoors 6-8 weeks before the last frost date or purchase seedlings from a nursery to transplant into your garden.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),

                            const SizedBox(height: 20,),
                            //HOW
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('How',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),

                            const SizedBox(height: 4,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '1. Prepare the Soil: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Till the soil to loosen it and add compost or aged manure to improve its texture and fertility.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '2. Choose Healthy Seedlings: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'If you''re not starting from seed, select healthy tomato seedlings from a reputable nursery. Look for sturdy stems, dark green leaves, and no signs of disease or pests.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '3. Dig Planting Holes:  ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Dig holes for your tomato plants that are deep enough to bury them up to their first set of leaves. This encourages the development of a strong root system.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '4. Plant the Seedlings: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Gently remove the seedlings from their containers and place them in the planting holes. Fill in the holes with soil, pressing gently to secure the seedlings in place.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '5. Provide Support:  ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Many tomato varieties benefit from staking or caging to support their growth and keep the fruits off the ground. Install stakes or cages at the time of planting to avoid damaging the roots later.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '6. Watering and Mulching: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' Water the newly planted seedlings thoroughly to help them establish their roots. Apply a layer of organic mulch, such as straw or shredded leaves, around the plants to retain moisture and suppress weeds.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '7. Maintenance: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'As the plants grow, continue to water them regularly, especially during dry periods. Monitor for signs of pests or diseases and take appropriate action if needed. Fertilize the plants periodically according to the recommendations for your specific tomato variety.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),
                          ]
                      ),
                    ),
                    ),
                  ],
              ),
            ),

            // SILING LABUYO Tab #2
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
                            child: CarouselSlider(items: reshapePepper(),
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
                              dotsCount: pepperImg.length,
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
                      height: 870,
                      width: double.infinity,
                      color: const Color.fromRGBO(0, 105, 46, 1),
                      child:  SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),

                            //ABOUT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('About',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                            const Text('Siling Labuyo, also known as Bird''s Eye Chili, is a small but potent chili pepper variety commonly found in the Philippines. It is known for its intense heat and is often used to add spice to Filipino dishes. Siling Labuyo plants produce small, thin peppers that start out green and turn red as they ripen.',
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
                              child: Text('Where',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                            const Text('Siling Labuyo plants require plenty of sunlight to thrive, so choose a planting location that receives full sun for most of the day. They also prefer well-drained soil with good organic matter content. If you''re planting them in containers, make sure the pots have drainage holes to prevent waterlogging.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),
                            const SizedBox(height: 20,),

                            //WHEN TO PLANT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('When',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                            const Text('Siling Labuyo thrives in warm weather, so it is best planted during the warmer months of the year. In tropical or subtropical regions like the Philippines, it can be planted year-round. However, it is typically planted in the spring or early summer when temperatures are consistently warm.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),

                            const SizedBox(height: 20,),
                            //HOW
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('How',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),

                            const SizedBox(height: 4,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '1. Prepare the Soil: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Till the soil to loosen it and add compost or aged manure to improve its texture and fertility.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '2. Select Seedlings or Seeds:  ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'You can start Siling Labuyo plants from seeds or purchase seedlings from nurseries. If starting from seeds, sow them directly into the soil or in seed trays indoors, 6-8 weeks before the last frost date.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '3. Planting:  ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' If planting seedlings, dig planting holes that are slightly larger than the root balls of the seedlings. Space the plants about 12-18 inches apart to allow for proper growth. If planting seeds, sow them about 1/4 to 1/2 inch deep in the soil.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '4. Watering: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Water the newly planted seedlings thoroughly to help them establish their roots. Afterward, water them regularly, especially during dry periods, but avoid overwatering, as Siling Labuyo plants prefer slightly dry conditions.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '5. Provide Support:  ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Depending on the variety and size of the plants, you may need to provide support such as stakes or cages to keep the plants upright as they grow.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '6. Maintenance: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Monitor the plants for pests and diseases, and take appropriate action if necessary. Fertilize the plants with a balanced fertilizer every 4-6 weeks during the growing season to promote healthy growth and fruit production.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                          ]
                      ),
                    ),
                    ),
                  ]
              ),
            ),
            SingleChildScrollView( // Tab #3
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
                          child: CarouselSlider(items: reshapePotato(),
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
                            dotsCount: tomatoImg.length,
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
                              child: Text('About',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                            const Text('The potato (Solanum tuberosum) belongs to the solanaceae family of flowering plants. It originated and was first domesticated in the Andesmountains of South America. The potato is the third most important food crop in the world after rice and wheat in terms of human consumption. More than a billion people worldwide eat potato, and global total crop production exceeds 300 million metric tons.',
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
                              child: Text('Where',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                            const Text('Tomatoes thrive in rich, free-draining soil, so add plenty of garden compost before planting. Choose your warmest, sunniest spot, sheltered from the wind. Potatoes are traditionally grown in rows on ridges, but they can also be grown in potato bags or containers.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),
                            const SizedBox(height: 20,),

                            //WHEN TO PLANT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('When',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                            const Text('In the Philippines, the optimal time to plant potatoes varies by region. Highland areas like Benguet and Bukidnon experience the most favorable conditions during March-April and October-November. In contrast, lowland regions generally see the best planting window from November to mid-December. These periods typically offer the ideal temperature and moisture levels for successful potato growth, as they prefer cool temperatures and adequate moisture for tuber development. However, it is crucial to consult with local agricultural extension offices or experienced potato farmers for the most accurate planting advice tailored to specific locations and potato varieties.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),

                            const SizedBox(height: 20,),
                            //HOW
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('How',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),

                            const SizedBox(height: 4,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '1. Prepare the Soil: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Prepare a small, shallow trench in well-tilled soil',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '2. Prepare the Seed: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Cut seed potatoes into pieces, each with at least 2 "eyes" (growth buds). Allow the cut pieces to dry for a few hours to prevent rot.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '3. Plant the Seed:  ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Dig trenches 4-6 inches deep. Place the seed potato pieces 12-18 inches apart in the trenches, with the "eyes" facing upwards. Gently cover the pieces with soil.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '4. Hilling: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'As the potato plants emerge and grow, gradually add more soil to the sides of the plants (hilling). This encourages the formation of more tubers.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '5. Water Regularly:  ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Water the plants regularly, especially during dry periods. Over-watering can lead to root rot.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '6. Weed Control ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Regularly remove weeds that compete with the potato plants for water and nutrients.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '7. Harvest: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Once the potato plant foliage begins to wither and die back, it's time to harvest the potatoes. Gently dig around the plants to avoid damaging the tubers.",
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView( // Tab #4
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
                          child: CarouselSlider(items: reshapeCucumber(),
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
                            dotsCount: tomatoImg.length,
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
                              child: Text('About',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                            const Text("Cucumber, (Cucumis sativus), creeping plant of the gourd family (Cucurbitaceae), widely cultivated for its edible fruit. The nutritional value of the cucumber is low, but its delicate flavour makes it popular for salads and relishes. Small fruits are often pickled. The cucumber can be grown in frames or on trellises in greenhouses in cool climates and is cultivated as a field crop and in home gardens in warmer areas.",
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
                              child: Text('Where',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                            const Text("Cucumbers thrive in sunny locations, making a south-facing window the ideal spot for indoor cultivation. This ensures the plants receive ample direct sunlight, which is crucial for their growth and fruit production. However, it's essential to avoid placing them near drafty windows or air conditioning vents, as cucumbers prefer warm temperatures. Given their vining nature, sufficient space is necessary to accommodate their growth. Utilizing trellises or cages can help guide their vertical growth and optimize space utilization. Furthermore, employing well-draining potting mix is crucial to prevent root rot, a common issue in container-grown plants. While indoor cucumber cultivation is feasible, it's important to acknowledge that yields may be lower compared to outdoor cultivation.",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),
                            const SizedBox(height: 20,),

                            //WHEN TO PLANT
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('When',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),
                            const SizedBox(height: 4,),
                            const Text("In the Philippines, cucumbers can be planted year-round due to the warm climate. However, planting during the warmest months, typically from March to May and September to November, generally provides the most favorable conditions for optimal growth and yield. While cucumbers thrive in warm weather, it's advisable to avoid planting during the hottest periods of the year to prevent heat stress on the plants. To ensure a continuous harvest, gardeners can employ the technique of successive plantings, sowing small batches of seeds every 2-3 weeks throughout the year. Furthermore, selecting cucumber varieties that are well-adapted to the local climate and planting season is crucial for successful cultivation.",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),

                            const SizedBox(height: 20,),
                            //HOW
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('How',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),),
                            ),

                            const SizedBox(height: 4,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '1. Choose the Right Spot: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Cucumbers need at least 6 hours of direct sunlight per day. Select a location with well-drained soil. Avoid areas that tend to be soggy.",
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '2. Prepare the Soil: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Till the soil to a depth of about 8 inches. Add compost or well-rotted manure to improve soil fertility and drainage.",
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '3. Plant the Seeds:  ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Dig holes for your tomato plants that are deep enough to bury them up to their first set of leaves. This encourages the development of a strong root system.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '4. Water Regularly: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Keep the soil consistently moist but not waterlogged. Water deeply and infrequently rather than shallowly and frequently.",
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '5. Provide Support:  ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "As the plants grow, provide support with a trellis or cage to help them climb and prevent them from sprawling on the ground.",
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '6. Watering and Mulching: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' Water the newly planted seedlings thoroughly to help them establish their roots. Apply a layer of organic mulch, such as straw or shredded leaves, around the plants to retain moisture and suppress weeds.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),

                            RichText(
                              textAlign: TextAlign.left,
                              text:  const TextSpan(
                                text: '7. Maintenance: ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'As the plants grow, continue to water them regularly, especially during dry periods. Monitor for signs of pests or diseases and take appropriate action if needed. Fertilize the plants periodically according to the recommendations for your specific tomato variety.',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),
                          ]
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
