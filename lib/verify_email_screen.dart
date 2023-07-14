import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olympic/auth_screen.dart';
import 'package:olympic/home_screen.dart';
import 'package:olympic/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen.dart';
import 'model/constant.dart';
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  bool clickedResend = false;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isEmailVerified){
      sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
          (_)=> checkEmailVerified()
      );
    }

  }
  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  Future sendVerificationEmail() async{
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
    Utils.showSnacBar('Email Verification Sent');
    setState(() {
      canResendEmail = false;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      canResendEmail = true;
    });

  }

  Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if(isEmailVerified) timer?.cancel();
  }

  void goToLogin(){
    FirebaseAuth.instance.signOut().then((_){
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context)=> const MainScreen()), (route) => false
      );
    });

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xBCE57C6E),
                radius: 100,
                child: Icon(isEmailVerified ? Icons.mark_email_read_outlined: Icons.mark_email_unread_outlined,size: 128,color: Colors.white,),
              ),
              const SizedBox(
                height: 36,
              ),
              Text(isEmailVerified ?  'Email Verified!\nYou can Log In now': 'A verification mail has been sent to your email',style: TextStyle(fontSize: 22),textAlign: TextAlign.center,),
              const SizedBox(height: 36),
              SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: Constant.colors2,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                              blurRadius: 5) //blur radius of shadow
                        ]
                    ),
                    child:  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent
                      ),
                      onPressed: isEmailVerified ? goToLogin : canResendEmail ? sendVerificationEmail : null,
                      icon: Icon(isEmailVerified ? Icons.login : Icons.mail,size: 32,color: Colors.white,),
                      label: Text(isEmailVerified ? "Log In": "Resend Mail",style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                      )),
                    ),
                  )
              ),
              const SizedBox(height: 24),
              if(!isEmailVerified)
                SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),

                        border: Border.all(color: Colors.deepOrangeAccent,width: 1.5)
                    ),
                    child: OutlinedButton(
                        onPressed: ()=> FirebaseAuth.instance.signOut(),
                        child: const Text('Cancel',style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),)
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );

  }
}
