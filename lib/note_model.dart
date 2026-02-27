import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Note {
  String id;
  String title;
  String content;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  // Chuyển đổi sang JSON để lưu trữ
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'updatedAt': updatedAt.toIso8601String(),
      };

  // Khôi phục từ JSON
  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}

class NoteRepository {
  static const String _key = 'smart_notes_data';

  // Lưu danh sách ghi chú xuống SharedPreferences dưới dạng chuỗi JSON
  Future<void> saveNotes(List<Note> notes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonData = jsonEncode(notes.map((n) => n.toJson()).toList());
    await prefs.setString(_key, jsonData);
  }

  // Đọc dữ liệu từ máy
  Future<List<Note>> loadNotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonData = prefs.getString(_key);
    if (jsonData == null) return [];
    
    final List<dynamic> decodedData = jsonDecode(jsonData);
    return decodedData.map((item) => Note.fromJson(item)).toList();
  }
}
