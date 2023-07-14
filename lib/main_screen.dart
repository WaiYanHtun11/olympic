import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olympic/admin/dashboard.dart';
import 'package:olympic/auth_screen.dart';
import 'package:olympic/home_screen.dart';
import 'package:olympic/verify_email_screen.dart';
class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent));
          }else if(snapshot.hasError){
            return const Center(child: Text('Something Went Wrong!'));
          }else{
            if(snapshot.hasData){
              return snapshot.data?.email == "admin-olympic@gmail.com" ? const Dashboard() : HomeScreen();
            }else{
              return const AuthScreen();
            }
          }
        })
      );
  }
}
