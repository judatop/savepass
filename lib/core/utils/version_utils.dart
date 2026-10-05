class VersionUtils {
  /// Whether [current] is strictly older than [remote], compared numerically.
  ///
  /// Returns false when either side cannot be parsed, so an unexpected value in
  /// the backend can never lock users out of the app.
  static bool isOlderThan(String current, String remote) {
    final currentParts = _parse(current);
    final remoteParts = _parse(remote);

    if (currentParts == null || remoteParts == null) {
      return false;
    }

    final length = currentParts.length > remoteParts.length
        ? currentParts.length
        : remoteParts.length;

    for (var i = 0; i < length; i++) {
      final a = i < currentParts.length ? currentParts[i] : 0;
      final b = i < remoteParts.length ? remoteParts[i] : 0;

      if (a != b) {
        return a < b;
      }
    }

    return false;
  }

  static List<int>? _parse(String version) {
    final core = version.split('+').first.split('-').first.trim();

    if (core.isEmpty) {
      return null;
    }

    final parts = <int>[];
    for (final segment in core.split('.')) {
      final value = int.tryParse(segment);
      if (value == null) {
        return null;
      }
      parts.add(value);
    }

    return parts;
  }
}
