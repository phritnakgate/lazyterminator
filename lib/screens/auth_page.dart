import 'package:flutter/material.dart';
import 'package:lazyterminator/screens/registerscreen.dart';
import 'package:lazyterminator/screens/startscreen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? StartScreen(onClickedSignUp: toggle)
      : RegisterScreen(onClickedSignIn: toggle);
  
  void toggle() => setState(() {
    isLogin = !isLogin;
  });
}
