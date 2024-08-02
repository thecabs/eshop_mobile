class Ville {
  final int id;
  final String nom;

  Ville({required this.id, required this.nom});

  factory Ville.fromJson(Map<String, dynamic> json) {
    return Ville(
      id: json['id'],
      nom: json['libelle'],
    );
  }
}
