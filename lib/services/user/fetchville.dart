import 'dart:convert';
import 'package:eshop/constants.dart';
import 'package:http/http.dart' as http;

class Ville {
  final int id;
  final String libelle;

  Ville({required this.id, required this.libelle});

  factory Ville.fromJson(Map<String, dynamic> json) {
    return Ville(
      id: json['id'],
      libelle: json['libelle'],
    );
  }
}

Future<List<Ville>> fetchVilles() async {
  final response = await http.get(
    Uri.parse(listVilleURL),
    headers: {'Accept': 'application/json'},
  );
  print(response.body);
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> villesJson = data['ville'];
    return villesJson.map((json) => Ville.fromJson(json)).toList();
  } else {
    throw Exception(
        'Failed to load villes: ${response.statusCode} - ${response.body}');
  }
}
