import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Student {
  String id;
  String name;
  List<double> scores;

  Student({required this.id, required this.name, List<double>? scores})
      : scores = scores ?? [];

  double get average =>
      scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'scores': scores};

  static Student fromJson(Map<String, dynamic> j) {
    final sc = <double>[];
    if (j['scores'] is List) {
      sc.addAll((j['scores'] as List).map((e) => (e as num).toDouble()));
    }
    return Student(id: j['id'], name: j['name'], scores: sc);
  }
}

class StudentRepository {
  final _fileName = 'students.json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<List<Student>> load() async {
    try {
      final f = await _file();
      if (!await f.exists()) return [];
      final s = await f.readAsString();
      final data = jsonDecode(s);
      if (data is List) {
        return data.map((e) => Student.fromJson(Map<String, dynamic>.from(e))).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<Student> students) async {
    final f = await _file();
    final jsonList = students.map((s) => s.toJson()).toList();
    await f.writeAsString(jsonEncode(jsonList), flush: true);
  }
}
