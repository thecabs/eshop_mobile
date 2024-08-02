import 'package:eshop/models/promo.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shimmer/shimmer.dart';

class PromoCarousel extends StatefulWidget {
  @override
  _PromoCarouselState createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final List<Promo> promos = [
    Promo(image: 'assets/images/promo1.png', message: 'Promo 1: Great Deals!'),
    Promo(
        image: 'assets/images/promo2.png',
        message: 'Promo 2: Buy One Get One Free!'),
    Promo(image: 'assets/images/promo2.png', message: 'Promo 3: 50% Off!'),
    Promo(image: 'assets/images/promo3.png', message: 'Promo 3: 50% Off!'),
  ];

  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _isLoading
            ? ShimmerCarousel()
            : CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                ),
                items: promos.map((promo) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            promo.image != null
                                ? Image.asset(
                                    promo.image!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 150.0,
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: 150.0,
                                    color: Colors.grey,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 50.0,
                                      color: Colors.white,
                                    ),
                                  ),
                            SizedBox(height: 10),
                            Text(
                              promo.message ?? 'No promotion message available',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
        SizedBox(height: 10),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: promos.length,
          effect: ExpandingDotsEffect(
            dotHeight: 10,
            dotWidth: 10,
            activeDotColor: Colors.blue,
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class ShimmerCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: 3, // Number of shimmer items
      itemBuilder: (context, index, realIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 200.0, // Adjust the height to match the actual card
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 150.0, // Adjust the height to match the image
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 150.0, // Adjust the width to match the text
                    height: 20.0, // Adjust the height to match the text
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        autoPlayCurve: Curves.fastOutSlowIn,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
      ),
    );
  }
}
