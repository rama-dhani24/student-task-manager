// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations_helper.dart';
import '../providers/settings_provider.dart';
import '../providers/task_provider.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (_emailCtrl.text.trim() == AppConstants.demoEmail &&
        _passwordCtrl.text == AppConstants.demoPassword) {
      if (!mounted) return;
      final settings = context.read<SettingsProvider>();
      await settings.login(_emailCtrl.text.trim());
      await context.read<TaskProvider>().loadTasks();

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const DashboardScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: AppConstants.animSlow,
        ),
      );
    } else {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      setState(() {
        _isLoading = false;
        _errorMessage = l10n.loginFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = context.watch<SettingsProvider>();
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.darkBackground, AppColors.navyDark]
                    : [AppColors.navy, AppColors.navyMid],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Decorative circles
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: -80,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Language toggle + dark mode
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _LanguageToggle(settings: settings),
                          const SizedBox(width: AppConstants.spacingS),
                          _ThemeToggle(settings: settings),
                        ],
                      ),

                      const SizedBox(height: AppConstants.spacingXXL),

                      // Logo / Title
                      Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gold.withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              color: AppColors.navyDark,
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingM),
                          Text(
                            l10n.appName,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.loginSubtitle,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppConstants.spacingXXL),

                      // Form card
                      Container(
                        padding: const EdgeInsets.all(AppConstants.spacingL),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusXL),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                l10n.login,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: AppConstants.spacingL),

                              // Email
                              TextFormField(
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: l10n.email,
                                  hintText: l10n.emailHint,
                                  prefixIcon: const Icon(
                                      Icons.alternate_email_rounded),
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? l10n.emailRequired
                                    : null,
                              ),
                              const SizedBox(height: AppConstants.spacingM),

                              // Password
                              TextFormField(
                                controller: _passwordCtrl,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _login(),
                                decoration: InputDecoration(
                                  labelText: l10n.password,
                                  hintText: l10n.passwordHint,
                                  prefixIcon:
                                      const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined),
                                    onPressed: () => setState(() =>
                                        _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? l10n.passwordRequired
                                    : null,
                              ),

                              if (_errorMessage != null) ...[
                                const SizedBox(height: AppConstants.spacingM),
                                Container(
                                  padding: const EdgeInsets.all(
                                      AppConstants.spacingM),
                                  decoration: BoxDecoration(
                                    color: AppColors.errorLight,
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusMedium),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error_outline_rounded,
                                          color: AppColors.error, size: 16),
                                      const SizedBox(
                                          width: AppConstants.spacingS),
                                      Expanded(
                                        child: Text(
                                          _errorMessage!,
                                          style: const TextStyle(
                                            color: AppColors.error,
                                            fontSize: 13,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: AppConstants.spacingL),

                              // Login button
                              SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _login,
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(l10n.loginButton),
                                ),
                              ),

                              // Demo hint
                              const SizedBox(height: AppConstants.spacingM),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkBackground
                                      : AppColors.goldSurface,
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusMedium),
                                ),
                                child: Text(
                                  'Demo: ${AppConstants.demoEmail} / ${AppConstants.demoPassword}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'Poppins',
                                    color: isDark
                                        ? AppColors.gold
                                        : AppColors.goldDark,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  final SettingsProvider settings;
  const _LanguageToggle({required this.settings});

  @override
  Widget build(BuildContext context) {
    final isEn = settings.locale.languageCode == 'en';
    return GestureDetector(
      onTap: () => settings
          .setLocale(isEn ? AppConstants.localeSwahili : AppConstants.localeEnglish),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEn ? '🇬🇧 EN' : '🇹🇿 SW',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  final SettingsProvider settings;
  const _ThemeToggle({required this.settings});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: settings.toggleTheme,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          settings.isDarkMode
              ? Icons.light_mode_rounded
              : Icons.dark_mode_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
