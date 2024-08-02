import 'package:eshop/models/promo.dart';
import 'package:eshop/screens/home/components/categories.dart';
import 'package:eshop/screens/promo/promo_caroussel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'components/discount_banner.dart';
import 'components/home_header.dart';
import 'components/popular_product.dart';
import 'components/special_offers.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              HomeHeader(),
              SizedBox(height: 10),
              DiscountBanner(),
              SizedBox(height: 20),
              PromoCarousel(),
              //Categories(),
              SpecialOffers(),
              SizedBox(height: 20),
              PopularProducts(),
            ],
          ),
        ),
      ),
    );
  }
}
