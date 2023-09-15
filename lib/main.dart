import 'package:flutter/material.dart';
import 'package:lazyterminator/screens/auth_page.dart';
//import 'package:lazyterminator/screens/detailscreen.dart';
import 'package:lazyterminator/screens/homescreen.dart';
//import 'package:lazyterminator/screens/startscreen.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "SukhumvitSet"),
      title: "Lazy Terminator",
      home: const AuthPage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const HomeScreen(),
      }));
}
