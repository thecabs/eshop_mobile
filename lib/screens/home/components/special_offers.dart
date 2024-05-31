import 'package:eshop/screens/home/components/subcomponentcat/categories.dart';
import 'package:eshop/screens/products/products_screen.dart';
import 'package:eshop/services/categories_service.dart';
//import 'package:eshop/test/categories.dart';
import 'package:flutter/material.dart';

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
                builder: (context, AsyncSnapshot snapshot) => snapshot.hasData
                    ? Categories(categories: snapshot.data)
                    : Center(child: Image.asset("assets/ripple.gif")),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }
}
