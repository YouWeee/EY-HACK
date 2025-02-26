import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'language_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to LanguageSelectionScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LanguageSelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8FAE0), // Background color
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Container
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(
                  'assets/images/seva_setu_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Seva Setu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B4B3C),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'THE BRIDGE BETWEEN YOUR RIGHTS AND YOU',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 30),
              // Loading indicator
              const CircularProgressIndicator(
                color: Color(0xFF1B4B3C),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 