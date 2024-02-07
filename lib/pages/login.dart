import 'package:authentication/auth_api.dart';
import 'package:authentication/model/usermodel.dart';
import 'package:authentication/pages/home.dart';
import 'package:authentication/pages/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/UserCubit.dart';

class LogIn extends StatelessWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.blue.shade300,
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 80, right: 30),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 50, left: 30, right: 30),
              child: TextField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, left: 30, right: 30),
              child: TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.green, width: 4),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    var authRes = await userAuth(_email.text, _password.text);

                    print("Auth result: $authRes");

                    if (authRes == null) {
                      print("Authentication result is null");
                      // Handle the case when authentication result is null
                      return;
                    }

                    if (authRes.runtimeType == String) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Container(
                              alignment: Alignment.center,
                              height: 200,
                              width: 250,
                              decoration: BoxDecoration(),
                              child: Text(authRes as String),
                            ),
                          );
                        },
                      );
                    } else if (authRes.runtimeType == User) {
                      User user = authRes;
                      context.read<UserCubit>().emit(user);
                      print("Navigation to home page");

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return MyHomePage();
                        }),
                      );
                    }
                  } catch (e) {
                    print("Error during navigation: $e");
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Background color
                  onPrimary: Colors.white, // Text color
                ),
                child: Text('Login'),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Row(
                children: [
                  Text(
                    'New user =====>',
                    style: TextStyle(fontSize: 15),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: Text(
                      'Register ',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
