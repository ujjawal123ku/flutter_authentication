import 'package:authentication/auth_api.dart';
import 'package:authentication/constant.dart';
import 'package:authentication/model/UserCubit.dart';
import 'package:authentication/model/usermodel.dart';
import 'package:authentication/pages/home.dart';
import 'package:authentication/pages/login.dart';
import 'package:authentication/pages/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return UserCubit(User());
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<Box>(
          future: Hive.openBox(tokenBox),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                var box = snapshot.data!;
                var token = box.get('token');

                if (token != null) {
                  // If token is available, try to fetch user data
                  return FutureBuilder<User?>(
                    future: getUser(token),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData && snapshot.data != null) {
                        User user=snapshot.data!;
                        user.token=token;
                        // If user data is fetched successfully, navigate to home page
                        context.read<UserCubit>().emit(user);
                        return const MyHomePage();
                      } else {
                        // If user data couldn't be fetched, show login page
                        return const LogIn();
                      }
                    },
                  );
                } else {
                  // If token is not available, show login page
                  return const LogIn();
                }
              } else if (snapshot.hasError) {
                // If there's an error while opening Hive box, show login page
                return const LogIn();
              }
            }

            // While Hive box is being opened, show loading indicator
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
