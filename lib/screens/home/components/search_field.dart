import 'package:flutter/material.dart';
import 'package:eshop/screens/products/productList/produit_page.dart';
import 'package:eshop/constants.dart';

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);

class SearchField extends StatefulWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();

  void _searchProducts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsPage(
          searchQuery: _searchController.text,
          minPrice: double.tryParse(_minPriceController.text),
          maxPrice: double.tryParse(_maxPriceController.text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        controller: _searchController,
        onFieldSubmitted: (_) => _searchProducts(),
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
