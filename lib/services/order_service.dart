import 'package:eshop/models/Produit.dart';
import 'package:eshop/screens/panier/cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> submitOrder({
  required List<Product> products,
  required String nomClient,
  required String mobile,
  String? addresse,
  String? commentaire,
  double? avance,
  required double remise,
  required int villeId,
  required BuildContext context,
}) async {
  final url = 'http://192.168.1.145:8000/api/createCommande';

  final orderData = {
    'montant': products.fold(
        0, (sum, item) => sum + item.prixAsDouble.toInt() * item.quantity),
    'nomClient': nomClient,
    'mobile': mobile,
    'addresse': addresse,
    'commentaire': commentaire,
    'avance': avance,
    'remise': remise,
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
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(orderData),
  );

  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Commande passée avec succès!')),
    );
    Provider.of<CartProvider>(context, listen: false).clearCart();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la passation de la commande')),
    );
  }
}
