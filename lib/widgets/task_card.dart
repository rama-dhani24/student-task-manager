// lib/widgets/task_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations_helper.dart';
import 'priority_badge.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback? onComplete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.onComplete,
  });

  Color _accentColor() {
    if (task.isCompleted) return AppColors.success;
    if (task.isOverdue) return AppColors.priorityHigh;
    switch (task.priority) {
      case AppConstants.priorityHigh:
        return AppColors.priorityHigh;
      case AppConstants.priorityMedium:
        return AppColors.priorityMedium;
      default:
        return AppColors.priorityLow;
    }
  }

  String _dueDateLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final diff = task.dueDate.difference(now).inDays;

    if (task.isOverdue) {
      final overdueDays = now.difference(task.dueDate).inDays + 1;
      return l10n.dayOverdue(overdueDays);
    }
    if (task.isDueToday) return l10n.today;
    if (diff == 1) return l10n.tomorrow;
    if (diff <= 7) return l10n.daysLeft(diff);
    return DateFormat('MMM d, yyyy').format(task.dueDate);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animMedium,
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingS / 2,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge - 1),
          child: Stack(
            children: [
              // Left accent bar
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(width: 4, color: _accentColor()),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.spacingM + 4,
                  AppConstants.spacingM,
                  AppConstants.spacingM,
                  AppConstants.spacingM,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: onComplete,
                      child: AnimatedContainer(
                        duration: AppConstants.animFast,
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: task.isCompleted
                              ? AppColors.success
                              : Colors.transparent,
                          border: Border.all(
                            color: task.isCompleted
                                ? AppColors.success
                                : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder),
                            width: 2,
                          ),
                        ),
                        child: task.isCompleted
                            ? const Icon(Icons.check_rounded,
                                size: 14, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.isCompleted
                                  ? (isDark
                                      ? AppColors.darkTextHint
                                      : AppColors.lightTextHint)
                                  : null,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task.subject,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingS),
                          Row(
                            children: [
                              PriorityBadge(
                                  priority: task.priority, small: true),
                              const Spacer(),
                              Icon(
                                task.isOverdue
                                    ? Icons.warning_amber_rounded
                                    : Icons.schedule_rounded,
                                size: 12,
                                color: task.isOverdue
                                    ? AppColors.priorityHigh
                                    : (isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _dueDateLabel(context),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: task.isOverdue
                                      ? AppColors.priorityHigh
                                      : (isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary),
                                  fontWeight: task.isOverdue
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark
                          ? AppColors.darkTextHint
                          : AppColors.lightTextHint,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
