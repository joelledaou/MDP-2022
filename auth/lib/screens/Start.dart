import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'SignIn.dart';
import 'SignUp.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(padding:EdgeInsets.only(top: 100.0)),
            Container(
              height: 400,
              child: const Image(
                  image: AssetImage("assets/images/start.jpg"),
                  fit: BoxFit.contain),
            ),
            // SizedBox(height: 20),
            RichText(
                text: TextSpan(
                    text: 'Welcome to Invertracker',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: hexStringToColor("9546C4")),
                    )),
            SizedBox(height: 10.0),
            const Text('Stay up to date even miles away',
                style: TextStyle(color: Colors.black, fontSize: 17)),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn())),
                    child: const Text('LOGIN',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.only(left: 30, right: 30)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(hexStringToColor("9546C4")),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          // side: BorderSide(color: Colors.red)
                        )))),
                const SizedBox(width: 20.0),
                ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp())),
                    child: const Text('REGISTER',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.only(left: 30, right: 30)),
                        backgroundColor: 
                            MaterialStateProperty.all<Color>(hexStringToColor("9546C4")),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          // side: BorderSide(color: Colors.red)
                        )))),
              ],
            ),
            /*
            SizedBox(height: 20.0),
            SignInButton(
              Buttons.Google,
              text: "Sign up with Google",
              onPressed: () {},
            )
            */
          ],
        ),
      ),
    );
  }
}
