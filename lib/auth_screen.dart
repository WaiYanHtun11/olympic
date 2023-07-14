import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:olympic/admin/dashboard.dart';
import 'package:olympic/forget_password_screen.dart';
import 'package:olympic/provider/user_provider.dart';
import 'package:olympic/signup_screen.dart';
import 'package:olympic/utils.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'model/constant.dart';
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isVisible = false;
  late Future userFuture;

  Future _obtainUserFuture() async {
    return Provider.of<UserProvider>(context,listen: false).fetchAndSetUsers();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userFuture = _obtainUserFuture();
  }

  Future signIn() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=> const Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent))
    );

    // if(mailController.text.trim().compareTo("admin@olympic") == 0  && passwordController.text.trim().compareTo("password@olympic") == 0 ){
    //   navigatorKey.currentState!.pop();
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context)=>const Dashboard())
    //   );
    // }else{
    //
    // }
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: mailController.text.trim(),
          password: passwordController.text.trim()
      );
      await deleteUserNotInDB();
    } on FirebaseAuthException catch (e){
      print(e);
      Utils.showSnacBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route)=> route.isFirst);
  }

  Future<void> deleteUserNotInDB()async {
    if(Provider.of<UserProvider>(context,listen: false).isUserNotInDB(mailController.text.trim()) && mailController.text.trim() != "admin-olympic@gmail.com"){
      FirebaseAuth.instance.currentUser?.delete();
      Utils.showSnacBar('There is an error with this account');
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  FutureBuilder(
                    future: userFuture,
                      builder: (context,snapshot){
                        return Consumer<UserProvider>(
                          builder: (context,data,child){
                            return const SizedBox(height: 48);
                          }
                        );
                      }
                  ),
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
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(colors: Constant.colors),
                        width: 2,
                      ),
                      focusedBorder: GradientOutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          gradient:
                          LinearGradient(colors: Constant.colors),
                          width: 2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value)=> value != null && value.length < 6 ?
                    'Enter min of 6 characters' : null,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: isVisible,
                    controller: passwordController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(onPressed: ()=> setState(() {
                        isVisible = !isVisible;
                      }), icon: Icon(isVisible ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined,size: 32,color: Colors.green,)),
                      labelStyle: TextStyle(fontSize: 18 ,foreground: Paint()?..shader = Constant.shader),
                      label: const Text("Enter Password",style: TextStyle(fontSize: 20)),
                      border: GradientOutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(colors: Constant.colors),
                        width: 2,
                      ),
                      focusedBorder: GradientOutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          gradient:
                          LinearGradient(colors: Constant.colors),
                          width: 2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                      width: double.infinity,
                      height: 65,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: Constant.colors2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                                  blurRadius: 5) //blur radius of shadow
                            ]
                        ),
                        child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(16))
                                )
                            ),
                            onPressed: signIn,
                            child: const Text("Sign In",style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),)
                        ),
                      )
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                      onPressed: ()=> Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=> ForgetPasswordScreen(title: "reset"))
                      ),
                      child: Text(
                        'Forget Your Password',
                        style: TextStyle(
                            fontSize: 18,
                            foreground: Paint()?..shader = Constant.shader
                        ),
                      )
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Create New Account?',style: TextStyle(fontSize: 18)),
                      TextButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context )=> const SignupScreen())
                            );
                          },
                          child: const Text('Sign Up',style: TextStyle(fontSize: 18))
                      )
                    ],
                  )

                ],
              ),
          ),
        ),
      ),
    );
  }
}
