class User {
  int? id;
  String? nomGest;
  int? typeGest;
  String? login;
  bool? actif;
  String? mobile;
  String? token;

  User({
    this.id,
    this.nomGest,
    this.typeGest,
    this.login,
    this.actif,
    this.mobile,
    this.token,
  });

  // function to convert json data to user model

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['user']['id'],
        nomGest: json['user']['nomGest'],
        typeGest: int.parse(json['user']['typeGest']),
        login: json['user']['login'],
        actif: json['user']['actif'],
        mobile: json['user']['mobile'],
        token: json['token']);
  }
}
