import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/models/categories.dart';
import 'package:eshop/screens/products/productBycategory/produit_by_cat_page.dart';
import 'package:flutter/material.dart';

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;
  // final String url = "http://192.168.1.136:8000/";
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
    return CachedNetworkImage(
      //imageUrl: url + '${category.image}' ?? '',
      imageUrl: category.image ?? '',
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey,
        child: const Center(
          child: Icon(
            Icons.broken_image,
            color: Colors.white,
            size: 50,
          ),
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
