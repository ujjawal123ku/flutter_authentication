class User {
  int? id;
  String? token;
  String? email;
  String? username;
  String? firstName;
  String? lastName;


  User({
    this.id,
    this.token,
    this.email,
    this.username,
    this.firstName,
    this.lastName,

  });

  factory User.fromJson(Map<String, dynamic> json) {
    print(json);
    return User(
      id: json["pk"],
      token: json["token"],
      email: json["email"],
      username: json["username"],
      firstName: json["first_name"],
      lastName: json["last_name"],

    );
  }
}
