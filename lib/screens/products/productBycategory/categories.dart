import 'package:eshop/models/categories.dart';
import 'package:flutter/material.dart';

import 'special_o.dart';

class Categories extends StatelessWidget {
  const Categories({
    Key? key,
    required this.categories,
  }) : super(key: key);

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          categories.length,
          (index) => GestureDetector(
            onTap: () {
              print('Category clicked: ${categories[index].nomCat}');
            },
            child: SpecialOfferCard(
              category: categories[index],
            ),
          ),
        ),
      ),
    );
  }
}
