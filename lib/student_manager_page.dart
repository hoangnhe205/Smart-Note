import 'package:flutter/material.dart';
import 'student_model.dart';
import 'main.dart';

class StudentManagerPage extends StatefulWidget {
  const StudentManagerPage({super.key});

  @override
  State<StudentManagerPage> createState() => _StudentManagerPageState();
}

class _StudentManagerPageState extends State<StudentManagerPage> {
  final repo = StudentRepository();
  List<Student> students = [];
  List<Student> filteredStudents = [];
  bool loading = true;
  String searchQuery = "";
  String sortBy = "name";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    students = await repo.load();
    _applyFilterAndSort();
    setState(() => loading = false);
  }

  void _applyFilterAndSort() {
    setState(() {
      filteredStudents = students.where((s) {
        return s.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
               s.id.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      if (sortBy == "name") {
        filteredStudents.sort((a, b) => a.name.compareTo(b.name));
      } else if (sortBy == "score") {
        filteredStudents.sort((a, b) => b.average.compareTo(a.average));
      }
    });
  }

  Future<void> _save() async {
    await repo.save(students);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã lưu dữ liệu')));
    }
  }

  Future<void> _showEditDialog({Student? s}) async {
    final idCtl = TextEditingController(text: s?.id ?? '');
    final nameCtl = TextEditingController(text: s?.name ?? '');
    final scoresCtl = TextEditingController(text: s != null ? s.scores.join(',') : '');
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(s == null ? 'Thêm sinh viên mới' : 'Cập nhật sinh viên'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
                controller: idCtl,
                decoration: const InputDecoration(labelText: 'Mã sinh viên (ID)', border: OutlineInputBorder()),
                enabled: s == null,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập ID' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: nameCtl,
                decoration: const InputDecoration(labelText: 'Họ và tên', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tên' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: scoresCtl,
                decoration: const InputDecoration(labelText: 'Điểm số (cách nhau bởi dấu phẩy)', border: OutlineInputBorder()),
              ),
            ]),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              final scInput = scoresCtl.text.trim();
              final scores = <double>[];
              if (scInput.isNotEmpty) {
                for (var part in scInput.split(RegExp(r'[,\s]+'))) {
                  final v = double.tryParse(part);
                  if (v != null && v >= 0 && v <= 10) scores.add(v);
                }
              }
              final newStudent = Student(id: idCtl.text.trim(), name: nameCtl.text.trim(), scores: scores);
              
              if (s == null) {
                if (students.any((e) => e.id == newStudent.id)) return;
                students.add(newStudent);
              } else {
                final idx = students.indexWhere((e) => e.id == s.id);
                if (idx != -1) students[idx] = newStudent;
              }
              _applyFilterAndSort();
              Navigator.pop(context, true);
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (result == true) await _save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản Lý Sinh Viên')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredStudents.length,
              itemBuilder: (_, i) {
                final s = filteredStudents[i];
                return ListTile(
                  title: Text(s.name),
                  subtitle: Text('ID: ${s.id}'),
                  onTap: () => _showEditDialog(s: s),
                );
              },
            ),
    );
  }
}
