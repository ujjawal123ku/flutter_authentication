import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'model/usermodel.dart';

Future<User?> userAuth(String email, String password) async {
  final body = {
    "email": email,
    "password": password,
  };
  final url = Uri.parse("http://$baseurl/app1/auth/login/");

  try {
    final res = await http.post(url, body: body);

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final token = json["key"];
      final box = await Hive.openBox(tokenBox);
      box.put("token", token);
      return getUser(token);
    } else {
      print("Login failed with status code: ${res.statusCode}");
      print("Response body: ${res.body}");
      return null;
    }
  } catch (e) {
    print("Exception during login: $e");
    return null;
  }
}

Future<User?> getUser(String token) async {
  final url = Uri.parse("http://$baseurl/app1/auth/user/");
  try {
    final res = await http.get(
      url,
      headers: {'Authorization': 'Token $token'},
    );

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final user = User.fromJson(json);
      user.token = token;
      return user;
    } else {
      print("Get user failed with status code: ${res.statusCode}");
      print("Response body: ${res.body}");
      return null;
    }
  } catch (e) {
    print("Exception during getUser: $e");
    return null;
  }
}
Future<User?> logout(String token) async {
  final url = Uri.parse("http://$baseurl/app1/auth/logout/");
  try {
    final res = await http.get(
      url,
      headers: {'Authorization': 'Token $token'},
    );}
 catch (e) {
    print("Exception during logout: $e");
    return null;
  }
}

Future<User?> registerUser(
    String email,
    String username,
    String firstName,
    String LastName,
    String password,
    String confirmPassword,

    ) async {
  final data = {
    "email": email,
    "username": username,
    "first_name": firstName,
    "last_name":LastName,
    "password1": password,
    "password2":confirmPassword,


  };

  final url = Uri.parse("http://$baseurl/app1/auth/registration/");

  try {
    final res = await http.post(url, body: data);
    print(res.statusCode);

    if ( res.statusCode == 201||res.statusCode==200) {
      final json = jsonDecode(res.body);
      if (json.containsKey('key')) {

        String token = json['key'];
        print(token);
        final box = await Hive.openBox(tokenBox);
        box.put("token", token);
        return getUser(token);
      } else {
        return null;
      }
    } else {
      print("Registration failed with status code: ${res.statusCode}");
      print("Response body: ${res.body}");
      return null;
    }
  } catch (e) {
    print("Exception during registration: $e");
    return null;
  }
}


