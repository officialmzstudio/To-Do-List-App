import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_screen.dart';

class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({super.key});

  @override
  State<IntroSliderScreen> createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Manage your tasks',
      'description': 'You can easily manage all of your daily tasks in Yaddasht for free!',
      'image': 'assets/images/slide1.svg',
    },
    {
      'title': 'Create daily routine',
      'description': 'In Yaddasht you can create your personalized routine to stay productive',
      'image': 'assets/images/slide2.svg',
    },
    {
      'title': 'My first app!',
      'description': 'Simple idea! Big step. This is the first app I created — hope you enjoy it!',
      'image': 'assets/images/slide3.svg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      // عنوان سبز بالا
                      Text(
                        _slides[index]['title']!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFA6CDC6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // تصویر وسط
                      Expanded(
                        child: SvgPicture.asset(
                          _slides[index]['image']!,
                          width: MediaQuery.of(context).size.width * 0.5,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // توضیح پایین
                      Text(
                        _slides[index]['description']!,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 60),

                      // Indicator خطی
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_slides.length, (i) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 4,
                            width: 32,
                            decoration: BoxDecoration(
                              color: _currentPage == i
                                  ? const Color(0xFFAFAFAF) // خط پررنگ
                                  : const Color(0xFFECECEC), // خط کمرنگ
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                );
              },
            ),

            // دکمه فقط در آخرین اسلاید پایین سمت راست
            if (_currentPage == _slides.length - 1)
              Positioned(
                bottom: 24,
                right: 24,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // سایه ملایم
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB967),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0, // فقط از Container سایه بیاد
                    ),
                    child: const Text(
                      'GET STARTED',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
