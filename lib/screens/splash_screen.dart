import 'package:flutter/material.dart';
import '../theme.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const OnboardingScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cDark, cDark2, Color(0xFF0E1A40)],
          ),
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: cBlue,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _discRow([cYellow, cRed, cYellow]),
                    const SizedBox(height: 4),
                    _discRow([cRed, cYellow, cRed]),
                    const SizedBox(height: 4),
                    _discRow([cBlue, cRed, cBlue]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800,
                    color: cText, letterSpacing: 1),
                children: [
                  TextSpan(text: 'Connect '),
                  TextSpan(text: '4', style: TextStyle(color: cYellow)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text('DROP. CONNECT. WIN.',
                style: TextStyle(fontSize: 12, color: cMuted, letterSpacing: 3)),
            const SizedBox(height: 60),
            const SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: cBlue),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _discRow(List<Color> colors) {
    return Row(mainAxisSize: MainAxisSize.min,
      children: colors.map((c) => Container(
        width: 18, height: 18,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      )).toList(),
    );
  }
}
