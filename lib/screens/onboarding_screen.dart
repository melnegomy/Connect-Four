import 'package:flutter/material.dart';
import '../theme.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _page = 0;

  void _goHome() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cDark,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              GestureDetector(
                onTap: _goHome,
                child: const Text('Skip',
                    style: TextStyle(color: cMuted, fontSize: 14)),
              ),
            ]),
          ),
          Expanded(child: _page == 0 ? _page1() : _page2()),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _dot(_page == 0),
                const SizedBox(width: 6),
                _dot(_page == 1),
              ]),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_page == 0) setState(() => _page = 1);
                    else _goHome();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(_page == 0 ? 'Next →' : 'Get Started',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _page1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 220, height: 150,
          decoration: BoxDecoration(
              color: cDark2, borderRadius: BorderRadius.circular(16)),
          child: Center(child: _miniBoard()),
        ),
        const SizedBox(height: 28),
        const Text('How to play',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700,
                color: cText)),
        const SizedBox(height: 12),
        const Text(
          'Take turns dropping colored discs into the 7×6 grid. Be the first to connect 4 in a row — horizontally, vertically, or diagonally!',
          style: TextStyle(fontSize: 14, color: cMuted, height: 1.7),
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }

  Widget _page2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        _playerCard(cRed, 'Player 1', 'Red disc', '3'),
        const SizedBox(height: 12),
        _playerCard(cYellow, 'Player 2', 'Yellow disc', '1'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: cBlue.withOpacity(0.12),
            border: Border.all(color: cBlue.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text('First to 4 in a row wins!',
              style: TextStyle(fontSize: 13, color: Color(0xFF93C5FD)),
              textAlign: TextAlign.center),
        ),
        const SizedBox(height: 28),
        const Text('Win the match',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700,
                color: cText)),
        const SizedBox(height: 12),
        const Text(
          'Each match consists of rounds. The player with the most round wins becomes the overall champion. Good luck!',
          style: TextStyle(fontSize: 14, color: cMuted, height: 1.7),
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }

  Widget _playerCard(Color color, String name, String sub, String score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: cDark2, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        CircleAvatar(radius: 16, backgroundColor: color),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: cText)),
          Text(sub, style: const TextStyle(fontSize: 11, color: cMuted)),
        ]),
        const Spacer(),
        Text(score, style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.w700, color: cText)),
      ]),
    );
  }

  Widget _miniBoard() {
    const preset = [
      0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,
      0,1,2,2,0,0,0,
      1,1,2,1,1,0,0,
    ];
    return Wrap(
      spacing: 3, runSpacing: 3,
      children: List.generate(42, (i) {
        final colors = [cDark, cRed, cYellow];
        return Container(
          width: 22, height: 22,
          decoration: BoxDecoration(
              color: colors[preset[i]], shape: BoxShape.circle),
        );
      }),
    );
  }

  Widget _dot(bool active) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    width: active ? 20 : 8,
    height: 8,
    decoration: BoxDecoration(
        color: active ? cBlue : const Color(0xFF334155),
        borderRadius: BorderRadius.circular(4)),
  );
}
