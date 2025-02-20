// onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:intern_flutter/pages/register_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class onboarding_page extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<onboarding_page> {
  final PageController _onboardingController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Onboarding",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            SmoothPageIndicator(
              controller: _onboardingController,
              count: 3,
              effect: ExpandingDotsEffect(
                dotHeight: 8.0,
                dotWidth: 50.0,
                spacing: 16.0,
                dotColor: Colors.grey,
                activeDotColor: Colors.deepPurple,
              ),
            ),
            Expanded(
              child: PageView(
                controller: _onboardingController,
                onPageChanged: _onPageChanged,
                children: [
                  OnboardingContent(
                    image: 'assets/hoursTrulyLogo.png',
                    title:
                        'Hey there! Ready to make the most of your internship?',
                    description: 'Hello',
                    onNext: () {
                      _onboardingController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    isLastPage: false,
                  ),OnboardingContent(
                    image: 'assets/hoursTrulyLogo.png',
                    title:
                        'Log Your Hours',
                    description: 'Hello',
                    onNext: () {
                      _onboardingController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    isLastPage: false,
                  ),
                  OnboardingContent(
                    image: 'assets/hoursTrulyLogo.png',
                    title: 'Log Your Hours',
                    description: 'Keep a record of your working hours.',
                    onNext: () {
                      _onboardingController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    isLastPage: false,
                  ),
                  OnboardingContent(
                    image: 'assets/hoursTrulyLogo.png',
                    title: 'Weekly Reports',
                    description: 'Generate weekly progress reports.',
                    onNext: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => register_page()),
                      );
                    },
                    isLastPage: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final VoidCallback onNext;
  final bool isLastPage;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.onNext,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 200,
            child: Gif(
              image: AssetImage("logo.gif"),
              autostart: Autostart.loop,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: onNext,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      isLastPage ? 'Get Started' : 'Let\'s Go',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
