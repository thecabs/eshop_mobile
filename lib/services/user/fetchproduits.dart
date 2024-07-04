import 'dart:convert';
import 'package:eshop/constants.dart';
import 'package:eshop/models/produit.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchProducts(
    {int page = 1, String? search, double? prix1, double? prix2}) async {
  final queryParameters = {
    'page': page.toString(),
    if (search != null) 'search': search,
    if (prix1 != null) 'prix1': prix1.toString(),
    if (prix2 != null) 'prix2': prix2.toString(),
  };

  final uri = Uri.http(base, produitListUrl, queryParameters);
  final response = await http.get(uri);
  print(response.body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;
    final products = items
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();

    return {
      'items': products,
      'current_page': data['current_page'],
      'last_page': data['last_page'],
      'total': data['total'],
    };
  } else {
    throw Exception('Failed to load products');
  }
}

Future<List<Product>> fetchProductscat({
  required int categoryId,
  int page = 1,
  String search = '',
  double prix1 = 0.0,
  double prix2 = 15000000.0,
}) async {
  try {
    final response = await http.get(
      Uri.parse(produitByCategorieURL +
          '$categoryId?page=$page&search=$search&prix1=$prix1&prix2=$prix2'),
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
