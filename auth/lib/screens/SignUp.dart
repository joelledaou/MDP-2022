import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../reusable_widgets/reusable_widgets.dart';
import '../utils/colors.dart';
import 'Home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _confirmPasswordTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        reusableTextField("Username", Icons.person_outline,
                            false, _usernameTextController),
                        const SizedBox(height: 20),
                        reusableTextField("Email", Icons.person_outline, false,
                            _emailTextController),
                        const SizedBox(height: 20),
                        reusableTextField("Password", Icons.lock_outlined, true,
                            _passwordTextController),
                        const SizedBox(height: 20),
                        reusableTextField(
                            "Confirm Password",
                            Icons.lock_outlined,
                            true,
                            _confirmPasswordTextController),
                        const SizedBox(height: 20),
                        SignInSignUpButton(context, false, () {
                          FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text)
                              .then((value) {
                                print("Created new account");
                                Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => Home()));
                              })
                              .onError((error, stackTrace) {
                                print("Error ${error.toString()}");
                              });
                        })
                      ],
                    )))));
  }
}
