//import 'package:eshop/services/categories_service.dart';
import 'package:eshop/models/Produit.dart';
import 'package:eshop/services/fetchproduits.dart';
//import 'package:eshop/services/produits_service.dart';
//import 'package:eshop/size_config.dart';
//import 'package:eshop/test/title_text.dart';
import 'package:flutter/material.dart';

//import 'categories.dart';
//import 'recommond_products.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int _currentPage = 1;
  late Future<Map<String, dynamic>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts =
        fetchProducts(page: _currentPage) as Future<Map<String, dynamic>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produits'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            final products = (snapshot.data!['items'] as List)
                .map((item) => Product.fromJson(item))
                .toList();
            final currentPage = snapshot.data!['current_page'];
            final lastPage = snapshot.data!['last_page'];

            final int currentpages = int.parse(currentPage);
            //final int lastpages = int.parse(lastPage);
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        title: Text(product.nomPro),
                        subtitle: Text(product.description),
                        trailing: Text('\$${product.prix}'),
                      );
                    },
                  ),
                ),
                if (currentpages < lastPage)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentPage++;
                        _futureProducts = fetchProducts(page: _currentPage)
                            as Future<Map<String, dynamic>>;
                      });
                    },
                    child: Text('Load More'),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
