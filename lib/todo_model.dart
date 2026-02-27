import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum TodoPriority { low, medium, high }

class Todo {
  String id;
  String task;
  bool isDone;
  DateTime createdAt;
  DateTime? dueDate;
  TodoPriority priority;

  Todo({
    required this.id,
    required this.task,
    this.isDone = false,
    required this.createdAt,
    this.dueDate,
    this.priority = TodoPriority.low,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'task': task,
        'isDone': isDone,
        'createdAt': createdAt.toIso8601String(),
        'dueDate': dueDate?.toIso8601String(),
        'priority': priority.index,
      };

  factory Todo.fromJson(Map<String, dynamic> j) => Todo(
        id: j['id'] ?? '',
        task: j['task'] ?? '',
        isDone: j['isDone'] ?? false,
        createdAt: j['createdAt'] != null
            ? DateTime.parse(j['createdAt'])
            : DateTime.now(),
        dueDate: j['dueDate'] != null ? DateTime.parse(j['dueDate']) : null,
        priority: j['priority'] != null 
            ? TodoPriority.values[j['priority']] 
            : TodoPriority.low,
      );
}

class TodoRepository {
  final _fileName = 'todos.json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<List<Todo>> load() async {
    try {
      final f = await _file();
      if (!await f.exists()) return [];
      final s = await f.readAsString();
      final data = jsonDecode(s);
      if (data is List) {
        return data.map((e) => Todo.fromJson(Map<String, dynamic>.from(e))).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<Todo> todos) async {
    final f = await _file();
    final jsonList = todos.map((t) => t.toJson()).toList();
    await f.writeAsString(jsonEncode(jsonList), flush: true);
  }
}
