import 'package:flutter/material.dart';
import '../theme.dart';
import 'game_screen.dart';

class ModeScreen extends StatefulWidget {
  final bool twoPlayer;
  const ModeScreen({super.key, this.twoPlayer = false});
  @override
  State<ModeScreen> createState() => _ModeScreenState();
}

class _ModeScreenState extends State<ModeScreen> {
  bool _vsAI = true;
  int _difficulty = 1; // 0=easy 1=medium 2=hard
  int _rounds = 1;     // 0=1 1=3 2=5

  int get aiDepth => [3, 5, 7][_difficulty];
  int get roundCount => [1, 3, 5][_rounds];

  @override
  void initState() {
    super.initState();
    _vsAI = !widget.twoPlayer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cDark,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                      color: cDark2, shape: BoxShape.circle),
                  child: const Icon(Icons.chevron_left, color: cMuted),
                ),
              ),
              const SizedBox(width: 12),
              const Text('Game Mode', style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: cText)),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('OPPONENT', style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: cMuted, letterSpacing: 0.5)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _opponentCard(
                        '🤖', 'vs AI', 'Single player', true)),
                    const SizedBox(width: 10),
                    Expanded(child: _opponentCard(
                        '👥', 'Local 2P', 'Pass & play', false)),
                  ]),
                  const SizedBox(height: 20),
                  if (_vsAI) ...[
                    const Text('DIFFICULTY', style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: cMuted, letterSpacing: 0.5)),
                    const SizedBox(height: 10),
                    _diffTile(0, 'Easy', 'Beginner friendly', cGreen),
                    const SizedBox(height: 8),
                    _diffTile(1, 'Medium', 'Balanced challenge', cYellow),
                    const SizedBox(height: 8),
                    _diffTile(2, 'Hard', 'Expert level', cRed),
                    const SizedBox(height: 20),
                  ],
                  const Text('ROUNDS', style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: cMuted, letterSpacing: 0.5)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _roundCard(0, '1', 'round')),
                    const SizedBox(width: 8),
                    Expanded(child: _roundCard(1, '3', 'rounds')),
                    const SizedBox(width: 8),
                    Expanded(child: _roundCard(2, '5', 'rounds')),
                  ]),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => GameScreen(
                            vsAI: _vsAI,
                            aiDepth: aiDepth,
                            totalRounds: roundCount,
                          ),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cBlue,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Start Game',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _opponentCard(String emoji, String title, String sub, bool isAI) {
    final selected = _vsAI == isAI;
    return GestureDetector(
      onTap: () => setState(() => _vsAI = isAI),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? cBlue : cDark2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: selected ? cBlueLt : Colors.transparent, width: 2),
        ),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700,
              color: selected ? Colors.white : cText)),
          Text(sub, style: TextStyle(
              fontSize: 10,
              color: selected ? Colors.white70 : cMuted)),
        ]),
      ),
    );
  }

  Widget _diffTile(int idx, String label, String desc, Color color) {
    final selected = _difficulty == idx;
    return GestureDetector(
      onTap: () => setState(() => _difficulty = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.1) : cDark2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: selected ? color : Colors.transparent, width: 1.5),
        ),
        child: Row(children: [
          Container(width: 10, height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: cText)),
            Text(desc, style: const TextStyle(fontSize: 11, color: cMuted)),
          ]),
          if (selected) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(6)),
              child: const Text('SELECTED',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                      color: Colors.black)),
            ),
          ],
        ]),
      ),
    );
  }

  Widget _roundCard(int idx, String num, String label) {
    final selected = _rounds == idx;
    return GestureDetector(
      onTap: () => setState(() => _rounds = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? cBlue : cDark2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? cBlueLt : Colors.transparent, width: 1.5),
        ),
        child: Column(children: [
          Text(num, style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: cText)),
          Text(label, style: const TextStyle(fontSize: 10, color: cMuted)),
        ]),
      ),
    );
  }
}
