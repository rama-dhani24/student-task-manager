// lib/widgets/priority_badge.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations_helper.dart';

class PriorityBadge extends StatelessWidget {
  final String priority;
  final bool small;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.small = false,
  });

  Color get bgColor {
    switch (priority) {
      case AppConstants.priorityHigh:
        return AppColors.priorityHighBg;
      case AppConstants.priorityMedium:
        return AppColors.priorityMediumBg;
      default:
        return AppColors.priorityLowBg;
    }
  }

  Color get textColor {
    switch (priority) {
      case AppConstants.priorityHigh:
        return AppColors.priorityHigh;
      case AppConstants.priorityMedium:
        return AppColors.priorityMedium;
      default:
        return AppColors.priorityLow;
    }
  }

  IconData get icon {
    switch (priority) {
      case AppConstants.priorityHigh:
        return Icons.keyboard_double_arrow_up_rounded;
      case AppConstants.priorityMedium:
        return Icons.remove_rounded;
      default:
        return Icons.keyboard_double_arrow_down_rounded;
    }
  }

  String label(BuildContext context) {
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 10,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: small ? 12 : 14, color: textColor),
          SizedBox(width: small ? 2 : 4),
          Text(
            label(context),
            style: TextStyle(
              fontSize: small ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: textColor,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
