// lib/widgets/section_header.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final int? count;
  final Color? countColor;

  const SectionHeader({
    super.key,
    required this.title,
    this.count,
    this.countColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingM,
        AppConstants.spacingL,
        AppConstants.spacingM,
        AppConstants.spacingS,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: AppConstants.spacingS),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: (countColor ?? AppColors.navy).withOpacity(0.12),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: countColor ?? AppColors.navy,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
