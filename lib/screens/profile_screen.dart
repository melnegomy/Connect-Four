import 'package:flutter/material.dart';
import '../theme.dart';
import 'home_screen.dart';
import 'leaderboard_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedColor = 0;
  final avatarColors = [cBlue, const Color(0xFF7C3AED), cRed, cGreen, cYellow,
    const Color(0xFFEC4899)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cDark,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(width: 36, height: 36,
                    decoration: BoxDecoration(color: cDark2, shape: BoxShape.circle),
                    child: const Icon(Icons.chevron_left, color: cMuted)),
              ),
              const SizedBox(width: 12),
              const Text('Profile', style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: cText)),
              const Spacer(),
              const Text('Edit', style: TextStyle(fontSize: 13, color: cBlue)),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                // Avatar
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: avatarColors[_selectedColor],
                    border: Border.all(color: cBlue.withOpacity(0.4), width: 3),
                  ),
                  child: const Center(
                    child: Text('A', style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w800,
                        color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Alex', style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700, color: cText)),
                const Text('★ 1,250 points · Rank #7',
                    style: TextStyle(fontSize: 12, color: cMuted)),
                const SizedBox(height: 20),
                // Avatar colors
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text('AVATAR COLOR', style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: cMuted, letterSpacing: 0.5)),
                    const SizedBox(height: 10),
                    Row(children: List.generate(avatarColors.length, (i) =>
                        GestureDetector(
                          onTap: () => setState(() => _selectedColor = i),
                          child: Container(
                            width: 34, height: 34,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: avatarColors[i],
                              border: _selectedColor == i
                                  ? Border.all(color: Colors.white, width: 2.5)
                                  : null,
                            ),
                          ),
                        ))),
                  ]),
                ),
                const SizedBox(height: 20),
                // Stats
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    _stat('24', 'Wins', cGreen),
                    const SizedBox(width: 8),
                    _stat('8', 'Losses', cRed),
                    const SizedBox(width: 8),
                    _stat('75%', 'Win Rate', cYellow),
                    const SizedBox(width: 8),
                    _stat('32', 'Games', cBlue),
                  ]),
                ),
                const SizedBox(height: 20),
                // Recent games
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text('RECENT GAMES', style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: cMuted, letterSpacing: 0.5)),
                    const SizedBox(height: 10),
                    _gameRow('vs AI (Hard)', 'Won', cGreen, '+80 pts'),
                    const SizedBox(height: 8),
                    _gameRow('vs ConnectKing', 'Lost', cRed, '-20 pts'),
                    const SizedBox(height: 8),
                    _gameRow('vs AI (Medium)', 'Won', cGreen, '+50 pts'),
                  ]),
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
          _bottomNav(context, 2),
        ]),
      ),
    );
  }

  Widget _stat(String val, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: cDark2, borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          Text(val, style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: color)),
          Text(label, style: const TextStyle(fontSize: 9, color: cMuted)),
        ]),
      ),
    );
  }

  Widget _gameRow(String opp, String res, Color color, String pts) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: cDark2, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(res == 'Won' ? '🏆' : '💀',
              style: const TextStyle(fontSize: 16))),
        ),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(opp, style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500, color: cText)),
          Text(res, style: TextStyle(fontSize: 11, color: color)),
        ]),
        const Spacer(),
        Text(pts, style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }
}

Widget _bottomNav(BuildContext ctx, int active) {
  final items = [('🏠','Home'),('🏆','Ranks'),('👤','Profile'),('⚙️','Settings')];
  final dests = [
    const HomeScreen(), const LeaderboardScreen(),
    const ProfileScreen(), const SettingsScreen(),
  ];
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: cCard, width: 0.5))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(items.length, (i) => GestureDetector(
        onTap: () { if (i != active) Navigator.pushReplacement(ctx,
            MaterialPageRoute(builder: (_) => dests[i])); },
        child: Column(children: [
          Text(items[i].$1, style: const TextStyle(fontSize: 20)),
          Text(items[i].$2, style: TextStyle(fontSize: 10,
              color: i == active ? cBlue : const Color(0xFF64748B))),
        ]),
      )),
    ),
  );
}
