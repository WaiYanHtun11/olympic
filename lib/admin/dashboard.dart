import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olympic/admin/manage_user.dart';
import 'package:olympic/admin/manage_video.dart';
import 'package:olympic/admin/summary.dart';
import 'package:olympic/auth_screen.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import '../provider/video_provider.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var currentIndex = 0;

  void switchScreen(int index){
    setState(() {
      if(index != currentIndex){
        setState(() {
          currentIndex = index;
        });
      }
    });
  }


  var drawerHeader = SizedBox(
    height: 200,
    child: Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
            colors: [Colors.deepOrangeAccent,Colors.blueAccent],
            radius: 3
        ),
      ),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset('assets/images/logo.png',width: 45,),),
          ),
          const SizedBox(height: 6),
          const Text('Olympic',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
          const Text('admin@olympic.com',style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal,color: Colors.white),textAlign: TextAlign.center),
          const SizedBox(height: 10)
        ],
      ),
    ),
  );
  Widget buildListTile(IconData icon,String title,int index){
    return ListTile(
      onTap: (){
          if(index != currentIndex){
            setState(() {
              currentIndex = index;
            });
          }
      },
      leading: Icon(icon),
      title: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    var alertDialog = AlertDialog(
      title: const Text("Log out Alert!"),
      content: const Text("Are you sure you want to log out?",style: TextStyle(fontSize: 20),),
      actions: [
        TextButton(onPressed: ()=> Navigator.of(context).pop(), child: const Text('NO',style: TextStyle(fontSize: 16),)),
        TextButton(onPressed: (){
          FirebaseAuth.instance.signOut().then((_){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context)=> const AuthScreen()
                )
            );
          });
        },
            child: const Text('Yes',style: TextStyle(fontSize: 16),))
      ],
    );

    var widgets = [
      Summary(switchScreen: switchScreen),
      const ManageUser(),
      const ManageVideo()
    ];

    var drawerItems = ListView(
      children: [
        drawerHeader,
        const SizedBox(height: 8),
        buildListTile(Icons.dashboard, 'Dashboard',0),
        const Divider(),
        buildListTile(Icons.groups_outlined, 'Users',1),
        const Divider(),
        buildListTile(Icons.movie_outlined, 'Videos',2),
        const Divider(),
      ],
    );
    return Scaffold(
      drawer: Drawer(
        child: drawerItems,
      ),
      appBar: AppBar(
        foregroundColor: Colors.deepOrangeAccent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: ()=> Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu,color: Colors.deepOrange,size: 32),
            );
          },
        ),
        title: const Text('Dashboard',textAlign: TextAlign.left,),
        actions: [
          IconButton(
              onPressed: ()=> switchScreen(0), 
              icon: const Icon(Icons.dashboard_outlined,size: 32,)
          ),
          IconButton(
              onPressed: ()=> switchScreen(1),
              icon: const Icon(Icons.groups_outlined,size: 32,)
          ),
          IconButton(
              onPressed: ()=> switchScreen(2),
              icon: const Icon(Icons.video_settings,size: 32,)
          ),
          IconButton(
              onPressed: ()=> showDialog(
                  context: context,
                  builder: (context) => alertDialog
              ),
              icon: const Icon(Icons.logout,size: 32,)
          ),
          
        ],
      ),
      body: widgets[currentIndex],
    );
  }
}
