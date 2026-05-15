import '../desktop_entry/desktop_entry.dart';

class _Scored {
  final DesktopEntry entry;
  final int fuzzyScore;
  final int launchCount;
  const _Scored(this.entry, this.fuzzyScore, this.launchCount);
}

List<DesktopEntry> fuzzyFilter(
  List<DesktopEntry> entries,
  String query,
  Map<String, int> launchCounts,
) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) {
    final sorted = [...entries];
    sorted.sort((a, b) {
      final ca = launchCounts[a.id] ?? 0;
      final cb = launchCounts[b.id] ?? 0;
      final byCount = cb.compareTo(ca);
      if (byCount != 0) return byCount;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return sorted;
  }

  final scored = <_Scored>[];
  for (final entry in entries) {
    final fuzzy = _bestMatchScore(entry, q);
    if (fuzzy == null) continue;
    scored.add(_Scored(entry, fuzzy, launchCounts[entry.id] ?? 0));
  }

  scored.sort((a, b) {
    final byCount = b.launchCount.compareTo(a.launchCount);
    if (byCount != 0) return byCount;
    final byFuzzy = b.fuzzyScore.compareTo(a.fuzzyScore);
    if (byFuzzy != 0) return byFuzzy;
    return a.entry.name.toLowerCase().compareTo(b.entry.name.toLowerCase());
  });
  return scored.map((s) => s.entry).toList();
}

int? _bestMatchScore(DesktopEntry entry, String query) {
  final nameScore = _score(entry.name.toLowerCase(), query);
  if (nameScore != null) return nameScore * 3;
  int? best;
  for (final k in entry.keywords) {
    final s = _score(k.toLowerCase(), query);
    if (s != null && (best == null || s > best)) best = s;
  }
  if (best != null) return best * 2;
  if (entry.comment != null) {
    final s = _score(entry.comment!.toLowerCase(), query);
    if (s != null) return s;
  }
  return null;
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
