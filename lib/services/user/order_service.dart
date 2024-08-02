import 'package:eshop/constants.dart';
import 'package:eshop/models/produit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

Future<bool> submitOrder({
  required List<Product> products,
  required String nomClient,
  required String mobile,
  String? addresse,
  String? commentaire,
  required int villeId,
  required BuildContext context,
}) async {
  final orderData = {
    'montant': products.fold(
        0, (sum, item) => sum + item.prixAsDouble.toInt() * item.quantity),
    'nomClient': nomClient,
    'mobile': mobile,
    'addresse': addresse,
    'commentaire': commentaire,
    'ville_id': villeId,
    'productList': products
        .map((product) => {
              'codePro': product.codePro,
              'qte': product.quantity,
              'taille': product.taille,
              'couleur': product.couleur,
            })
        .toList(),
  };

  final response = await http.post(
    Uri.parse(createCommandeURL),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(orderData),
  );
  print(response.body);
  if (response.statusCode == 201) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? orderHistoryString = prefs.getString('orderHistory');
    List<Map<String, dynamic>> orderHistory = orderHistoryString != null
        ? List<Map<String, dynamic>>.from(json.decode(orderHistoryString))
        : [];
    orderHistory.add(orderData);
    await prefs.setString('orderHistory', json.encode(orderHistory));

    return true;
  } else {
    return false;
  }
}
