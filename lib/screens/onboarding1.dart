import 'package:flutter/material.dart';
import 'package:my_app/screens/login_screen.dart'; // Ensure this file exists
import 'dart:async'; // Import for Timer

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer; // Timer for auto-sliding

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/movie1.jpg',
      'title': 'Find Your Next Favorite Movie Here',
      'description':
          'Get access to an extensive library of movies, from timeless classics to the latest blockbusters.'
    },
    {
      'image': 'assets/images/movie2.jpg',
      'title': 'Watch Anytime, Anywhere',
      'description':
          'Stream your favorite movies and TV shows on any device at your convenience.'
    },
    {
      'image': 'assets/images/movie3.jpg',
      'title': 'Discover New Releases',
      'description':
          'Stay updated with the latest blockbuster releases and trending films.'
    }
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide(); // Start auto-sliding when the screen loads
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to avoid memory leaks
    _pageController.dispose(); // Dispose of the PageController
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < onboardingData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // Loop back to the first page
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              return OnboardingPage(
                image: onboardingData[index]['image']!,
                title: onboardingData[index]['title']!,
                description: onboardingData[index]['description']!,
                showButton: index == onboardingData.length - 1,
                onButtonPressed: () {
                  _timer?.cancel(); // Stop the timer when navigating away
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: _currentPage == index ? 12 : 8,
      height: _currentPage == index ? 12 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? const Color.fromARGB(255, 223, 51, 39)
            : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image, title, description;
  final bool showButton;
  final VoidCallback? onButtonPressed;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.showButton = false,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (showButton)
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 206, 19, 28),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: onButtonPressed,
                          child: const Text(
                            'Explore Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
