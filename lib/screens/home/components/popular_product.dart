import 'package:eshop/screens/components/product_card.dart';
import 'package:eshop/screens/home/components/subcomponentpro/produit_page.dart';
import 'package:eshop/test/body.dart';
import 'package:flutter/material.dart';

import '../../../models/Produit.dart';
import '../../detailso/details_screen.dart';
import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Popular Products",
            press: () {
              //Navigator.pushNamed(context, Body())
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => ProductsPage()),
                  (route) => true);
              // Navigator.pushNamed(context, ProductsScreen.routeName);
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                demoProducts.length,
                (index) {
                  if (demoProducts[index].actif == 1) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ProductCard(
                        product: demoProducts[index],
                        // onPress: () {},
                        onPress: () => Navigator.pushNamed(
                          context,
                          DetailsScreeno.routeName,
                          arguments: ProductDetailsArguments(
                              product: demoProducts[index]),
                        ),
                      ),
                    );
                  }

                  return const SizedBox
                      .shrink(); // here by default width and height is 0
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
        )
      ],
    );
  }
}
