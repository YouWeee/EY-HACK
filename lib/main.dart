  import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,  // Removes the debug banner
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
      home: const SplashScreen(), // Set SplashScreen as initial screen
    );
  }
}