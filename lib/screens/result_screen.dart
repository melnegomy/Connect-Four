import 'package:flutter/material.dart';
import '../theme.dart';
import 'home_screen.dart';
import 'mode_screen.dart';

class ResultScreen extends StatelessWidget {
  final int p1Wins;
  final int p2Wins;
  final bool vsAI;
  final int totalRounds;
  const ResultScreen({
    super.key,
    required this.p1Wins,
    required this.p2Wins,
    required this.vsAI,
    required this.totalRounds,
  });

  @override
  Widget build(BuildContext context) {
    final p1Won = p1Wins > p2Wins;
    final draw = p1Wins == p2Wins;
    final winnerName = draw ? 'Draw!' : (p1Won ? (vsAI ? 'You Win!' : 'Player 1') : (vsAI ? 'AI Wins!' : 'Player 2'));
    final winnerColor = draw ? cMuted : (p1Won ? cRed : cYellow);

    return Scaffold(
      backgroundColor: cDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(children: [
            const SizedBox(height: 16),
            const Text('🏆', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 8),
            const Text('WINNER', style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600,
                color: cMuted, letterSpacing: 2)),
            const SizedBox(height: 6),
            Text(winnerName, style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w800, color: winnerColor)),
            const SizedBox(height: 4),
            Text('Match $p1Wins - $p2Wins',
                style: const TextStyle(fontSize: 14, color: cMuted)),
            const SizedBox(height: 20),
            // Score cards
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _scoreBox('$p1Wins', vsAI ? 'You' : 'P1', cRed),
              const SizedBox(width: 10),
              _scoreBox('$p2Wins', vsAI ? 'AI' : 'P2', cYellow),
              const SizedBox(width: 10),
              _scoreBox('+${p1Won ? 120 : 30}', 'Points', cGreen),
            ]),
            const SizedBox(height: 20),
            // Mini board snapshot
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: cDark2, borderRadius: BorderRadius.circular(14)),
              child: _miniResult(p1Won),
            ),
            const SizedBox(height: 24),
            // Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const ModeScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Play Again',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: cCard),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('↑ Share',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: cText)),
              )),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (_) => false),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: cCard),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('⌂ Home',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: cText)),
              )),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _scoreBox(String val, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
          color: cDark2, borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Text(val, style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: cMuted)),
      ]),
    );
  }

  Widget _miniResult(bool p1Won) {
    final preset = [
      0,0,0,0,0,0,0,
      0,2,1,2,0,0,0,
      1,1,1,1,0,0,0,
    ];
    final winIdx = [7, 8, 9, 10];
    return Wrap(
      spacing: 3, runSpacing: 3,
      children: List.generate(21, (i) {
        final colors = [const Color(0xFF0F1F3D), cRed, cYellow];
        final isW = winIdx.contains(i) && preset[i] != 0;
        return Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors[preset[i]],
            border: preset[i] == 0
                ? Border.all(color: const Color(0xFF1A3070), width: 1.5)
                : null,
            boxShadow: isW ? [
              BoxShadow(color: colors[preset[i]].withOpacity(0.6),
                  blurRadius: 8)
            ] : null,
          ),
        );
      }),
    );
  }
}
