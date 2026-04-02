import 'package:flutter/material.dart';
import '../theme.dart';
import 'home_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundFx = true;
  bool music = true;
  bool haptic = false;
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cDark,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(width: 36, height: 36,
                    decoration: BoxDecoration(color: cDark2, shape: BoxShape.circle),
                    child: const Icon(Icons.chevron_left, color: cMuted)),
              ),
              const SizedBox(width: 12),
              const Text('Settings', style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: cText)),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _section('AUDIO'),
                  _toggleTile('🔊', 'Sound Effects', soundFx, cBlue,
                          (v) => setState(() => soundFx = v)),
                  const SizedBox(height: 6),
                  _toggleTile('🎵', 'Background Music', music, cBlue,
                          (v) => setState(() => music = v)),
                  const SizedBox(height: 6),
                  _toggleTile('📳', 'Haptic Feedback', haptic, cBlue,
                          (v) => setState(() => haptic = v)),
                  _section('APPEARANCE'),
                  _toggleTile('🌙', 'Dark Mode', darkMode,
                      const Color(0xFF7C3AED),
                          (v) => setState(() => darkMode = v)),
                  _section('LANGUAGE'),
                  _arrowTile('🌍', 'Language', 'English', cGreen),
                  _section('ACCOUNT'),
                  _arrowTile('👤', 'Edit Profile', '', cBlue),
                  const SizedBox(height: 6),
                  _arrowTile('🔒', 'Privacy', '', cBlue),
                  const SizedBox(height: 6),
                  _arrowTile('📊', 'Stats Reset', '', cRed),
                  const SizedBox(height: 16),
                  // Sign out
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: cRed.withOpacity(0.08),
                      border: Border.all(color: cRed.withOpacity(0.25)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(children: [
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                            color: cRed.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(child: Text('🚪',
                            style: TextStyle(fontSize: 18))),
                      ),
                      const SizedBox(width: 12),
                      const Text('Sign Out', style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: cRed)),
                    ]),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          _bottomNav(context, 3),
        ]),
      ),
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(title, style: const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w600,
        color: cMuted, letterSpacing: 0.5)),
  );

  Widget _toggleTile(String emoji, String label, bool val, Color color,
      ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
          color: cDark2, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(emoji,
              style: const TextStyle(fontSize: 18))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: cText))),
        Switch(
          value: val,
          onChanged: onChanged,
          activeColor: color,
          activeTrackColor: color.withOpacity(0.3),
          inactiveThumbColor: cMuted,
          inactiveTrackColor: cCard,
        ),
      ]),
    );
  }

  Widget _arrowTile(String emoji, String label, String sub, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
          color: cDark2, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(emoji,
              style: const TextStyle(fontSize: 18))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: cText)),
          if (sub.isNotEmpty)
            Text(sub, style: const TextStyle(fontSize: 11, color: cMuted)),
        ])),
        const Icon(Icons.chevron_right, color: cMuted, size: 20),
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
