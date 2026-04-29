// lib/widgets/stats_summary.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations_helper.dart';
import '../providers/task_provider.dart';

class StatsSummary extends StatelessWidget {
  final TaskProvider taskProvider;

  const StatsSummary({super.key, required this.taskProvider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.navyMid, AppColors.navyDark]
              : [AppColors.navy, AppColors.navyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress label
          Row(
            children: [
              Text(
                l10n.progress,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${(taskProvider.completionRate * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: taskProvider.completionRate,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),

          // Stats row
          Row(
            children: [
              _StatItem(
                label: l10n.totalTasks,
                value: '${taskProvider.tasks.length}',
                icon: Icons.assignment_rounded,
                color: Colors.white,
              ),
              _StatItem(
                label: l10n.pendingCount,
                value: '${taskProvider.pendingCount}',
                icon: Icons.pending_actions_rounded,
                color: AppColors.goldLight,
              ),
              _StatItem(
                label: l10n.completed,
                value: '${taskProvider.completedCount}',
                icon: Icons.task_alt_rounded,
                color: AppColors.success,
              ),
              if (taskProvider.overdueCount > 0)
                _StatItem(
                  label: l10n.overdue,
                  value: '${taskProvider.overdueCount}',
                  icon: Icons.warning_amber_rounded,
                  color: AppColors.error,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
