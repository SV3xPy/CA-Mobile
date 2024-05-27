import 'package:ca_mobile/features/auth/screens/options_screen.dart';
import 'package:ca_mobile/features/onboarding/screens/onboarding_pages/intro_page_1.dart';
import 'package:ca_mobile/features/onboarding/screens/onboarding_pages/intro_page_2.dart';
import 'package:ca_mobile/features/onboarding/screens/onboarding_pages/intro_page_3.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LandingScreen extends StatefulWidget {
  static const routeName = '/onboarding';
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final PageController _controller = PageController();
  bool lastPage = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void navigateToOptionsScreen(BuildContext context) {
    Navigator.pushNamed(context, OptionsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(
                () {
                  lastPage = (index == 2);
                },
              );
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.90),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: const Text(
                    'Omitir',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const SwapEffect(
                    type: SwapType.yRotation,
                  ),
                ),
                lastPage
                    ? GestureDetector(
                        onTap: () {
                          navigateToOptionsScreen(context);
                        },
                        child: const Text(
                          "Listo",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                            curve: Curves.easeIn,
                          );
                        },
                        child: const Text(
                          "Siguiente",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
