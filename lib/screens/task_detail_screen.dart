// lib/screens/task_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations_helper.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../widgets/priority_badge.dart';
import 'add_task_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  TaskModel? _task;
  bool _notFound = false;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  void _loadTask() {
    final t = context.read<TaskProvider>().findById(widget.taskId);
    if (t == null) {
      setState(() => _notFound = true);
    } else {
      setState(() => _task = t);
    }
  }

  Future<void> _editTask() async {
    if (_task == null) return;
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(existingTask: _task),
      ),
    );
    if (result == true && mounted) {
      _loadTask();
      final l10n = AppLocalizations.of(context);
      Navigator.of(context).pop(l10n.taskUpdated);
    }
  }

  Future<void> _toggleComplete() async {
    if (_task == null) return;
    final provider = context.read<TaskProvider>();
    final l10n = AppLocalizations.of(context);

    if (_task!.isCompleted) {
      await provider.markPending(_task!.id);
      if (mounted) Navigator.of(context).pop(l10n.taskPending);
    } else {
      await provider.markCompleted(_task!.id);
      if (mounted) Navigator.of(context).pop(l10n.taskCompleted);
    }
  }

  Future<void> _deleteTask() async {
    if (_task == null) return;
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteConfirm),
        content: Text(l10n.deleteMessage),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<TaskProvider>().deleteTask(_task!.id);
      if (mounted) Navigator.of(context).pop(l10n.taskDeleted);
    }
  }

  @override
  Widget build(BuildContext context) {
    // React to provider changes
    final task = context.watch<TaskProvider>().findById(widget.taskId);
    if (task != null && task != _task) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _task = task);
      });
    }

    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_notFound || _task == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.taskDetails)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final t = _task!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.taskDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _editTask,
            tooltip: l10n.editAction,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: _deleteTask,
            tooltip: l10n.deleteTask,
            color: AppColors.error,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status banner
            _StatusBanner(task: t),

            const SizedBox(height: AppConstants.spacingM),

            // Main card
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingL),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                border: Border.all(
                  color:
                      isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    t.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      decoration: t.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: t.isCompleted
                          ? (isDark
                              ? AppColors.darkTextHint
                              : AppColors.lightTextHint)
                          : null,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingM),

                  // Priority + Subject row
                  Row(
                    children: [
                      PriorityBadge(priority: t.priority),
                      const SizedBox(width: AppConstants.spacingS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkBackground
                              : AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(
                              AppConstants.radiusSmall),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.book_outlined,
                              size: 12,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              t.subject,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  if (t.description.isNotEmpty) ...[
                    const SizedBox(height: AppConstants.spacingL),
                    Text(
                      l10n.description,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingS),
                    Text(t.description, style: theme.textTheme.bodyMedium),
                  ],

                  const SizedBox(height: AppConstants.spacingL),
                  const Divider(height: 1),
                  const SizedBox(height: AppConstants.spacingL),

                  // Date info
                  _DateRow(
                    icon: Icons.schedule_rounded,
                    label: l10n.dueOn,
                    value: DateFormat('EEEE, MMM d, yyyy').format(t.dueDate),
                    valueColor: t.isOverdue ? AppColors.error : null,
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  _DateRow(
                    icon: Icons.add_circle_outline_rounded,
                    label: l10n.createdOn,
                    value:
                        DateFormat('MMM d, yyyy').format(t.createdAt),
                  ),
                  if (t.completedAt != null) ...[
                    const SizedBox(height: AppConstants.spacingS),
                    _DateRow(
                      icon: Icons.task_alt_rounded,
                      label: l10n.completedOn,
                      value: DateFormat('MMM d, yyyy').format(t.completedAt!),
                      valueColor: AppColors.success,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: AppConstants.spacingL),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _editTask,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(l10n.editAction),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusMedium),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingM),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _toggleComplete,
                    icon: Icon(
                      t.isCompleted
                          ? Icons.restart_alt_rounded
                          : Icons.task_alt_rounded,
                      size: 18,
                    ),
                    label: Text(
                      t.isCompleted ? l10n.markPending : l10n.markCompleted,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          t.isCompleted ? AppColors.warning : AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusMedium),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.spacingM),

            TextButton.icon(
              onPressed: _deleteTask,
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.error),
              label: Text(
                l10n.deleteTask,
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final TaskModel task;
  const _StatusBanner({required this.task});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Color bg;
    Color fg;
    IconData icon;
    String label;

    if (task.isCompleted) {
      bg = AppColors.successLight;
      fg = AppColors.success;
      icon = Icons.task_alt_rounded;
      label = l10n.completed;
    } else if (task.isOverdue) {
      bg = AppColors.errorLight;
      fg = AppColors.error;
      icon = Icons.warning_amber_rounded;
      label = l10n.overdue;
    } else if (task.isDueToday) {
      bg = AppColors.warningLight;
      fg = AppColors.warning;
      icon = Icons.today_rounded;
      label = l10n.today;
    } else {
      bg = AppColors.infoLight;
      fg = AppColors.info;
      icon = Icons.pending_actions_rounded;
      label = l10n.pending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingM,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Row(
        children: [
          Icon(icon, color: fg, size: 18),
          const SizedBox(width: AppConstants.spacingS),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DateRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
        const SizedBox(width: AppConstants.spacingS),
        Text(
          '$label  ',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ??
                  (isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary),
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
