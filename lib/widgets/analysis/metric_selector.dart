import 'package:flutter/material.dart';
import 'package:nutriscan/config/app_colors.dart';
import 'package:nutriscan/config/app_localizations.dart';
import 'package:nutriscan/providers/theme/language_provider.dart';
import 'package:nutriscan/providers/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MetricSelector extends StatelessWidget {
  final String selectedMetric;
  final Function(String) onMetricChanged;
  final List<String> metrics;

  const MetricSelector({
    super.key,
    required this.selectedMetric,
    required this.onMetricChanged,
    this.metrics = const ['calories', 'protein', 'carbs', 'fat'],
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        final metricLabels = [
          {
            'value': 'calories',
            'label': AppLocalizations.getString(
              'calories',
              languageProvider.currentLanguage,
            ),
          },
          {
            'value': 'protein',
            'label': AppLocalizations.getString(
              'protein',
              languageProvider.currentLanguage,
            ),
          },
          {
            'value': 'carbs',
            'label': AppLocalizations.getString(
              'carbs',
              languageProvider.currentLanguage,
            ),
          },
          {
            'value': 'fat',
            'label': AppLocalizations.getString(
              'fat',
              languageProvider.currentLanguage,
            ),
          },
        ];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          child: Row(
            children: metricLabels.map((metric) {
              final isSelected = selectedMetric == metric['value'];
              return Expanded(
                child: GestureDetector(
                  onTap: () => onMetricChanged(metric['value']!),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (isDarkMode
                                ? AppColors.grey800.withValues(alpha: 0.5)
                                : AppColors.grey100),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDarkMode
                                  ? AppColors.grey700
                                  : AppColors.grey300),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      metric['label']!,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: themeProvider.getFontForCurrentLanguage(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white
                            : (isDarkMode
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
