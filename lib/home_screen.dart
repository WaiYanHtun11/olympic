import 'dart:math';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olympic/forget_password_screen.dart';
import 'package:olympic/model/login_user.dart';
import 'package:olympic/provider/user_provider.dart';
import 'package:olympic/slide.dart';
import 'package:olympic/update_profile.dart';
import 'package:olympic/view_sports_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/constant.dart';
class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  late Future userFuture;

  Future _obtainUserFuture() async {
    return Provider.of<UserProvider>(context,listen: false).fetchAndSetUsers();
  }
  late LoginUser loginUser = LoginUser(id: '', fullName: '', mail: '', phNo: '');
  late User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser?.reload();
    user = FirebaseAuth.instance.currentUser!;
    userFuture = _obtainUserFuture();
  }

  @override
  Widget build(BuildContext context) {

    var alertDialog = AlertDialog(
      title: const Text("Log out Alert!"),
      content: const Text("Are you sure you want to log out?",style: TextStyle(fontSize: 20),),
      actions: [
        TextButton(onPressed: ()=> Navigator.of(context).pop(), child: const Text('NO',style: TextStyle(fontSize: 16),)),
        TextButton(onPressed: (){
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pop();
        }, child: const Text('Yes',style: TextStyle(fontSize: 16),))
      ],
    );

    var paint = Paint()?..shader = Constant.shader;
    Widget homeWidget = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Slide(),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(5, 2.5, 5, 2.5),
            itemCount: Constant.sampleSports.length,
            itemBuilder: (context,index){
              return Card(
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ViewSportsScreen(name: Constant.sampleSports[index].name)
                        )
                    );
                  },
                  child: Column(
                    children: [
                      const SizedBox(height: 14),
                      ShaderMask(
                        shaderCallback: (Rect bounds){
                          return LinearGradient(
                              colors: Constant.colors
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcATop,
                        child: Image.asset('assets/images/${Constant.sampleSports[index].image}',width: 60),
                      ),
                      ListTile(
                        title: Text(Constant.sampleSports[index].name,style: const TextStyle(fontSize: 16),textAlign: TextAlign.center,),
                        //trailing: const Icon(Icons.chevron_right),
                      )
                    ],
                  ),
                ),
              );
            }, gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          ),
        ),
      ],
    );
    Widget profileWidget = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 250,
          child: Card(
            child: ListView(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: FirebaseAuth.instance.currentUser!.photoURL == null ? const Icon(Icons.account_circle,color: Colors.deepOrangeAccent,size: 80,) :
                            Container(
                              height: 95,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: FadeInImage(
                                  image: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL?? ""),
                                  placeholder: const AssetImage('assets/images/account.png'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: ()=> Navigator.of(context).push(
                              MaterialPageRoute(builder: (context)=> UpdateProfile(user: loginUser))
                            ),
                            icon: const Icon(Icons.edit,size: 20,color: Colors.deepOrangeAccent),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(user.displayName!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,foreground: paint),textAlign: TextAlign.center,),
                  Text(user.email!,style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,foreground: paint),textAlign: TextAlign.center),
                 // Text(loginUser.phNo,style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,foreground: paint),textAlign: TextAlign.center),
                ]
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.lock_reset_outlined,size: 32,),
            title: const Text('Change Password',style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
            onTap: ()=> Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=> ForgetPasswordScreen(title: 'update'))
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        )
      ],
    );

    final pages = [
      homeWidget,
      profileWidget
    ];

    final bottomNavigationBarItem = [
      const BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.account_circle),label: 'Profile')
    ];

    final bottomNavBar = BottomNavigationBar(
        items: bottomNavigationBarItem,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index){setState(() {
        currentIndex = index;
      });},
    );

    return FutureBuilder(
      future: userFuture,
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent));
          }else{
            return Consumer<UserProvider>(
                builder: (context,data,child){
                  loginUser = data.getUserByMail(FirebaseAuth.instance.currentUser!.email!)!;
                  setPreference(loginUser.id);
                  return Scaffold(
                    appBar: AppBar(
                      shadowColor: Colors.black26,
                      // leading: Builder(
                      //   builder: (BuildContext context) {
                      //     return IconButton(
                      //       onPressed: ()=> Scaffold.of(context).openDrawer(),
                      //       icon: const Icon(Icons.menu,color: Colors.deepOrange,size: 32),
                      //     );
                      //   },
                      // ),
                      title: Text(
                        Constant.appName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          foreground: Paint()
                            ?..shader = Constant.shader,
                        ),
                      ),
                      actions: [
                        IconButton(onPressed: ()=> showDialog(
                            context: context,
                            builder: (context) => alertDialog
                        ),
                            icon: const Icon(Icons.logout,size: 32,color: Colors.deepOrangeAccent))
                      ],
                    ),
                    body: pages[currentIndex],
                    bottomNavigationBar: bottomNavBar,
                  );
                }
            );
          }

        }
    );
  }

  Future<void> setPreference(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id') ?? "";
    if(userId.isEmpty){
      prefs.setString('id', id);
    }
  }
}
