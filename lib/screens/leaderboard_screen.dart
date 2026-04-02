import 'package:flutter/material.dart';
import '../theme.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});
  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _tab = 0;

  final players = [
    {'rank': 1, 'name': 'XxNova99xX',   'pts': 4820, 'medal': '🥇', 'color': cYellow},
    {'rank': 2, 'name': 'ConnectKing',  'pts': 4310, 'medal': '🥈', 'color': cMuted},
    {'rank': 3, 'name': 'DroppedIt',    'pts': 3990, 'medal': '🥉', 'color': Color(0xFFCD7C2F)},
    {'rank': 4, 'name': 'GridMaster',   'pts': 3450, 'medal': '4',  'color': cBlue},
    {'rank': 5, 'name': 'ByteForce',    'pts': 3100, 'medal': '5',  'color': cBlue},
    {'rank': 6, 'name': 'QuickDrop',    'pts': 2870, 'medal': '6',  'color': cBlue},
    {'rank': 7, 'name': 'Alex ← You',  'pts': 1250, 'medal': '7',  'color': cGreen, 'you': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cDark,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
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
              const Text('Leaderboard', style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: cText)),
              const Spacer(),
              const Text('This Week',
                  style: TextStyle(fontSize: 12, color: cBlue)),
            ]),
          ),
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: ['Week', 'Month', 'All Time']
                .asMap().entries.map((e) => GestureDetector(
              onTap: () => setState(() => _tab = e.key),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: _tab == e.key ? cBlue : cDark2,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(e.value, style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600,
                    color: _tab == e.key ? Colors.white : cMuted)),
              ),
            )).toList(),
          ),),  
          const SizedBox(height: 12),       
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: players.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _playerTile(players[i]),
            ),
          ),
          _bottomNav(context, 1),
        ]),
      ),
    );
  }

  Widget _playerTile(Map p) {
    final isYou = p['you'] == true;
    final color = p['color'] as Color;
    final rank = p['rank'] as int;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isYou ? cBlue.withOpacity(0.1) : cDark2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isYou ? cBlue.withOpacity(0.4) : Colors.transparent,
            width: 1.5),
      ),
      child: Row(children: [
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(rank <= 3 ? 0.3 : 0.15),
          ),
          child: Center(
            child: Text(p['medal'] as String,
                style: TextStyle(
                    fontSize: rank <= 3 ? 16 : 12,
                    fontWeight: FontWeight.w700,
                    color: color)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p['name'] as String, style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, color: cText)),
          Text('Rank #${p['rank']}',
              style: const TextStyle(fontSize: 11, color: cMuted)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${p['pts']}', style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: color)),
          const Text('points',
              style: TextStyle(fontSize: 10, color: cMuted)),
        ]),
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
