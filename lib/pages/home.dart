import 'package:authentication/auth_api.dart';
import 'package:authentication/model/UserCubit.dart';
import 'package:authentication/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/usermodel.dart';
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user=context.read<UserCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home of ${user.firstName}'),
        actions: [
          OutlinedButton(

              onPressed: ()async {
            await logout(user.token!);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LogIn()), (route) => false);
          },
              style: OutlinedButton.styleFrom(
                side: BorderSide(width:2,color: Colors.blue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),)
              ),
              
              child:Text("LogOut",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),)
          )
        ],
      ),
    );
  }
}
