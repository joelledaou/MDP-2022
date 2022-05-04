import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/Start.dart';
import 'screens/SignIn.dart';
import 'screens/Charts.dart';
import 'screens/Savings.dart';
import 'screens/EditProfile.dart';
import 'screens/Settings.dart';
import 'screens/drop.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: const Start(),
        initialRoute: '/',
        routes: {
          // '/': (context) => const Start(),
          '/': (context) => const Drop(),
          '/charts': (context) => const Charts(),
          '/savings': (context) => const Savings(),
          '/profile': (context) => const EditProfilePage(),
          '/settings': (context) => const Settings()
        });
  }
}
