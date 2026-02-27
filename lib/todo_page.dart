import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'todo_model.dart';
import 'todo_item_widget.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TodoRepository _repository = TodoRepository();
  List<Todo> _allTodos = [];
  List<Todo> _filteredTodos = [];
  bool _isLoading = true;
  String _activeFilter = 'all';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    _allTodos = await _repository.load();
    _applyFilter();
    setState(() => _isLoading = false);
  }

  void _applyFilter() {
    setState(() {
      if (_activeFilter == 'incomplete') {
        _filteredTodos = _allTodos.where((t) => !t.isDone).toList();
      } else if (_activeFilter == 'completed') {
        _filteredTodos = _allTodos.where((t) => t.isDone).toList();
      } else {
        _filteredTodos = List.from(_allTodos);
      }
      _filteredTodos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  Future<void> _confirmDelete(Todo todo) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.delete_outline),
        title: const Text("Xác nhận xóa"),
        content: Text("Bạn có chắc chắn muốn xóa công việc \"${todo.task}\"?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Hủy")),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text("Xóa"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _allTodos.removeWhere((t) => t.id == todo.id);
        _applyFilter();
      });
      await _repository.save(_allTodos);
    }
  }

  void _openTodoSheet({Todo? existingTodo}) {
    final bool isEditMode = existingTodo != null;
    final TextEditingController inputController = TextEditingController(
      text: isEditMode ? existingTodo.task : '',
    );
    DateTime? pickedDueDate = isEditMode ? existingTodo.dueDate : null;
    TodoPriority pickedPriority = isEditMode ? existingTodo.priority : TodoPriority.low;
    String? errorText;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final colorScheme = Theme.of(ctx).colorScheme;
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 32,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isEditMode ? 'Chỉnh sửa công việc' : 'Thêm công việc mới',
                      style: Theme.of(ctx).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: inputController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Nhiệm vụ',
                        hintText: 'Bạn cần làm gì?',
                        errorText: errorText,
                        prefixIcon: const Icon(Icons.task_alt),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (errorText != null && value.trim().isNotEmpty) {
                          setSheetState(() => errorText = null);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<TodoPriority>(
                            value: pickedPriority,
                            decoration: const InputDecoration(
                              labelText: 'Độ ưu tiên',
                              prefixIcon: Icon(Icons.low_priority),
                              border: OutlineInputBorder(),
                            ),
                            items: TodoPriority.values.map((p) => DropdownMenuItem(
                              value: p, 
                              child: Text(p.name[0].toUpperCase() + p.name.substring(1))
                            )).toList(),
                            onChanged: (val) => setSheetState(() => pickedPriority = val ?? TodoPriority.low),
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton.filledTonal(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: ctx, 
                              initialDate: pickedDueDate ?? DateTime.now(), 
                              firstDate: DateTime.now(), 
                              lastDate: DateTime(2100)
                            );
                            if (date == null) return;
                            final time = await showTimePicker(
                              context: ctx, 
                              initialTime: TimeOfDay.fromDateTime(pickedDueDate ?? DateTime.now())
                            );
                            if (time == null) return;
                            setSheetState(() => pickedDueDate = DateTime(date.year, date.month, date.day, time.hour, time.minute));
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                    if (pickedDueDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          "Hạn chót: ${pickedDueDate!.hour}:${pickedDueDate!.minute} - ${pickedDueDate!.day}/${pickedDueDate!.month}/${pickedDueDate!.year}",
                          style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: () async {
                        final String text = inputController.text.trim();

                        if (text.isEmpty) {
                          setSheetState(() {
                            errorText = "Tiêu đề không được để trống";
                          });
                          return;
                        }

                        setState(() {
                          if (isEditMode) {
                            final idx = _allTodos.indexWhere((t) => t.id == existingTodo.id);
                            if (idx != -1) {
                              _allTodos[idx].task = text;
                              _allTodos[idx].dueDate = pickedDueDate;
                              _allTodos[idx].priority = pickedPriority;
                            }
                          } else {
                            final newTodo = Todo(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              task: text,
                              createdAt: DateTime.now(),
                              dueDate: pickedDueDate,
                              priority: pickedPriority,
                            );
                            _allTodos.add(newTodo);
                          }
                          _applyFilter();
                        });

                        Navigator.pop(context);
                        await _repository.save(_allTodos);
                      },
                      child: Text(isEditMode ? 'Cập nhật' : 'Tạo mới'),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleToggle(Todo todo) async {
    setState(() {
      todo.isDone = !todo.isDone;
      _applyFilter();
    });
    await _repository.save(_allTodos);
  }

  @override
  Widget build(BuildContext context) {
    int totalCount = _allTodos.length;
    int doneCount = _allTodos.where((t) => t.isDone).length;
    double progressValue = totalCount == 0 ? 0 : doneCount / totalCount;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ghi chú công việc"),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        scrolledUnderElevation: 2,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildProgressHeader(progressValue, doneCount, totalCount),
                const SizedBox(height: 8),
                _buildFilterSegmented(),
                Expanded(
                  child: _filteredTodos.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 88),
                          itemBuilder: (ctx, i) => TodoItemWidget(
                            todo: _filteredTodos[i],
                            onToggle: _handleToggle,
                            onEdit: (t) => _openTodoSheet(existingTodo: t),
                            onDelete: _confirmDelete,
                          ),
                          itemCount: _filteredTodos.length,
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openTodoSheet(),
        label: const Text("Công việc mới"),
        icon: const Icon(Icons.add_task),
      ),
    );
  }

  Widget _buildProgressHeader(double value, int done, int total) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tiến độ hoàn thành",
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "$done/$total",
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: value,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
            backgroundColor: colorScheme.surface.withOpacity(0.5),
            color: colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            value == 1.0 && total > 0 
                ? "Tuyệt vời! Bạn đã xong hết rồi 🎉" 
                : "${(value * 100).toInt()}% hoàn thành",
            style: TextStyle(
              color: colorScheme.onPrimaryContainer.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSegmented() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'all', label: Text('Tất cả'), icon: Icon(Icons.list)),
          ButtonSegment(value: 'incomplete', label: Text('Đang làm'), icon: Icon(Icons.pending_actions)),
          ButtonSegment(value: 'completed', label: Text('Xong'), icon: Icon(Icons.task_alt)),
        ],
        selected: {_activeFilter},
        onSelectionChanged: (Set<String> newSelection) {
          setState(() {
            _activeFilter = newSelection.first;
            _applyFilter();
          });
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assignment_turned_in_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Chưa có công việc nào",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Hãy nhấn nút + để bắt đầu lên kế hoạch!",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
