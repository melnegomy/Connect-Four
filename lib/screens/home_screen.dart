import 'package:flutter/material.dart';
import '../theme.dart';
import 'mode_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cDark,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [cBlue, Color(0xFF7C3AED)]),
                ),
                child: const Center(
                  child: Text('A', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
              const SizedBox(width: 10),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Alex', style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: cText)),
                Text('★ 1,250 pts', style: TextStyle(fontSize: 11, color: cMuted)),
              ]),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen())),
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                      color: cDark2, shape: BoxShape.circle),
                  child: const Icon(Icons.settings_outlined,
                      color: cMuted, size: 18),
                ),
              ),
            ]),
          ),
          // Stats row
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(children: [
              _statCard('24', 'Wins', cGreen),
              const SizedBox(width: 10),
              _statCard('8', 'Losses', cRed),
              const SizedBox(width: 10),
              _statCard('75%', 'Win rate', cYellow),
            ]),
          ),
          // Play buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ModeScreen())),
                    icon: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 20),
                    ),
                    label: const Text('Play Now',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cBlue,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _modeCard(
                    context, '🤖', 'vs AI', 'Single player', const ModeScreen())),
                  const SizedBox(width: 12),
                  Expanded(child: _modeCard(
                    context, '👥', 'Local 2P', 'Pass & play',
                    const ModeScreen(twoPlayer: true))),
                ]),
                const SizedBox(height: 12),
                _menuTile(context, '🏆', cYellow, 'Leaderboard', "You're ranked #7",
                    const LeaderboardScreen()),
                const SizedBox(height: 10),
                _menuTile(context, '👤', cGreen, 'Profile', 'Customize avatar',
                    const ProfileScreen()),
              ]),
            ),
          ),
          _bottomNav(context, 0),
        ]),
      ),
    );
  }

  Widget _statCard(String val, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: cDark2, borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          Text(val, style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: cMuted)),
        ]),
      ),
    );
  }

  Widget _modeCard(BuildContext ctx, String emoji, String title,
      String sub, Widget dest) {
    return GestureDetector(
      onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => dest)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            color: cDark2, borderRadius: BorderRadius.circular(14)),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: cText)),
          Text(sub, style: const TextStyle(fontSize: 10, color: cMuted)),
        ]),
      ),
    );
  }

  Widget _menuTile(BuildContext ctx, String emoji, Color bg,
      String title, String sub, Widget dest) {
    return GestureDetector(
      onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => dest)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
            color: cDark2, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
                color: bg.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(emoji,
                style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: cText)),
            Text(sub, style: const TextStyle(fontSize: 11, color: cMuted)),
          ]),
          const Spacer(),
          const Icon(Icons.chevron_right, color: cMuted),
        ]),
      ),
    );
  }
}

Widget _bottomNav(BuildContext ctx, int active) {
  final items = [
    ('🏠', 'Home'),
    ('🏆', 'Ranks'),
    ('👤', 'Profile'),
    ('⚙️', 'Settings'),
  ];
  final dests = [
    const HomeScreen(),
    const LeaderboardScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: cCard, width: 0.5)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(items.length, (i) {
        final isActive = i == active;
        return GestureDetector(
          onTap: () {
            if (!isActive) {
              Navigator.pushReplacement(ctx,
                  MaterialPageRoute(builder: (_) => dests[i]));
            }
          },
          child: Column(children: [
            Text(items[i].$1, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 2),
            Text(items[i].$2, style: TextStyle(
                fontSize: 10,
                color: isActive ? cBlue : const Color(0xFF64748B))),
          ]),
        );
      }),
    ),
  );
}
