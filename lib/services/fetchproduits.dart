import 'dart:convert';
import 'package:eshop/models/Produit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Product>> fetchProducts(
    {int page = 1, String? search, double? prix1, double? prix2}) async {
  final queryParameters = {
    'page': page.toString(),
    if (search != null) 'search': search,
    if (prix1 != null) 'prix1': prix1.toString(),
    if (prix2 != null) 'prix2': prix2.toString(),
  };

  final uri =
      Uri.http("192.168.1.145:8000", '/api/produitsList', queryParameters);
  // Remplacez 'example.com' par votre domaine
  //const String apiUrl = "http://192.168.175.206:8000/api/produitsproducts";

  final response = await http.get(uri);
  // final response = await http.get(Uri.parse(apiUrl));
  print(response.body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;
    return items
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to load products');
  }
}
