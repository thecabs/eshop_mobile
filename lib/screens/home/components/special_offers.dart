import 'package:eshop/screens/products/productBycategory/special_o.dart';
import 'package:eshop/services/user/categories_service.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'section_title.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Special for you",
            press: () {},
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              FutureBuilder(
                future: fetchCategories(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: snapshot.data.map<Widget>((category) {
                        return SpecialOfferCard(category: category);
                      }).toList(),
                    );
                  } else {
                    return Row(
                      children:
                          List.generate(3, (_) => ShimmerSpecialOfferCard()),
                    );
                  }
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class ShimmerSpecialOfferCard extends StatelessWidget {
  const ShimmerSpecialOfferCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SizedBox(
        width: 243,
        height: 120,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
