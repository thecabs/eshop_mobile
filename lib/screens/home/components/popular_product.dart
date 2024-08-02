import 'dart:math';
import 'package:eshop/screens/components/produit_card.dart';
import 'package:eshop/services/user/fetchproduits.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:eshop/screens/products/productList/produit_page.dart';
import '../../../models/produit.dart';
import '../../details/details_screen.dart';
import 'section_title.dart';

class PopularProducts extends StatefulWidget {
  const PopularProducts({Key? key}) : super(key: key);

  @override
  _PopularProductsState createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  late Future<Map<String, dynamic>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Popular Products",
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProductsPage()),
              );
            },
          ),
        ),
        FutureBuilder<Map<String, dynamic>>(
          future: futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerPlaceholder();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!['items'] == null ||
                !(snapshot.data!['items'] is List) ||
                (snapshot.data!['items'] as List).isEmpty) {
              return const Center(child: Text('No products found'));
            } else {
              final products = snapshot.data!['items'];
              final randomProducts = getRandomProducts(products, 10);
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(
                        width: 20), // Shift ProductCards to the right
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: randomProducts.map((product) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          child: ProductCard(
                            product: product,
                            onPress: () => Navigator.pushNamed(
                              context,
                              DetailsScreen.routeName,
                              arguments:
                                  ProductDetailsArguments(product: product),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }

  List<Product> getRandomProducts(List<Product> products, int count) {
    if (products.isEmpty) return [];

    final random = Random();
    final selectedProducts = <Product>{};

    while (selectedProducts.length < count &&
        selectedProducts.length < products.length) {
      final product = products[random.nextInt(products.length)];
      selectedProducts.add(product);
    }

    return selectedProducts.toList();
  }
}

class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 20), // Shift Shimmer to the right
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(10, (index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 1.02,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Container(
                          height: 20,
                          width: 100,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: Container(
                          height: 20,
                          width: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Container(
                          height: 20,
                          width: 80,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
