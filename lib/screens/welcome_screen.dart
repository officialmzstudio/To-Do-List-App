import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'intro_slider_screen.dart';
import 'dart:async';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // بعد از 3 ثانیه برو به اسلایدر
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IntroSliderScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // تصویر آدمک وسط
            SvgPicture.asset(
              'assets/images/learn.svg',
              width: 350,
              height: 350,
            ),
            const SizedBox(height: 130),
            // عنوان
            const Text(
              'Yaddasht',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Color(0xFF16404D),
                fontFamily: 'ubuntu',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
