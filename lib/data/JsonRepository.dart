import 'dart:convert';
import 'dart:io';

/// A strict-typed, generic JSON repository for reading/writing collections.
/// - T: the model type
/// - fromJson: converter from Map<String, Object?> to T
/// - toJson: converter from T to Map<String, Object?>
/// - rootKey: the top-level JSON key that contains the list (e.g. "shifts")
class JsonRepository<T> {
  final String filePath;
  final String rootKey;
  final T Function(Map<String, Object?>) fromJson;
  final Map<String, Object?> Function(T) toJson;

  const JsonRepository({
    required this.filePath,
    required this.rootKey,
    required this.fromJson,
    required this.toJson,
  });

  List<T> readAll() {
    final file = File(filePath);
    if (!file.existsSync()) return <T>[];

    final content = file.readAsStringSync();
    if (content.trim().isEmpty) return <T>[];

    final root = jsonDecode(content) as Map<String, Object?>;
    final rawList = root[rootKey];
    if (rawList is! List<Object?>) return <T>[];

    final items = rawList.whereType<Map<String, Object?>>();
    return items.map(fromJson).toList(growable: false);
  }

  void writeAll(List<T> items) {
    final file = File(filePath);
    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }

    final root = <String, Object?>{
      rootKey: items.map(toJson).toList(growable: false),
    };
    final jsonString = const JsonEncoder.withIndent('  ').convert(root);
    file.writeAsStringSync(jsonString);
  }
}
