import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../reusable_widgets/reusable_widgets.dart';
import '../utils/colors.dart';
import 'Home.dart';
import 'SignIn.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
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
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Reset Password", () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(child: CircularProgressIndicator()));
                  
                  const SizedBox(height: 80);
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    /*
                    const Text(
                        "We've sent you an email to joelledaou2000@hotmail.com\nReset your password and try logging in again",
                        style: TextStyle(color: Colors.white70)),
                        */
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) => SignIn()));
                        },
                        child: const Text(
                          "We've sent an email to joelledaou2000@hotmail.com\nReset your password and try logging in again here",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                     ],
                  );
                  
       
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: _emailTextController.text)
                      .then((value) => Navigator.of(context).pop());
                  
                  //resetPassword();
                  //goBackToHome()
                }),
                //goBackToHome()
              ],
            ),
          ))),
    );
  }

  /*
  Future resetPassword() async {
    //goBackToHome();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailTextController.text)
          .then((value) => Navigator.of(context).pop());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Row goBackToHome() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /*
        const Text(
            "We've sent you an email to joelledaou2000@hotmail.com\nReset your password and try logging in again",
            style: TextStyle(color: Colors.white70)),
            */
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignIn()));
          },
          child: const Text(
            "We've sent an email to joelledaou2000@hotmail.com\nReset your password and try logging in again here",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
  */
}
