import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/constants.dart';
import 'package:flutter/material.dart';

import '../../../models/produit.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;
  final VoidCallback onPress;

  String formatProductCode(String code) {
    // Séparez le code en blocs de trois caractères
    List<String> parts = [];
    for (int i = 0; i < code.length; i += 3) {
      parts.add(code.substring(i, i + 3 > code.length ? code.length : i + 3));
    }

    // Joindre les parties avec '-'
    return parts.join('-');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.photos!.isNotEmpty
                        ? product.photos!.first
                        : 'https://demofree.sirv.com/products/123456/123456.jpg?profile=error-example',
                    fit: BoxFit.fill,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/empty.png',
                      fit: BoxFit.fill,
                    ),
                  )),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'CodePro: ${formatProductCode(product.codePro.toString())}',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
              ),
            ),
            Center(
              child: Text(
                product.nomPro,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${product.prix}  FCFA ",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
