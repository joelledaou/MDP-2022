import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../reusable_widgets/reusable_widgets.dart';
import '../utils/colors.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'Home.dart';
import 'SignIn.dart';

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
                        firebaseUIButton(context, "SIGN UP", () {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text)
                              .then((value) {
                            print("Created new account");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          }).onError((error, stackTrace) {
                            print("Error ${error.toString()}");
                          });
                        }),
                        const SizedBox(height: 5.0),
                        SignInButton(
                          Buttons.Google,
                          text: "Sign up with Google",
                          //shape: ,
                          onPressed: () {},
                        ),
                        const SizedBox(height: 20.0),
                        signInOption()
                      ],
                    )))));
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? Log in",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignIn()));
          },
          child: const Text(
            " here",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
