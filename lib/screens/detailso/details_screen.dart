import 'package:eshop/screens/panier/cart_provider.dart';
import 'package:flutter/material.dart';

import '../../models/Produit.dart';
import 'components/product_description.dart';
import 'components/product_images.dart';
import 'components/top_rounded_container.dart';
import 'package:provider/provider.dart';

class DetailsScreeno extends StatefulWidget {
  static String routeName = "/detailso";

  const DetailsScreeno({Key? key}) : super(key: key);

  @override
  _DetailsScreenoState createState() => _DetailsScreenoState();
}

class _DetailsScreenoState extends State<DetailsScreeno> {
  String? selectedSize;
  String? selectedColor;
  bool isDescriptionExpanded = false;

  void addToCart(BuildContext context, Product product) {
    if ((product.sizes != null &&
            product.sizes!.isNotEmpty &&
            selectedSize == null) ||
        (product.colors != null &&
            product.colors!.isNotEmpty &&
            selectedColor == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Veuillez sélectionner une taille et une couleur")),
      );
      return;
    }

    Product productVariant = Product(
      codePro: product.codePro,
      nomPro: product.nomPro,
      prix: product.prix,
      qte: product.qte,
      description: product.description,
      codeArrivage: product.codeArrivage,
      actif: product.actif,
      categorie_id: product.categorie_id,
      prixAchat: product.prixAchat,
      pourcentage: product.pourcentage,
      promo: product.promo,
      photos: product.photos,
      sizes: product.sizes,
      colors: product.colors,
      taille: selectedSize,
      couleur: selectedColor,
    );

    context.read<CartProvider>().addToCart(productVariant);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product.nomPro} a été ajouté au panier")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments args =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    final product = args.product;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: buildAppBar(context),
      body: buildBody(product),
      bottomNavigationBar: buildBottomNavigationBar(product),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: const [
                  Text(
                    "4.7",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.star, color: Colors.yellow, size: 16),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildBody(Product product) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProductImages(product: product),
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                ProductDescription(
                  product: product,
                  isDescriptionExpanded: isDescriptionExpanded,
                  pressOnSeeMore: () {
                    setState(() {
                      isDescriptionExpanded = !isDescriptionExpanded;
                    });
                  },
                ),
                TopRoundedContainer(
                  color: const Color(0xFFF6F7F9),
                  child: Column(
                    children: [
                      if (product.sizes != null && product.sizes!.isNotEmpty)
                        buildAttributeSelector(
                          title: "Taille",
                          items: product.sizes!,
                          selectedItem: selectedSize,
                          onSelected: (size) {
                            setState(() {
                              selectedSize = size;
                            });
                          },
                        ),
                      if (product.colors != null && product.colors!.isNotEmpty)
                        buildAttributeSelector(
                          title: "Couleur",
                          items: product.colors!,
                          selectedItem: selectedColor,
                          onSelected: (color) {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomNavigationBar(Product product) {
    return TopRoundedContainer(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: ElevatedButton(
            onPressed: () {
              addToCart(context, product);
            },
            child: const Text("Ajouter au panier"),
          ),
        ),
      ),
    );
  }

  Widget buildAttributeSelector({
    required String title,
    required List<String> items,
    required String? selectedItem,
    required Function(String?) onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Wrap(
            spacing: 8.0,
            children: items.map((item) {
              return ChoiceChip(
                label: Text(item),
                selected: selectedItem == item,
                onSelected: (selected) {
                  onSelected(selected ? item : null);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsArguments {
  final Product product;

  ProductDetailsArguments({required this.product});
}
