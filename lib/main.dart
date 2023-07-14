import 'package:flutter/material.dart';
import 'package:olympic/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:olympic/forget_password_screen.dart';
import 'package:olympic/home_screen.dart';
import 'package:olympic/main_screen.dart';
import 'package:olympic/provider/history_provider.dart';
import 'package:olympic/provider/user_provider.dart';
import 'package:olympic/provider/video_provider.dart';
import 'package:olympic/signup_screen.dart';
import 'package:olympic/splash_screen.dart';
import 'package:olympic/verify_email_screen.dart';
import 'package:provider/provider.dart';

import 'admin/dashboard.dart';
import 'model/constant.dart';
Future main() async{
  if(!Constant.isWeb){
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();
final messengerKey = GlobalKey<ScaffoldMessengerState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
              create: (context) => UserProvider()
          ),
          ChangeNotifierProvider<VideoProvider>(
              create: (context) => VideoProvider()
          ),
          ChangeNotifierProvider<HistoryProvider>(
              create: (context) => HistoryProvider()
          )
        ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
          scaffoldMessengerKey: messengerKey,
          debugShowCheckedModeBanner: false,
          title: Constant.appName,
          theme: ThemeData(
            appBarTheme: AppBarTheme.of(context).copyWith(
              backgroundColor: Colors.white,
              shadowColor: Colors.black26,
              elevation: 2
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
            useMaterial3: true,
          ),
          home: const SplashScreen()
      ),
    );
  }
}
