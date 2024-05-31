import 'package:eshop/models/Produit.dart';
import 'package:eshop/screens/home/components/subcomponentpro/produit_page.dart';
import 'package:eshop/services/fetchproduits.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);

class SearchField1 extends StatefulWidget {
  const SearchField1({super.key});

  @override
  State<SearchField1> createState() => _SearchField1State();
}

class _SearchField1State extends State<SearchField1> {
  late Future<List<Product>> _futureProducts;

  TextEditingController _searchController = TextEditingController();
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() {
    setState(() {
      _futureProducts = fetchProducts(
        // page: _currentPage,
        search: _searchController.text,
        prix1: double.tryParse(_minPriceController.text),
        prix2: double.tryParse(_maxPriceController.text),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductsPage()),
          );
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: kSecondaryColor.withOpacity(0.1),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: searchOutlineInputBorder,
          focusedBorder: searchOutlineInputBorder,
          enabledBorder: searchOutlineInputBorder,
          hintText: "Search product",
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
