import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/screens/home.dart';
import 'package:weight_tracker/screens/sign_in.dart';
import 'package:weight_tracker/service_locator.dart';
import 'package:weight_tracker/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: serviceLocator<AuthService>().loggedIn() != null
          ? HomeScreen()
          : SignInScreen(),
    );
  }
}
