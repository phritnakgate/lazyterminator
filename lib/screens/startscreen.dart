import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lazyterminator/screens/homescreen.dart';

class StartScreen extends StatefulWidget {
  //SignUp
  final VoidCallback onClickedSignUp;

  const StartScreen({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String currentScreen = "Welcome";
  String txt = "Welcome to Lazy Terminator!";

  //SignIn
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              backgroundColor: const Color.fromRGBO(254, 230, 159, 1),
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("images/main_logo.png", width: 200, height: 200),
                  Text(
                    txt,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(23, 15, 106, 1)),
                  ),
                  const SizedBox(height: 10),
                  currentScreen == "Welcome"
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentScreen = "Login";
                              txt = "Login";
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder()),
                          child: const Icon(Icons.arrow_right_alt_rounded),
                        )
                      : SizedBox(
                          width: 350,
                          child: Column(
                            children: [
                              TextField(
                                controller: emailController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: passwordController,
                                textInputAction: TextInputAction.done,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: signIn,
                                child: const Text('Login'),
                              ),
                              const SizedBox(height: 10),
                              RichText(
                                  text: TextSpan(
                                text: "Don't have an account? ",
                                style: const TextStyle(
                                    color: Color.fromRGBO(23, 15, 106, 1)),
                                children: [
                                  TextSpan(
                                      text: "Sign up here",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = widget.onClickedSignUp,
                                      style: const TextStyle(
                                          color: Color.fromRGBO(23, 15, 106, 1),
                                          decoration: TextDecoration.underline))
                                ],
                              ))
                            ],
                          ),
                        ),
                ],
              )),
            );
          } else {
            return const HomeScreen();
          }
        });
  }
}
