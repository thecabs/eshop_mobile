import 'package:eshop/models/Produit.dart';
import 'package:eshop/screens/components/product_card.dart';
import 'package:flutter/material.dart';

 
class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  static String routeName = "/products";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            itemCount: demoProducts.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.7,
              mainAxisSpacing: 20,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) => ProductCard(
              product: demoProducts[index], onPress: () {},
              // onPress: () => Navigator.pushNamed(
              //   context,
              //   DetailsScreen.routeName,
              //   arguments:
              //       ProductDetailsArguments(product: demoProducts[index]),
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
