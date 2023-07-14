import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_list_pick/country_selection_theme.dart';
import 'package:country_list_pick/support/code_country.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:olympic/home_screen.dart';
import 'package:olympic/provider/user_provider.dart';
import 'package:olympic/utils.dart';
import 'package:olympic/verify_email_screen.dart';
import 'package:provider/provider.dart';
import 'package:olympic/model/login_user.dart';

import 'main.dart';
import 'model/constant.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  // TextEditingController countryController = TextEditingController();
  // TextEditingController favoriteSportController = TextEditingController();

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
  // List<String> getSuggestions(String query,List<String> data)=>
  //     List.of(data).where(
  //             (category){
  //           final courseLower = category.toLowerCase();
  //           final queryLower = query.toLowerCase();
  //           return courseLower.contains(queryLower);
  //         }
  //     ).toList();


  Future signUp(UserProvider userProvider) async{
    final isValid = formKey.currentState!.validate();
    if(!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=> const Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent))
    );
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: mailController.text.trim(),
          password: passwordController.text.trim()
      ).then((data){
        data.user!.updateDisplayName(nameController.text);
        data.user!.updatePhotoURL("");
      });

      addUser(userProvider).then((_){
        navigatorKey.currentState!.pop();

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const VerifyEmailScreen()
        ));
      });

    } on FirebaseAuthException catch (e){
      print(e);
      Utils.showSnacBar(e.message);
      navigatorKey.currentState!.pop();
    }
  }
  Future<void> addUser(UserProvider userProvider) async {
    LoginUser loginUser = LoginUser(id: '', fullName: nameController.text, mail: mailController.text, phNo: phoneController.text);
    await userProvider.addUser(loginUser);
  }
  @override
  Widget build(BuildContext context) {
    // Widget countryPicker = CountryListPick(
    //   appBar: AppBar(
    //     title: const Text('Pick your country'),
    //   ),
    //   //if you need custom picker use this
    //   pickerBuilder: (context, CountryCode? countryCode) {
    //     if (countryCode != null){
    //       CountryCode c = countryCode;
    //       countryController.text = c.name!;
    //       return Row(
    //         children: [
    //           Image.asset(
    //             c.flagUri.toString(),
    //             package: 'country_list_pick',
    //             width: 30,
    //           ),
    //           const SizedBox(width: 18),
    //           Text(c.name.toString(),style: TextStyle(fontSize: 18,foreground: Paint()..shader = Constant.shader)),
    //         ],
    //       );
    //     }else{
    //       return const Placeholder();
    //     }
    //
    //   },
    //   theme: CountryTheme(
    //     isShowFlag: true,
    //     isShowTitle: true,
    //     isShowCode: true,
    //     isDownIcon: true,
    //     showEnglishName: false,
    //     labelColor: Colors.blueAccent,
    //   ),
    //   initialSelection: '+95',
    //   // or
    //   // initialSelection: 'US'
    //   onChanged: (CountryCode? code){
    //     if(code != null){
    //       setState(() {
    //         countryController.text = code.name!;
    //       });
    //     }
    //
    //   },
    // );

    // Widget favouriteSportPicker = TypeAheadFormField<String?>(
    //   textFieldConfiguration: TextFieldConfiguration(
    //       controller: favoriteSportController,
    //       style: TextStyle(fontSize: 18,foreground: Paint()?..shader = Constant.shader),
    //       decoration: InputDecoration(
    //         labelStyle: TextStyle(fontSize: 18 ,foreground: Paint()?..shader = Constant.shader),
    //         labelText: 'Your Favorite Sport',
    //
    //         border: GradientOutlineInputBorder(
    //           borderRadius: BorderRadius.circular(50),
    //           gradient: LinearGradient(colors: Constant.colors),
    //           width: 2,
    //         ),
    //         focusedBorder: GradientOutlineInputBorder(
    //             borderRadius: BorderRadius.circular(50),
    //             gradient:
    //             LinearGradient(colors: Constant.colors),
    //             width: 2),
    //
    //         ),
    //   ),
    //   onSuggestionSelected: (suggestion){
    //     favoriteSportController.text = suggestion!;
    //   },
    //   onSaved: (value)=> favoriteSportController.text = value.toString(),
    //   itemBuilder: (context,String? suggestion) => ListTile(
    //     title: Text(suggestion!),
    //   ),
    //   suggestionsCallback: (pattern) async {
    //     return getSuggestions(pattern,Constant.sports);
    //   },
    // );
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Image.asset("assets/images/logo.png",width: 200),
                  const SizedBox(height: 18),
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
                        return const SizedBox(height: 24);
                      }
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    decoration: InputDecoration(
                      label: const Text("Enter Your Name",style: TextStyle(fontSize: 18)),
                      labelStyle: TextStyle(fontSize: 18 ,foreground: Paint()?..shader = Constant.shader),
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
                  const SizedBox(height: 18),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (email){
                      email != null && !EmailValidator.validate(email) ?
                      'Enter a valid email' : null;
                    },
                    controller: mailController,
                    decoration: InputDecoration(
                      label: const Text("Enter Mail",style: TextStyle(fontSize: 18)),
                      labelStyle: TextStyle(fontSize: 18 ,foreground: Paint()?..shader = Constant.shader),
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
                  const SizedBox(height: 18),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 18 ,foreground: Paint()?..shader = Constant.shader),
                      label: const Text("Enter Password",style: TextStyle(fontSize: 18)),
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
                  const SizedBox(height: 18),
                  // favouriteSportPicker,
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text('  Your Country',style: TextStyle(fontSize: 18,foreground: Paint()..shader = Constant.shader)),
                  //     countryPicker,
                  //   ],
                  // ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 18 ,foreground: Paint()?..shader = Constant.shader),
                      label: const Text("Enter Phone Number",style: TextStyle(fontSize: 18)),
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
                  const SizedBox(height: 18),
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
                            onPressed: ()=> signUp(userProvider),
                            child: const Text("Sign Up",style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),)
                        ),
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
