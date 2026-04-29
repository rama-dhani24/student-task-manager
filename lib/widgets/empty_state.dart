// lib/widgets/empty_state.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = iconColor ??
        (isDark ? AppColors.darkTextHint : AppColors.lightTextHint);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingXL,
        vertical: AppConstants.spacingL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: color.withOpacity(0.5)),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
