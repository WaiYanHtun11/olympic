import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:olympic/utils.dart';

import 'main.dart';
import 'model/constant.dart';
class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({Key? key,required this.title}) : super(key: key);
  String title;

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController mailController = TextEditingController();

  Future verifyEmail() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=> const Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent))
    );
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: mailController.text.trim()
      ).then((value) => Utils.showSnacBar('Password Reset Email Sent'));
      navigatorKey.currentState!.popUntil((route)=> route.isFirst);
    } on FirebaseAuthException catch(e){
      print(e);
      Utils.showSnacBar(e.message);
      Navigator.of(context).pop();
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.deepOrangeAccent,
        title: Text(widget.title == "update" ? "Change Password" : "Forget Password" ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png",width: 200),
                const SizedBox(height: 24),
                Text(
                  Constant.appName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    foreground: Paint()
                      ?..shader = Constant.shader,
                  ),
                ),
                const SizedBox(height: 48),
                Text('Receive an email to ${widget.title} your password',style: const TextStyle(
                  fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email){
                    email != null && !email.contains('@gmail.com') ?
                    'Enter a valid email' : null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: mailController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 18 ,foreground: Paint()?..shader = Constant.shader),
                    label: const Text("Enter Mail",style: TextStyle(fontSize: 20)),
                    border: GradientOutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(colors: Constant.colors),
                      width: 2,
                    ),
                    focusedBorder: GradientOutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        gradient:
                        LinearGradient(colors: Constant.colors),
                        width: 2),
                  ),
                ),
                const SizedBox(height: 24),
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
                          onPressed: verifyEmail,
                          icon: const Icon(Icons.mail,size: 32,color: Colors.white,),
                          label: const Text("Send Email",style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                          )),
                      ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
