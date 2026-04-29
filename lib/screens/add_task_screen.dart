// lib/screens/add_task_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations_helper.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? existingTask; // null = add, non-null = edit

  const AddTaskScreen({super.key, this.existingTask});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String _selectedSubject = AppConstants.subjects.first;
  String _selectedPriority = AppConstants.priorityMedium;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  bool _isLoading = false;

  bool get _isEdit => widget.existingTask != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final t = widget.existingTask!;
      _titleCtrl.text = t.title;
      _descCtrl.text = t.description;
      _selectedSubject = t.subject;
      _selectedPriority = t.priority;
      _selectedDate = t.dueDate;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.navy,
                secondary: AppColors.gold,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final taskProvider = context.read<TaskProvider>();

    if (_isEdit) {
      final updated = widget.existingTask!.copyWith(
        title: _titleCtrl.text.trim(),
        subject: _selectedSubject,
        description: _descCtrl.text.trim(),
        dueDate: _selectedDate,
        priority: _selectedPriority,
      );
      await taskProvider.updateTask(updated);
    } else {
      await taskProvider.addTask(
        title: _titleCtrl.text.trim(),
        subject: _selectedSubject,
        description: _descCtrl.text.trim(),
        dueDate: _selectedDate,
        priority: _selectedPriority,
      );
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l10n.editTask : l10n.addTask),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          children: [
            // Task Title
            _FieldLabel(label: l10n.taskTitle),
            TextFormField(
              controller: _titleCtrl,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: l10n.taskTitleHint,
                prefixIcon: const Icon(Icons.title_rounded),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: AppConstants.spacingM),

            // Subject
            _FieldLabel(label: l10n.subject),
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.book_outlined),
                hintText: l10n.selectSubject,
              ),
              items: AppConstants.subjects
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedSubject = v!),
              validator: (v) => v == null ? l10n.fieldRequired : null,
              dropdownColor:
                  isDark ? AppColors.darkCard : AppColors.lightSurface,
            ),
            const SizedBox(height: AppConstants.spacingM),

            // Description
            _FieldLabel(label: l10n.description),
            TextFormField(
              controller: _descCtrl,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: l10n.descriptionHint,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: AppConstants.spacingM),

            // Due Date
            _FieldLabel(label: l10n.dueDate),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingM,
                  vertical: AppConstants.spacingM,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCard
                      : AppColors.lightBackground,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    const SizedBox(width: AppConstants.spacingM),
                    Text(
                      DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark
                          ? AppColors.darkTextHint
                          : AppColors.lightTextHint,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingM),

            // Priority
            _FieldLabel(label: l10n.priority),
            Row(
              children: [
                AppConstants.priorityHigh,
                AppConstants.priorityMedium,
                AppConstants.priorityLow,
              ].map((p) => _PriorityOption(
                    priority: p,
                    isSelected: _selectedPriority == p,
                    onTap: () => setState(() => _selectedPriority = p),
                  )).toList(),
            ),

            const SizedBox(height: AppConstants.spacingXL),

            // Submit
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(_isEdit ? l10n.updateTask : l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}

class _PriorityOption extends StatelessWidget {
  final String priority;
  final bool isSelected;
  final VoidCallback onTap;

  const _PriorityOption({
    required this.priority,
    required this.isSelected,
    required this.onTap,
  });

  Color get _mainColor {
    switch (priority) {
      case AppConstants.priorityHigh:
        return AppColors.priorityHigh;
      case AppConstants.priorityMedium:
        return AppColors.priorityMedium;
      default:
        return AppColors.priorityLow;
    }
  }

  IconData get _icon {
    switch (priority) {
      case AppConstants.priorityHigh:
        return Icons.keyboard_double_arrow_up_rounded;
      case AppConstants.priorityMedium:
        return Icons.remove_rounded;
      default:
        return Icons.keyboard_double_arrow_down_rounded;
    }
  }

  String _label(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (priority) {
      case AppConstants.priorityHigh:
        return l10n.priorityHigh;
      case AppConstants.priorityMedium:
        return l10n.priorityMedium;
      default:
        return l10n.priorityLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppConstants.animFast,
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? _mainColor : _mainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(
              color: isSelected ? _mainColor : _mainColor.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              Icon(
                _icon,
                color: isSelected ? Colors.white : _mainColor,
                size: 18,
              ),
              const SizedBox(height: 4),
              Text(
                _label(context),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : _mainColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
