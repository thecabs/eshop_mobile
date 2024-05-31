class Category {
  final int? id;
  final String? nomCat, image;

  Category({
    this.id,
    this.nomCat,
    this.image,
  });

  // It creates an Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      nomCat: json["nomCat"],
      image: json["image"],
    );
  }
}
