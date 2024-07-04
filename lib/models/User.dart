class User {
  int? id;
  String? nomGest;
  int? typeGest;
  String? login;
  bool? actif;
  String? mobile;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? token;

  User({
    this.id,
    this.nomGest,
    this.typeGest,
    this.login,
    this.actif,
    this.mobile,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nomGest: json['nomGest'],
      typeGest: json['typeGest'],
      login: json['login'],
      actif: json['actif'] == 1, // Convert int to bool
      mobile: json['mobile'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomGest': nomGest,
      'typeGest': typeGest,
      'login': login,
      'actif': actif! ? 1 : 0, // Convert bool to int
      'mobile': mobile,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'token': token,
    };
  }
}
