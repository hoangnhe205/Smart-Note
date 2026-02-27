import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'todo_model.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onToggle;
  final Function(Todo) onEdit;
  final Function(Todo) onDelete;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return Colors.red;
      case TodoPriority.medium:
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = todo.dueDate != null &&
        todo.dueDate!.isBefore(DateTime.now()) &&
        !todo.isDone;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Checkbox(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          value: todo.isDone,
          onChanged: (_) => onToggle(todo),
        ),
        title: Row(
          children: [
            Icon(Icons.flag, color: _getPriorityColor(todo.priority), size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                todo.task,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  color: todo.isDone ? Colors.grey : null,
                ),
              ),
            ),
          ],
        ),
        subtitle: todo.dueDate != null
            ? Padding(
                padding: const EdgeInsets.only(top: 8, left: 24),
                child: Row(
                  children: [
                    Icon(Icons.event,
                        size: 14, color: isOverdue ? Colors.red : Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        DateFormat('HH:mm - dd/MM/yy').format(todo.dueDate!),
                        style: TextStyle(
                          fontSize: 12,
                          color: isOverdue ? Colors.red : Colors.grey[600],
                          fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 22),
              onPressed: () => onEdit(todo),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: Colors.redAccent, size: 22),
              onPressed: () => onDelete(todo),
            ),
          ],
        ),
      ),
    );
  }
}
