// lib/l10n/app_localizations_helper.dart
// Since we can't run flutter gen-l10n here, this file provides
// a hand-written delegate and strings map for both languages.
// In a real project, run: flutter gen-l10n to auto-generate from .arb files.

import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _strings = {
    'en': {
      'appName': 'TaskMaster',
      'login': 'Login',
      'loginSubtitle': 'Manage your studies smarter',
      'email': 'Email',
      'password': 'Password',
      'emailHint': 'student@school.ac.tz',
      'passwordHint': 'Enter your password',
      'loginButton': 'Login',
      'loginFailed': 'Invalid email or password',
      'emailRequired': 'Email is required',
      'passwordRequired': 'Password is required',
      'dashboard': 'Dashboard',
      'goodMorning': 'Good morning',
      'goodAfternoon': 'Good afternoon',
      'goodEvening': 'Good evening',
      'todayTasks': "Today's Tasks",
      'upcomingTasks': 'Upcoming Tasks',
      'overdueTasks': 'Overdue',
      'completedTasks': 'Completed',
      'addTask': 'Add Task',
      'noTasksToday': 'No tasks for today. Great job!',
      'noUpcoming': 'No upcoming tasks',
      'noOverdue': 'No overdue tasks',
      'noCompleted': 'No completed tasks yet',
      'taskTitle': 'Task Title',
      'taskTitleHint': 'e.g. Read Chapter 5',
      'subject': 'Subject',
      'description': 'Description',
      'descriptionHint': 'Add more details about this task...',
      'dueDate': 'Due Date',
      'priority': 'Priority',
      'priorityHigh': 'High',
      'priorityMedium': 'Medium',
      'priorityLow': 'Low',
      'save': 'Save Task',
      'editTask': 'Edit Task',
      'updateTask': 'Update Task',
      'taskDetails': 'Task Details',
      'markCompleted': 'Mark as Completed',
      'markPending': 'Mark as Pending',
      'editAction': 'Edit',
      'deleteTask': 'Delete Task',
      'deleteConfirm': 'Delete this task?',
      'deleteMessage': 'This action cannot be undone.',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'taskAdded': 'Task added successfully!',
      'taskUpdated': 'Task updated successfully!',
      'taskDeleted': 'Task deleted',
      'taskCompleted': 'Task marked as completed!',
      'taskPending': 'Task marked as pending',
      'status': 'Status',
      'pending': 'Pending',
      'completed': 'Completed',
      'overdue': 'Overdue',
      'createdOn': 'Created on',
      'completedOn': 'Completed on',
      'dueOn': 'Due on',
      'settings': 'Settings',
      'darkMode': 'Dark Mode',
      'language': 'Language',
      'english': 'English',
      'swahili': 'Kiswahili',
      'logout': 'Logout',
      'logoutConfirm': 'Logout?',
      'logoutMessage': 'You will be returned to the login screen.',
      'totalTasks': 'Total Tasks',
      'pending_count': 'Pending',
      'progress': 'Progress',
      'fieldRequired': 'This field is required',
      'selectSubject': 'Select a subject',
      'selectDate': 'Select due date',
      'today': 'Today',
      'tomorrow': 'Tomorrow',
      'thisWeek': 'This Week',
    },
    'sw': {
      'appName': 'TaskMaster',
      'login': 'Ingia',
      'loginSubtitle': 'Simamia masomo yako vizuri zaidi',
      'email': 'Barua pepe',
      'password': 'Nenosiri',
      'emailHint': 'mwanafunzi@shule.ac.tz',
      'passwordHint': 'Weka nenosiri lako',
      'loginButton': 'Ingia',
      'loginFailed': 'Barua pepe au nenosiri si sahihi',
      'emailRequired': 'Barua pepe inahitajika',
      'passwordRequired': 'Nenosiri linahitajika',
      'dashboard': 'Dashibodi',
      'goodMorning': 'Habari za asubuhi',
      'goodAfternoon': 'Habari za mchana',
      'goodEvening': 'Habari za jioni',
      'todayTasks': 'Kazi za Leo',
      'upcomingTasks': 'Kazi Zijazo',
      'overdueTasks': 'Zilizochelewa',
      'completedTasks': 'Zilizokamilika',
      'addTask': 'Ongeza Kazi',
      'noTasksToday': 'Hakuna kazi za leo. Hongera!',
      'noUpcoming': 'Hakuna kazi zijazo',
      'noOverdue': 'Hakuna kazi zilizochelewa',
      'noCompleted': 'Bado hakuna kazi zilizokamilika',
      'taskTitle': 'Jina la Kazi',
      'taskTitleHint': 'mfano: Soma Sura ya 5',
      'subject': 'Somo',
      'description': 'Maelezo',
      'descriptionHint': 'Ongeza maelezo zaidi kuhusu kazi hii...',
      'dueDate': 'Tarehe ya Mwisho',
      'priority': 'Kipaumbele',
      'priorityHigh': 'Juu',
      'priorityMedium': 'Kati',
      'priorityLow': 'Chini',
      'save': 'Hifadhi Kazi',
      'editTask': 'Hariri Kazi',
      'updateTask': 'Sasisha Kazi',
      'taskDetails': 'Maelezo ya Kazi',
      'markCompleted': 'Weka kama Imekamilika',
      'markPending': 'Weka kama Inaendelea',
      'editAction': 'Hariri',
      'deleteTask': 'Futa Kazi',
      'deleteConfirm': 'Futa kazi hii?',
      'deleteMessage': 'Kitendo hiki hakiwezi kutenduliwa.',
      'cancel': 'Ghairi',
      'delete': 'Futa',
      'taskAdded': 'Kazi imeongezwa!',
      'taskUpdated': 'Kazi imesasishwa!',
      'taskDeleted': 'Kazi imefutwa',
      'taskCompleted': 'Kazi imewekwa kama imekamilika!',
      'taskPending': 'Kazi imewekwa kama inaendelea',
      'status': 'Hali',
      'pending': 'Inaendelea',
      'completed': 'Imekamilika',
      'overdue': 'Imechelewa',
      'createdOn': 'Iliundwa tarehe',
      'completedOn': 'Ilikamilika tarehe',
      'dueOn': 'Muda wa mwisho',
      'settings': 'Mipangilio',
      'darkMode': 'Hali ya Usiku',
      'language': 'Lugha',
      'english': 'Kiingereza',
      'swahili': 'Kiswahili',
      'logout': 'Toka',
      'logoutConfirm': 'Toka?',
      'logoutMessage': 'Utarudishwa kwenye skrini ya kuingia.',
      'totalTasks': 'Jumla ya Kazi',
      'pending_count': 'Zinaendelea',
      'progress': 'Maendeleo',
      'fieldRequired': 'Sehemu hii inahitajika',
      'selectSubject': 'Chagua somo',
      'selectDate': 'Chagua tarehe ya mwisho',
      'today': 'Leo',
      'tomorrow': 'Kesho',
      'thisWeek': 'Wiki Hii',
    },
  };

  String translate(String key) {
    final lang = locale.languageCode;
    return _strings[lang]?[key] ?? _strings['en']?[key] ?? key;
  }

  String get appName => translate('appName');
  String get login => translate('login');
  String get loginSubtitle => translate('loginSubtitle');
  String get email => translate('email');
  String get password => translate('password');
  String get emailHint => translate('emailHint');
  String get passwordHint => translate('passwordHint');
  String get loginButton => translate('loginButton');
  String get loginFailed => translate('loginFailed');
  String get emailRequired => translate('emailRequired');
  String get passwordRequired => translate('passwordRequired');
  String get dashboard => translate('dashboard');
  String get goodMorning => translate('goodMorning');
  String get goodAfternoon => translate('goodAfternoon');
  String get goodEvening => translate('goodEvening');
  String get todayTasks => translate('todayTasks');
  String get upcomingTasks => translate('upcomingTasks');
  String get overdueTasks => translate('overdueTasks');
  String get completedTasks => translate('completedTasks');
  String get addTask => translate('addTask');
  String get noTasksToday => translate('noTasksToday');
  String get noUpcoming => translate('noUpcoming');
  String get noOverdue => translate('noOverdue');
  String get noCompleted => translate('noCompleted');
  String get taskTitle => translate('taskTitle');
  String get taskTitleHint => translate('taskTitleHint');
  String get subject => translate('subject');
  String get description => translate('description');
  String get descriptionHint => translate('descriptionHint');
  String get dueDate => translate('dueDate');
  String get priority => translate('priority');
  String get priorityHigh => translate('priorityHigh');
  String get priorityMedium => translate('priorityMedium');
  String get priorityLow => translate('priorityLow');
  String get save => translate('save');
  String get editTask => translate('editTask');
  String get updateTask => translate('updateTask');
  String get taskDetails => translate('taskDetails');
  String get markCompleted => translate('markCompleted');
  String get markPending => translate('markPending');
  String get editAction => translate('editAction');
  String get deleteTask => translate('deleteTask');
  String get deleteConfirm => translate('deleteConfirm');
  String get deleteMessage => translate('deleteMessage');
  String get cancel => translate('cancel');
  String get delete => translate('delete');
  String get taskAdded => translate('taskAdded');
  String get taskUpdated => translate('taskUpdated');
  String get taskDeleted => translate('taskDeleted');
  String get taskCompleted => translate('taskCompleted');
  String get taskPending => translate('taskPending');
  String get status => translate('status');
  String get pending => translate('pending');
  String get completed => translate('completed');
  String get overdue => translate('overdue');
  String get createdOn => translate('createdOn');
  String get completedOn => translate('completedOn');
  String get dueOn => translate('dueOn');
  String get settings => translate('settings');
  String get darkMode => translate('darkMode');
  String get language => translate('language');
  String get english => translate('english');
  String get swahili => translate('swahili');
  String get logout => translate('logout');
  String get logoutConfirm => translate('logoutConfirm');
  String get logoutMessage => translate('logoutMessage');
  String get totalTasks => translate('totalTasks');
  String get pendingCount => translate('pending_count');
  String get progress => translate('progress');
  String get fieldRequired => translate('fieldRequired');
  String get selectSubject => translate('selectSubject');
  String get selectDate => translate('selectDate');
  String get today => translate('today');
  String get tomorrow => translate('tomorrow');
  String get thisWeek => translate('thisWeek');

  String daysLeft(int count) {
    if (locale.languageCode == 'sw') {
      return 'Siku $count zimebaki';
    }
    return '$count days left';
  }

  String dayOverdue(int count) {
    if (locale.languageCode == 'sw') {
      return 'Imechelewa siku $count';
    }
    return '$count ${count == 1 ? 'day' : 'days'} overdue';
  }

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return goodMorning;
    if (hour < 17) return goodAfternoon;
    return goodEvening;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'sw'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
