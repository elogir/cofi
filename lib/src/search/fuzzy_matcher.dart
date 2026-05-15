import '../desktop_entry/desktop_entry.dart';

class _Scored {
  final DesktopEntry entry;
  final int score;
  const _Scored(this.entry, this.score);
}

List<DesktopEntry> fuzzyFilter(List<DesktopEntry> entries, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return entries;

  final scored = <_Scored>[];
  for (final entry in entries) {
    final nameScore = _score(entry.name.toLowerCase(), q);
    if (nameScore != null) {
      scored.add(_Scored(entry, nameScore * 3));
      continue;
    }
    final keywordsScore = entry.keywords
        .map((k) => _score(k.toLowerCase(), q))
        .whereType<int>()
        .fold<int?>(null, (best, s) => best == null || s > best ? s : best);
    if (keywordsScore != null) {
      scored.add(_Scored(entry, keywordsScore * 2));
      continue;
    }
    final commentScore = entry.comment == null
        ? null
        : _score(entry.comment!.toLowerCase(), q);
    if (commentScore != null) {
      scored.add(_Scored(entry, commentScore));
    }
  }

  scored.sort((a, b) {
    final byScore = b.score.compareTo(a.score);
    if (byScore != 0) return byScore;
    return a.entry.name.toLowerCase().compareTo(b.entry.name.toLowerCase());
  });
  return scored.map((s) => s.entry).toList();
}

int? _score(String haystack, String needle) {
  if (needle.isEmpty) return 0;
  var hi = 0;
  var ni = 0;
  var score = 0;
  var streak = 0;
  var prevWasBoundary = true;
  while (hi < haystack.length && ni < needle.length) {
    final hc = haystack.codeUnitAt(hi);
    final nc = needle.codeUnitAt(ni);
    final boundary = prevWasBoundary || _isBoundary(haystack, hi);
    if (hc == nc) {
      score += 10;
      streak++;
      if (streak > 1) score += streak * 4;
      if (boundary) score += 8;
      if (hi == 0) score += 5;
      ni++;
      prevWasBoundary = false;
    } else {
      streak = 0;
      prevWasBoundary = _isBoundary(haystack, hi);
    }
    hi++;
  }
  if (ni < needle.length) return null;
  score -= (haystack.length - needle.length);
  return score;
}

bool _isBoundary(String s, int i) {
  if (i == 0) return true;
  final prev = s.codeUnitAt(i - 1);
  return prev == 0x20 || prev == 0x2D || prev == 0x5F || prev == 0x2E;
}
