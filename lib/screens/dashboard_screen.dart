// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations_helper.dart';
import '../providers/settings_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/stats_summary.dart';

import '../widgets/empty_state.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _goToAddTask() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
    if (result == true && mounted) {
      _showSnack(AppLocalizations.of(context).taskAdded);
    }
  }

  Future<void> _goToTaskDetail(String taskId) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => TaskDetailScreen(taskId: taskId)),
    );
    if (result != null && mounted) {
      _showSnack(result);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsProvider>();
    final taskProvider = context.watch<TaskProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.greeting()}, 👋',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            Text(
              l10n.dashboard,
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
        actions: [
          // Language toggle
          GestureDetector(
            onTap: () => settings.setLocale(
              settings.locale.languageCode == 'en'
                  ? AppConstants.localeSwahili
                  : AppConstants.localeEnglish,
            ),
            child: Container(
              margin: const EdgeInsets.only(right: AppConstants.spacingS),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Text(
                settings.locale.languageCode == 'en' ? '🇬🇧 EN' : '🇹🇿 SW',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
          ),

          // Settings
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: isDark ? AppColors.gold : AppColors.navy,
          unselectedLabelColor:
              isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
          indicatorColor: isDark ? AppColors.gold : AppColors.navy,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          tabs: [
            Tab(text: l10n.todayTasks),
            Tab(text: l10n.upcomingTasks),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.overdueTasks),
                  if (taskProvider.overdueCount > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        '${taskProvider.overdueCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(text: l10n.completedTasks),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: AppConstants.spacingM),
          StatsSummary(taskProvider: taskProvider),
          const SizedBox(height: AppConstants.spacingM),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Today
                _TaskList(
                  tasks: taskProvider.todayTasks,
                  emptyIcon: Icons.today_rounded,
                  emptyMessage: l10n.noTasksToday,
                  onTap: (id) => _goToTaskDetail(id),
                  onComplete: (id) {
                    final t = taskProvider.findById(id);
                    if (t == null) return;
                    if (t.isCompleted) {
                      taskProvider.markPending(id);
                    } else {
                      taskProvider.markCompleted(id);
                    }
                  },
                ),
                // Upcoming
                _TaskList(
                  tasks: taskProvider.upcomingTasks,
                  emptyIcon: Icons.event_available_rounded,
                  emptyMessage: l10n.noUpcoming,
                  onTap: (id) => _goToTaskDetail(id),
                  onComplete: (id) {
                    final t = taskProvider.findById(id);
                    if (t == null) return;
                    if (t.isCompleted) {
                      taskProvider.markPending(id);
                    } else {
                      taskProvider.markCompleted(id);
                    }
                  },
                ),
                // Overdue
                _TaskList(
                  tasks: taskProvider.overdueTasks,
                  emptyIcon: Icons.check_circle_outline_rounded,
                  emptyMessage: l10n.noOverdue,
                  emptyColor: AppColors.success,
                  onTap: (id) => _goToTaskDetail(id),
                  onComplete: (id) => taskProvider.markCompleted(id),
                ),
                // Completed
                _TaskList(
                  tasks: taskProvider.completedTasks,
                  emptyIcon: Icons.assignment_late_outlined,
                  emptyMessage: l10n.noCompleted,
                  onTap: (id) => _goToTaskDetail(id),
                  onComplete: (id) => taskProvider.markPending(id),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAddTask,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          l10n.addTask,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  final List tasks;
  final IconData emptyIcon;
  final String emptyMessage;
  final Color? emptyColor;
  final Function(String) onTap;
  final Function(String) onComplete;

  const _TaskList({
    required this.tasks,
    required this.emptyIcon,
    required this.emptyMessage,
    this.emptyColor,
    required this.onTap,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: EmptyState(
          icon: emptyIcon,
          message: emptyMessage,
          iconColor: emptyColor,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: tasks.length,
      itemBuilder: (_, i) {
        final task = tasks[i];
        return TaskCard(
          key: ValueKey(task.id),
          task: task,
          onTap: () => onTap(task.id),
          onComplete: () => onComplete(task.id),
        );
      },
    );
  }
}
