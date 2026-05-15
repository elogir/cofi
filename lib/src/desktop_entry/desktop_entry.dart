class DesktopEntry {
  final String id;
  final String name;
  final String? comment;
  final String exec;
  final String? icon;
  final String? workingDirectory;
  final List<String> keywords;
  final String sourcePath;

  const DesktopEntry({
    required this.id,
    required this.name,
    required this.exec,
    required this.keywords,
    required this.sourcePath,
    this.comment,
    this.icon,
    this.workingDirectory,
  });
}
