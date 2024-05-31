import 'package:eshop/models/categories.dart';
//import 'package:eshop/screens/home/components/subcomponent/special_o.dart';
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
              // Lorsque l'utilisateur clique sur une catégorie, vous pouvez exécuter une action ici
              // Par exemple, vous pouvez naviguer vers une nouvelle page ou charger les produits de cette catégorie
              // Ici, je vous montre comment imprimer le nom de la catégorie sélectionnée
              print('Category clicked: ${categories[index].nomCat}');
              // Ajoutez ici la navigation ou le chargement des produits de cette catégorie
              // Par exemple :
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ProductsByCategoryPage(
              //       categoryId: categories[index].id,
              //       categoryName: categories[index].nomCat,
              //     ),
              //   ),
              // );
            },
            child: SpecialOfferCardo(
              category: categories[index],
            ),
          ),
        ),
      ),
    );
  }
}
