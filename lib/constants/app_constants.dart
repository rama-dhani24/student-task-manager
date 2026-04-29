// lib/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'TaskMaster';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyTasks = 'tasks';
  static const String keyUserEmail = 'user_email';
  static const String keyIsLoggedIn = 'is_logged_in';

  // Supported Locales
  static const String localeEnglish = 'en';
  static const String localeSwahili = 'sw';

  // Priority Levels
  static const String priorityHigh = 'high';
  static const String priorityMedium = 'medium';
  static const String priorityLow = 'low';

  // Task Status
  static const String statusPending = 'pending';
  static const String statusCompleted = 'completed';

  // Subject Options
  static const List<String> subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'Kiswahili',
    'History',
    'Geography',
    'Computer Science',
    'Economics',
    'Other',
  ];

  // Animation Durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 600);

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 20.0;
  static const double radiusXL = 28.0;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Demo credentials
  static const String demoEmail = 'student@school.ac.tz';
  static const String demoPassword = 'password123';
}
