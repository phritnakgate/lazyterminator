import 'package:flutter/material.dart';
import 'package:lazyterminator/screens/auth_page.dart';
import 'package:lazyterminator/screens/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use compile-time constants for environment variables, injected via --dart-define
  const String appId = String.fromEnvironment('APPID', defaultValue: '');
  const String apiKey = String.fromEnvironment('APIKEY', defaultValue: '');
  const String messagingSenderId = String.fromEnvironment('MESSAGESERVICEID', defaultValue: '');
  const String projectId = String.fromEnvironment('PROJECTID', defaultValue: '');
  const String databaseUrl = String.fromEnvironment('DATABASEURL', defaultValue: '');

  // Initialize Firebase with environment variables
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: appId,
      apiKey: apiKey,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      databaseURL: databaseUrl,
    ),
  );

  // Run the Flutter app
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: "SukhumvitSet"),
    title: "Lazy Terminator",
    home: const AuthPage(),
    routes: <String, WidgetBuilder>{
      '/home': (BuildContext context) => const HomeScreen(),
    },
  ));
}
