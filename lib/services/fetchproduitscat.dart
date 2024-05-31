import 'dart:convert';
import 'package:eshop/models/Produit.dart';
import 'package:http/http.dart' as http;

Future<List<Product>> fetchProductscat({
  required int categoryId,
  int page = 1,
  String search = '',
  double prix1 = 0.0,
  double prix2 = 15000000.0,
}) async {
  try {
    final response = await http.get(
      Uri.parse(
          'http://192.168.1.145:8000/api/produitByCategories/$categoryId?page=$page&search=$search&prix1=$prix1&prix2=$prix2'),
      headers: {'Accept': 'application/json'},
    );
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> productList = data['items'];
      return productList.map((json) => Product.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      throw Exception('Resource not found (404).');
    } else {
      throw Exception(
          'Failed to load products. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load products: $e');
  }
}
