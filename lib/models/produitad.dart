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
  final DateTime createdAt;
  String? nomCategorie; // New field

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
    required this.createdAt,
    this.taille,
    this.couleur,
    this.photos,
    this.sizes,
    this.colors,
    this.quantity = 1,
    this.nomCategorie,
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
    DateTime? createdAt,
    String? nomCategorie, // New field
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
      createdAt: createdAt ?? this.createdAt,
      nomCategorie: nomCategorie ?? this.nomCategorie, // New field
      taille: taille ?? this.taille,
      couleur: couleur ?? this.couleur,
    );
  }

  // Factory constructor to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonPhotos = json['photos'] ?? [];
    List<String> photoUrls =
        jsonPhotos.map((photo) => photo['lienPhoto'] as String).toList();

    List<dynamic> jsonSizes = json['sizes'] ?? [];
    List<String> sizeNames =
        jsonSizes.map((size) => size['sizeName'] as String).toList();

    List<dynamic> jsonColors = json['colors'] ?? [];
    List<String> colorNames =
        jsonColors.map((color) => color['colorName'] as String).toList();

    return Product(
      codePro: json['codePro'] ?? 0,
      nomPro: json['nomPro'] ?? '',
      prix: json['prix'] ?? '0.0',
      qte: json['qte'] ?? 0,
      description: json['description'] ?? '',
      codeArrivage: json['codeArrivage'] ?? '',
      actif: json['actif'] ?? 0,
      categorie_id: json['categorie_id'] ?? 0,
      prixAchat: json['prixAchat'] ?? '0.0',
      pourcentage: json['pourcentage'] ?? '0.0',
      promo: json['promo'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      photos: photoUrls,
      sizes: sizeNames,
      colors: colorNames,
    );
  }
}
