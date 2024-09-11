import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onClickedSignIn;

  const RegisterScreen({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(254, 230, 159, 1),
        body: Center(
            child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset("images/main_logo.png", width: 200, height: 200),
            const Text(
              "Sign Up",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(23, 15, 106, 1)),
            ),
            const SizedBox(height: 10),
            SizedBox(
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
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: confirmPasswordController,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (confirmPasswordController.value ==
                          passwordController.value) {
                        signUp();
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text("Password do not match"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("OK"),
                                    )
                                  ],
                                ));
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                      text: TextSpan(
                    text: "Already have an account? ",
                    style:
                        const TextStyle(color: Color.fromRGBO(23, 15, 106, 1)),
                    children: [
                      TextSpan(
                          text: "Sign in here",
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignIn,
                          style: const TextStyle(
                              color: Color.fromRGBO(23, 15, 106, 1),
                              decoration: TextDecoration.underline))
                    ],
                  ))
                ],
              ),
            ),
          ]),
        )));
  }
}
