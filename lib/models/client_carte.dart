class Client {
  final int matr;
  final String nom;
  final bool sexe;
  final String dateNaiss;
  final int villeId;
  final String mobile;
  final bool? whatsapp;
  final int point;
  final double montantTontine;
  // Additional fields if necessary

  Client({
    required this.matr,
    required this.nom,
    required this.sexe,
    required this.dateNaiss,
    required this.villeId,
    required this.mobile,
    this.whatsapp,
    required this.point,
    required this.montantTontine,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      matr: json['matr'] as int,
      nom: json['nom'] as String,
      sexe: json['sexe'] == 1, // Convert 1 to true and 0 to false
      dateNaiss: json['dateNaiss'] as String,
      villeId: json['ville_id'] as int,
      mobile: json['mobile'] as String,
      whatsapp: json['whatsapp'] == null
          ? null
          : json['whatsapp'] == 1, // Handle nullable boolean
      point: json['point'] as int,
      montantTontine:
          double.parse(json['montantTontine']), // Convert string to double
    );
  }
}
