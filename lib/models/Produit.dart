import 'package:flutter/material.dart';

class Product {
  final int codePro;
  final String nomPro;
  final String prix;
  final int qte;
  final String description;
  final String codeArrivage;
  final int actif;
  final int categorie_id;
  final String prixAchat;
  final String pourcentage;
  final int promo;
  int quantity;

  final List<String>? photos;
  final List<String>? sizes;
  final List<String>? colors;

  String? taille;
  String? couleur;

  // Constructor
  Product({
    required this.codePro,
    required this.nomPro,
    required this.prix,
    required this.qte,
    required this.description,
    required this.codeArrivage,
    required this.actif,
    required this.categorie_id,
    required this.prixAchat,
    required this.pourcentage,
    required this.promo,
    this.taille,
    this.couleur,
    this.photos,
    this.sizes,
    this.colors,
    this.quantity = 1,
  });

  double get prixAsDouble => double.tryParse(prix) ?? 0.0;

  void incrementQuantity() {
    quantity++;
  }

  Product copyWith({
    int? codePro,
    String? nomPro,
    String? prix,
    int? qte,
    String? description,
    String? codeArrivage,
    int? actif,
    int? categorie_id,
    String? prixAchat,
    String? pourcentage,
    int? promo,
    int? quantity,
    List<String>? photos,
    List<String>? sizes,
    List<String>? colors,
    String? taille,
    String? couleur,
  }) {
    return Product(
      codePro: codePro ?? this.codePro,
      nomPro: nomPro ?? this.nomPro,
      prix: prix ?? this.prix,
      qte: qte ?? this.qte,
      description: description ?? this.description,
      codeArrivage: codeArrivage ?? this.codeArrivage,
      actif: actif ?? this.actif,
      categorie_id: categorie_id ?? this.categorie_id,
      prixAchat: prixAchat ?? this.prixAchat,
      pourcentage: pourcentage ?? this.pourcentage,
      promo: promo ?? this.promo,
      quantity: quantity ?? this.quantity,
      photos: photos ?? this.photos,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      taille: taille ?? this.taille,
      couleur: couleur ?? this.couleur,
    );
  }

  // Factory constructor to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonPhotos = json['photos'];
    List<String> photoUrls =
        jsonPhotos.map((photo) => photo['lienPhoto']).cast<String>().toList();

    List<dynamic> jsonSizes = json['sizes'];
    List<String> sizeNames =
        jsonSizes.map((size) => size['sizeName']).cast<String>().toList();

    List<dynamic> jsonColors = json['colors'];
    List<String> colorNames =
        jsonColors.map((color) => color['colorName']).cast<String>().toList();

    return Product(
      codePro: json['codePro'],
      nomPro: json['nomPro'],
      prix: json['prix'],
      qte: json['qte'],
      description: json['description'],
      codeArrivage: json['codeArrivage'],
      actif: json['actif'],
      categorie_id: json['categorie_id'],
      prixAchat: json['prixAchat'],
      pourcentage: json['pourcentage'],
      promo: json['promo'],
      photos: photoUrls,
      sizes: sizeNames,
      colors: colorNames,
    );
  }
}

// Method to convert a Product to JSON
 