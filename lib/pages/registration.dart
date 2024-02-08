import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication/auth_api.dart';
import '../model/UserCubit.dart';
import '../model/usermodel.dart';
import 'home.dart';
import 'login.dart'; // assuming you have a login page defined

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _userName = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _userName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade300,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50, right: 30),
                child: Text(
                  'Register',
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
                padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                child: TextField(
                  controller: _userName,
                  decoration: InputDecoration(
                    labelText: 'UserName',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10,),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 30,),
                      child: TextField(
                        controller: _firstName,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green, width: 4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: TextField(
                        controller: _lastName,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green, width: 4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                child: TextField(
                  controller: _confirmPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),


              SizedBox(height: 30),

              Container(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      // Validate user input
                      if (_email.text.isEmpty ||
                          _userName.text.isEmpty ||
                          _firstName.text.isEmpty ||
                          _lastName.text.isEmpty ||
                          _password.text.isEmpty ||
                          _confirmPassword.text.isEmpty) {
                        // Show an error message if any field is empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill in all fields')),
                        );
                        return;
                      }

                      // Check if passwords match
                      if (_password.text != _confirmPassword.text) {
                        // Show an error message if passwords don't match
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Passwords do not match')),
                        );
                        return;
                      }

                      var result = await registerUser(
                        _email.text,
                        _userName.text,
                        _firstName.text,
                        _lastName.text,
                        _password.text,
                        _confirmPassword.text,
                      );

                      print("Auth result: $result");
                      if (result != null) {
                        context.read<UserCubit>().emit(result);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      } else {
                        // Show an error message if registration fails
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration failed')),
                        );
                      }
                    } catch (e) {
                      print("Error during registration: $e");
                      // Show an error message if an exception occurs during registration
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error during registration')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Background color
                    onPrimary: Colors.white, // Text color
                  ),
                  child: Text('Register'),
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: 30,right: 30,top: 20),
                child: Row(
                  children: [
                    Text("Already Registered? ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                    InkWell(
                      onTap: (){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LogIn()),
                        );
                      },
                      child: Text("Log In",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,color: Colors.green),),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
