import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footbook/screens/home_page.dart';
import 'package:footbook/screens/splash_screen_page.dart';
import 'package:footbook/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Footbook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.light,

        ),
        useMaterial3: true,

      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage(),

    );
  }
}
