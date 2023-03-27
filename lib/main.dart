import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:another_todo/Screens/navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EasySplashScreen(
        durationInSeconds: 7,
        futureNavigator: Future.value(
          MainNavigationScreen(),
        ),
        backgroundColor: Colors.lightBlue,
        logo: Image.asset(
          'lib/images/logo_spsc.png',
          width: 1200,
          height: 1200,
        ),
        logoWidth: 100,
        showLoader: true,
      ),
    );
  }
}
