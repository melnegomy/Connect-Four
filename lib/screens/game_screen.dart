import 'package:flutter/material.dart';
import '../theme.dart';
import '../game/logic.dart';
import 'result_screen.dart';
import 'home_screen.dart';
import 'mode_screen.dart';

class GameScreen extends StatefulWidget {
  final bool vsAI;
  final int aiDepth;
  final int totalRounds;
  const GameScreen({
    super.key,
    this.vsAI = true,
    this.aiDepth = 5,
    this.totalRounds = 3,
  });
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late List<List<int>> board;
  int currentPlayer = kPlayer; // 1=red 2=yellow
  bool gameOver = false;
  bool aiThinking = false;
  bool paused = false;
  int p1Wins = 0;
  int p2Wins = 0;
  int currentRound = 1;
  List<List<int>> winCells = [];
  int? hoverCol;

  late List<List<AnimationController>> _dropCtrl;
  late List<List<Animation<double>>> _dropAnim;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    board = createBoard();
    _initAnims();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.75, end: 1.0).animate(_pulseCtrl);
  }

  void _initAnims() {
    _dropCtrl = List.generate(kRows, (r) =>
        List.generate(kCols, (c) => AnimationController(
            vsync: this, duration: const Duration(milliseconds: 450))));
    _dropAnim = List.generate(kRows, (r) =>
        List.generate(kCols, (c) =>
            Tween<double>(begin: -1.0, end: 0.0).animate(
                CurvedAnimation(parent: _dropCtrl[r][c],
                    curve: Curves.bounceOut))));
  }

  @override
  void dispose() {
    for (final row in _dropCtrl) for (final c in row) c.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _drop(int col) async {
    if (gameOver || aiThinking || paused) return;
    if (!isValidCol(board, col)) return;

    final row = getNextRow(board, col);
    setState(() {
      board[row][col] = currentPlayer;
      _dropCtrl[row][col].forward(from: 0);
    });

    if (checkWin(board, currentPlayer)) {
      final wc = winningCells(board, currentPlayer);
      setState(() { winCells = wc; gameOver = true; });
      await Future.delayed(const Duration(milliseconds: 800));
      _endRound(currentPlayer);
      return;
    }
    if (validCols(board).isEmpty) {
      await Future.delayed(const Duration(milliseconds: 400));
      _endRound(0);
      return;
    }

    setState(() =>
        currentPlayer = currentPlayer == kPlayer ? kAI : kPlayer);

    if (widget.vsAI && currentPlayer == kAI) {
      setState(() => aiThinking = true);
      await Future.delayed(const Duration(milliseconds: 300));
      final aiCol = getBestCol(board, widget.aiDepth);
      final aiRow = getNextRow(board, aiCol);
      setState(() {
        board[aiRow][aiCol] = kAI;
        _dropCtrl[aiRow][aiCol].forward(from: 0);
        aiThinking = false;
      });

      if (checkWin(board, kAI)) {
        final wc = winningCells(board, kAI);
        setState(() { winCells = wc; gameOver = true; });
        await Future.delayed(const Duration(milliseconds: 800));
        _endRound(kAI);
        return;
      }
      if (validCols(board).isEmpty) {
        await Future.delayed(const Duration(milliseconds: 400));
        _endRound(0);
        return;
      }
      setState(() => currentPlayer = kPlayer);
    }
  }

  void _endRound(int winner) {
    if (winner == kPlayer) p1Wins++;
    if (winner == kAI || (!widget.vsAI && winner == kAI)) p2Wins++;
    if (!widget.vsAI && winner == kAI) p2Wins++;

    if (currentRound >= widget.totalRounds ||
        p1Wins > widget.totalRounds / 2 ||
        p2Wins > widget.totalRounds / 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => ResultScreen(
          p1Wins: p1Wins, p2Wins: p2Wins,
          vsAI: widget.vsAI, totalRounds: widget.totalRounds,
        ),
      ));
    } else {
      setState(() {
        currentRound++;
        board = createBoard();
        for (final row in _dropCtrl) for (final c in row) c.reset();
        winCells = [];
        gameOver = false;
        currentPlayer = kPlayer;
      });
    }
  }

  bool _isWin(int r, int c) =>
      winCells.any((cell) => cell[0] == r && cell[1] == c);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cDark,
      body: SafeArea(
        child: Stack(children: [
          Column(children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Row(children: [
                Text('Round $currentRound / ${widget.totalRounds}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700, color: cText)),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => paused = true),
                  child: Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                        color: cDark2, shape: BoxShape.circle),
                    child: const Icon(Icons.pause_rounded,
                        color: cMuted, size: 18),
                  ),
                ),
              ]),
            ),
            // Score
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                _scoreCard(cRed, widget.vsAI ? 'You' : 'P1', p1Wins,
                    currentPlayer == kPlayer && !gameOver),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(children: [
                    const Text('TURN', style: TextStyle(
                        fontSize: 9, color: cMuted)),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 10, height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentPlayer == kPlayer ? cRed : cYellow,
                      ),
                    ),
                  ]),
                ),
                _scoreCard(cYellow, widget.vsAI ? 'AI' : 'P2', p2Wins,
                    currentPlayer == kAI && !gameOver),
              ]),
            ),
            const SizedBox(height: 12),
            // Board
            Expanded(child: _buildBoard()),
            // Turn indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: cDark2,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (aiThinking)
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: 14, height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: cYellow),
                      ),
                    ),
                  CircleAvatar(radius: 8,
                      backgroundColor: currentPlayer == kPlayer ? cRed : cYellow),
                  const SizedBox(width: 10),
                  Text(
                    aiThinking ? 'AI thinking...'
                        : currentPlayer == kPlayer
                        ? (widget.vsAI ? "Your turn" : "Player 1's turn")
                        : (widget.vsAI ? "AI's turn" : "Player 2's turn"),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: cText),
                  ),
                ]),
              ),
            ),
          ]),
          if (paused) _pauseOverlay(),
        ]),
      ),
    );
  }

  Widget _scoreCard(Color color, String label, int wins, bool active) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.15) : cDark2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: active ? color.withOpacity(0.5) : Colors.transparent,
              width: 1.5),
        ),
        child: Row(children: [
          CircleAvatar(radius: 12, backgroundColor: color),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600,
                color: color.withOpacity(0.9))),
            Text('$wins', style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: cText)),
          ]),
        ]),
      ),
    );
  }

  Widget _buildBoard() {
    return LayoutBuilder(builder: (ctx, box) {
      final sz = ((box.maxWidth - 32) / kCols).clamp(0.0, 56.0);
      final bw = sz * kCols + 12;
      final bh = sz * kRows + 12;
      return Center(
        child: MouseRegion(
          onHover: (e) {
            if (!gameOver && !aiThinking) {
              final col = ((e.localPosition.dx - 6) / sz)
                  .floor().clamp(0, kCols - 1);
              setState(() => hoverCol = col);
            }
          },
          onExit: (_) => setState(() => hoverCol = null),
          child: GestureDetector(
            onTapDown: (d) {
              final col = ((d.localPosition.dx - 6) / sz)
                  .floor().clamp(0, kCols - 1);
              _drop(col);
            },
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // Hover indicator
              SizedBox(
                width: bw,
                height: sz * 0.45,
                child: Row(
                  children: List.generate(kCols, (c) => SizedBox(
                    width: sz,
                    child: (hoverCol == c && !gameOver && !aiThinking &&
                        currentPlayer == kPlayer)
                        ? Center(child: Container(
                      width: sz * 0.38, height: sz * 0.38,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cRed.withOpacity(0.7)),
                    ))
                        : const SizedBox(),
                  )),
                ),
              ),
              // Board
              Container(
                width: bw, height: bh,
                decoration: BoxDecoration(
                  color: cDark3,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.4),
                        blurRadius: 20, offset: const Offset(0, 8)),
                  ],
                ),
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: List.generate(kRows, (r) => Expanded(
                    child: Row(
                      children: List.generate(kCols, (c) =>
                          Expanded(child: _cell(r, c, sz))),
                    ),
                  )),
                ),
              ),
            ]),
          ),
        ),
      );
    });
  }

  Widget _cell(int r, int c, double sz) {
    final piece = board[r][c];
    final isWin = _isWin(r, c);
    Color bg = const Color(0xFF0F1F3D);
    if (piece == kPlayer) bg = cRed;
    if (piece == kAI) bg = cYellow;

    Widget disc = AnimatedBuilder(
      animation: _dropAnim[r][c],
      builder: (_, __) {
        final off = piece != kEmpty ? _dropAnim[r][c].value * sz * (r + 1) : 0.0;
        return Transform.translate(
          offset: Offset(0, off),
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: piece == kEmpty
                  ? (hoverCol == c && currentPlayer == kPlayer && !gameOver && !aiThinking
                  ? cRed.withOpacity(0.15)
                  : const Color(0xFF0F1F3D))
                  : bg,
              border: piece == kEmpty
                  ? Border.all(color: const Color(0xFF1A3070), width: 1.5)
                  : null,
              boxShadow: piece != kEmpty ? [
                BoxShadow(color: bg.withOpacity(0.5), blurRadius: 8)
              ] : null,
            ),
          ),
        );
      },
    );

    if (isWin) {
      return AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, child) =>
            Transform.scale(scale: _pulseAnim.value, child: child),
        child: disc,
      );
    }
    return disc;
  }

  Widget _pauseOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.75),
      child: Center(
        child: Container(
          width: 260,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cDark2,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cCard),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Game Paused', style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700, color: cText)),
            const SizedBox(height: 16),
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cBlue.withOpacity(0.15)),
              child: const Icon(Icons.pause_rounded, color: cBlue, size: 28),
            ),
            const SizedBox(height: 20),
            _pauseBtn('▶  Resume Game', cBlue, Colors.white, () {
              setState(() => paused = false);
            }),
            const SizedBox(height: 10),
            _pauseBtn('↺  Restart', cCard, cText, () {
              setState(() {
                board = createBoard();
                for (final row in _dropCtrl) for (final c in row) c.reset();
                winCells = [];
                gameOver = false;
                currentPlayer = kPlayer;
                paused = false;
              });
            }),
            const SizedBox(height: 10),
            _pauseBtn('⚙  Change Mode', cCard, cText, () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const ModeScreen()));
            }),
            const SizedBox(height: 10),
            _pauseBtn('✕  Exit Game', Colors.transparent, cRed, () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (_) => false);
            }, border: cRed.withOpacity(0.4)),
          ]),
        ),
      ),
    );
  }

  Widget _pauseBtn(String label, Color bg, Color fg, VoidCallback onTap,
      {Color? border}) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: border != null ? Border.all(color: border) : null,
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                  color: fg)),
        ),
      ),
    );
  }
}
