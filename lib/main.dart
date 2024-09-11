import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:lazyterminator/screens/auth_page.dart';
import 'package:lazyterminator/screens/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io' show Platform;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if running in a local environment (e.g., .env file exists).
  bool isLocalEnv = Platform.environment.isEmpty; // Vercel will have non-empty environment variables
  
  if (isLocalEnv) {
    // If in local development, load the .env file
    await dotenv.load(fileName: '.env');
  }

  // Load Firebase options either from the system environment (Vercel) or the .env file.
  await Firebase.initializeApp(
    options: FirebaseOptions(
      appId: Platform.environment['APPID'] ?? dotenv.env['APPID'] ?? '',
      apiKey: Platform.environment['APIKEY'] ?? dotenv.env['APIKEY'] ?? '',
      messagingSenderId: Platform.environment['MESSAGESERVICEID'] ?? dotenv.env['MESSAGESERVICEID'] ?? '',
      projectId: Platform.environment['PROJECTID'] ?? dotenv.env['PROJECTID'] ?? '',
      databaseURL: Platform.environment['DATABASEURL'] ?? dotenv.env['DATABASEURL'] ?? '',
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
