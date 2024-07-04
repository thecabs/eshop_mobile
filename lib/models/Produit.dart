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

List<Product> demoProducts = [
  Product(
    codePro: 1,
    nomPro: 'Chaussure en cuir',
    prix: '25000',
    qte: 10,
    description:
        'Description for Product 1Lorsque vous vous attardez sur votre descriptif produit, il est pas seulement import Lorsque vous vous attardez sur votre descriptif produit, il nest pas seulement important que le design et les images crèvent lécran. Pour que vos clients aient envie de placer les produits dans le panier dachat, il faut aussi que vos descriptions produits soient irréprochables et inspirent confiance. Ces critères contribuent non seulement à une expérience client positive, mais aussi à la crédibilité de votre page, à un meilleur classement sur Google et à un meilleur taux de conversion. ',
    codeArrivage: 'ARR2024-001',
    actif: 112300,
    categorie_id: 1,
    prixAchat: '15.00',
    pourcentage: '10.00',
    promo: 0,
    photos: [
      'http://192.168.1.145:8000/images/1717508595.png',
      'http://192.168.1.145:8000/images/1717508892.png',
    ],
    sizes: ['S', 'M', 'L'],
    colors: ['#FF0000', '#00FF00', '#0000FF'],
  ),
  Product(
    codePro: 223100,
    nomPro: 'Chaussure',
    prix: '50000',
    qte: 20,
    description: 'Description for Product 2',
    codeArrivage: 'ARR2024-002',
    actif: 1,
    categorie_id: 2,
    prixAchat: '25.00',
    pourcentage: '15.00',
    promo: 1,
    photos: [
      'http://192.168.1.145:8000/images/1717508892.png',
      'http://192.168.1.145:8000/images/1717508892.png',
    ],
    sizes: ['M', 'L', 'XL'],
    colors: ['#FFFF00', '#FF00FF', '#00FFFF'],
  ),
  Product(
    codePro: 323300,
    nomPro: 'Product 3',
    prix: '19.99',
    qte: 30,
    description: 'Description for Product 3',
    codeArrivage: 'ARR2024-003',
    actif: 0,
    categorie_id: 3,
    prixAchat: '10.00',
    pourcentage: '5.00',
    promo: 0,
    photos: [
      'https://picsum.photos/200/300?random=7',
      'https://picsum.photos/200/300?random=8',
      'https://picsum.photos/200/300?random=9',
    ],
    sizes: ['L', 'XL'],
    colors: ['#FF4500', '#2E8B57', '#4682B4'],
  ),
  Product(
    codePro: 333200,
    nomPro: 'Wireless Controllers PS4',
    prix: '19.99',
    qte: 30,
    description: 'Description for Product 3',
    codeArrivage: 'ARR2024-003',
    actif: 0,
    categorie_id: 3,
    prixAchat: '10.00',
    pourcentage: '5.00',
    promo: 0,
    photos: [
      'http://192.168.1.145:8000/images/1717016849.png',
      'http://192.168.1.145:8000/images/1717016864.png',
      'http://192.168.1.145:8000/images/1717016873.png',
    ],
    sizes: ['L', 'XL'],
    colors: ['#FF4500', '#2E8B57', '#4682B4'],
  ),
  Product(
    codePro: 412300,
    nomPro: 'Manette Ps4',
    prix: '3999',
    qte: 40,
    description: 'Description for Product 4',
    codeArrivage: 'ARR2024-004',
    actif: 1,
    categorie_id: 4,
    prixAchat: '20.00',
    pourcentage: '20.00',
    promo: 1,
    photos: [
      'http://192.168.1.145:8000/images/1717016885.png',
    ],
    sizes: ['S', 'M', 'XL'],
    colors: ['#FFD700', '#FF69B4', '#B0E0E6'],
  ),
  Product(
    codePro: 512310,
    nomPro: 'Talon',
    prix: '5999',
    qte: 50,
    description: 'Description for Product 5',
    codeArrivage: 'ARR2024-005',
    actif: 1,
    categorie_id: 5,
    prixAchat: '30.00',
    pourcentage: '25.00',
    promo: 0,
    photos: [
      'http://192.168.1.145:8000/images/1717509905.png',
    ],
    sizes: ['S', 'L', 'XL'],
    colors: ['#7FFF00', '#D2691E', '#6495ED'],
  ),
];
