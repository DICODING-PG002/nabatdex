import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nabatdex/core/constant/activity_type.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:nabatdex/core/model/plant_activity_model.dart';

class ActivityCard extends StatelessWidget {
  final PlantActivityModel activity;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ActivityCard({
    super.key,
    required this.activity,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.whiteColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getActivityIcon(),
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.activityName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity.formattedDate,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.bodyTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onEdit != null)
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Symbols.edit, size: 20),
                    color: AppTheme.primaryColor,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                if (onEdit != null && onDelete != null)
                  const SizedBox(width: 8),
                if (onDelete != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Symbols.delete, size: 20),
                    color: AppTheme.errorColor,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Symbols.notes,
                    size: 18,
                    color: AppTheme.bodyTextColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      activity.notes,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon() {
    switch (activity.activityType) {
      case ActivityType.penyiraman:
        return Symbols.water_drop;
      case ActivityType.memberiObat:
        return Symbols.medication;
      case ActivityType.pemupukan:
        return Symbols.compost;
      case ActivityType.lainnya:
        return Symbols.more_horiz;
    }
  }
}

