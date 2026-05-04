import 'dart:math';

const int kRows   = 6;
const int kCols   = 7;
const int kEmpty  = 0;
const int kPlayer = 1;
const int kAI     = 2;
const int kWin    = 4;
const int attempts = 4;

List<List<int>> createBoard() => List.generate(kRows, (x) => List.filled(kCols, kEmpty));

bool isValidCol(List<List<int>> b, int c) => b[0][c] == kEmpty;

int getNextRow(List<List<int>> b, int c) {
  for (int r = kRows - 1; r >= 0; r--) {
    if (b[r][c] == kEmpty) return r;
  }
  return -1;
}

List<int> validCols(List<List<int>> b) {
  final res = <int>[];
  for (int c = 0; c < kCols; c++) {
    if (isValidCol(b, c)) res.add(c);
  }
  return res;
}

List<List<int>> copyBoard(List<List<int>> b) =>List.generate(kRows, (r) => List<int>.from(b[r]));

bool checkWin(List<List<int>> b, int p) {

  for (int r = 0; r < kRows; r++){
    for (int c = 0; c <= kCols - kWin; c++) {
      bool w = true;
      for (int i = 0; i < kWin; i++) { //horizontal
        if (b[r][c+i] != p) { w = false; break; }
      }
      if (w) return true;
    }
  }

  for (int c = 0; c < kCols; c++){//vertical
    for (int r = 0; r <= kRows - kWin; r++) {
      bool w = true;
      for (int i = 0; i < kWin; i++) {
        if (b[r+i][c] != p) { w = false; break; }
      }
      if (w) return true;
    }
  }

  for (int r = 0; r <= kRows - kWin; r++){
    for (int c = 0; c <= kCols - kWin; c++) { // non-main diagonal
      bool w = true;
      for (int i = 0; i < kWin; i++) {
        if (b[r+i][c+i] != p) { w = false; break; }
      }
      if (w) return true;
    }
  }

  for (int r = kWin - 1; r < kRows; r++){
    for (int c = 0; c <= kCols - kWin; c++) {
      bool w = true;
      for (int i = 0; i < kWin; i++) {
        if (b[r-i][c+i] != p) { w = false; break; }
      }
      if (w) {return true;}
    }
  }
  return false;
}

List<List<int>> winningCells(List<List<int>> b, int p) {
  for (int r = 0; r < kRows; r++){
    for (int c = 0; c <= kCols - kWin; c++) {
      bool w = true;
      for (int i = 0; i < kWin; i++) {
        if (b[r][c+i] != p) { w = false; break; }
      }
      if (w) return List.generate(kWin, (i) => [r, c+i]);
    }
  }

  for (int c = 0; c < kCols; c++){
    for (int r = 0; r <= kRows - kWin; r++) {
      bool w = true;
      for (int i = 0; i < kWin; i++) {
        if (b[r+i][c] != p) { w = false; break; }
      }
      if (w) return List.generate(kWin, (i) => [r+i, c]);
    }
  }

  for (int r = 0; r <= kRows - kWin; r++){
    for (int c = 0; c <= kCols - kWin; c++) {
      bool w = true;
      for (int i = 0; i < kWin; i++) {
        if (b[r+i][c+i] != p) { w = false; break; }
      }
      if (w) return List.generate(kWin, (i) => [r+i, c+i]);
    }
  }

  for (int r = kWin - 1; r < kRows; r++){
    for (int c = 0; c <= kCols - kWin; c++) {
      bool w = true;
      for (int i = 0; i < kWin; i++) {
        if (b[r-i][c+i] != p) { w = false; break; }
      }
      if (w) return List.generate(kWin, (i) => [r-i, c+i]);
    }
    }
  return [];
}

bool isTerminal(List<List<int>> b) =>
    checkWin(b, kPlayer) || checkWin(b, kAI) || validCols(b).isEmpty;

int _scoreWindow(List<int> w, int p) {
  final opp = (p == kAI) ? kPlayer : kAI;
  int pc = 0, ec = 0, oc = 0;
  
  for (final v in w) {
    if (v == p) {
      pc++;
    } else if (v == kEmpty) ec++;
    else if (v == opp) oc++;
  }

  if  (pc == 4) return 100;
  if (pc == 3 && ec == 1) return 5;
  if (pc == 2 && ec == 2) return 2;
  if (oc == 3 && ec == 1) return -4;
  return 0;
}

int _scoreBoard(List<List<int>> b, int p) {
  int score = 0;
  for (int r = 0; r < kRows; r++) {
    if (b[r][kCols ~/ 2] == p) score += 3;      
  }

  for (int r = 0; r < kRows; r++){
    for (int c = 0; c <= kCols - kWin; c++) {
      score += _scoreWindow(List.generate(kWin, (i) => b[r][c+i]), p); 
    }
  }

  for (int c = 0; c < kCols; c++){
    for (int r = 0; r <= kRows - kWin; r++) {
      score += _scoreWindow(List.generate(kWin, (i) => b[r+i][c]), p);
    }
  }

  for (int r = 0; r <= kRows - kWin; r++){
    for (int c = 0; c <= kCols - kWin; c++) {
      score += _scoreWindow(List.generate(kWin, (i) => b[r+i][c+i]), p);
    }
  }
  
  for (int r = kWin - 1; r < kRows; r++){
    for (int c = 0; c <= kCols - kWin; c++) {
      score += _scoreWindow(List.generate(kWin, (i) => b[r-i][c+i]), p);
    }
    }
  return score;
}

class _MM { final int score; final int? col; _MM(this.score, this.col); }

_MM _alphabeta(List<List<int>> b, int depth, int alpha, int beta, bool max) {
  if (isTerminal(b)) {
    if (checkWin(b, kAI))     return _MM(100000000 + depth, null);
    if (checkWin(b, kPlayer)) return _MM(-100000000 - depth, null);
    return _MM(0, null);
  }

  if (depth == 0) return _MM(_scoreBoard(b, kAI), null);
  final cols = validCols(b);
  
  if (max) {
    int best = -999999999; int? bc = cols[Random().nextInt(cols.length)];
    for (final c in cols) {
      final tmp = copyBoard(b); tmp[getNextRow(b, c)][c] = kAI;
      final s = _alphabeta(tmp, depth - 1, alpha, beta, false).score;
      if (s > best) { best = s; bc = c;}
      if(best > alpha){alpha=best;}
      if (alpha >= beta) break;
    }
    return _MM(best, bc);
  } else {
    int best = 999999999; int? bc = cols[Random().nextInt(cols.length)];
    for (final c in cols) {
      final tmp = copyBoard(b); tmp[getNextRow(b, c)][c] = kPlayer;
      final s = _alphabeta (tmp, depth - 1, alpha, beta, true).score;
      if (s < best) { best = s; bc = c; }
      if(best < beta){beta=best;}
      if (alpha >= beta) break;
    }
    return _MM(best, bc);
  }
}

_MM _minimax(List<List<int>> b, int depth, bool max){
  if (isTerminal(b)) {
    if (checkWin(b, kAI))     return _MM(100000000 + depth, null);
    if (checkWin(b, kPlayer)) return _MM(-100000000 - depth, null);
    return _MM(0, null);
  }

  if (depth == 0) return _MM(_scoreBoard(b, kAI), null);
  final cols = validCols(b);
  
  if (max) {
    int best = -999999999; int? bc = cols[Random().nextInt(cols.length)];
    for (final c in cols) {
      final tmp = copyBoard(b); tmp[getNextRow(b, c)][c] = kAI;
      final s = _minimax(tmp, depth - 1, false).score;
      if (s > best) {
         best = s; bc = c;
      }
      
    }
    return _MM(best, bc);
  } else {
    int best = 999999999; int? bc = cols[Random().nextInt(cols.length)];
    for (final c in cols) {
      final tmp = copyBoard(b); tmp[getNextRow(b, c)][c] = kPlayer;
      final s = _minimax(tmp, depth - 1, true).score;
      if (s < best) { 
        best = s; bc = c; 
        }
      
    }
    return _MM(best, bc);
  }
}

_MM _randomsearch(List<List<int>> b, int depth, int attempts, bool max){
  if (isTerminal(b)) {
    if (checkWin(b, kAI))     return _MM(100000000 + depth, null);
    if (checkWin(b, kPlayer)) return _MM(-100000000 - depth, null);
    return _MM(0, null);
  }

  if (depth == 0) return _MM(_scoreBoard(b, kAI), null);
  final cols = validCols(b);
  attempts= min(attempts, cols.length);

  if (max) {
    int best = -999999999; 
    int? bc = cols[Random().nextInt(cols.length)];
    var visited = <int>{};

    for (int x= attempts; x>0; x-=1) {
      int c = Random().nextInt(cols.length);
      
      if (visited.contains(c) == true){x++; continue;}
      visited.add(c);
      
      c = cols[c];

      final tmp = copyBoard(b); tmp[getNextRow(b, c)][c] = kAI;
      final s = _randomsearch(tmp, depth - 1, attempts, false).score;
      if (s > best) {
         best = s; bc = c;
      }
    }
    return _MM(best, bc);
  } else {
    int best = 999999999; int? 
    bc = cols[Random().nextInt(cols.length)];
    var visited = <int>{};

    for (int x= attempts; x>0; x-=1) {
      int c = Random().nextInt(cols.length);
      
      if (visited.contains(c) == true){ x++; continue;}
      visited.add(c);
      
      c = cols[c];

      final tmp = copyBoard(b); tmp[getNextRow(b, c)][c] = kPlayer;
      final s = _randomsearch(tmp, depth - 1, attempts, true).score;
      if (s < best) { 
        best = s; bc = c; 
        }
    }
    return _MM(best, bc);
  }
}


int getBestCol(List<List<int>> b, int depth, int algorithm) {
    if(algorithm == 1){
    return _alphabeta(b, depth, -999999999, 999999999, true).col ?? validCols(b).first;
    }
    else if (algorithm == 2){
    return _minimax(b, depth, true).col ?? validCols(b).first;
    }
    else{
      return _randomsearch(b, depth, attempts, true).col ?? validCols(b).first;
    }
}