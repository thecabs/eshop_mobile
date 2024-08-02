import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/constants.dart';
import 'package:eshop/models/categories.dart';
import 'package:eshop/screens/home/components/categories.dart';
import 'package:eshop/screens/products/productBycategory/produit_by_cat_page.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: () {
          print('Special Offer tapped: ${category.nomCat}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductsByCategoryPage(
                categoryId: category.id!,
                categoryName: category.nomCat!,
              ),
            ),
          );
        },
        child: SizedBox(
          width: 242,
          height: 120,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                buildImage(),
                buildGradientOverlay(),
                buildCategoryInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage() {
    // Define a base URL for images

    // Check if category.image is not null and not empty
    final imageUrl = category.image != null && category.image!.isNotEmpty
        ? (category.image!.startsWith('http')
            ? category.image!
            : baseimage + category.image!)
        : null;

    if (imageUrl == null) {
      return Image.asset(
        'assets/images/empty.png', // Fallback asset image
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey,
        child: Image.asset(
          'assets/images/empty.png', // Path to your default image
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget buildGradientOverlay() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black54,
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget buildCategoryInfo() {
    return Positioned(
      bottom: 10,
      left: 15,
      child: Text(
        category.nomCat!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
