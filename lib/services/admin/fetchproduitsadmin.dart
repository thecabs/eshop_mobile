import 'dart:convert';
import 'package:eshop/constants.dart';
import 'package:eshop/models/produitad.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchProducts({
  int page = 1,
  String? search,
  double? minPrice,
  double? maxPrice,
  String? codePro,
  DateTime? dateStart,
  DateTime? dateEnd,
  int rowsPerPage = 10,
}) async {
  final queryParameters = {
    'page': page.toString(),
    'rowsPerPage': rowsPerPage.toString(),
    if (search != null && search.isNotEmpty) 'search': search,
    if (minPrice != null) 'prix1': minPrice.toString(),
    if (maxPrice != null) 'prix2': maxPrice.toString(),
    if (codePro != null && codePro.isNotEmpty) 'codePro': codePro,
    if (dateStart != null) 'dateStart': dateStart.toIso8601String(),
    if (dateEnd != null) 'dateEnd': dateEnd.toIso8601String(),
  };

  print('Query Parameters: $queryParameters');

  final uri = Uri.http(base, produitListUrl, queryParameters);

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>;
      final products = items
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();

      final currentPage = data['current_page'] != null
          ? int.tryParse(data['current_page'].toString()) ?? 1
          : 1;
      final lastPage = data['last_page'] != null
          ? int.tryParse(data['last_page'].toString()) ?? 1
          : 1;
      final total = data['total'] != null
          ? int.tryParse(data['total'].toString()) ?? 0
          : 0;

      return {
        'items': products,
        'current_page': currentPage,
        'last_page': lastPage,
        'total': total,
      };
    } else {
      throw Exception(
          'Failed to load products. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load products. Error: $e');
  }
}

// Custom Exceptions
class NetworkException implements Exception {}

class ServerException implements Exception {}

class NotFoundException implements Exception {}

class UnknownException implements Exception {}

Future<Map<String, dynamic>> fetchProductDetails(int codePro,
    {int retries = 3, int delaySeconds = 2}) async {
  int attempt = 0;

  while (attempt < retries) {
    attempt++;
    try {
      final response = await http.get(Uri.parse(getQuantityURL + '$codePro'));

      print('Response status: ${response.statusCode}');
      print(response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw NotFoundException();
      } else if (response.statusCode >= 500) {
        throw ServerException();
      } else {
        throw UnknownException();
      }
    } catch (e) {
      if (attempt == retries) {
        if (e is http.ClientException) {
          throw NetworkException();
        } else {
          throw e;
        }
      }
    }
    await Future.delayed(Duration(seconds: delaySeconds));
  }
  throw Exception(
      'Échec du chargement des détails du produit après plusieurs tentatives');
}

Future<String> fetchCategoryName(int categoryId) async {
  final response =
      await http.get(Uri.parse(getCategorienameURL + '$categoryId'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return jsonResponse['nomCat'];
  } else {
    throw Exception('Failed to load category');
  }
}
