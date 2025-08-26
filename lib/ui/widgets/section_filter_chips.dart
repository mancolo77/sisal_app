import 'package:flutter/material.dart';
import '../../domain/entities/sport_section.dart';
import '../../core/colors/app_colors.dart';
import '../../core/typography/app_typography.dart';

class SectionFilterChips extends StatelessWidget {
  final SportSection? selectedSection;
  final ValueChanged<SportSection?> onSectionChanged;

  const SectionFilterChips({
    super.key,
    required this.selectedSection,
    required this.onSectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // All sections chip
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('All'),
              selected: selectedSection == null,
              onSelected: (selected) {
                if (selected) {
                  onSectionChanged(null);
                }
              },
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
              labelStyle: AppTypography.caption.copyWith(
                color: selectedSection == null 
                    ? AppColors.primary 
                    : AppColors.textSecondary,
                fontWeight: selectedSection == null 
                    ? FontWeight.w600 
                    : FontWeight.w500,
              ),
            ),
          ),
          
          // Individual section chips
          ...SportSection.values.map((section) {
            final isSelected = selectedSection == section;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(section.emoji),
                    const SizedBox(width: 4),
                    Text(section.displayName),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onSectionChanged(section);
                  } else if (isSelected) {
                    onSectionChanged(null);
                  }
                },
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
                labelStyle: AppTypography.caption.copyWith(
                  color: isSelected 
                      ? AppColors.primary 
                      : AppColors.textSecondary,
                  fontWeight: isSelected 
                      ? FontWeight.w600 
                      : FontWeight.w500,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
