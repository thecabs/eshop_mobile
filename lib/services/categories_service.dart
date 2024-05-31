import 'dart:convert';

import 'package:eshop/models/categories.dart';
import 'package:http/http.dart' as http;

// Fetch our Categories from API
Future<List<Category>> fetchCategories() async {
  try {
    const String apiUrl = "http://192.168.1.145:8000/api/listCategories";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Accept': 'application/json'},
    );
    print(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<Category> categories = (json.decode(response.body) as List)
          .map((data) => Category.fromJson(data))
          .toList();
// It retuen list of categories
      return categories;
    }
  } catch (e) {
    print(e.toString());
  }
  throw Exception('Failed to load');
}
