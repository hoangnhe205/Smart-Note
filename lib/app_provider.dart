import 'package:flutter/material.dart';
import 'student_model.dart';
import 'todo_model.dart';
import 'note_model.dart';

class AppProvider with ChangeNotifier {
  final StudentRepository _studentRepo = StudentRepository();
  final TodoRepository _todoRepo = TodoRepository();
  final NoteRepository _noteRepo = NoteRepository();

  List<Student> _students = [];
  List<Todo> _todos = [];
  List<Note> _notes = [];

  List<Student> get students => _students;
  List<Todo> get todos => _todos;
  List<Note> get notes => _notes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Tải toàn bộ dữ liệu khi khởi động app
  Future<void> initData() async {
    _isLoading = true;
    notifyListeners();

    _students = await _studentRepo.load();
    _todos = await _todoRepo.load();
    _notes = await _noteRepo.loadNotes();

    _isLoading = false;
    notifyListeners();
  }

  // --- Sinh viên ---
  Future<void> addStudent(Student s) async {
    _students.add(s);
    await _studentRepo.save(_students);
    notifyListeners();
  }

  Future<void> updateStudent(Student s) async {
    final idx = _students.indexWhere((e) => e.id == s.id);
    if (idx != -1) {
      _students[idx] = s;
      await _studentRepo.save(_students);
      notifyListeners();
    }
  }

  Future<void> deleteStudent(String id) async {
    _students.removeWhere((e) => e.id == id);
    await _studentRepo.save(_students);
    notifyListeners();
  }

  // --- Todo ---
  Future<void> addTodo(Todo t) async {
    _todos.add(t);
    await _todoRepo.save(_todos);
    notifyListeners();
  }

  Future<void> updateTodo(Todo t) async {
    final idx = _todos.indexWhere((e) => e.id == t.id);
    if (idx != -1) {
      _todos[idx] = t;
      await _todoRepo.save(_todos);
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((t) => t.id == id);
    await _todoRepo.save(_todos);
    notifyListeners();
  }

  // --- Note ---
  Future<void> addNote(Note n) async {
    _notes.insert(0, n);
    await _noteRepo.saveNotes(_notes);
    notifyListeners();
  }

  Future<void> updateNote(Note n) async {
    final idx = _notes.indexWhere((e) => e.id == n.id);
    if (idx != -1) {
      _notes[idx] = n;
      await _noteRepo.saveNotes(_notes);
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((e) => e.id == id);
    await _noteRepo.saveNotes(_notes);
    notifyListeners();
  }
}
