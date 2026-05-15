List<String> tokeniseExec(String exec) {
  final tokens = <String>[];
  final buffer = StringBuffer();
  var inQuote = false;
  var hasContent = false;
  var i = 0;

  void flush() {
    if (hasContent) {
      final raw = buffer.toString();
      final processed = _expandFieldCodes(raw);
      if (processed != null) tokens.add(processed);
    }
    buffer.clear();
    hasContent = false;
  }

  while (i < exec.length) {
    final ch = exec[i];
    if (inQuote) {
      if (ch == r'\' && i + 1 < exec.length) {
        final next = exec[i + 1];
        if (next == '"' || next == r'\' || next == r'$' || next == '`') {
          buffer.write(next);
          hasContent = true;
          i += 2;
          continue;
        }
      }
      if (ch == '"') {
        inQuote = false;
        i++;
        continue;
      }
      buffer.write(ch);
      hasContent = true;
      i++;
      continue;
    }
    if (ch == '"') {
      inQuote = true;
      hasContent = true;
      i++;
      continue;
    }
    if (ch == ' ' || ch == '\t') {
      flush();
      i++;
      continue;
    }
    buffer.write(ch);
    hasContent = true;
    i++;
  }
  flush();
  return tokens;
}

String? _expandFieldCodes(String token) {
  if (!token.contains('%')) return token;
  final out = StringBuffer();
  var i = 0;
  while (i < token.length) {
    final ch = token[i];
    if (ch != '%') {
      out.write(ch);
      i++;
      continue;
    }
    if (i + 1 >= token.length) {
      i++;
      continue;
    }
    final code = token[i + 1];
    switch (code) {
      case '%':
        out.write('%');
        break;
      case 'f':
      case 'F':
      case 'u':
      case 'U':
      case 'i':
      case 'c':
      case 'k':
      case 'd':
      case 'D':
      case 'n':
      case 'N':
      case 'v':
      case 'm':
        break;
      default:
        break;
    }
    i += 2;
  }
  final result = out.toString();
  if (result.isEmpty && token.replaceAll(' ', '').startsWith('%')) {
    return null;
  }
  return result;
}
