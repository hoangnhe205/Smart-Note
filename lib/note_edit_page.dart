import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';
import 'note_model.dart';

class NoteEditPage extends StatefulWidget {
  final Note? note;

  const NoteEditPage({super.key, this.note});

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _contentController = TextEditingController(text: widget.note?.content ?? "");
  }

  // Hàm tự động lưu khi thoát màn hình
  Future<void> _autoSave() async {
    if (_isSaved) return; // Tránh lưu nhiều lần
    
    final String title = _titleController.text.trim();
    final String content = _contentController.text.trim();

    // Chỉ lưu nếu tiêu đề hoặc nội dung không rỗng
    if (title.isNotEmpty || content.isNotEmpty) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      
      final newNote = Note(
        id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.isEmpty ? "Ghi chú không tiêu đề" : title,
        content: content,
        updatedAt: DateTime.now(),
      );

      if (widget.note == null) {
        await provider.addNote(newNote);
      } else {
        await provider.updateNote(newNote);
      }
    }
    _isSaved = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _autoSave(); // Gọi hàm lưu khi bấm Back
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Soạn thảo", style: TextStyle(fontSize: 16)),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // Ô nhập tiêu đề (Ẩn viền)
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: "Tiêu đề",
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 1),
              
              // Ô nhập nội dung (Đa dòng, ẩn viền)
              Expanded(
                child: TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    hintText: "Nội dung ghi chú...",
                    border: InputBorder.none,
                  ),
                  maxLines: null, // Tự động giãn chiều cao theo nội dung
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
