import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_model.dart';

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

  Color _getPriorityColor(BuildContext context, TodoPriority priority) {
    final colors = Theme.of(context).colorScheme;
    switch (priority) {
      case TodoPriority.high:
        return colors.error;
      case TodoPriority.medium:
        return colors.tertiary;
      default:
        return colors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isOverdue = todo.dueDate != null &&
        todo.dueDate!.isBefore(DateTime.now()) &&
        !todo.isDone;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      // Using filled style for Card
      color: todo.isDone ? colorScheme.surfaceVariant.withOpacity(0.5) : colorScheme.surfaceVariant,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        leading: Checkbox(
          value: todo.isDone,
          onChanged: (_) => onToggle(todo),
          // M3 style checkbox
          side: MaterialStateBorderSide.resolveWith(
            (states) => BorderSide(width: 2, color: colorScheme.onSurfaceVariant),
          ),
        ),
        title: Text(
          todo.task,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            color: todo.isDone ? colorScheme.onSurface.withOpacity(0.5) : colorScheme.onSurface,
          ),
        ),
        subtitle: todo.dueDate != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      size: 14,
                      color: _getPriorityColor(context, todo.priority),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      todo.priority.name[0].toUpperCase() + todo.priority.name.substring(1),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _getPriorityColor(context, todo.priority),
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: isOverdue ? colorScheme.error : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('dd/MM/yy HH:mm').format(todo.dueDate!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isOverdue ? colorScheme.error : colorScheme.onSurfaceVariant,
                        fontWeight: isOverdue ? FontWeight.bold : null,
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
              icon: const Icon(Icons.edit_note),
              color: colorScheme.primary,
              onPressed: () => onEdit(todo),
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              color: colorScheme.error,
              onPressed: () => onDelete(todo),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
